#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	exec sudo -- "$0" "$@"
	exit
fi

command -v curl >/dev/null 2>&1 || { echo "This script requires cURL to run, install it with 'sudo apt install curl'."; exit 1; }

SPATH=$(dirname $0)
REMOTE_URL=https://raw.githubusercontent.com/jacklul/telegram-notify/master
REMOTE_URL_ORIGINAL=https://raw.githubusercontent.com/NicolasBernaerts/debian-Scripts/master/telegram

if [ -f "$SPATH/telegram-notify" ] && [ -f "$SPATH/telegram-notify.conf" ]; then
	cp -v $SPATH/telegram-notify /usr/local/bin/telegram-notify && \
	chmod +x /usr/local/bin/telegram-notify

	if [ ! -f "/etc/telegram-notify.conf" ]; then
		cp -v $SPATH/telegram-notify.conf /etc/telegram-notify.conf
	fi
	
	if [ -f "$SPATH/telegram-notify@.service" ]; then
		cp -v $SPATH/telegram-notify@.service /etc/systemd/system/telegram-notify@.service
	fi
elif [ "$REMOTE_URL" != "" ]; then
	wget -nv -O /usr/local/sbin/telegram-notify "$REMOTE_URL_ORIGINAL/telegram-notify" && \
	chmod +x /usr/local/sbin/telegram-notify || \
	wget -nv -O /usr/local/sbin/telegram-notify "$REMOTE_URL/telegram-notify" && \
	chmod +x /usr/local/sbin/telegram-notify
	
	if [ ! -f "/etc/telegram-notify.conf" ]; then
		wget -nv -O /etc/telegram-notify.conf "$REMOTE_URL/telegram-notify.conf"
	fi
	
	wget -nv -O /etc/systemd/system/telegram-notify@.service "$REMOTE_URL/telegram-notify@.service"
else
	exit 1
fi

echo "Override any unit file adding 'OnFailure=telegram-notify@%n' to '[Unit]' section to use service failure handler."

# Telegram Notify

**Original script by Nicolas Bernaerts is [here](https://github.com/NicolasBernaerts/debian-scripts/tree/master/telegram), this repository mirrors the script.**

Allows sending text, document and photo messages to Telegram chats.
Additionally can be used as a notification handler for failed systemd services.

### Install

Either clone this repository and execute `sudo bash install.sh` or:

```bash
wget -q -O - https://raw.githubusercontent.com/jacklul/telegram-notify/master/install.sh | sudo bash
```

## Systemd service failure handler

Just add override to any service you want to be monitored:

```bash
sudo systemctl edit your_service.service
```

```
[Unit]
OnFailure=telegram-notify@%n
```

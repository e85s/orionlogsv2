# 🪐 Orion Logs

[![FiveM](https://img.shields.io/badge/FiveM-Server-blue)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-green)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

**Orion Logs** is a full Discord + file logging system for FiveM servers built to track player activity, staff actions, detections, and server events in one place.  

Logs are sent to Discord webhooks **and** saved locally in structured log files for backup, investigations, and analytics.

Made by Owen.

---

## 📌 Features

### Basic Logs
- Chat messages
- Player joins
- Player leaves
- Death / kill logs
- Shooting logs
- Explosion logs
- Resource start / stop
- Steam name changes
- Screenshot logging

### Vehicle Logs
- Vehicle spawns

### Moderation Logs (EasyAdmin synced)
- Kicks
- Bans
- Warnings
- Spectate
- Freeze
- Teleports

### Report Logs
- Report creation
- Report claims

### Detection / Security Logs
- Modder detections (staff ping)
- Combat logging
- Shared IP detection
- Ban evasion alerts
- Alt account detection
- VPN / proxy detection (optional)

### AI / Session Logs
- Player session summaries
- Playtime tracking
- Activity reports

### Infrastructure Logs
- Server hitch warnings
- Performance spikes
- Resource errors

---

## 📡 Discord Features

- Webhook routing (separate webhook per log type)
- Embed styling
- Orion branding
- Staff role pings on detections
- Identifier display:
  - Steam Hex
  - License
  - Discord ID
  - IP (optional)

---

## 💾 File Logging

All logs are saved locally in `logs/`. Example files:

chat.log
joins.log
deaths.log
shooting.log
explosions.log
resources.log
vehicles.log
admin.log
reports.log
detections.log
ai.log
performance.log

---

## ⚙️ Requirements

- FiveM server (latest recommended)
- EasyAdmin (for moderation/report logs)
- baseevents resource (for death logs)

Optional:
- Screenshot resource (for screenshot logs)
- VPN API key (for VPN detection)

---

## 🛠 Installation

1. Download or clone the repo
2. Place folder in: resources/[standalone]/orion-logs
3. Add to `server.cfg`:
4. Add your Discord webhooks in `config.lua`
5. Restart server

---

## 📝 Configuration

`config.lua` options:

```lua
Config.LogIP = true
Config.StaffPing = "<@&ROLE_ID>"
Webhook links
Staff ping role
IP logging toggle
VPN detection toggle

---

⚡ Framework Compatibility

Works with:

Standalone

ESX

QBCore

Custom frameworks

EasyAdmin required for admin/report sync.

---

## 🎨 Branding

All embeds are branded: Orion Logs • Made by Owen

---

## 💡 Support

If you run into issues:

Check webhook links

Ensure EasyAdmin events are enabled

Make sure baseevents is running

ADD MY DISCORD @e85s for anything else.




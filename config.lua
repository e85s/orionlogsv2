Config = {}

-- Logging toggles
Config.LogIP = true
Config.StaffPing = "<@&ROLE_ID>" -- Replace with your staff role ID

-- Discord Webhooks
Config.Webhooks = {
    Chat            = "YOUR_CHAT_WEBHOOK_URL",
    JoinLeave       = "YOUR_JOINLEAVE_WEBHOOK_URL",
    Death           = "YOUR_DEATH_WEBHOOK_URL",
    Shooting        = "YOUR_SHOOTING_WEBHOOK_URL",
    Explosions      = "YOUR_EXPLOSION_WEBHOOK_URL",
    Resources       = "YOUR_RESOURCE_WEBHOOK_URL",
    Vehicles        = "YOUR_VEHICLE_WEBHOOK_URL",
    Admin           = "YOUR_ADMIN_WEBHOOK_URL",
    ReportsCreate   = "YOUR_REPORT_CREATE_WEBHOOK_URL",
    ReportsClaim    = "YOUR_REPORT_CLAIM_WEBHOOK_URL",
    ModderDetect    = "YOUR_MODDER_DETECTION_WEBHOOK_URL"
}

-- Optional: VPN / Proxy Detection
Config.VPNCheck = false
Config.VPNAPIKey = ""

-- Branding
Config.BrandName = "Orion Logs"
Config.FooterText = "Orion Logs • Made by Owen"

--==============================
-- Orion Logs | Made by Owen
--==============================

local Combat = {}
local IPCache = {}
local Sessions = {}

--==============================
-- Utility Functions
--==============================
local function WriteLog(file, text)
    local time = os.date("%Y-%m-%d %H:%M:%S")
    local line = ("[%s] %s\n"):format(time, text)
    local path = ("logs/%s.log"):format(file)
    SaveResourceFile(GetCurrentResourceName(), path, line, -1)
end

local function GetIDs(src)
    local ids = { steam = "N/A", license = "N/A", discord = "N/A", ip = "Hidden" }
    for _, id in pairs(GetPlayerIdentifiers(src)) do
        if id:find("steam:") then ids.steam = id end
        if id:find("license:") then ids.license = id end
        if id:find("discord:") then ids.discord = "<@" .. id:gsub("discord:", "") .. ">" end
        if id:find("ip:") and Config.LogIP then ids.ip = id:gsub("ip:", "") end
    end
    return ids
end

local function SendLog(webhook, title, desc, color, ids, ping)
    local embed = {{
        title = "🪐 " .. title,
        description = desc,
        color = color,
        footer = { text = "Orion Logs • Made by Owen" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
    PerformHttpRequest(webhook, function() end, "POST", json.encode({
        username = "Orion Logs",
        content = ping or "",
        embeds = embed
    }), { ["Content-Type"] = "application/json" })
end

--==============================
-- Player Connecting
--==============================
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    local ids = GetIDs(src)

    -- Join log
    WriteLog("joins", name .. " connecting | " .. ids.license)
    SendLog(Config.Webhooks.JoinLeave, "Player Connecting", name .. " is joining\nSteam: "..ids.steam.."\nLicense: "..ids.license.."\nDiscord: "..ids.discord.."\nIP: "..ids.ip, 5763719, ids)

    -- Shared IP detection
    if ids.ip ~= "Hidden" then
        if IPCache[ids.ip] then
            WriteLog("detections", name .. " shares IP with " .. IPCache[ids.ip])
            SendLog(Config.Webhooks.ModderDetect, "Shared IP Detected", name .. " shares IP with " .. IPCache[ids.ip], 16711680, ids, Config.StaffPing)
        else
            IPCache[ids.ip] = name
        end
    end

    -- Session start
    Sessions[src] = { join = os.time() }
end)

--==============================
-- Player Dropped
--==============================
AddEventHandler("playerDropped", function(reason)
    local src = source
    local ids = GetIDs(src)

    -- Leave log
    WriteLog("joins", GetPlayerName(src) .. " left | " .. (reason or "Unknown"))
    SendLog(Config.Webhooks.JoinLeave, "Player Left", GetPlayerName(src) .. " left | " .. (reason or "Unknown"), 16744448, ids)

    -- Combat log
    if Combat[src] then
        WriteLog("detections", GetPlayerName(src) .. " combat logged")
        SendLog(Config.Webhooks.ModderDetect, "Combat Logged", GetPlayerName(src) .. " combat logged", 16711680, ids, Config.StaffPing)
        Combat[src] = nil
    end

    -- Session end / AI summary
    local data = Sessions[src]
    if data then
        local playtime = os.time() - data.join
        WriteLog("ai", GetPlayerName(src) .. " session | " .. playtime .. " sec")
        Sessions[src] = nil
    end
end)

--==============================
-- Chat Log
--==============================
AddEventHandler("chatMessage", function(src, name, msg)
    local ids = GetIDs(src)
    WriteLog("chat", name .. ": " .. msg)
    SendLog(Config.Webhooks.Chat, "Chat", ("**%s:** %s"):format(name, msg), 3447003, ids)
end)

--==============================
-- Death / Kill Log
--==============================
RegisterNetEvent("baseevents:onPlayerKilled")
AddEventHandler("baseevents:onPlayerKilled", function(killer, data)
    local victim = source
    local weapon = data.weapon or "Unknown"
    local killerName = (killer ~= 0 and GetPlayerName(killer)) or "NPC/Environment"
    local text = GetPlayerName(victim) .. " killed by " .. killerName .. " | " .. weapon
    local ids = GetIDs(victim)

    WriteLog("deaths", text)
    SendLog(Config.Webhooks.Death, "Kill Log", text .. "\nSteam: "..ids.steam.."\nLicense: "..ids.license.."\nDiscord: "..ids.discord.."\nIP: "..ids.ip, 15158332, ids)
end)

--==============================
-- Shooting Log
--==============================
RegisterNetEvent("orion:shot")
AddEventHandler("orion:shot", function(weapon)
    local src = source
    local ids = GetIDs(src)
    WriteLog("shooting", GetPlayerName(src) .. " fired " .. weapon)
end)

--==============================
-- Explosion Log
--==============================
AddEventHandler("explosionEvent", function(sender, ev)
    local ids = GetIDs(sender)
    WriteLog("explosions", GetPlayerName(sender) .. " created explosion")
end)

--==============================
-- Resource Start/Stop Log
--==============================
AddEventHandler("onResourceStart", function(res)
    WriteLog("resources", res .. " started")
end)

AddEventHandler("onResourceStop", function(res)
    WriteLog("resources", res .. " stopped")
end)

--==============================
-- Vehicle Spawn Log
--==============================
RegisterNetEvent("orion:vehicleSpawn")
AddEventHandler("orion:vehicleSpawn", function(model)
    local src = source
    local ids = GetIDs(src)
    WriteLog("vehicles", GetPlayerName(src) .. " spawned " .. model)
    SendLog(Config.Webhooks.VehicleSpawn, "Vehicle Spawned", GetPlayerName(src).." spawned "..model.."\nSteam: "..ids.steam.."\nLicense: "..ids.license.."\nDiscord: "..ids.discord.."\nIP: "..ids.ip, 3447003, ids)
end)

--==============================
-- EasyAdmin Logs
--==============================
local function AdminLog(action, staff, target, reason)
    local targetName = target and GetPlayerName(target) or ""
    local ids = target and GetIDs(target) or {}
    local text = staff.." "..action.." "..targetName..(reason and (" | "..reason) or "")
    WriteLog("admin", text)
    SendLog(Config.Webhooks.Admin, "Admin Action", text.."\nSteam: "..(ids.steam or "N/A").."\nLicense: "..(ids.license or "N/A").."\nDiscord: "..(ids.discord or "N/A").."\nIP: "..(ids.ip or "Hidden"), 16711680, ids, Config.StaffPing)
end

RegisterServerEvent("EasyAdmin:kickPlayer")
AddEventHandler("EasyAdmin:kickPlayer", function(target, reason, staff)
    AdminLog("kicked", staff, target, reason)
end)

RegisterServerEvent("EasyAdmin:banPlayer")
AddEventHandler("EasyAdmin:banPlayer", function(target, reason, staff)
    AdminLog("banned", staff, target, reason)
end)

RegisterServerEvent("EasyAdmin:spectate")
AddEventHandler("EasyAdmin:spectate", function(staff, target)
    AdminLog("spectating", staff, target)
end)

RegisterServerEvent("EasyAdmin:FreezePlayer")
AddEventHandler("EasyAdmin:FreezePlayer", function(staff, target)
    AdminLog("froze", staff, target)
end)

RegisterServerEvent("EasyAdmin:TeleportPlayer")
AddEventHandler("EasyAdmin:TeleportPlayer", function(staff, target)
    AdminLog("teleported", staff, target)
end)

RegisterServerEvent("EasyAdmin:CreateReport")
AddEventHandler("EasyAdmin:CreateReport", function(player, msg)
    local ids = GetIDs(player)
    WriteLog("reports", GetPlayerName(player).." created report: "..msg)
    SendLog(Config.Webhooks.ReportsCreate, "Report Created", GetPlayerName(player)..": "..msg.."\nSteam: "..ids.steam.."\nLicense: "..ids.license.."\nDiscord: "..ids.discord.."\nIP: "..ids.ip, 3447003, ids)
end)

RegisterServerEvent("EasyAdmin:ClaimReport")
AddEventHandler("EasyAdmin:ClaimReport", function(staff, id)
    WriteLog("reports", staff.." claimed report "..id)
    SendLog(Config.Webhooks.ReportsClaim, "Report Claimed", staff.." claimed report "..id, 3447003, {}, Config.StaffPing)
end)

--==============================
-- Combat Log
--==============================
RegisterNetEvent("orion:combatTag")
AddEventHandler("orion:combatTag", function(id)
    Combat[id] = true
end)

--==============================
-- AI / Session Summary
--==============================
-- Handled in playerDropped above

--==============================
-- Performance Logging
--==============================
CreateThread(function()
    while true do
        Wait(60000)
        local hitch = GetGameTimer()
        if hitch > 200 then
            WriteLog("performance", "High hitch: "..hitch)
        end
    end
end)

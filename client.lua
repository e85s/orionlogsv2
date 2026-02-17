-- Example for shooting or vehicle detection

RegisterCommand("testshoot", function()
    TriggerServerEvent("orion:shot", "TEST_WEAPON")
end)

RegisterCommand("spawncar", function()
    local vehicle = "adder" -- example model
    TriggerServerEvent("orion:vehicleSpawn", vehicle)
end)

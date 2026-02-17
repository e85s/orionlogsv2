fx_version 'cerulean'
game 'gta5'

author 'Orion Development'
description 'Orion Logs - Full FiveM logging system'
version '2.0.0'

server_scripts {
    'config.lua',
    'server.lua'
}

client_scripts {
    'client.lua' -- Optional: for shooting, vehicle, or other client events
}

dependencies {
    'baseevents',
    'EasyAdmin'
}

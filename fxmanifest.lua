fx_version 'adamant'
game 'gta5'
author 'levi'
description 'lv - wholesaler'
version '1.0.0'

ui_page "uix/index.html"
shared_script 'config.lua'
client_script 'client/client.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

files {
    'uix/index.html',
    'uix/script.js',
    'uix/style.css'
}


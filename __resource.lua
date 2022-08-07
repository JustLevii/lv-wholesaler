resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"


client_script {
    'client/client.lua'
}

shared_script {
    'config.lua'
}
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}
ui_page "uix/index.html"

files {
    'uix/index.html',
    'uix/script.js',
    'uix/style.css'
}


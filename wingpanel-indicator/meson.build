wingpanel_dep = dependency('wingpanel')
wingpanel_indicatorsdir = wingpanel_dep.get_variable('indicatorsdir', pkgconfig_define: ['libdir', prefix / get_option('libdir')])

files = files(
    'DisplayWidget.vala',
    'Indicator.vala',
    'SettingsPopover.vala'
)

dependencies = [
    dependency('gtk+-3.0'),
    dependency('libhandy-1'),
    dependency('granite'),
    wingpanel_dep
]

conf_data = configuration_data()
conf_data.set('GETTEXT_PACKAGE', meson.project_name())
conf_data.set('LOCALEDIR', prefix / get_option('localedir'))

config_in = configure_file(
    input: 'config.vala.in',
    output: '@BASENAME@',
    configuration: conf_data
)

shared_module(
    meson.project_name(),
    files,
    config_in,
    gresource,
    dependencies: dependencies,
    install: true,
    install_dir : wingpanel_indicatorsdir
)
project(
    'io.github.lenemter.unity-indicator',
    'vala', 'c',
    version: '1.0.0',
    meson_version: '>= 0.58.0'
)

prefix = get_option('prefix')

add_project_arguments([
    '--vapidir=' + join_paths (meson.source_root (), 'vapi'),
  ],
  language: 'vala',
)

mutter_dep = []
libmutter_dep = []

vala_flags = []

mutter42_dep = dependency('libmutter-10', version: ['>= 42', '< 43'], required: false)
if mutter42_dep.found()
	libmutter_dep = dependency('libmutter-10', version: '>= 42')
	mutter_dep = [
		libmutter_dep,
		dependency('mutter-cogl-10'), dependency('mutter-cogl-pango-10'),
		dependency('mutter-clutter-10')
	]
	vala_flags = []
endif

mutter43_dep = dependency('libmutter-11', version: ['>= 43', '< 44'], required: false)
if mutter43_dep.found()
	libmutter_dep = dependency('libmutter-11', version: '>= 43')
	mutter_dep = [
		libmutter_dep,
		dependency('mutter-cogl-11'), dependency('mutter-cogl-pango-11'),
		dependency('mutter-clutter-11')
	]
	vala_flags = ['--define', 'HAS_MUTTER43']
endif

mutter44_dep = dependency('libmutter-12', version: ['>= 44', '< 45'], required: false)
if mutter44_dep.found()
	libmutter_dep = dependency('libmutter-12', version: '>= 44')
	mutter_dep = [
		libmutter_dep,
		dependency('mutter-cogl-12'), dependency('mutter-cogl-pango-12'),
		dependency('mutter-clutter-12')
	]
	vala_flags = ['--define', 'HAS_MUTTER43', '--define', 'HAS_MUTTER44']
endif

mutter45_dep = dependency('libmutter-13', version: ['>= 45', '< 46'], required: false)
if mutter45_dep.found()
	libmutter_dep = dependency('libmutter-13', version: '>= 45')
	mutter_dep = [
		libmutter_dep,
		dependency('mutter-mtk-13'), dependency('mutter-cogl-13'),
		dependency('mutter-cogl-pango-13'), dependency('mutter-clutter-13')
	]
	vala_flags = ['--define', 'HAS_MUTTER43', '--define', 'HAS_MUTTER44', '--define', 'HAS_MUTTER45']
endif

if mutter_dep.length () == 0
  error('No supported mutter library found!')
endif

mutter_typelib_dir = libmutter_dep.get_variable('typelibdir')

vapigen = find_program('vapigen', required: false)
if vapigen.found()
  subdir('vapi')
endif

gnome = import('gnome')

subdir('data')
subdir('gala-window-management-plugin')
subdir('wingpanel-indicator')


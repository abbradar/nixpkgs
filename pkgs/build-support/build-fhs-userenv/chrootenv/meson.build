project('chrootenv', 'c')

cc = meson.get_compiler('c')

glib = dependency('glib-2.0')
cap = cc.find_library('cap')

executable('chrootenv', 'chrootenv.c', dependencies: [glib, cap], install: true)

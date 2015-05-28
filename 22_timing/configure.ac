AC_PREREQ([2.69])
AC_INIT([test], [1.8], [peterlamby@web.de])
AC_CONFIG_SRCDIR([src/test.vala])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([foreign -Wall -Werror subdir-objects dist-xz no-dist-gzip])
AM_SILENT_RULES([no])

AC_PROG_CC

dnl ***************************************************************************
dnl Check for Windows
dnl ***************************************************************************
AC_CANONICAL_HOST

case $host_os in
	*mingw*)
		platform_win32=yes
		native_win32=yes
		;;
	pw32* | *cygwin*)
		platform_win32=yes
		native_win32=no
		;;
	*)
		platform_win32=no
		native_win32=no
		;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")

LT_INIT([win32-dll])

dnl Check for vala
AM_PROG_VALAC([0.10.0])

PKG_CHECK_MODULES([SDL_DEPS], [sdl2], , AC_MSG_ERROR([SDL2 is required for this package]))
PKG_CHECK_MODULES([SDL_IMAGE_DEPS], [SDL2_image], , AC_MSG_ERROR([SDL2-image is required for this package]))
PKG_CHECK_MODULES([SDL_TTF_DEPS], [SDL2_ttf], , AC_MSG_ERROR([SDL2-ttf is required for this package]))
PKG_CHECK_MODULES([GLIB_DEPS], [glib-2.0 gobject-2.0], , AC_MSG_ERROR([glib-2 and gobject-2 is required for this package]))

AC_OUTPUT([Makefile])

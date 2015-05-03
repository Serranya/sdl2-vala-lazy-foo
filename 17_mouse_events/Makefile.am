AM_CPPFLAGS = $(SDL_DEPS_CFLAGS) $(SDL_IMAGE_DEPS_CFLAGS) $(SDL_TTF_DEPS_CFLAGS) $(GLIB_DEPS_CFLAGS)
AM_LDFLAGS = $(SDL_DEPS_LIBS) $(SDL_IMAGE_DEPS_LIBS) $(SDL_TTF_DEPS_LIBS) $(GLIB_DEPS_LIBS) 

bin_PROGRAMS = test
test_SOURCES = src/test.vala src/MyTexture.vala src/MyButton.vala
test_VALAFLAGS = --pkg sdl2 --pkg sdl2-image --pkg sdl2-ttf
test_LDFLAGS = $(SDL_DEPS_LIBS) $(SDL_IMAGE_DEPS_LIBS) $(SDL_TTF_DEPS_LIBS) $(GLIB_DEPS_LIBS)

if PLATFORM_WIN32
test_LDFLAGS += -Wl,--export-all-symbols
else
test_LDFLAGS += -Wl,--export-dynamic
endif

ACLOCAL_AMFLAGS= -I m4

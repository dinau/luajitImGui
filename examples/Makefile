# Use nim-1.6.20 for small binary size
# by audin 2024/08
#

ifeq ($(OS),Windows_NT)
	EXE = .exe
endif

OPT += -d:release -d:strip --opt:size --app:gui
OPT += --passL:-static

TC ?= gcc
#TC ?= clang
#TC ?= vcc

ifeq ($(TC),gcc)
	OPT += -d:lto
endif
ifneq ($(TC),vcc)
	OPT += --passC:"-ffunction-sections -fdata-sections -Wl,--gc-sections"
endif

.PHONY: clean clean_each

MAKEFLAGS += --no-print-directory
EXAMPLE_DIRS := \
							glfw_opengl3 \
	            glfw_opengl3_implot \
	            glfw_opengl3_jp \
	            glfw_opengl3_simple \
	            sdl2_opengl3

LAUNCHER_SRC = execLuaSource.nim
OPT += --cc:$(TC) --nimcache:../.nimcache

all:
	$(foreach example_dir,$(EXAMPLE_DIRS), $(call def_make,$(example_dir)))

clean_each:
	$(foreach example_dir,$(EXAMPLE_DIRS), $(call def_clean,$(example_dir)))

clean: clean_each
	-rm -fr .nimcache
#
define def_make
	$(MAKE) -C $(1)/res
	cp tools/$(LAUNCHER_SRC) $(1)
	(cd $(1); nim c $(OPT) -o:$(1)$(EXE) $(LAUNCHER_SRC))
	rm -f $(1)/$(LAUNCHER_SRC)

endef

define def_clean
	$(MAKE) -C $(1)/res clean
	rm -f $(1)/$(1)$(EXE)

endef

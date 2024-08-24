# Use nim-1.6.20 for small binary size
# by audin 2024/08
#
TARGET = $(notdir $(CURDIR))

ifeq ($(OS),Windows_NT)
	EXE = .exe
endif

TARGET_EXE = $(TARGET)$(EXE)

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

.PHONY: gen_exe copy_src del_src icon all_task

GOWIN_SRC = execLuaSource.nim

all_task: copy_src icon gen_exe del_src

copy_src:
	cp -f  ../tools/$(GOWIN_SRC) .

del_src:
	rm $(GOWIN_SRC)

icon:
	$(MAKE) -C res

gen_exe:
	nim c $(OPT) --cc:$(TC) --nimcache:.nimcache -o:$(TARGET_EXE) $(GOWIN_SRC)

clean:
	-rm $(TARGET_EXE)
	-rm -fr .nimcache

MAKEFLAGS += --no-print-directory

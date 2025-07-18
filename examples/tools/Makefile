ifeq ($(TC),)
	TC = gcc
endif

C_SRC = execLuaSource

EXAMPLES_DIR = ../../bin/examples

CFLAGS += -mwindows

EXAMPLE_DIRS := glfw_opengl3 \
							  glfw_opengl3_jp \
							  glfw_opengl3_implot \
							  glfw_opengl3_simple \
							  sdl2_opengl3


.PHONY: gen_bat gen_exe

all:  gen_bat gen_exe

gen_exe:
	@echo =
	@echo === $(TC) === Generating Launcher files ===
	@echo =
	$(foreach exdir,$(EXAMPLE_DIRS), $(call def_gen_exe,$(exdir)))

gen_bat:
	@echo =
	@echo === Generating Batch files ===
	@echo =
	../../bin/luajit genbat.lua

define def_gen_bat
	@echo @echo off >          $(EXAMPLES_DIR)/LuaJIT-ImGui/examples/$(1).bat
	@echo call r.bat $1.lua >> $(EXAMPLES_DIR)/LuaJIT-ImGui/examples/$(1).bat
	@echo $(EXAMPLES_DIR)/LuaJIT-ImGui/examples/$(1).bat

endef

define def_gen_exe
	@(cd ../$(1); \
	  $(TC) -O2 -Wl,-s $(CFLAGS) -o $(1).exe res/rsc64.res  ../tools/$(C_SRC).c)
	@echo ../$(1)/$(1).exe

endef

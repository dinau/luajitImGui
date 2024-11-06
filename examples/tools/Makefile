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

EXAMPLE_NAMES := \
 CTE_Objects_sample\
 CTE_sample\
 CTE_windows\
 cimnodes_r_graph_sample\
 cimnodes_r_sample\
 dock\
 fb_sample\
 folder_sizes_gui\
 font_loader_sample\
 imGuizmo_sample\
 imnodes_graph_sample\
 imnodes_sample\
 implot_sample\
 listclipper\
 minimal_main\
 minimal_main_viewport\
 minimal_sdl\
 minimal_sdl_opengl2\
 piemenu\
 plotter_sample\
 rotateText\
 sdl_audio\
 timeline_example\
 widgets_sample\
 window_drag_drop

.PHONY: gen_bat show_cc

all:  gen_bat
	@echo =
	@echo === $(TC) === Generating Launcher files ===
	@echo =
	$(foreach exdir,$(EXAMPLE_DIRS), $(call def_gen_exe,$(exdir)))

gen_bat:
	@echo =
	@echo === Generating Batch files ===
	@echo =
	cp -f r.bat $(EXAMPLES_DIR)/LuaJIT-ImGui/examples/
	cp -f julia.bat $(EXAMPLES_DIR)/juliaSet/
	$(foreach expName,$(EXAMPLE_NAMES), $(call def_gen_bat,$(expName)))

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

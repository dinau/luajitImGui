NIM_SRC = execLuaSource.nim

EXAMPLES_DIR = "../../bin/examples/LuaJIT-ImGui/examples/"

OPT = --verbosity:0

all:
	cp -f r.bat $(EXAMPLES_DIR)
	nim $(OPT) make_bat.nims
	@cp -f $(NIM_SRC) ../glfw_opengl3/
	@cp -f $(NIM_SRC) ../glfw_opengl3_implot/
	@cp -f $(NIM_SRC) ../glfw_opengl3_jp/
	@cp -f $(NIM_SRC) ../glfw_opengl3_simple/
	@cp -f $(NIM_SRC) ../sdl2_opengl3/
	nim $(OPT) make_exe.nims $(TC)
	@rm  -f ../glfw_opengl3/$(NIM_SRC)
	@rm  -f ../glfw_opengl3_implot/$(NIM_SRC)
	@rm  -f ../glfw_opengl3_jp/$(NIM_SRC)
	@rm  -f ../glfw_opengl3_simple/$(NIM_SRC)
	@rm  -f ../sdl2_opengl3/$(NIM_SRC)

local ffi = require "ffi"
require"utils"
--- GLFW/etc
local glfw = require"glfw"
local gllib = require"gl"
gllib.set_loader(glfw)
local gl, glc = gllib.libraries()
local ig = require"imgui.glfw"
require"loadimage"

--- Global valuable: app
require"apps"

-- Inifile
loadIni()

glfw.setErrorCallback(function(error,description)
    print("GLFW error:",error,ffi.string(description or ""));
end)

glfw.init()

local window = glfw.Window(app.mainWindow.width,app.mainWindow.height)
window:setPos(app.mainWindow.posx ,app.mainWindow.posy)

window:makeContextCurrent()
glfw.swapInterval(1)

--choose implementation
local ig_impl = ig.Imgui_Impl_glfw_opengl3() --standard imgui opengl3 example
--local ig_impl = ig.ImplGlfwGL3() --multicontext
--local ig_impl = ig.Imgui_Impl_glfw_opengl2() --standard imgui opengl2 example

local io= ig.GetIO()
io.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + io.ConfigFlags

ig_impl:Init(window, true)

ig.lib.ImGui_ImplOpenGL3_DestroyFontsTexture()
ig.lib.ImGui_ImplOpenGL3_CreateFontsTexture()

---------------
--- Font image
---------------
local atlas = ig.GetIO().Fonts
local font_tex_id = atlas.TexID
local font_tex_w  = atlas.TexWidth
local font_tex_h  = atlas.TexHeight
font_tex_size = ffi.new("ImVec2",{font_tex_w, font_tex_h})
print(font_tex_id,font_tex_w,font_tex_h)

----------
--- Image
----------
local ImageName = "space-400.jpg"
pic1 = {texture = ffi.new("GLuint[1]"), width = 0,height = 0 , comp = 0}
if LoadTextureFromFile("../img/" .. ImageName, pic1) then
  print(pic1.texture)
  print(pic1.width, pic1.height)
  print("Comp:",pic1.comp)
end
pic1.size = ig.ImVec2(pic1.width, pic1.height)

local showdemo = ffi.new("bool[1]",false)

--------------
--- main loop
--------------
while not window:shouldClose() do
  glfw.pollEvents()
  gllib.gl.glClearColor(0.25,0.65,0.85,1.0)
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)
  ig_impl:NewFrame()
  do
    ig.Begin("My win")
    ig.Image(ffi.cast("ImTextureID",pic1.texture[0]),pic1.size)
    ig.Text("Text sample")
    ig.ImageButton("Image Buton",font_tex_id,font_tex_size)
    ig.ShowDemoWindow(showdemo)
    ig.End()
  end
  ig_impl:Render()
  window:swapBuffers()
end

-------------
--- end proc
-------------
saveIni(window)
ig_impl:destroy()
window:destroy()
glfw.terminate()

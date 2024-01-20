local ffi = require "ffi"
local utils = require"utils"
--- GLFW/etc
local glfw = require"glfw"
local gllib = require"gl"
local gl, glc = gllib.libraries()
local ig = require"imgui.glfw"
require"loadimage"

--- Global valuable: app
require"apps"

--- Image folder
local ImgDir = "../img/"

-- Load inifile
loadIni()

-- Call back
glfw.setErrorCallback(function(error,description)
  print("GLFW error:",error,ffi.string(description or ""));
end)

-- Initialize
glfw.init()

-------------------
--- Get GLFWWindow
-------------------
local window = glfw.Window(app.mainWindow.width,app.mainWindow.height)
window:setPos(app.mainWindow.posx ,app.mainWindow.posy)

window:makeContextCurrent()

glfw.swapInterval(1) --- Set VSync

--------------------------
--- Choose implementation
--------------------------
local ig_impl = ig.Imgui_Impl_glfw_opengl3() --standard imgui opengl3 example
--local ig_impl = ig.ImplGlfwGL3() --multicontext
--local ig_impl = ig.Imgui_Impl_glfw_opengl2() --standard imgui opengl2 example

local pio= ig.GetIO()
pio.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + pio.ConfigFlags

ig_impl:Init(window, true)

ig.lib.ImGui_ImplOpenGL3_DestroyFontsTexture()
ig.lib.ImGui_ImplOpenGL3_CreateFontsTexture()

-------------------------
--- Load title bar icon
-------------------------
local  IconName = ImgDir .. "icon_jp.png"
utils.LoadWindowIcon(window, IconName)

---------------
--- Load image
---------------
local ImageName = ImgDir .. "fuji-400.jpg"
pic1 = {texture = ffi.new("GLuint[1]"), width = 0,height = 0 , comp = 0}
if nil == LoadTextureFromFile(ImageName, pic1) then
  print("Error!: Can't load image file: ",ImageName)
else
  -- print(pic1.texture)
  -- print(pic1.width, pic1.height)
  -- print("Comp:",pic1.comp)
end
pic1.size = ig.ImVec2(pic1.width, pic1.height)

--- Flags
local fShowDemo = ffi.new("bool[1]",true)

--------------
--- Load font
--------------
local fontsAtlas = pio.Fonts
--maximal range allowed with ImWchar16
--local ranges = ffi.new("ImWchar[3]",{0x0001,0xFFFF,0})
local fontName = ""
local ranges = nil
if utils.checkLang("jp") then -- Specify country ID
  fontName = os.getenv("windir") .. "/fonts/meiryo.ttc"
  ranges = fontsAtlas:GetGlyphRangesJapanese()
end
if utils.fileExists(fontName) then
  local fontsize = ffi.new("float[1]",18)
  local theFONT= fontsAtlas:AddFontFromFileTTF(fontName, fontsize[0], nil,ranges)
  if (theFONT ~= nil) then
    pio.FontDefault = theFONT -- OK, set as default font
  end
else
  print("Error!: Can't find fontName: ", fontName)
  fontName = ""
end

-- Set window title
local sAry = ""
local fntName = ""
local sTitle = ""
if "" == fontName then
  sTitle = string.format("[ImGui: v%s]" ,ffi.string(ig.GetVersion()))
else
  sAry = fontName:split("/")
  fntName = sAry[#sAry] -- Eliminated directory part
  sTitle = string.format("[ImGui: v%s] 起動時フォント: %s)" ,ffi.string(ig.GetVersion()),fntName)
end

--------------
--- main loop
--------------
--- Global vars
local sBuf       = ffi.new("char[?]",100)
local somefloat  = ffi.new("float[1]",0.0)
local clearColor = ffi.new("float[3]",{0.25,0.65,0.85})
local counter = 0

while not window:shouldClose() do
  glfw.pollEvents()
  gl.glClearColor(clearColor[0],clearColor[1],clearColor[2],1.0)
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)
  ig_impl:NewFrame()
  -- Show ImGui demo
  if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end

  if ig.Begin(sTitle) then
    ig.Text("GLFW v" .. ffi.string(glfw.glfwVersionString()))
    local s = "OpenGL v" .. ffi.string(gl.glGetString(glc.GL_VERSION)):split(" ")[1]
    ig.Text(s)
    ig.Text("これは日本語表示テスト")
    ig.InputTextWithHint("テキスト入力", "ここに日本語を入力", sBuf,100)
    ig.Text("入力結果: " .. ffi.string(sBuf))
    ig.Checkbox("デモ・ウインドウ表示", fShowDemo)
    ig.SliderFloat("浮動小数", somefloat, 0.0, 1.0, "%3f", 0)
    ig.ColorEdit3("背景色変更", clearColor)
    -- File open dialog
    if ig.Button("ファイルを開く") then
    end
    ig.SameLine(0.0,-1.0)
    -- ヒント表示
    if ig.IsItemHovered() and ig.BeginTooltip() then
      ig.Text("ファイルを開きます")
      local ary = ffi.new("float[7]",{0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2})
      ig.PlotLines("Curve", ffi.cast("float *",ary), 7 ,0,"オーバーレイ文字列")
      ig.Text("Sin(time) = %.2f", math.sin(ig.GetTime()))
      ig.EndTooltip()
    end
    ig.Text("選択ファイル名 = %s", "test.jpg")
    --
    ig.Text("描画フレームレート  %.3f ms/frame (%.1f FPS)"
      , 1000.0 / pio.Framerate, pio.Framerate)
    ig.Text("経過時間 = %.1f [s]", counter / pio.Framerate)
    counter = counter + 1
    local delay = 600 * 3
    somefloat[0] = math.fmod(counter, delay) / delay
    ig.End()
  end

  if ig.Begin("イメージ・ウインドウ") then
    ig.Image(ffi.cast("ImTextureID",pic1.texture[0]),pic1.size)
    ig.End()
  end
  --
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

local ffi   = require"ffi"
local utils = require"utils"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
require"loadimage"
require"setupFonts"
local IFA   = require"fonticon.IconsFontAwesome6"

--- Global var: app
require"apps"

---
local SaveImageName = "windowImage"

--- Global var
local fReqImageCapture = false

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

local pio = ig.GetIO()
pio.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + pio.ConfigFlags

ig_impl:Init(window, true)

ig.lib.ImGui_ImplOpenGL3_DestroyFontsTexture()
ig.lib.ImGui_ImplOpenGL3_CreateFontsTexture()

-------------------------
--- Load title bar icon
-------------------------
local  IconName = ImgDir .. "icon_qr_my_github.png"
utils.loadWindowIcon(window, IconName)

---------------
--- Load image
---------------
local ImageName = ImgDir .. "space-400.jpg"
local pic1 = {texture = ffi.new("GLuint[1]"), width = 0, height = 0, comp = 0}
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
local  fExistMultibytesFonts, sActiveFontName, sActiveFontTitle = setupFonts(pio)

-- Set window title
local sTitle
local imGuiVersion = ffi.string(ig.GetVersion())
if "" == sActiveFontName then
  sTitle = string.format("[ImGui: v%s]" ,imGuiVersion)
else
  print("Loaded font: ", sActiveFontName)
  local sAry = sActiveFontName:split("/")
  local fntName = sAry[#sAry] -- Eliminated directory part
  sTitle = string.format("[ImGui: v%s] Start up font: %s)"
                          , imGuiVersion,fntName)
end

ig.StyleColorsClassic()

---------------
--- setTooltip
---------------
function setTooltip(str)
  if ig.IsItemHovered(ig.ImguiHoveredFlags_DelayNormal) then
    if ig.BeginTooltip() then
      ig.Text(str)
      ig.EndTooltip()
    end
  end
end

--------------
--- main loop
--------------
--- Global vars
local sBufLen    = 100
local sBuf       = ffi.new("char[?]",sBufLen)
local somefloat  = ffi.new("float[1]",0.0)
local clearColor = ffi.new("float[3]",{0.25,0.65,0.85})
local counter    = 0
local imageFormatTbl = {"JPEG", "PNG", "TIFF", "BMP"}
local cmbItemIndex   = app.image.imageSaveFormatIndex

while not window:shouldClose() do
  glfw.pollEvents()
  gl.glClearColor(clearColor[0],clearColor[1],clearColor[2],1.0)
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)
  ig_impl:NewFrame()
  -- Show ImGui demo
  if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end
  local svName

  if ig.Begin(sTitle) then
    ig.Text("GLFW v" .. ffi.string(glfw.glfwVersionString()))
    local s = "OpenGL v" .. ffi.string(gl.glGetString(glc.GL_VERSION)):split(" ")[1]
    ig.Text(s)
    ig.Text("Input text test")
    ig.InputTextWithHint("Input text", "Here input text", sBuf,100)
    ig.Text("Input result: " .. ffi.string(sBuf))
    ig.Checkbox("Show ImGui demo window", fShowDemo)
    ig.SliderFloat("Float number", somefloat, 0.0, 1.0, "%3f", 0)
    ig.ColorEdit3("Change background", clearColor)
    -- File open dialog
    if ig.Button("Open file") then
    end
    ig.SameLine(0.0,-1.0)

    -- Show tooltip help
    if ig.IsItemHovered() and ig.BeginTooltip() then
      ig.Text("Open file")
      local ary = ffi.new("float[7]",{0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2})
      ig.PlotLines("Curve", ffi.cast("float *",ary), 7 ,0,"Overlay strings")
      ig.Text("Sin(time) = %.2f", math.sin(ig.GetTime()))
      ig.EndTooltip()
    end
    ig.Text("Selected filename = %s", "test.jpg")
    --
    ig.Text("Frame rate  %.3f ms/frame (%.1f FPS)"
      , 1000.0 / pio.Framerate, pio.Framerate)
    ig.Text("Elapsed time = %.1f [s]", counter / pio.Framerate)
    counter = counter + 1
    local delay = 600 * 3
    somefloat[0] = math.fmod(counter, delay) / delay

    -- Save button for capturing window image
    ig.PushID(0)
    ig.PushStyleColor(ig.lib.ImGuiCol_Button,        ig.ImVec4(0.7, 0.7, 0.0, 1.0))
    ig.PushStyleColor(ig.lib.ImGuiCol_ButtonHovered, ig.ImVec4(0.8, 0.8, 0.0, 1.0))
    ig.PushStyleColor(ig.lib.ImGuiCol_ButtonActive,  ig.ImVec4(0.9, 0.9, 0.0, 1.0))
    ig.PushStyleColor(ig.lib.ImGuiCol_Text, ig.ImVec4(0.0, 0.0, 0.0,1.0))
    if ig.Button("Save window image") then
      fReqImageCapture = true
    end
    ig.PopStyleColor(4)
    ig.PopID()

    -- Show tooltip help
    local imgSaveFormatStr = imageFormatTbl[cmbItemIndex]
    svName = SaveImageName .. "_" .. counter .. utils.imageExt[imgSaveFormatStr]
    setTooltip(string.format("Save to \"%s\"", svName))
    -- End Save button of window image
    ig.SameLine(0.0,-1.0)

    -- Combobox
    ig.SetNextItemWidth(70)
    if ig.BeginCombo("##", imgSaveFormatStr, 0) then
      for n,val in ipairs(imageFormatTbl) do
        local is_selected = (cmbItemIndex == n)
        if ig.Selectable(val, is_selected , 0)then
          if is_selected then
            ig.SetItemDefaultFocus()
          end
          cmbItemIndex = n
        end
      end
      app.image.imageSaveFormatIndex = cmbItemIndex
      ig.EndCombo()
    end
    setTooltip("Select image format")

    -- Icon font test
    ig.SeparatorText(IFA.ICON_FA_WRENCH .. " Icon font test ")
    ig.Text(IFA.ICON_FA_TRASH_CAN .. " Trash")
    ig.Text(IFA.ICON_FA_MAGNIFYING_GLASS_PLUS ..
     " " .. IFA.ICON_FA_POWER_OFF ..
     " " .. IFA.ICON_FA_MICROPHONE ..
     " " .. IFA.ICON_FA_MICROCHIP ..
     " " .. IFA.ICON_FA_VOLUME_HIGH ..
     " " .. IFA.ICON_FA_SCISSORS ..
     " " .. IFA.ICON_FA_SCREWDRIVER_WRENCH ..
     " " .. IFA.ICON_FA_BLOG)
     --

    ig.End()
  end
  --
  if ig.Begin("Image window") then
    ig.Image(ffi.cast("ImTextureID",pic1.texture[0]),pic1.size)
    ig.End()
  end
  --
  ig_impl:Render()

  -- Save window image to file
  if fReqImageCapture then
    fReqImageCapture = false
    local w,h,x,y = app.getCurrentWindowSize(window)
    utils.saveImage(svName, imageFormatTbl[cmbItemIndex], w , h)
  end
  --
  window:swapBuffers()
end

-------------
--- end proc
-------------
saveIni(window)
ig_impl:destroy()
window:destroy()
glfw.terminate()

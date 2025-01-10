local ffi   = require"ffi"
local utils = require"mylib.utils"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
require"mylib.setupFonts"
local IFA   = require"mylib.fonticon.IconsFontAwesome6"

--- Image / Icon folder
local ImgDir = "img/"
local IconDir = "res/img/"

-- Call back
glfw.setErrorCallback(function(error,description)
  print("GLFW error:",error,ffi.string(description or ""));
end)

-- Initialize
glfw.init()

-------------------
--- Get GLFWWindow
-------------------
--- ### First set attribute to hide main window for avoiding flickering
glfw.hint(glfw.glfwc.GLFW_VISIBLE,false)
local window = glfw.Window(1080,760)
window:setPos(50,50)

window:makeContextCurrent()

glfw.swapInterval(1) --- Set VSync

--------------------------
--- Choose implementation
--------------------------
local ig_impl = ig.Imgui_Impl_glfw_opengl3() --standard imgui opengl3 example

local pio = ig.GetIO()
pio.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + pio.ConfigFlags

ig_impl:Init(window, true)

ig.lib.ImGui_ImplOpenGL3_DestroyFontsTexture()
ig.lib.ImGui_ImplOpenGL3_CreateFontsTexture()

------------------------
--- Load title bar icon
-------------------------
local  IconName = IconDir .. "lua.png"
utils.loadWindowIcon(window, IconName)

--- Flags
local fShowDemo = ffi.new("bool[1]",true)

--- Defalut window title
local sTitle = IFA.ICON_FA_THUMBS_UP .. " Simple window" ..
               "               5G " ..
               IFA.ICON_FA_SIGNAL     .. " " ..
               IFA.ICON_FA_WIFI     .. " " ..
               IFA.ICON_FA_PHONE    .. " " ..
               IFA.ICON_FA_DOWNLOAD .. " " ..
               "56%" .. " " ..
               IFA.ICON_FA_BATTERY_HALF

--------------
--- Load font
--------------
local  _, sActiveFontName, _ = setupFonts(pio) --- Setup font and font Icon

------------------------
--- Set GUI theme color
------------------------
 ig.StyleColorsClassic()
-- ig.StyleColorsLight()
-- ig.StyleColorsDark()

--------------
--- main loop
--------------
--- Global vars
local clearColor = ffi.new("float[3]",{0.00,0.68,0.75}) -- Background color
local avoid_flicker = true

while not window:shouldClose() do
  glfw.pollEvents()
  gl.glClearColor(clearColor[0],clearColor[1],clearColor[2],1.0)
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)
  ig_impl:NewFrame()

  -- Show ImGui demo
  if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end

  -- Show Simple window
  do ig.Begin(sTitle)
    ig.Text(IFA.ICON_FA_COMMENT .. "  ImGui v" .. ffi.string(ig.GetVersion()))
    ig.Text(IFA.ICON_FA_COMMENT .. "  GLFW v" .. ffi.string(glfw.glfwVersionString()))
    local s = "OpenGL v" .. ffi.string(gl.glGetString(glc.GL_VERSION)):split(" ")[1]
    ig.Text(IFA.ICON_FA_CUBES .. "  " .. s)
    ig.Checkbox("Show ImGui demo window", fShowDemo)
    -- Icon font test
    ig.SeparatorText(IFA.ICON_FA_WRENCH .. " Icon font test ")
    ig.Text(IFA.ICON_FA_TRASH_CAN .. " Trash")
    ig.Text(IFA.ICON_FA_MAGNIFYING_GLASS_PLUS ..
     "  " .. IFA.ICON_FA_MICROPHONE ..
     "  " .. IFA.ICON_FA_MICROCHIP ..
     "  " .. IFA.ICON_FA_VOLUME_HIGH ..
     "  " .. IFA.ICON_FA_SCISSORS ..
     "  " .. IFA.ICON_FA_SCREWDRIVER_WRENCH ..
     "  " .. IFA.ICON_FA_BLOG)
     --
    ig.Separator()
    if ig.Button(IFA.ICON_FA_POWER_OFF .. "  Power Off") then
      window:setShouldClose(true) --  == (glfw.glfwc.GLFW_TRUE)
    end
    ig.End()
  end
  --
  ig_impl:Render()
  window:swapBuffers()
if avoid_flicker then -- Avoid flickering window at startup.
    avoid_flicker = false
    window:show() --- Show main window
  end
end

-------------
--- end proc
-------------
ig_impl:destroy()
window:destroy()
glfw.terminate()

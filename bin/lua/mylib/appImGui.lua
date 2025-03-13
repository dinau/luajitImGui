local ffi   = require"ffi"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
require"mylib.loadimage"
require"mylib.setupFonts"
local utils = require"mylib.utils"
local inifile = require"mylib.inifile"

-- Get ini file name
local iniName = (arg[0]:split("."))[1] .. ".ini"

local M = {}

-- Call back
glfw.setErrorCallback(function(error,description)
  print("GLFW error:",error,ffi.string(description or ""));
end)

------------
--- loadIni
------------
local loadIni = function(win)
  local DEFAULT_WINDOW_WIDTH  = 1080
  local DEFAULT_WINDOW_HEIGHT =  800
  local DEFAULT_WINDOW_POSX   =   50
  local DEFAULT_WINDOW_POSY   =   50

  if not utils.fileExists(iniName) then
    print("Not found ini file: ", iniName)
    win.ini.mainWindow.width  = DEFAULT_WINDOW_WIDTH
    win.ini.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    win.ini.mainWindow.posx   = DEFAULT_WINDOW_POSX
    win.ini.mainWindow.posy   = DEFAULT_WINDOW_POSY
    win.ini.mainWindow.colBGx = 0.25
    win.ini.mainWindow.colBGy = 0.65
    win.ini.mainWindow.colBGz = 0.85
    win.ini.image.imageSaveFormatIndex = 1 -- "JPEG"
    inifile.save(iniName, win.ini)
  else -- Load ini file
    print("Load ini file: ",iniName)
    win.ini = inifile.parse(iniName)
    if win.ini.mainWindow.width < 100 then
       win.ini.mainWindow.width = DEFAULT_WINDOW_WIDTH
    end
    if win.ini.mainWindow.height < 100 then
       win.ini.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    end
  end
end

------------
--- saveIni
------------
local saveIni = function(win, info)
  win.ini.mainWindow.width  = info.w
  win.ini.mainWindow.height = info.h
  win.ini.mainWindow.posx, win.ini.mainWindow.posy = info.x, info.y
  inifile.save(iniName, win.ini)
end

----------------
--- createImGui
----------------
function M.createImGui(w, h, title, titleBarIcon, docking, fImPlot)
  local window = {}
  window.ini = {}
  window.ini.mainWindow = {}
  window.ini.image = {}

  window.avoid_flicker = true

  loadIni(window)   -- Load inifile
  glfw.init()       -- Initialize

  ----------------------
  --- Create GLFWWindow
  ----------------------
  --- First set attribute to hide main window for avoiding flickering
  glfw.hint(glfw.glfwc.GLFW_VISIBLE,false)
  window.handle = glfw.Window(window.ini.mainWindow.width, window.ini.mainWindow.height, title) --- Create main window
  window.handle:setPos(window.ini.mainWindow.posx ,window.ini.mainWindow.posy)                  --- Move main window to previous position

  if fImPlot then
    ig.ImPlot_CreateContext()
    ig.ImPlot3D_CreateContext()
  end

  window.handle:makeContextCurrent()
  glfw.swapInterval(1) --- Set VSync

  --------------------------
  --- Choose implementation
  --------------------------
  window.ig_impl = ig.Imgui_Impl_glfw_opengl3() --standard imgui opengl3 example
  --window.ig_impl = ig.ImplGlfwGL3() --multicontext

  local pio = ig.GetIO()
  pio.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + pio.ConfigFlags

  window.ig_impl:Init(window.handle, true)

  ig.lib.ImGui_ImplOpenGL3_DestroyFontsTexture()
  ig.lib.ImGui_ImplOpenGL3_CreateFontsTexture()

  -------------------------
  --- Load title bar icon
  -------------------------
  utils.loadWindowIcon(window.handle, titleBarIcon)

  --------------
  --- Load font
  --------------
  local  _, sActiveFontName, sActiveFontTitle = setupFonts(pio)
  window.sActiveFontName = sActiveFontName
  window.sActiveFontTitle = sActiveFontTitle

  ig.StyleColorsClassic()
  if fImPlot then
    ig.ImPlot_StyleColorsClassic()
  end

  -------------
  --- newFrame
  -------------
  function window.newFrame(win)
    gl.glClearColor(window.ini.mainWindow.colBGx, window.ini.mainWindow.colBGy, window.ini.mainWindow.colBGz, 1.0)
    gl.glClear(glc.GL_COLOR_BUFFER_BIT)
    win.ig_impl:NewFrame()
  end

  -----------
  --- render
  -----------
  function window.render(win)
    win.ig_impl:Render()
    win.handle:swapBuffers()
    if win.avoid_flicker then -- Avoid flickering window at startup.
      win.avoid_flicker = false
      win.handle:show() --- Show main window
    end
  end

  -----------------
  --- destroyImGui
  -----------------
  function window.destroyImGui(win)
    -- Save Window info
    local info = {}
    info.x, info.y = win.handle:getPos()
    local wsize = ig.GetMainViewport().WorkSize
    info.w = wsize.x
    info.h = wsize.y
    saveIni(win, info)
    ---
    win.ig_impl:destroy()
    win.handle:destroy()
    glfw.terminate()
  end

  ----------------
  --- getWinColor
  ----------------
  function window.getWinColor(win)
      return ffi.new("float[3]", {win.ini.mainWindow.colBGx, win.ini.mainWindow.colBGy, win.ini.mainWindow.colBGz})
  end

  ----------------
  --- setWinColor
  ----------------
  function window.setWinColor(win, col)
      win.ini.mainWindow.colBGx = col[0]
      win.ini.mainWindow.colBGy = col[1]
      win.ini.mainWindow.colBGz = col[2]
  end

  return window
end


return M

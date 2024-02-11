local ig = require"imgui.glfw" -- Imgui,ImPlot,ImNode etc.
local inifile = require"inifile"
local utils = require"utils"

-- Get ini file name
local IniName = (arg[0]:split("."))[1] .. ".ini"

-- Global var
app = {}
app.mainWindow = {}
app.image = {}

local DEFAULT_WINDOW_WIDTH  = 1080
local DEFAULT_WINDOW_HEIGHT =  800
local DEFAULT_WINDOW_POSX   =   50
local DEFAULT_WINDOW_POSY   =   50

function loadIni()
  if not utils.fileExists(IniName) then
    print("Not found ini file: ", IniName)
    app.mainWindow.width  = DEFAULT_WINDOW_WIDTH
    app.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    app.mainWindow.posx   = DEFAULT_WINDOW_POSX
    app.mainWindow.posy   = DEFAULT_WINDOW_POSY
    app.image.imageSaveFormatIndex = 1 -- "JPEG"
    inifile.save(IniName,app)
  else -- Load ini file
    print("Load ini file: ",IniName)
    app = inifile.parse(IniName)
    if app.mainWindow.width < 100 then
       app.mainWindow.width = DEFAULT_WINDOW_WIDTH
    end
    if app.mainWindow.height < 100 then
      app.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    end
  end
end

function getCurrentWindowSize(glfwWin)
  local wsize = ig.GetMainViewport().WorkSize
  local posx, posy = glfwWin:getPos()
  return wsize.x, wsize.y, posx, posy
end

function saveIni(glfwWin)
  local w,h,x,y = getCurrentWindowSize(glfwWin)
  app.mainWindow.width  = w
  app.mainWindow.height = h
  app.mainWindow.posx, app.mainWindow.posy = x, y
  inifile.save(IniName,app)
end

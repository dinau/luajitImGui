local ig = require"imgui.glfw" -- Imgui/ImPlot/ImNode etc.
local inifile = require"inifile"
local utils = require"utils"

-- Get ini file name
local IniName = (arg[0]:split("."))[1] .. ".ini"

-- Global var
app = {}
app.mainWindow = {}

local DEFAULT_WINDOW_WIDTH  = 1080
local DEFAULT_WINDOW_HEIGHT =  800
local DEFAULT_WINDOW_POSX   =   50
local DEFAULT_WINDOW_POSY   =   50

function loadIni()
  if not utils.fileExists(IniName) then
    print("no ini file: ", IniName)
    app.mainWindow.width  = DEFAULT_WINDOW_WIDTH
    app.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    app.mainWindow.posx   = DEFAULT_WINDOW_POSX
    app.mainWindow.posy   = DEFAULT_WINDOW_POSY
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

function saveIni(glfwWin)
  --print("Save ini")
  wsize = ig.GetMainViewport().WorkSize
  app.mainWindow.width  = wsize.x
  app.mainWindow.height = wsize.y
  app.mainWindow.posx, app.mainWindow.posy = glfwWin:getPos()
  --print( app.mainWindow.posx, app.mainWindow.posy)
  inifile.save(IniName,app)
end

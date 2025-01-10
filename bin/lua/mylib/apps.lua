local inifile = require"mylib.inifile"
local utils = require"mylib.utils"

-- Get ini file name
local IniName = (arg[0]:split("."))[1] .. ".ini"

-- Global var
App = {}
App.mainWindow = {}
App.image = {}

local DEFAULT_WINDOW_WIDTH  = 1080
local DEFAULT_WINDOW_HEIGHT =  800
local DEFAULT_WINDOW_POSX   =   50
local DEFAULT_WINDOW_POSY   =   50

function LoadIni()
  if not utils.fileExists(IniName) then
    print("Not found ini file: ", IniName)
    App.mainWindow.width  = DEFAULT_WINDOW_WIDTH
    App.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    App.mainWindow.posx   = DEFAULT_WINDOW_POSX
    App.mainWindow.posy   = DEFAULT_WINDOW_POSY
    App.image.imageSaveFormatIndex = 1 -- "JPEG"
    inifile.save(IniName,App)
  else -- Load ini file
    print("Load ini file: ",IniName)
    App = inifile.parse(IniName)
    if App.mainWindow.width < 100 then
       App.mainWindow.width = DEFAULT_WINDOW_WIDTH
    end
    if App.mainWindow.height < 100 then
      App.mainWindow.height = DEFAULT_WINDOW_HEIGHT
    end
  end
end


function SaveIni(info)
  App.mainWindow.width  = info.w
  App.mainWindow.height = info.h
  App.mainWindow.posx, App.mainWindow.posy = info.x, info.y
  inifile.save(IniName, App)
end

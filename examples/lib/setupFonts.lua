local ffi   = require "ffi"
--local ig    = require"imgui.glfw"
local utils = require"utils"
local IFA   = require"fonticon.IconsFontAwesome6"

-------------
--- point2px
-------------
function point2px(point)
  -- ## Convert point to pixel
  return ((point * 96) / 72)
end

local ranges_icon_fonts = ffi.new("unsigned short[3]",{IFA.ICON_MIN_FA,  IFA.ICON_MAX_FA, 0})
local config = ffi.new("ImFontConfig",{
  FontDataOwnedByAtlas = true,
  FontNo = fontNo,
  OversampleH = 3,
  OversampleV = 1,
  PixelSnapH = false,
  GlyphMaxAdvanceX = 1000.0,
  RasterizerMultiply = 1.0,
  RasterizerDensity  = 1.0,
  MergeMode = true,          -- ** Notice **
  EllipsisChar = -1,
})

function setupFonts(pio)
  local fontsAtlas = pio.Fonts
  --maximal range allowed with ImWchar16
  --local ranges = ffi.new("ImWchar[3]",{0x0001,0xFFFF,0})
  local ranges = nil
  local fontSize
  local fontNo
  local sActiveFontTitle
  local sActiveFontName = ""
  --
  if utils.checkLang("jp") then -- Specify country ID
    if true then
      sActiveFontName  = os.getenv("windir") .. "/fonts/meiryo.ttc" -- Windows7, 8.1
      sActiveFontTitle = "メイリオ"
      fontSize = 14 -- point
      fontNo   = 0
    else
      sActiveFontName = os.getenv("windir") .. "/fonts/YuGothM.ttc" -- Windows10, 11
      sActiveFontTitle = "ゆうゴシック"
      fontSize = 12 -- point
      fontNo   = 0
    end
    ranges = fontsAtlas:GetGlyphRangesJapanese()
  end
  --
  if utils.fileExists(sActiveFontName) then
    local theFONT= fontsAtlas:AddFontFromFileTTF(sActiveFontName
                                                 ,point2px(fontSize)
                                                 ,imFontConfig
                                                 ,ranges)
    if (theFONT ~= nil) then
      pio.FontDefault = theFONT -- OK, set as default font
    else
      print("Error!: Font load error", sActiveFontName)
    end
  else
    print("Error!: Can't find fontName: ", sActivefontName)
    sActiveFontName = ""
  end

  local  fontFullPath = "../lib/fonticon/fa6/fa-solid-900.ttf"
  -- Add Icon font
  if utils.fileExists(fontFullPath) then
    print("OK", fontFullPath)
    fontsAtlas:AddFontFromFileTTF(fontFullPath
                                ,point2px(11)
                                ,config
                                ,ranges_icon_fonts)
  else
    print("Error!: Can't find Icon fonts: " , fontFullPath)
  end

  return true, sActiveFontName, sActiveFontTitle
end

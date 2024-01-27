local ffi = require "ffi"
local ig = require"imgui.glfw"
local utils = require"utils"

function setupFonts()
  local pio = ig.GetIO()
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
      fontSize = 18
      fontNo   = 0
    else
      sActiveFontName = os.getenv("windir") .. "/fonts/YuGothM.ttc" -- Windows10, 11
      sActiveFontTitle = "ゆうゴシック"
      fontSize = 16
      fontNo   = 0
    end
    ranges = fontsAtlas:GetGlyphRangesJapanese()
  end
  --
  if utils.fileExists(sActiveFontName) then
    local imFontConfig = ffi.new("ImFontConfig",{
      FontDataOwnedByAtlas = true,
      FontNo = fontNo,
      OversampleH = 3,
      OversampleV = 1,
      PixelSnapH = false,
      GlyphMaxAdvanceX = 1000.0,
      RasterizerMultiply = 1.0,
      RasterizerDensity  = 1.0,
      MergeMode = false,
      EllipsisChar = -1,
    })
    local theFONT= fontsAtlas:AddFontFromFileTTF(sActiveFontName, fontSize, imFontConfig,ranges)
    if (theFONT ~= nil) then
      pio.FontDefault = theFONT -- OK, set as default font
    else
      print("Error!: Font load error", sActiveFontName)
    end
  else
    print("Error!: Can't find fontName: ", sActivefontName)
    sActiveFontName = ""
  end

  return true, sActiveFontName, sActiveFontTitle
end

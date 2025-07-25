local ffi   = require"ffi"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
require"mylib.loadimage"
require"mylib.zoomglass"
local appImGui = require"mylib.appImGui"
local utils    = require"mylib.utils"
local IFA      = require"mylib.fonticon.IconsFontAwesome6"

--- Vars
local SaveImageName = "ImageSaved"
local fReqImageCapture = false

-------------
--- gui_main
-------------
function gui_main(win)
  --- Load image
  local ImgDir = "img/"
  local ImageName = ImgDir .. "fuji-400.png"
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

  -- Set window title
  local sTitle = ""
  local imGuiVersion = ffi.string(ig.GetVersion())
  if "" == win.sActiveFontName then
    sTitle = string.format("[ImGui: v%s]" ,imGuiVersion)
  else
    print("Loaded font: ", win.sActiveFontName)
    local sAry = win.sActiveFontName:split("/")
    local fntName = sAry[#sAry] -- Eliminated directory part
    sTitle = string.format("[ImGui: v%s] Start up font: %s)" , imGuiVersion, fntName)
  end

  local pio = ig.GetIO()

  -- Set window title
  local sTitle = ""
  local imGuiVersion = ffi.string(ig.GetVersion())
  if "" == win.sActiveFontName then
    sTitle = string.format("[ImGui: v%s]" ,imGuiVersion)
  else
    print("Loaded font: ", win.sActiveFontName)
    local sAry = win.sActiveFontName:split("/")
    local fntName = sAry[#sAry] -- Eliminated directory part
    sTitle = string.format("[ImGui: v%s] 起動時フォント: %s: %s)" ,imGuiVersion, win.sActiveFontTitle, fntName)
  end

  --- Vars
  local sBufLen    = 100
  local sBuf       = ffi.new("char[?]", sBufLen)
  local somefloat  = ffi.new("float[1]", 0.0)
  local counter    = 0
  local imageFormatTbl = {"JPEG", "PNG", "TIFF", "BMP"}
  local cmbItemIndex   = win.ini.image.imageSaveFormatIndex
  local green  = ig.ImVec4(0.0, 1.0, 0.0, 1.0)
  local yellow = ig.ImVec4(1.0, 1.0, 0.0, 1.0)

  local pio = ig.GetIO()

  --------------
  --- main loop
  --------------
  while not win.handle:shouldClose() do
    glfw.pollEvents()
    win:newFrame()

    -- Show ImGui demo
    if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end

    -- Show first window
    local svName = ""

    do ig.Begin(sTitle)
      ig.Text(IFA.ICON_FA_APPLE_WHOLE .. "  Lua: " .. _VERSION)
      ig.Text(IFA.ICON_FA_PAGER .. "  Dear ImGui v" .. ffi.string(ig.GetVersion()))
      ig.Text(IFA.ICON_FA_DISPLAY .. "  GLFW v" .. ffi.string(glfw.glfwVersionString()))
      local s = "  OpenGL v" .. ffi.string(gl.glGetString(glc.GL_VERSION)):split(" ")[1]
      ig.Text(IFA.ICON_FA_CUBES .. s)
      ig.Text("これは日本語表示テスト")
      ig.InputTextWithHint("テキスト入力", "ここに日本語を入力", sBuf,sBufLen)
      ig.Text("入力結果: " .. ffi.string(sBuf))
      ig.Checkbox("デモ・ウインドウ表示", fShowDemo)
      ig.SliderFloat("浮動小数", somefloat, 0.0, 1.0, "%3f", 0)
      local col = win:getWinColor()
      ig.ColorEdit3("背景色変更", col)
      win:setWinColor(col)
      -- File open dialog
      if ig.Button("ファイルを開く") then
        print("Button clicked")
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
      ig.Text("描画フレームレート  %.3f ms/frame (%.1f FPS)" , 1000.0 / pio.Framerate, pio.Framerate)
      ig.Text("経過時間 = %.1f [s]", counter / pio.Framerate)
      counter = counter + 1
      local delay = 600 * 3
      somefloat[0] = math.fmod(counter, delay) / delay

      -- Save button for capturing window image
      ig.PushID(0)
      ig.PushStyleColor(ig.lib.ImGuiCol_Button,        ig.ImVec4(0.7, 0.7, 0.0, 1.0))
      ig.PushStyleColor(ig.lib.ImGuiCol_ButtonHovered, ig.ImVec4(0.8, 0.8, 0.0, 1.0))
      ig.PushStyleColor(ig.lib.ImGuiCol_ButtonActive,  ig.ImVec4(0.9, 0.9, 0.0, 1.0))
      ig.PushStyleColor(ig.lib.ImGuiCol_Text,          ig.ImVec4(0.0, 0.0, 0.0, 1.0))
      if ig.Button("画面を保存") then
        fReqImageCapture = true
      end
      ig.PopStyleColor(4)
      ig.PopID()

      -- Show tooltip help
      local imgSaveFormatStr = imageFormatTbl[cmbItemIndex]
      svName = SaveImageName .. "_" .. counter .. utils.imageExt[imgSaveFormatStr]
      utils.setTooltip(ig, string.format("Save to \"%s\"", svName), ig.lib.ImGuiHoveredFlags_DelayNormal, green)
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
        win.ini.image.imageSaveFormatIndex = cmbItemIndex
        ig.EndCombo()
      end
      utils.setTooltip(ig, "Select image format", ig.lib.ImGuiHoveredFlags_DelayNormal, yellow)

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

    -- Show image Window
    do ig.Begin("イメージ・ウインドウ")
      local imageBoxPosTop = ig.GetCursorScreenPos() -- Get absolute pos.
      local texRef = ffi.new("ImTextureRef")
      texRef._TexData = nil
      texRef._TexID = pic1.texture[0]
      ig.Image(texRef, pic1.size)
      local imageBoxPosEnd = ig.GetCursorScreenPos() -- Get absolute pos.
      --
      if ig.IsItemHovered(ig.lib.ImGuiHoveredFlags_DelayNone) then
        zoomGlass(ig, pic1.texture, pic1.width, imageBoxPosTop, imageBoxPosEnd, IFA.ICON_FA_MAGNIFYING_GLASS .. "  4 x")
      end
      ig.End()
    end

    --
    win:render()

    -- Save window image to file
    if fReqImageCapture then
      fReqImageCapture = false
      local wkSize = ig.GetMainViewport().WorkSize
      utils.saveImage(glext, svName, imageFormatTbl[cmbItemIndex], wkSize.x , wkSize.y)
    end
  end -- end while loop
end


---------
--- main
---------
function main()
  local IconName = "res/img/icon_jp.png" --- title bar icon
  local MainWinWidth = 1024
  local MainWinHeight= 900
  do
    local window = appImGui.createImGui(MainWinWidth, MainWinHeight, "LuaJIT ImGui demo", IconName, false)
    gui_main(window)
    window:destroyImGui()
  end
end

-------------
--- Run main
-------------
main()

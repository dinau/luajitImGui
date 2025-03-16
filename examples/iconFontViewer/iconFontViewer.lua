local ffi   = require"ffi"
local bit   = require"bit"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()

require"mylib.loadimage"
local utils = require"mylib.utils"
local IFA   = require"mylib.fonticon.IconsFontAwesome6"
local ift   = require"iconFontsTblDef"

local appImGui = require"mylib.appImGui"

-------------
--- gui_main
-------------
local gui_main = function (win)
  --- Flags
  local fShowDemo = ffi.new("bool[1]", false)

  local item_current = 1
  local sBufLen    = 100
  local sBuf = ffi.new("char[?]", sBufLen)
  local wsZoom  = ffi.new("float[1]",2.5)
  local item_highlighted_idx = 1
  -- Colors
  local yellow = ig.ImVec4(1.0, 1.0, 0.0, 1.0)
  local green  = ig.ImVec4(0.0, 1.0, 0.0, 1.0)

  local filterAry = {}

  --------------
  --- main loop
  --------------
  while not win.handle:shouldClose() do
    glfw.pollEvents()
    win:newFrame()

    -- Show ImGui demo
    if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end

    -- Show icons in ListBox
    ig.Begin("Icon font viewer")
      ig.SeparatorText((IFA.ICON_FA_FONT_AWESOME .. " Icon font view: " .. ift.len .. " icons"))
      ig.Text("No.[%4s]", tostring(item_current - 1));     -- TODO ?
      ig.SameLine(0,-1.0)
      ffi.copy(sBuf, ift.iconFontsTbl[item_current])
      if ig.Button(IFA.ICON_FA_COPY .. " Copy to", ig.ImVec2(0, 0)) then
        local sRes =  ffi.string(sBuf):match(".+%s(ICON.+).+")
        if sRes ~= nil then
          ig.SetClipboardText(sRes)
        end
      end
      utils.setTooltip(ig, "Clipboard", ig.lib.ImGuiHoveredFlags_DelayNormal, green) -- Show tooltip help
      ig.SameLine(0,-1.0)
      ig.Checkbox("ImGui demo", fShowDemo)

      -- Show ListBox header
      local listBoxWidth = 360  -- The value must be 2^
      ig.SetNextItemWidth(listBoxWidth)
      ig.InputText("##input1", sBuf, sBufLen)
      ig.Separator()

      -- Show icons in ListBox
      ig.BeginChild("child2")
         ig.SetNextItemWidth(listBoxWidth)
         --ig.ListBox("##listbox1" , pItem_current , ift.iconFontsTbl , ift.len, 44)
        if ig.BeginListBox("##listbox2", ig.ImVec2(0, 44 * ig.GetTextLineHeightWithSpacing())) then
          for n = 1, ift.len do
            local is_selected = (item_current == n)
            local flags = 0
            if item_highlighted_idx == n then
              flags = ig.lib.ImGuiSelectableFlags_Highlight
              --item_current = n
            end
            if ig.Selectable(ift.iconFontsTbl[n] , is_selected, flags) then
              item_current = n
            end
            if is_selected then
              ig.SetItemDefaultFocus()
            end
          end
          ig.EndListBox()
        end
      ig.EndChild() -- end BeginChild
    ig.End()

    -- Show icons in Table
    ig.Begin("Icon Font Viewer2", nil, 0)
      ig.Text("%s", " Zoom x"); ig.SameLine(0,-1.0)
      ig.SliderFloat("##Zoom1", wsZoom, 0.8, 5.0, "%.1f", 0)
      ig.Separator()
      ig.BeginChild("child2")
      local wsNormal = 1.0
      local flags = bit.bor(ig.lib.ImGuiTableFlags_Borders, ig.lib.ImGuiTableFlags_RowBg, ig.lib.ImGuiTableFlags_BordersOuter, ig.lib.ImGuiTableFlags_BordersV, ig.lib.ImGuiTableFlags_Resizable, ig.lib.ImGuiTableFlags_Reorderable, ig.lib.ImGuiTableFlags_Hideable)
      local text_base_height = ig.GetTextLineHeightWithSpacing()
      local outer_size = ig.ImVec2(0.0, text_base_height * 8)
      local col = 10
      if ig.BeginTable("table_scrolly", col, flags, outer_size, 0) then
        for row = 0, (ift.len / col) - 1 do
          ig.TableNextRow(0, 0.0)
          for column = 0, col - 1 do
            local ix = (row  * col) + column + 1
            ig.TableSetColumnIndex(column)
            ig.SetWindowFontScale(wsZoom[0])
            ig.Text("%s", ift.iconFontsTbl2[ix][1])
            if ig.IsItemHovered() then
               item_highlighted_idx = ix
               item_current =  ix
            end
            --ig.Button(icon, ig.ImVec2(0, 0))
            --
            local iconFontLabel = ift.iconFontsTbl2[ix][2]
            utils.setTooltip(ig, iconFontLabel, ig.lib.ImGuiHoveredFlags_DelayNormal, yellow)
            ig.SetWindowFontScale(wsNormal)
            --
            ig.PushID(ix)
            if ig.BeginPopupContextItem("Contex Menu", 1) then
              if ig.MenuItem("Copy to clip board", "" , false, true) then
                item_current =  ix
                ig.SetClipboardText(ift.iconFontsTbl2[ix][2])
              end
              ig.EndPopup()
            end
            ig.PopID()
          end       -- for column end
        end         -- for row end
        ig.EndTable()
      end           -- end if BeginTable
      ig.EndChild() -- end BeginChild
    ig.End()        -- end Begin

    -- Text filter window
    ig.Begin("Icon Font filter", nil, 0)
      ig.Text("(Copy)")
      if ig.IsItemHovered() then
        local sRes = filterAry[1]:match(".+(ICON.+)")
        if sRes ~= nil then
          ig.SetClipboardText(sRes)
        end
      end
      filterAry = {}
      utils.setTooltip(ig, "Copied first line to clipboard !") -- Show tooltip help
      ig.SameLine()
      filter = ig.ImGuiTextFilter.__new()
      filter:Draw("Filter")
      tbl = ift.iconFontsTbl
      for i=1,ift.len do
        pstr = tbl[i]
        if filter:PassFilter(pstr) then
          ig.Text("[%04s]  %s", tostring(i - 1), tbl[i])
          table.insert(filterAry, tbl[i])
        end
      end
    ig.End()
    --
    win:render()
  end -- end while loop
end

---------
--- main
---------
local main = function()
  local IconName = "res/img/lua.png" --- title bar icon
  local MainWinWidth, MainWinHeight = 1024, 900
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

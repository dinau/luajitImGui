local ffi   = require"ffi"
local utils = require"mylib.utils"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()

require"mylib.loadimage"
require"mylib.setupFonts"
require"mylib.zoomglass"
local utils = require"mylib.utils"
local IFA   = require"mylib.fonticon.IconsFontAwesome6"
local ift   = require"iconFontsTblDef"

--- Global var: app
require"mylib.apps"

--- Global var

--- Image / Icon folder
local IconDir = "res/img/"

-- Load inifile
LoadIni()

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
local window = glfw.Window(App.mainWindow.width,App.mainWindow.height) --- ### Create main window
window:setPos(App.mainWindow.posx ,App.mainWindow.posy) --- ### Move main window to previous position

window:makeContextCurrent()

glfw.swapInterval(1) --- Set VSync

--------------------------
--- Choose implementation
--------------------------
local ig_impl = ig.Imgui_Impl_glfw_opengl3() --standard imgui opengl3 example
--local ig_impl = ig.ImplGlfwGL3() --multicontext

local pio = ig.GetIO()
pio.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + pio.ConfigFlags

ig_impl:Init(window, true)

ig.lib.ImGui_ImplOpenGL3_DestroyFontsTexture()
ig.lib.ImGui_ImplOpenGL3_CreateFontsTexture()

-------------------------
--- Load title bar icon
-------------------------
local  IconName = IconDir .. "lua.png"
utils.loadWindowIcon(window, IconName)

--- Flags
local fShowDemo = ffi.new("bool[1]",true)

--------------
--- Load font
--------------
local  _, sActiveFontName, _ = setupFonts(pio)

-- Set window title
local sTitle = ""
local imGuiVersion = ffi.string(ig.GetVersion())
if "" == sActiveFontName then
  sTitle = string.format("[ImGui: v%s]" ,imGuiVersion)
else
  print("Loaded font: ", sActiveFontName)
  local sAry = sActiveFontName:split("/")
  local fntName = sAry[#sAry] -- Eliminated directory part
  sTitle = string.format("[ImGui: v%s] Start up font: %s)" , imGuiVersion,fntName)
end
window:setTitle(sTitle)

ig.StyleColorsClassic()

--------------
--- main loop
--------------
--- Global vars
local clearColor = ffi.new("float[3]",{0.25,0.65,0.85})
local avoid_flicker = true
local pItem_current = ffi.new("int[1]",0)
local sBufLen    = 100
local sBuf = ffi.new("char[?]", sBufLen)
local item_current = ffi.new("int[1]",0)
local wsZoom  = ffi.new("float[1]",2.5)
-- Colors
local yellow = ig.ImVec4(1.0, 1.0, 0.0, 1.0)
local green  = ig.ImVec4(0.0, 1.0, 0.0, 1.0)

while not window:shouldClose() do
  glfw.pollEvents()
  gl.glClearColor(clearColor[0],clearColor[1],clearColor[2],1.0)
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)
  ig_impl:NewFrame()

  -- Show ImGui demo
  if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end

  -------------------------
  -- Show icons in ListBox
  -------------------------
  ig.Begin("Icon font viewer")
     ig.SeparatorText((IFA.ICON_FA_FONT_AWESOME .. " Icon font view: " .. ift.len .. " icons"))
     ig.Text("No.[%4s]", tostring(pItem_current[0]));     -- TODO ?
     ig.SameLine(0,-1.0)
     ffi.copy(sBuf, ffi.string(ift.iconFontsTbl[pItem_current[0]]))
     if ig.Button(IFA.ICON_FA_COPY .. " Copy to", ig.ImVec2(0, 0)) then
       local sRes =  ffi.string(sBuf):match(".+%s(ICON.+).+")
       if sRes ~= nil then
         ig.SetClipboardText(sRes)
       end
     end
     utils.setTooltip(ig, "Clipboard", ig.ImguiHoveredFlags_DelayNormal, green) -- Show tooltip help

     -- Show ListBox header
     local listBoxWidth = 360  -- The value must be 2^
     ig.SetNextItemWidth(listBoxWidth)
     ig.InputText("##input1", sBuf, sBufLen)

     -- Show icons in ListBox
     ig.SetNextItemWidth(listBoxWidth)
     ig.ListBox("##listbox1"
                   , pItem_current
                   , ift.iconFontsTbl
                   , ift.len, 44)
  ig.End()

  -----------------------
  -- Show icons in Table
  -----------------------
  ig.Begin("Icon Font Viewer2", nil, 0)
    ig.SliderFloat("x Zoom", wsZoom, 0.8, 5.0, "%.1f", 0)
    ig.Separator()
    ig.BeginChild("child1")
    local wsNormal = 1.0
    local flags = ig.ImGuiTableFlags_RowBg or ig.ImGuiTableFlags_BordersOuter or ig.ImGuiTableFlags_BordersV or ig.ImGuiTableFlags_Resizable or ig.ImGuiTableFlags_Reorderable or ig.ImGuiTableFlags_Hideable
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
          local iconFontLabel = ift.iconFontsTbl2[ix][2]
          utils.setTooltip(ig, iconFontLabel, ig.ImguiHoveredFlags_DelayNormal, yellow)
          ig.SetWindowFontScale(wsNormal)
          --
          ig.PushID(ix)
          if ig.BeginPopupContextItem("Contex Menu", 1) then
            if ig.MenuItem("Copy to clip board", "" , false, true) then
              item_current[0] =  ix
              ig.SetClipboardText(ift.iconFontsTbl2[ix][2])
            end
            ig.EndPopup()
          end
          ig.PopID()
        end -- for column end
      end -- for row end
      ig.EndTable()
    end -- end if BeginTable
    ig.EndChild() -- end BeginChild
  ig.End() -- end Begin

  --
  ig_impl:Render()
  window:swapBuffers()

  if avoid_flicker then -- Avoid flickering window at startup.
    avoid_flicker = false
    window:show() --- Show main window
  end

  --
end

-- Save Window info
local info = {}
info.x, info.y = window:getPos()
local wsize = ig.GetMainViewport().WorkSize
info.w = wsize.x
info.h = wsize.y
SaveIni(info)

-------------
--- end proc
-------------
ig_impl:destroy()
window:destroy()
glfw.terminate()

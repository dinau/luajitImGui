local ffi   = require"ffi"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
local appImGui = require"mylib.appImGui"
local utils    = require"mylib.utils"
local IFA      = require"mylib.fonticon.IconsFontAwesome6"

-------------
--- gui_main
-------------
function gui_main(win)
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
  --- main loop
  --------------
  while not win.handle:shouldClose() do
    glfw.pollEvents()
    win:newFrame()

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
      win:render()
    end -- end while loop
end

---------
--- main
---------
function main()
  local IconName = "res/img/lua.png" --- title bar icon
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

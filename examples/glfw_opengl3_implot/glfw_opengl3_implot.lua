local ffi   = require"ffi"
--- GLFW/etc
local glfw  = require"glfw"
local gllib = require"gl"
local ig    = require"imgui.glfw"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
--
local IFA      = require"mylib.fonticon.IconsFontAwesome6"
local appImGui = require"mylib.appImGui"
local ipDemo   = require"imPlotWindow"

-------------
--- gui_main
-------------
local gui_main = function (win)
  --- Flags
  local fShowDemo       = ffi.new("bool[1]",true)
  local fShowImPlotDemo = ffi.new("bool[1]",true)

  --- Vars
  local sBufLen    = 100
  local sBuf       = ffi.new("char[?]", sBufLen)
  local somefloat  = ffi.new("float[1]", 0.0)
  local counter    = 0

  local pio = ig.GetIO()

  --------------
  --- main loop
  --------------
  while not win.handle:shouldClose() do
    glfw.pollEvents()
    win:newFrame()

    ---- Show ImGui demo
    if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end
    if fShowImPlotDemo[0] then ig.ImPlot_ShowDemoWindow(fShowImPlotDemo) end

    ---- Show first window
    local svName = ""
    do ig.Begin("Example window " .. IFA.ICON_FA_KIWI_BIRD)
      ig.Text("GLFW v" .. ffi.string(glfw.glfwVersionString()))
      local s = "OpenGL v" .. ffi.string(gl.glGetString(glc.GL_VERSION)):split(" ")[1]
      ig.Text(s)
      ig.Text("Input text test")
      ig.InputTextWithHint("Input text", "Here input text", sBuf,100)
      ig.Text("Input result: " .. ffi.string(sBuf))
      ig.Checkbox("ImGui demo", fShowDemo); ig.SameLine()
      ig.Checkbox("ImPlot demo ", fShowImPlotDemo)
      ig.SliderFloat("Float number", somefloat, 0.0, 1.0, "%3f", 0)
      local col = win:getWinColor()
      ig.ColorEdit3("Background Color", col)
      win:setWinColor(col)

      -- File open dialog
      if ig.Button("Open file") then
        print("Button clicked")
      end
      ig.SameLine(0.0,-1.0)

      -- Show tooltip help
      if ig.IsItemHovered() and ig.BeginTooltip() then
        ig.Text("Open file")
        local ary = ffi.new("float[7]",{0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2})
        ig.PlotLines("Curve", ffi.cast("float *",ary), 7 ,0,"Overlay strings")
        ig.Text("Sin(time) = %.2f", math.sin(ig.GetTime()))
        ig.EndTooltip()
      end
      ig.Text("Selected filename = %s", "test.jpg")
      --
      ig.Text("Frame rate  %.3f ms/frame (%.1f FPS)" , 1000.0 / pio.Framerate, pio.Framerate)
      ig.Text("Elapsed time = %.1f [s]", counter / pio.Framerate)
      counter = counter + 1
      local delay = 600 * 3
      somefloat[0] = math.fmod(counter, delay) / delay

      ig.End()
    end
    --

    ipDemo.imPlotWindowFirst()
    ipDemo.imPlotWindowSecond()
    ipDemo.DemoSurfacePlots(pio) -- Show ImPlot3D demo
    --
    win:render()
  end -- end while loop
end

---------
--- main
---------
local main = function()
  local IconName = "res/img/lua.png" --- title bar icon
  local WinWidth, WinHeight = 1024, 900
  local fImPlot = true
  local fDocking = false
  do
    local window = appImGui.createImGui(WinWidth, WinHeight, "LuaJIT ImGui demo", IconName, fDocking, fImPlot)
    gui_main(window)
    window:destroyImGui()
  end
end

-------------
--- Run main
-------------
main()

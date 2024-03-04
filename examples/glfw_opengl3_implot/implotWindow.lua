local ffi = require "ffi"
local ig = require"imgui.glfw"
---

--- first window plot data
local dataSize = 10
local x_data = ffi.new("float[?]",dataSize)
local y_data = ffi.new("float[?]",dataSize)
for i=0,dataSize-1 do
  x_data[i] = i
  y_data[i] = i * i
end

-----------------------
--- imPlotWindowFirst
-----------------------
function imPlotWindowFirst()
  --- First plot window
  ig.Begin("Ploters")
    if (ig.ImPlot_BeginPlot("Plot demo", ig.ImVec2(0,0))) then
      ig.ImPlot_PlotLine("Line: y=x*x", x_data, y_data, dataSize)
      ig.ImPlot_PlotBars("Bar : y=x*x", y_data, dataSize)
      ig.ImPlot_EndPlot()
    end
  ig.End()
end

--- Second winodw plot data
local xs1Size = 1000
local xs1 = ffi.new("float[?]",xs1Size)
local ys1 = ffi.new("float[?]",xs1Size)
local xs2Size = 20
local xs2 = ffi.new("float[?]",xs1Size)
local ys2 = ffi.new("float[?]",xs1Size)
for i=0, xs2Size-1 do
  xs2[i] = i * 1/19.0
  ys2[i] = xs2[i] * xs2[i]
end

-----------------------
--- imPlotWindowSecond
-----------------------
function imPlotWindowSecond()
  --- Second plot window
  ig.Begin("Line Plots")
    for i=0,xs1Size-1 do
      xs1[i] = i * 0.001
      ys1[i] = 0.5 + 0.5 * math.sin(50 * (xs1[i] + ig.GetTime() / 10))
    end
    if (ig.ImPlot_BeginPlot("Line Plots demo", ig.ImVec2(0,0))) then
      ig.ImPlot_SetupAxes("x", "y")
      ig.ImPlot_PlotLine("f(x)", xs1, ys1, xs1Size)
      ig.ImPlot_SetNextMarkerStyle(ig.lib.ImPlotMarker_Circle)
      ig.ImPlot_PlotLine("g(x)", xs2, ys2, xs2Size,ig.lib.ImPlotLineFlags_Segments)
      ig.ImPlot_EndPlot()
    end
  ig.End()
end

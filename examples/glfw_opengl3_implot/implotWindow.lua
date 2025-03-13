local ffi = require "ffi"
local ig = require"imgui.glfw"
---

local M = {}

--- first window plot data
local dataSize = 10
local x_data = ffi.new("float[?]", dataSize)
local y_data = ffi.new("float[?]", dataSize)
for i=0,dataSize-1 do
  x_data[i] = i
  y_data[i] = i * i
end

-----------------------
--- imPlotWindowFirst
-----------------------
function M.imPlotWindowFirst()
  --- First plot window
  ig.Begin("Ploters written in LuaJIT")
    if (ig.ImPlot_BeginPlot("Plot demo", ig.ImVec2(0,0))) then
      ig.ImPlot_PlotLine("Line: y=x*x", x_data, y_data, dataSize)
      ig.ImPlot_PlotBars("Bar : y=x*x", y_data, dataSize)
      ig.ImPlot_EndPlot()
    end
  ig.End()
end

--- Second winodw plot data
local xs1Size = 1000
local xs1 = ffi.new("float[?]", xs1Size)
local ys1 = ffi.new("float[?]", xs1Size)
local xs2Size = 20
local xs2 = ffi.new("float[?]", xs1Size)
local ys2 = ffi.new("float[?]", xs1Size)
for i=0, xs2Size - 1 do
  xs2[i] = i * 1/19.0
  ys2[i] = xs2[i] * xs2[i]
end

-----------------------
--- imPlotWindowSecond
-----------------------
function M.imPlotWindowSecond()
  --- Second plot window
  ig.Begin("Line Plots written in LuaJIT")
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

----------------------------------
-- For ImPlot3D: DemoSurfacePlots
----------------------------------
-- Static vars
local N = 20
local xs = ffi.new("float[?]", N * N)
local ys = ffi.new("float[?]", N * N)
local zs = ffi.new("float[?]", N * N)
local t = 0.0
--
local  selected_fill = ffi.new("int32_t[?]", 1, {1}) -- Colormap by default
local  sel_colormap  = ffi.new("int32_t[?]", 1, {5}) -- Jet by default
local  solid_color   = ffi.new("ImVec4",   {0.8, 0.8, 0.2, 0.6})
-- Generate colormaps
local cColormaps = {}
local sColormaps = {"Viridis", "Plasma", "Hot", "Cool", "Pink", "Jet", "Twilight", "RdBu", "BrBG", "PiYG", "Spectral", "Greys"}
for i, v in ipairs(sColormaps) do
  cColormaps[i] = ffi.new("const char*",v)
end
local colormaps = ffi.new("const char*[?]", #cColormaps, cColormaps)
--
local custom_range = ffi.new("bool[1]", false)
local range_min    = ffi.new("float[1]", -1.0)
local range_max    = ffi.new("float[1]", 1.0)

---------------------
--- DemoSurfacePlots
---------------------
function M.DemoSurfacePlots(pio)
  ig.Begin("Surface Plots written in LuaJIT")
    ig.Text("Frame rate  %.3f ms/frame (%.1f FPS)" , 1000.0 / pio.Framerate, pio.Framerate)
    t = t + ig.GetIO().DeltaTime
    -- Define the range for X and Y
    local min_val = -1.0
    local max_val = 1.0
    local step = (max_val - min_val) / (N - 1)
   -- Populate the xs, ys, and zs arrays
    for i=0, N -1 do
      local j = 0
      while j < N do
        local  idx = i * N + j
        xs[idx] = min_val + j * step -- X values are constant along rows
        ys[idx] = min_val + i * step -- Y values are constant along columns
        zs[idx] = math.sin(2 * t + math.sqrt((xs[idx] * xs[idx] + ys[idx] * ys[idx]))) -- z = sin(2t + sqrt(x^2 + y^2))
        j = j + 1
      end
    end
  -- Choose fill color
  ig.Text("Fill color")
  do ig.Indent()
    -- Choose solid color
    ig.RadioButton("Solid", selected_fill, 0)
    if selected_fill[0] == 0 then
      ig.SameLine()
      ig.ColorEdit4("##SurfaceSolidColor", ffi.cast("float*", solid_color))
    end
    -- Choose colormap
    ig.RadioButton("Colormap", selected_fill, 1)
    if (selected_fill[0] == 1) then
      ig.SameLine()
      ig.Combo("##SurfaceColormap", sel_colormap, colormaps, #sColormaps)
    end
    ig.Unindent()
  end

  -- Choose range
  ig.Checkbox("Custom range", custom_range)
  do ig.Indent()
    if not custom_range[0] then ig.BeginDisabled() end
    ig.SliderFloat("Range min", range_min, -1.0               , range_max[0] - 0.01)
    ig.SliderFloat("Range max", range_max, range_min[0] + 0.01, 1.0)
    if not custom_range[0] then ig.EndDisabled() end
    ig.Unindent()
  end
  -- Begin the plot
  if selected_fill[0] == 1 then
    ig.ImPlot3D_PushColormap(colormaps[sel_colormap[0]])
  end
  if ig.ImPlot3D_BeginPlot("Surface Plots", ig.ImVec2(-1, 400), ig.ImPlot3DFlags_NoClip) then
    -- Set styles
    ig.ImPlot3D_SetupAxesLimits(-1, 1, -1, 1, -1.5, 1.5)
    ig.ImPlot3D_PushStyleVar(ig.lib.ImPlot3DStyleVar_FillAlpha, 0.8)
    if selected_fill[0] == 0 then
      ig.ImPlot3D_SetNextFillStyle(solid_color)
    end
    ig.ImPlot3D_SetNextLineStyle(ig.ImPlot3D_GetColormapColor(1))

    -- Plot the surface
    if custom_range[0] then
      ig.ImPlot3D_PlotSurface("Wave Surface", xs, ys, zs, N, N, ffi.cast("double",range_min[0]), ffi.cast("double",range_max[0]))
    else
      ig.ImPlot3D_PlotSurface("Wave Surface", xs, ys, zs, N, N)
    end
    -- End the plot
    ig.ImPlot3D_PopStyleVar()
    ig.ImPlot3D_EndPlot()
  end
  if selected_fill[0] == 1 then
    ig.ImPlot3D_PopColormap()
  end
  ig.End()
end

return M

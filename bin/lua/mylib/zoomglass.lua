local ffi   = require"ffi"
local ig    = require"imgui.glfw"

--------------
--- zoomGlass
--------------
function zoomGlass(textureID, itemWidth, itemPosTop, itemPosEnd)
--   # itemPosTop and itemPosEnd are absolute position in main window.
   if ig.BeginItemTooltip() then
     local itemHeight = itemPosEnd.y - itemPosTop.y
     local  my_tex_w = itemWidth
     local  my_tex_h = itemHeight
     local wkSize = ig.GetMainViewport().WorkSize
--     #igText("lbp: (%.2f, %.2f)", pio.MousePos.x, pio.MousePos.y)
     local  pio = ig.GetIO()
     local  region_sz = 32.0
     local  region_x = pio.MousePos.x - itemPosTop.x - region_sz * 0.5
     local  region_y = pio.MousePos.y - itemPosTop.y - region_sz * 0.5
     local  zoom = 4.0
     if region_x < 0.0 then
       region_x = 0.0
     elseif region_x > (my_tex_w - region_sz) then
       region_x = my_tex_w - region_sz
     end
     if region_y < 0.0 then
       region_y = 0.0
     elseif region_y > my_tex_h - region_sz then
       region_y = my_tex_h - region_sz
     end
     local uv0 =        ig.ImVec2((region_x) / my_tex_w, (region_y) / my_tex_h)
     local uv1 =        ig.ImVec2((region_x + region_sz) / my_tex_w, (region_y + region_sz) / my_tex_h)
     local tint_col =   ig.ImVec4(1.0, 1.0, 1.0, 1.0)    -- # No tint
     local border_col = ig.ImVec4(0.22, 0.56, 0.22, 1.0) -- # Green
     ig.Image(ffi.cast("ImTextureID",textureID[0]), ig.ImVec2(region_sz * zoom, region_sz * zoom), uv0, uv1, tint_col, border_col)
     ig.EndTooltip()
   end
end

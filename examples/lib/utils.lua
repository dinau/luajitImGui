local M = {}

function M.fileExists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end

--https://stackoverflow.com/questions/72386387/lua-split-string-to-table
function string:split(sep)
   local sep = sep or ","
   local result = {}
   local pattern = string.format("([^%s]+)", sep)
   local i = 1
   self:gsub(pattern, function (c) result[i] = c i = i + 1 end)
   return result
end

local lgTable = {"LANG","LC_ALL","LC_CTYPE"}
function M.checkLang(countryID)
  for i=1,#lgTable do
    local envValue = os.getenv( lgTable[i] ):lower()
    print(lgTable[i],envValue,countryID:lower())
    if nil ~= envValue:match(countryID:lower()) then
      return true -- match ok
    end
  end
  return false
end

-------------------------
--- Load title bar icon
-------------------------
local ffi = require "ffi"
local glfw = require"glfw"
local stb = require"stb_image"
function M.LoadWindowIcon(window,iconName)
  if not M.fileExists(iconName) then
    glfw.glfw.glfwSetWindowIcon(window, 0, nil)
    print("Error!: Can't find Icon ",iconName)
    return
  end
  local w = ffi.new("int[1]")
  local h = ffi.new("int[1]")
  local channels = ffi.new("int[1]",0)
  local stbi_RGBA = 4
  local pixels = stb.stbi_load(iconName, w, h, channels, stbi_RGBA)
  local img = ffi.new("GLFWimage")
  img.width  = w[0]
  img.height = h[0]
  img.pixels = ffi.new("unsigned char[?]", w[0] * h[0] * 4)
  for x=0, w[0]-1 do
    for y=0 ,h[0]-1 do
      for p=0 ,3 do
        img.pixels[(x + y*w[0])*4 + p] = pixels[(x + y*w[0])*4 + p]
      end
    end
  end
  stb.stbi_image_free(pixels)
  glfw.glfw.glfwSetWindowIcon(window, 1, img)
end

return M

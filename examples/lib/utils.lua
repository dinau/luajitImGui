
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
function M.loadWindowIcon(window,iconName)
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

---
local ffi = require "ffi"
local glfw = require"glfw"
local gllib = require"gl"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()
local im = require"imffi"

M.imageExt = {JPEG=".jpg", PNG=".png", TIFF=".tif", BMP=".bmp"}

--------------
--- SaveImage
--------------
--- Refer to luajitImGui/anima/mirror-im/html/index.html
function M.saveImage(filename,formato,width,height,xPos,yPos)
  local formato = formato or "TIFF"
  local xPos = xPos or 0
  local yPos = yPos or 0
  local w,h = width, height
  print("SaveImage",w,h,formato)
  local pixelsUserData = ffi.new("char[?]",w*h*4)

  local intformat = glc.GL_RGBA --self.SRGB and glc.GL_SRGB8_ALPHA8 or glc.GL_RGBA
  --if self.SRGB then gl.glEnable(glc.GL_FRAMEBUFFER_SRGB) end

  glext.glBindBuffer(glc.GL_PIXEL_PACK_BUFFER,0)
  gl.glPixelStorei(glc.GL_PACK_ALIGNMENT, 1)
  gl.glReadPixels(xPos, yPos, w, h, intformat, glc.GL_UNSIGNED_BYTE, pixelsUserData)

  --if self.SRGB then gl.glDisable(glc.GL_FRAMEBUFFER_SRGB) end
  -- glext.glBindFramebuffer(glc.GL_READ_FRAMEBUFFER,oldfboread)

  local image = im.ImageCreateFromOpenGLData(w, h, glc.GL_RGBA, pixelsUserData);
  --local err = im.FileImageSave(filename,formato,image)
  local err = image:FileSave(filename,formato)
  if (err and err ~= im.ERR_NONE) then
    print("saved",filename)
    error(im.ErrorStr(err))
  end
  --im.ImageDestroy(image)
  image:Destroy()
end

return M

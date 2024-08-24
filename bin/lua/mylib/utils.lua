
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

function M.loadWindowIcon(window,iconName)
  if true then
    M.loadWindowIconIm(window,iconName)  -- OK for gcc and msvc compiler
  else
    M.loadWindowIconSTB(window,iconName) -- Only for gcc compiler at this moment
  end
end

local ffi = require"ffi"
local glfw = require"glfw"
-------------------------
--- Load title bar icon
-------------------------
local stb = require"mylib.stb_image"
function M.loadWindowIconSTB(window,iconName)
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
  if true then
    img.pixels = pixels
    glfw.glfw.glfwSetWindowIcon(window, 1, img)
    stb.stbi_image_free(pixels)
  else
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
end

local im = require"imffi"
local imffi = im.imffi
ffi.cdef[[
  int imFileReadImageData (imFile* ifile, void* data, int convert2bitmap, int color_mode_flags);
]]
----------------------
-- loadWindowIconGLFW
----------------------
function M.loadWindowIconIm(window,iconName)
  function checkError(err)
    if (err and err ~= imffi.IM_ERR_NONE) then
      print("Error load: ",iconName,err)
      error(im.ErrorStr(err))
    end
  end
  if not M.fileExists(iconName) then
    glfw.glfw.glfwSetWindowIcon(window, 0, nil)
    print("Error!: Can't find Icon ",iconName)
    return
  end
  local err = ffi.new("int[1]",imffi.IM_ERR_NONE)
  local width = ffi.new("int[1]")
  local height = ffi.new("int[1]")
  local colorMode = ffi.new("int[1]",imffi.IM_ALPHA)
  local dataType = ffi.new("int[1]")
  local ifile = imffi.imFileOpen(iconName, err)
  checkError(err[0])
  imffi.imFileReadImageInfo(ifile, 0, width, height, colorMode, dataType)
  local data = ffi.new("unsigned char[?]",width[0] * height[0] * 4)
  --IM_ALPHA    = 0x100,  /**< adds an Alpha channel */
  --IM_PACKED   = 0x200,  /**< packed components (rgbrgbrgb...) */
  --IM_TOPDOWN  = 0x400   /**< orientation from top down to bottom */
  --print("width,height: ",width[0],height[0])
  --print("dataType: ",dataType[0])
  --print(string.format("colorMode: 0x%X",colorMode[0]))

  -- Convert to packed alpha topdown image
  local errRead = imffi.imFileReadImageData(ifile, data, 0
                      ,imffi.IM_ALPHA + imffi.IM_PACKED + imffi.IM_TOPDOWN)
  checkError(errRead)
  local img = ffi.new("GLFWimage")
  img.width  = width[0]
  img.height = height[0]
  img.pixels = data
  glfw.glfw.glfwSetWindowIcon(window, 1, img)
  imffi.imFileClose(ifile)
end

---
local gllib = require"gl"
gllib.set_loader(glfw)
local gl, glc, glu, glext = gllib.libraries()

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

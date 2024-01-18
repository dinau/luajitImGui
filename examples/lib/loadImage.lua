local stb = require"stb_image"
local ffi = require "ffi"
local gl,glc = require"gl".libraries()

--// Simple helper function to load an image into a OpenGL texture with common settings
function LoadTextureFromFile(filename, out)
  --// Load from file
  local image_width = ffi.new("int[1]",0)
  local image_height = ffi.new("int[1]",0)
  local comp = ffi.new("int[1]",0)
  local image_data = stb.stbi_load(filename, image_width, image_height, comp, 4)
  if image_data == nil then
    print("Error!: load image : fail at stbi_load() ")
    return nil
  end
  --// Create a OpenGL texture identifier
  gl.glGenTextures(1, out.texture)
  gl.glBindTexture(glc.GL_TEXTURE_2D, out.texture[0])
  --// Setup filtering parameters for display
  gl.glTexParameteri(glc.GL_TEXTURE_2D, glc.GL_TEXTURE_MIN_FILTER, glc.GL_LINEAR)
  gl.glTexParameteri(glc.GL_TEXTURE_2D, glc.GL_TEXTURE_MAG_FILTER, glc.GL_LINEAR)
  gl.glTexParameteri(glc.GL_TEXTURE_2D, glc.GL_TEXTURE_WRAP_S, glc.GL_CLAMP_TO_EDGE) --// This is required on WebGL for non power-of-two textures
  gl.glTexParameteri(glc.GL_TEXTURE_2D, glc.GL_TEXTURE_WRAP_T, glc.GL_CLAMP_TO_EDGE) --// Same
  --// Upload pixels into texture
  --#if defined(GL_UNPACK_ROW_LENGTH) && !defined(__EMSCRIPTEN__)
  gl.glPixelStorei(glc.GL_UNPACK_ROW_LENGTH, 0)
  --.#endif
  gl.glTexImage2D(glc.GL_TEXTURE_2D
                , 0, glc.GL_RGBA
                , image_width[0], image_height[0]
                , 0 , glc.GL_RGBA
                , glc.GL_UNSIGNED_BYTE, image_data)
  stb.stbi_image_free(image_data)

  out.width = image_width[0]
  out.height = image_height[0]
  out.comp = comp[0]

  return true
end

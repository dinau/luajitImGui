local ffi   = require"ffi"
--- SDL2/etc
local sdl   = require"sdl2_ffi"
local gllib = require"gl"
gllib.set_loader(sdl)
local gl, glc, glu, glext = gllib.libraries()
local ig    = require"imgui.sdl"
require"mylib.loadimage"
require"mylib.setupFonts"
require"mylib.zoomglass"
local utils = require"mylib.utils"
local IFA   = require"mylib.fonticon.IconsFontAwesome6"

--- Global var: app
require"mylib.apps"

---
local SaveImageName = "ImageSaved"

-- Select {JPEG, PNG, TIFF, BMP}
local SaveFormat = "JPEG"

--- Global var
local fReqImageCapture = false

--- Image / Icon folder
local ImgDir = "img/"

-- Load inifile
LoadIni()

if (sdl.init(sdl.INIT_VIDEO+sdl.INIT_TIMER) ~= 0) then
    print(string.format("Error: %s\n", sdl.getError()))
    return -1
end

local versions = {{4, 6}, {4, 5}, {4, 4}, {4, 3}, {4, 2}, {4, 1}, {4, 0}, {3, 3}}
local window = 0
for _, ver in pairs(versions) do
  sdl.gL_SetAttribute(sdl.GL_CONTEXT_FLAGS, sdl.GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
  sdl.gL_SetAttribute(sdl.GL_CONTEXT_PROFILE_MASK, sdl.GL_CONTEXT_PROFILE_CORE)
  sdl.gL_SetAttribute(sdl.GL_DOUBLEBUFFER, 1)
  sdl.gL_SetAttribute(sdl.GL_DEPTH_SIZE, 24)
  sdl.gL_SetAttribute(sdl.GL_STENCIL_SIZE, 8)
  sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, ver[1])
  sdl.gL_SetAttribute(sdl.GL_CONTEXT_MINOR_VERSION, ver[2])

  local current = ffi.new("SDL_DisplayMode[1]")
  sdl.getCurrentDisplayMode(0, current)

  window = sdl.createWindow("ImGui SDL2+OpenGL3 example"
                   ,App.mainWindow.posx -- x
                   ,App.mainWindow.posy -- y
                   ,App.mainWindow.width, App.mainWindow.height  -- w, h
                   ,sdl.WINDOW_OPENGL + sdl.WINDOW_RESIZABLE + sdl.WINDOW_HIDDEN)

  if window ~= 0 then
      break
  end
end
if window == 0 then
  print("Error!: sdl.createWindow()")
  os.exit(false)
end

local gl_context = sdl.gL_CreateContext(window)
sdl.gL_MakeCurrent(window, gl_context)
sdl.gL_SetSwapInterval(1); -- Enable vsync

local ig_impl = ig.Imgui_Impl_SDL_opengl3()
ig_impl:Init(window, gl_context)

---------------
--- Load image
---------------
local ImageName = ImgDir .. "himeji-400.jpg"
local pic1 = {texture = ffi.new("GLuint[1]"), width = 0, height = 0, comp = 0}
if nil == LoadTextureFromFile(ImageName, pic1) then
  print("Error!: Can't load image file: ",ImageName)
else
  -- print(pic1.texture)
  -- print(pic1.width, pic1.height)
  -- print("Comp:",pic1.comp)
end
pic1.size = ig.ImVec2(pic1.width, pic1.height)

local pio = ig.GetIO()

--------------
--- Load font
--------------
local  _, sActiveFontName, _ = setupFonts(pio)

-- Set window title
local sTitle
local imGuiVersion = ffi.string(ig.GetVersion())
if "" == sActiveFontName then
  sTitle = string.format("[ImGui: v%s]" ,imGuiVersion)
else
  print("Loaded font: ", sActiveFontName)
  local sAry = sActiveFontName:split("/")
  local fntName = sAry[#sAry] -- Eliminated directory part
  sTitle = string.format("[ImGui: v%s] Start up font: %s)"
                          , imGuiVersion,fntName)
end
--------------
--- main loop
--------------
--- Global vars
local fShowDemo  = ffi.new("bool[1]",true)
local sBufLen= 100
local sBuf       = ffi.new("char[?]",sBufLen)
local somefloat  = ffi.new("float[1]",0.0)
local clearColor = ffi.new("float[3]",{0.25,0.65,0.85})
local counter = 0
local done = false
local showWindowDelay = 2
--
local sdlVer = ffi.new("SDL_version")
sdl.GetVersion(sdlVer)

--local sTitle = string.format("[ImGui: v%s]" ,ffi.string(ig.GetVersion()))

while (not done) do
  --SDL_Event
  local event = ffi.new"SDL_Event"
  while (sdl.pollEvent(event) ~=0) do
    ig.lib.ImGui_ImplSDL2_ProcessEvent(event)
    if (event.type == sdl.QUIT) then
      done = true
    end
    if (event.type == sdl.WINDOWEVENT and event.window.event == sdl.WINDOWEVENT_CLOSE and event.window.windowID == sdl.getWindowID(window)) then
      done = true
    end
  end
  --standard rendering
  --sdl.gL_MakeCurrent(window, gl_context)
  gl.glClearColor(clearColor[0],clearColor[1],clearColor[2],1.0)
  gl.glViewport(0, 0, pio.DisplaySize.x, pio.DisplaySize.y)
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)

  ig_impl:NewFrame()
  -- Show ImGui demo
  if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end
  local svName
  do ig.Begin(sTitle)
    ig.Text(string.format("SDL2 v%d.%d.%d",sdlVer.major,sdlVer.minor,sdlVer.patch))
    local s = "OpenGL v" .. ffi.string(gl.glGetString(glc.GL_VERSION)):split(" ")[1]
    ig.Text(s)
    ig.Text("Input text test")
    ig.InputTextWithHint("Input text", "Here input text", sBuf,100)
    ig.Text("Input result: " .. ffi.string(sBuf))
    ig.Checkbox("Show ImGui demo window", fShowDemo)
    ig.SliderFloat("Float number", somefloat, 0.0, 1.0, "%3f", 0)
    ig.ColorEdit3("Change background", clearColor)
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
    ig.Text("Frame rate  %.3f ms/frame (%.1f FPS)"
      , 1000.0 / pio.Framerate, pio.Framerate)
    ig.Text("Elapsed time = %.1f [s]", counter / pio.Framerate)
    counter = counter + 1
    local delay = 600 * 3
    somefloat[0] = math.fmod(counter, delay) / delay

    -- Save button of screen image
    ig.PushID(0)
    ig.PushStyleColor(ig.lib.ImGuiCol_Button,        ig.ImVec4(0.7, 0.7, 0.0, 1.0))
    ig.PushStyleColor(ig.lib.ImGuiCol_ButtonHovered, ig.ImVec4(0.8, 0.8, 0.0, 1.0))
    ig.PushStyleColor(ig.lib.ImGuiCol_ButtonActive,  ig.ImVec4(0.9, 0.9, 0.0, 1.0))
    ig.PushStyleColor(ig.lib.ImGuiCol_Text, ig.ImVec4(0.0, 0.0, 0.0,1.0))
    if ig.Button("Save window image") then
      fReqImageCapture = true
    end
    ig.PopStyleColor(4)
    ig.PopID()
    --
    --ig.SameLine(0.0,-1.0)
    -- Show tooltip help
    svName = SaveImageName .. "_" .. counter .. utils.imageExt[SaveFormat]
    utils.setTooltip(ig, string.format("Save to \"%s\"", svName), ig.lib.ImGuiHoveredFlags_DelayNormal, ig.ImVec4(0.0, 1.0, 0.0, 1.0))
    -- End Save button of screen image

    -- Icon font test
    ig.SeparatorText(IFA.ICON_FA_WRENCH .. " Icon font test ")
    ig.Text(IFA.ICON_FA_TRASH_CAN .. " Trash")
    ig.Text(IFA.ICON_FA_MAGNIFYING_GLASS_PLUS ..
      " " .. IFA.ICON_FA_POWER_OFF ..
      " " .. IFA.ICON_FA_MICROPHONE ..
      " " .. IFA.ICON_FA_MICROCHIP ..
      " " .. IFA.ICON_FA_VOLUME_HIGH ..
      " " .. IFA.ICON_FA_SCISSORS ..
      " " .. IFA.ICON_FA_SCREWDRIVER_WRENCH ..
      " " .. IFA.ICON_FA_BLOG)
      --

    ig.End()
  end
  --
  do ig.Begin("Image window")
    local imageBoxPosTop = ig.GetCursorScreenPos() -- Get absolute pos.
      local texRef = ffi.new("ImTextureRef")
      texRef._TexData = nil
      texRef._TexID = pic1.texture[0]
      ig.Image(texRef, pic1.size)
    local imageBoxPosEnd = ig.GetCursorScreenPos() -- Get absolute pos.
    --
    if ig.IsItemHovered(ig.lib.ImGuiHoveredFlags_DelayNone) then
      zoomGlass(ig, pic1.texture, pic1.width, imageBoxPosTop, imageBoxPosEnd, IFA.ICON_FA_MAGNIFYING_GLASS .. "  4 x")
    end
    ig.End()
  end

  ---
  ig_impl:Render()
  -- Save screen image to file
  if fReqImageCapture then
    fReqImageCapture = false

    local wkSize = ig.GetMainViewport().WorkSize
    utils.saveImage(glext,svName, SaveFormat, wkSize.x , wkSize.y)
  end
  --
  sdl.gL_SwapWindow(window)

  if showWindowDelay >= 0 then
    showWindowDelay = showWindowDelay - 1
  end
  if showWindowDelay == 0 then
    sdl.showWindow(window)
  end
end

-- Save Window info
local posx = ffi.new("int[1]")
local posy = ffi.new("int[1]")
sdl.getWindowPosition(window, posx, posy)
local info = {}
info.x = posx[0]
info.y = posy[0]
local wsize = ig.GetMainViewport().WorkSize
info.w = wsize.x
info.h = wsize.y
SaveIni(info)

-- Cleanup
ig_impl:destroy()
sdl.gL_DeleteContext(gl_context)
sdl.destroyWindow(window)
sdl.quit()

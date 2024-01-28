local ffi   = require"ffi"
local utils = require"utils"
--- SDL2/etc
local sdl   = require"sdl2_ffi"
local gllib = require"gl"
gllib.set_loader(sdl)
local gl, glc, glu, glext = gllib.libraries()
local ig    = require"imgui.sdl"
require"loadimage"
require"setupFonts"
local IFA   = require"fonticon.IconsFontAwesome6"

--- Global var: app
--require"apps"

---
local SaveImageName = "screenImage"
-- Select {JPEG, PNG, TIFF, BMP}
local SaveFormat = "JPEG"

--- Global var
local fReqImageCapture = false

--- Image folder
local ImgDir = "../img/"

-- Load inifile
--loadIni()

if (sdl.init(sdl.INIT_VIDEO+sdl.INIT_TIMER) ~= 0) then
    print(string.format("Error: %s\n", sdl.getError()));
    return -1;
end

sdl.gL_SetAttribute(sdl.GL_CONTEXT_FLAGS, sdl.GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
sdl.gL_SetAttribute(sdl.GL_CONTEXT_PROFILE_MASK, sdl.GL_CONTEXT_PROFILE_CORE);
sdl.gL_SetAttribute(sdl.GL_DOUBLEBUFFER, 1);
sdl.gL_SetAttribute(sdl.GL_DEPTH_SIZE, 24);
sdl.gL_SetAttribute(sdl.GL_STENCIL_SIZE, 8);
sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, 3);
sdl.gL_SetAttribute(sdl.GL_CONTEXT_MINOR_VERSION, 3);

local current = ffi.new("SDL_DisplayMode[1]")
sdl.getCurrentDisplayMode(0, current);

--local window = sdl.createWindow("ImGui SDL2+OpenGL3 example", sdl.WINDOWPOS_CENTERED, sdl.WINDOWPOS_CENTERED, 700, 500, sdl.WINDOW_OPENGL+sdl.WINDOW_RESIZABLE);
--local window = sdl.createWindow("ImGui SDL2+OpenGL3 example"
--                 ,app.mainWinodw.posx -- x
--                 ,app.mainWinodw.posy -- y
--                 ,app.mainwinodw.width, app.mainWindow.height  -- w, h
--                 ,sdl.WINDOW_OPENGL+sdl.WINDOW_RESIZABLE);
local window = sdl.createWindow("ImGui SDL2+OpenGL3 example"
                 ,100 -- x
                 ,100 -- y
                 ,1024, 800  -- w, h
                 ,sdl.WINDOW_OPENGL+sdl.WINDOW_RESIZABLE);
local gl_context = sdl.gL_CreateContext(window);
sdl.gL_SetSwapInterval(1); -- Enable vsync

local ig_impl = ig.Imgui_Impl_SDL_opengl3()
ig_impl:Init(window, gl_context)

-------------------------
--- Load title bar icon
-------------------------
local  IconName = ImgDir .. "icon_qr_my_github.png"

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
local  fExistMultibytesFonts, sActiveFontName, sActiveFontTitle = setupFonts(pio)

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
local done = false;
--
local sdlVer = ffi.new("SDL_version")
sdl.GetVersion(sdlVer)

--local sTitle = string.format("[ImGui: v%s]" ,ffi.string(ig.GetVersion()))

while (not done) do
  --SDL_Event
  local event = ffi.new"SDL_Event"
  while (sdl.pollEvent(event) ~=0) do
    ig.lib.ImGui_ImplSDL2_ProcessEvent(event);
    if (event.type == sdl.QUIT) then
      done = true;
    end
    if (event.type == sdl.WINDOWEVENT and event.window.event == sdl.WINDOWEVENT_CLOSE and event.window.windowID == sdl.getWindowID(window)) then
      done = true;
    end
  end
  --standard rendering
  sdl.gL_MakeCurrent(window, gl_context);
  gl.glClearColor(clearColor[0],clearColor[1],clearColor[2],1.0)
  gl.glViewport(0, 0, pio.DisplaySize.x, pio.DisplaySize.y);
  gl.glClear(glc.GL_COLOR_BUFFER_BIT)

  ig_impl:NewFrame()
  -- Show ImGui demo
  if fShowDemo[0] then ig.ShowDemoWindow(fShowDemo) end
  local svName
  if ig.Begin(sTitle) then
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
    if ig.Button("Save screeen image") then
      fReqImageCapture = true
    end
    ig.PopStyleColor(4)
    ig.PopID()
    --
    --ig.SameLine(0.0,-1.0)
    -- Show tooltip help
    svName = SaveImageName .. "_" .. counter .. utils.imageExt[SaveFormat]
    if ig.IsItemHovered() and ig.BeginTooltip() then
      ig.Text(string.format("[Unimplement]: Save to \"%s\"", svName))
      ig.EndTooltip()
    end
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
  if ig.Begin("Image window") then
    ig.Image(ffi.cast("ImTextureID",pic1.texture[0]),pic1.size)
    ig.End()
  end

  ---
  ig_impl:Render()
  -- Save screen image to file
  if fReqImageCapture then
    fReqImageCapture = false
    -- TODO
    --local w,h,x,y = getCurrentWindowSize(window)
    --utils.saveImage(svName, SaveFormat, w , h)
  end
  --
  sdl.gL_SwapWindow(window)
end

-- Cleanup
--saveIni(window)
ig_impl:destroy()

sdl.gL_DeleteContext(gl_context);
sdl.destroyWindow(window);
sdl.quit();

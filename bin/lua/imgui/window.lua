local function MainDockSpace(W)
    local ig = W.ig
    if not W.has_imgui_viewport then return end
    if (bit.band(ig.GetIO().ConfigFlags , ig.lib.ImGuiConfigFlags_DockingEnable)==0) then return end

    local dockspace_flags = bit.bor(ig.lib.ImGuiDockNodeFlags_NoDockingOverCentralNode, ig.lib.ImGuiDockNodeFlags_AutoHideTabBar, ig.lib.ImGuiDockNodeFlags_PassthruCentralNode) --ImGuiDockNodeFlags_NoSplit
    ig.DockSpaceOverViewport(nil, nil, dockspace_flags);
end
local M = {}

local function startGLFW(W, postf)
    local window = W.window
    local ig = W.ig
    local gl, glc, glu, glext = W.gllib.libraries()
    while not window:shouldClose() do

        W.lj_glfw.pollEvents()
        if (window:getAttrib(W.lj_glfw.glfwc.GLFW_ICONIFIED) ~= 0) then
            ig.lib.ImGui_ImplGlfw_Sleep(10);
            goto continue
        end

        window:makeContextCurrent()

        gl.glClear(glc.GL_COLOR_BUFFER_BIT)

        if W.preimgui then W.preimgui() end

        W.ig_impl:NewFrame()

        MainDockSpace(W)
        W:draw(ig)

        W.ig_impl:Render()

        --viewport branch
        if W.has_imgui_viewport then
            local igio = ig.GetIO()
            if bit.band(igio.ConfigFlags , ig.lib.ImGuiConfigFlags_ViewportsEnable) ~= 0 then
                local backup_current_context = W.lj_glfw.getCurrentContext();
                ig.UpdatePlatformWindows();
                ig.RenderPlatformWindowsDefault();
                window.makeContextCurrent(backup_current_context)
                --window:makeContextCurrent()
            end
        end

        window:swapBuffers()
        --vsync protects GPU sleep protects CPU
        --uses Sleep, sdl.Delay is much precise
        if not W.args.dont_sleep then ig.lib.ImGui_ImplGlfw_Sleep(10); end
        ::continue::
    end
    if postf then postf() end
    W.ig_impl:destroy()
    window:destroy()
    W.lj_glfw.terminate()
end

function M:GLFW(w,h,title,args)
    args = args or {}
    local W = {args = args}
    local ffi = require "ffi"
    W.lj_glfw = require"glfw"
    W.gllib = require"gl"
    W.gllib.set_loader(W.lj_glfw)
    --local gl, glc, glu, glext = gllib.libraries()
    W.ig = require"imgui.glfw"

    W.lj_glfw.setErrorCallback(function(error,description)
        print("GLFW error:",error,ffi.string(description or ""));
    end)

    W.lj_glfw.init()
    local main_scale = W.ig.lib.ImGui_ImplGlfw_GetContentScaleForMonitor(W.lj_glfw.getPrimaryMonitor()); -- Valid on GLFW 3.3+ only
    local window = W.lj_glfw.Window(w * main_scale, h * main_scale,title or "")
    window:makeContextCurrent()
    W.lj_glfw.swapInterval(args.vsync or 1)

    if args.gl2 then
        W.ig_impl = W.ig.Imgui_Impl_glfw_opengl2()
    else
        W.ig_impl = W.ig.Imgui_Impl_glfw_opengl3()
    end

    local igio = W.ig.GetIO()
    igio.ConfigFlags = W.ig.lib.ImGuiConfigFlags_NavEnableKeyboard + igio.ConfigFlags
    
    -- Setup scaling
    local style = W.ig.GetStyle();
    style:ScaleAllSizes(main_scale);        -- Bake a fixed style scale. (until we have a solution for dynamic style scaling, changing this requires resetting Style + calling this again)
    style.FontScaleDpi = main_scale;        -- Set initial font scale. (using io.ConfigDpiScaleFonts=true makes this unnecessary. We leave both here for documentation purpose)
    igio.ConfigDpiScaleFonts = true;          -- [Experimental] Automatically overwrite style.FontScaleDpi in Begin() when Monitor DPI changes. This will scale fonts but _NOT_ scale sizes/padding for now.
    igio.ConfigDpiScaleViewports = true;      -- [Experimental] Scale Dear ImGui and Platform Windows when Monitor DPI changes.
    
    
    local ok = pcall(function() return W.ig.lib.ImGuiConfigFlags_ViewportsEnable end)
    if ok then
        W.has_imgui_viewport = true
        igio.ConfigFlags = igio.ConfigFlags + W.ig.lib.ImGuiConfigFlags_DockingEnable
        if args.use_imgui_viewport then
            igio.ConfigFlags = igio.ConfigFlags + W.ig.lib.ImGuiConfigFlags_ViewportsEnable
        end
    end

    W.ig_impl:Init(window, true)

    W.window = window
    W.start = startGLFW
    return W
end

local function startSDL(W, postf)
    local ffi = require"ffi"

    local window = W.window
    local sdl = W.sdl
    local ig = W.ig
    local gl,glc = W.gllib.gl,W.gllib.glc
    local igio = ig.GetIO()
    local done = false;
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
        if (bit.band(sdl.GetWindowFlags(window), sdl.WINDOW_MINIMIZED) > 0) then
            sdl.Delay(10);
            goto continue
        end
        --standard rendering
        sdl.gL_MakeCurrent(window, W.gl_context);
        gl.glViewport(0, 0, igio.DisplaySize.x, igio.DisplaySize.y);
        gl.glClear(glc.GL_COLOR_BUFFER_BIT)

        if W.preimgui then W.preimgui() end

        W.ig_Impl:NewFrame()

        MainDockSpace(W)
        W:draw(ig)

        W.ig_Impl:Render()

        --viewport branch
        if W.has_imgui_viewport then
            local igio = ig.GetIO()
            if bit.band(igio.ConfigFlags , ig.lib.ImGuiConfigFlags_ViewportsEnable) ~= 0 then
                ig.UpdatePlatformWindows();
                ig.RenderPlatformWindowsDefault();
                sdl.gL_MakeCurrent(window, W.gl_context)
            end
        end

        sdl.gL_SwapWindow(window);
        --vsync protects GPU sleep protects CPU
        if not W.args.dont_sleep then sdl.Delay(10); end
        ::continue::
    end

    -- Cleanup
    if postf then postf() end
    W.ig_Impl:destroy()

    sdl.gL_DeleteContext(W.gl_context);
    sdl.destroyWindow(window);
    sdl.quit();
end
function M:SDL(w,h,title,args)
    args = args or {}
    local W = {args = args}
    local ffi = require "ffi"
    W.sdl = require"sdl2_ffi"
    local sdl = W.sdl
    W.gllib = require"gl"
    W.gllib.set_loader(W.sdl)
    --local gl, glc, glu, glext = gllib.libraries()
    W.ig = require"imgui.sdl"
    
    if jit.os == "Windows" then
        ffi.cdef[[bool SetProcessDPIAware();]]
        ffi.C.SetProcessDPIAware()
    end

    if (sdl.init(sdl.INIT_VIDEO+sdl.INIT_TIMER) ~= 0) then
        print(string.format("Error: %s\n", sdl.getError()));
        return -1;
    end


    sdl.gL_SetAttribute(sdl.GL_DOUBLEBUFFER, 1);
    sdl.gL_SetAttribute(sdl.GL_DEPTH_SIZE, 24);
    sdl.gL_SetAttribute(sdl.GL_STENCIL_SIZE, 8);
    if args.gl2 then
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, 2);
    else
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_FLAGS, sdl.GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_PROFILE_MASK, sdl.GL_CONTEXT_PROFILE_CORE);
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, 3);
    end
    sdl.gL_SetAttribute(sdl.GL_CONTEXT_MINOR_VERSION, 2);
    local current = ffi.new("SDL_DisplayMode[1]")
    sdl.getCurrentDisplayMode(0, current);
    local main_scale = W.ig.lib.ImGui_ImplSDL2_GetContentScaleForDisplay(0);
    local window = sdl.createWindow(title or "", sdl.WINDOWPOS_CENTERED, sdl.WINDOWPOS_CENTERED, w * main_scale, h * main_scale, sdl.WINDOW_OPENGL + sdl.WINDOW_RESIZABLE + sdl.SDL_WINDOW_ALLOW_HIGHDPI);
    W.gl_context = sdl.gL_CreateContext(window);
    sdl.gL_SetSwapInterval(args.vsync or 1)

    if args.gl2 then
        W.ig_Impl = W.ig.Imgui_Impl_SDL_opengl2()
    else
        W.ig_Impl = W.ig.Imgui_Impl_SDL_opengl3()
    end

    local igio = W.ig.GetIO()
    igio.ConfigFlags = W.ig.lib.ImGuiConfigFlags_NavEnableKeyboard + igio.ConfigFlags
    
    -- Setup scaling
    local style = W.ig.GetStyle();
    style:ScaleAllSizes(main_scale);        -- Bake a fixed style scale. (until we have a solution for dynamic style scaling, changing this requires resetting Style + calling this again)
    style.FontScaleDpi = main_scale;        -- Set initial font scale. (using io.ConfigDpiScaleFonts=true makes this unnecessary. We leave both here for documentation purpose)
    igio.ConfigDpiScaleFonts = true;          -- [Experimental] Automatically overwrite style.FontScaleDpi in Begin() when Monitor DPI changes. This will scale fonts but _NOT_ scale sizes/padding for now.
    igio.ConfigDpiScaleViewports = true;      -- [Experimental] Scale Dear ImGui and Platform Windows when Monitor DPI changes.
    
    local ok = pcall(function() return W.ig.lib.ImGuiConfigFlags_ViewportsEnable end)
    if ok then
        W.has_imgui_viewport = true
        igio.ConfigFlags = igio.ConfigFlags + W.ig.lib.ImGuiConfigFlags_DockingEnable
        if args.use_imgui_viewport then
            igio.ConfigFlags = igio.ConfigFlags + W.ig.lib.ImGuiConfigFlags_ViewportsEnable
        end
    end

    W.ig_Impl:Init(window, W.gl_context)

    W.window = window
    W.start = startSDL
    return W
end

local function startSDL3(W, postf)
    local ffi = require"ffi"

    local window = W.window
    local sdl = W.sdl
    local ig = W.ig
    local gl,glc = W.gllib.gl,W.gllib.glc
    local igio = ig.GetIO()
    local done = false;
    while (not done) do
        --SDL_Event
        local event = ffi.new"SDL_Event"
        while (sdl.pollEvent(event)) do
            ig.lib.ImGui_ImplSDL3_ProcessEvent(event);
            if (event.type == sdl.EVENT_QUIT) then
                done = true;
            end
            if (event.type == sdl.EVENT_WINDOW_CLOSE_REQUESTED and event.window.windowID == sdl.getWindowID(window)) then
                done = true;
            end
        end
        if (bit.band(sdl.GetWindowFlags(window), sdl.WINDOW_MINIMIZED) > 0) then
            sdl.Delay(10);
            goto continue
        end
        --standard rendering
        sdl.gL_MakeCurrent(window, W.gl_context);
        gl.glViewport(0, 0, igio.DisplaySize.x, igio.DisplaySize.y);
        gl.glClear(glc.GL_COLOR_BUFFER_BIT)

        if W.preimgui then W.preimgui() end

        W.ig_Impl:NewFrame()

        MainDockSpace(W)
        W:draw(ig)

        W.ig_Impl:Render()

        --viewport branch
        if W.has_imgui_viewport then
            local igio = ig.GetIO()
            if bit.band(igio.ConfigFlags , ig.lib.ImGuiConfigFlags_ViewportsEnable) ~= 0 then
                ig.UpdatePlatformWindows();
                ig.RenderPlatformWindowsDefault();
                sdl.gL_MakeCurrent(window, W.gl_context)
            end
        end

        sdl.gL_SwapWindow(window);
        --vsync protects GPU sleep protects CPU
        if not W.args.dont_sleep then sdl.Delay(10); end
        ::continue::
    end

    -- Cleanup
    if postf then postf() end
    W.ig_Impl:destroy()

    sdl.gL_DestroyContext(W.gl_context);
    sdl.destroyWindow(window);
    sdl.quit();
end
function M:SDL3(w,h,title,args)

    args = args or {}
    local W = {args = args}
    local ffi = require "ffi"
    W.sdl = require"sdl3_ffi"
    local sdl = W.sdl
    W.gllib = require"gl"
    W.gllib.set_loader(W.sdl)
    --local gl, glc, glu, glext = gllib.libraries()
    W.ig = require"imgui.sdl3"

    if not (sdl.init(sdl.INIT_VIDEO+sdl.INIT_GAMEPAD)) then
        print(string.format("Error: %s\n", ffi.string(sdl.getError())));
        error"failed sdl3_init";
    end


    sdl.gL_SetAttribute(sdl.GL_DOUBLEBUFFER, 1);
    sdl.gL_SetAttribute(sdl.GL_DEPTH_SIZE, 24);
    sdl.gL_SetAttribute(sdl.GL_STENCIL_SIZE, 8);
    if args.gl2 then
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, 2);
    else
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_FLAGS, sdl.GL_CONTEXT_FORWARD_COMPATIBLE_FLAG);
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_PROFILE_MASK, sdl.GL_CONTEXT_PROFILE_CORE);
        sdl.gL_SetAttribute(sdl.GL_CONTEXT_MAJOR_VERSION, 3);
    end
    sdl.gL_SetAttribute(sdl.GL_CONTEXT_MINOR_VERSION, 2);

    local main_scale = sdl.getDisplayContentScale(sdl.getPrimaryDisplay());
    local window = sdl.createWindow(title or "", w * main_scale, h * main_scale, sdl.WINDOW_OPENGL + sdl.WINDOW_RESIZABLE)-- + sdl.SDL_WINDOW_HIDDEN);
    W.gl_context = sdl.gL_CreateContext(window);
    sdl.gL_SetSwapInterval(args.vsync or 1)

    if args.gl2 then
        W.ig_Impl = W.ig.Imgui_Impl_SDL3_opengl2()
    else
        W.ig_Impl = W.ig.Imgui_Impl_SDL3_opengl3()
    end

    local igio = W.ig.GetIO()
    igio.ConfigFlags = W.ig.lib.ImGuiConfigFlags_NavEnableKeyboard + igio.ConfigFlags
    
        -- Setup scaling
    local style = W.ig.GetStyle();
    style:ScaleAllSizes(main_scale);        -- Bake a fixed style scale. (until we have a solution for dynamic style scaling, changing this requires resetting Style + calling this again)
    style.FontScaleDpi = main_scale;        -- Set initial font scale. (using io.ConfigDpiScaleFonts=true makes this unnecessary. We leave both here for documentation purpose)
    igio.ConfigDpiScaleFonts = true;          -- [Experimental] Automatically overwrite style.FontScaleDpi in Begin() when Monitor DPI changes. This will scale fonts but _NOT_ scale sizes/padding for now.
    igio.ConfigDpiScaleViewports = true;      -- [Experimental] Scale Dear ImGui and Platform Windows when Monitor DPI changes.
    
    
    local ok = pcall(function() return W.ig.lib.ImGuiConfigFlags_ViewportsEnable end)
    if ok then
        W.has_imgui_viewport = true
        igio.ConfigFlags = igio.ConfigFlags + W.ig.lib.ImGuiConfigFlags_DockingEnable
        if args.use_imgui_viewport then
            igio.ConfigFlags = igio.ConfigFlags + W.ig.lib.ImGuiConfigFlags_ViewportsEnable
        end
    end

    W.ig_Impl:Init(window, W.gl_context)

    W.window = window
    W.start = startSDL3

    return W
end

return M
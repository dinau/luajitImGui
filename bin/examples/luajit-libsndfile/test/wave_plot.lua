--- load soundfile
local ffi = require"ffi"
local sndf = require"sndfile_ffi"
local filename = "african_room.wav";
local info = sndf.get_info(filename)
print(info.frames,info.channels)
local buffer = ffi.new("float[?]",info.frames*info.channels)
local sf = sndf.Sndfile(filename)
sf:readf(buffer)
sf:close()

----normalize buffer
local maxi = -math.huge
local abs = math.abs
for i=0,tonumber(info.frames*2)-1 do
    local val = abs(buffer[i])
    maxi = maxi > val and maxi or val
end
local invmaxi = 1/maxi
for i=0,tonumber(info.frames*2)-1 do
    buffer[i] = buffer[i]*invmaxi
end

--- resample functions
local max,min = math.max, math.min
local function clip(v,l,h)
    return max(l,min(h,v))
end
local function Resample(W,t1,t2,info,Buf,ch)
    local Byl = ffi.new("float[?]",W) --amplitude low
    local Byh = ffi.new("float[?]",W) --amplitude hight
    local Bt = ffi.new("float[?]",W) -- time
    local nbins = math.floor((t2-t1)*info.samplerate)
    local facx = tonumber(nbins/W)
    local binle = math.floor(facx+0.5)
    local frames = tonumber(info.frames)
    --print(nbins,facx,binle)
    for i=0,W-1 do
        local binini = math.floor(t1*info.samplerate+i*facx)
        local inibin = clip(binini,0,frames-1)
        local endbin = clip(binini+binle-1,0,frames-1)
        Bt[i] = t1+ i*(t2-t1)/(W-1)
        Byl[i] = math.huge
        Byh[i] = -math.huge
        for j=inibin,endbin do
            local j1 = j*info.channels+ch
            local value = Buf[j1]
            Byl[i] = Byl[i] < value and Byl[i] or value
            Byh[i] = Byh[i] > value and Byh[i] or value
        end
    end
    return Bt,Byl,Byh
end

-- imgui
local igwin = require"imgui.window"

local win = igwin:GLFW(800,400, "wav",{vsync=true})
win.ig.ImPlot_CreateContext()

local a,b,c
local Bt,Byl,Byh
local audioLengthInSeconds = tonumber(info.frames/info.samplerate)
local dummyX = ffi.new("float[?]",2,{0, audioLengthInSeconds});
local dummyY = ffi.new("float[?]",2,{1, -1})

function win:draw(ig)
    ig.ImPlot_ShowDemoWindow()
    ig.Begin("Waveform")
        if ig.ImPlot_BeginPlot("wav",ig.ImVec2(-1,-1)) then
            ig.ImPlot_SetupAxes("Time [s]","Amplitude");
            ig.ImPlot_SetupAxisLimits(ig.lib.ImAxis_Y1, -1, 1, ig.lib.ImPlotCond_Always);
            local widthPix = ig.ImPlot_GetPlotSize().x;
            local t1 = ig.ImPlot_GetPlotLimits().X.Min;
            local t2 = ig.ImPlot_GetPlotLimits().X.Max;
            if a~=widthPix or b~=t1 or c~=t2 then
                Bt,Byl,Byh = Resample(widthPix,t1,t2,info,buffer,0)
                a=widthPix;b=t1;c=t2
            end
            ig.ImPlot_PushStyleVar(ig.lib.ImPlotStyleVar_FillAlpha, 0.25);
            ig.ImPlot_PlotShaded("L",Bt, Byl,Byh,widthPix);
            ig.ImPlot_PlotLine("L",Bt, Byl,widthPix);
            ig.ImPlot_PlotLine("L",Bt, Byh,widthPix);
            ig.ImPlot_PopStyleVar()
            ig.ImPlot_SetNextLineStyle(ig.ImVec4(0,0,0,0)); 
            ig.ImPlot_PlotLine("##DummyPointsForFitting",dummyX,dummyY,2)
            ig.ImPlot_EndPlot();
        end
    ig.End()
end

local function clean()
    win.ig.ImPlot_DestroyContext()
end

win:start(clean)
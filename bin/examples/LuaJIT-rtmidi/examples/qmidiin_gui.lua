igwin = require"imgui.window"
local win = igwin:GLFW(600,400,"midiwin")
local ig = win.ig
local ffi = require"ffi"
----------Log
local function Log()
	local L = {}
	local Buf = ffi.new"ImGuiTextBuffer"
	local ScrollToBottom = false
	function L:Add(fmt,args)
		Buf:appendfv(fmt, args);
		ScrollToBottom = true
	end
	function L:Draw(title)
		if ig.Button("Clear") then Buf:clear() end
		ig.BeginChild("scrolling", ig.ImVec2(0,0), false, ig.ImGuiWindowFlags_HorizontalScrollbar);
		ig.TextUnformatted(Buf:begin());
		if (ScrollToBottom) then ig.SetScrollHereY(1.0); ScrollToBottom = false end
		ig.EndChild();
	end
	return L
end
local igLOG = Log() --ig.Log()
local function printLOG(...)
	igLOG:Add(table.concat({...},", "))
end
------------------------

local rtmidi = require"rtmidi_ffi"
local info = rtmidi.GetAllInfo()

local DevCombo = ig.LuaCombo("port")
local APIcombo = ig.LuaCombo("api", info.APIdisplay_names, function(val,i)
	local api = info.APIbyi[i]
	DevCombo:set(info.API[api].ins)
end)

local oDevCombo = ig.LuaCombo("port##out")
local oAPIcombo = ig.LuaCombo("api##out", info.APIdisplay_names, function(val,i)
	local api = info.APIbyi[i]
	oDevCombo:set(info.API[api].outs)
end)


local m_in, m_out
local function set_midi_out(api,port)
	printLOG("opening midi out:", oAPIcombo:get_name(),oDevCombo:get_name(),"\n")
	if m_out then m_out:close_port(); m_out:free(); m_out=nil end
	if portname=="none" then return end
	m_out = rtmidi.rtmidi_out(api)
	m_out:open_port( port,"Mi input port" );
	if m_out.ok == false then error(ffi.string(m_out.msg)) end
end
local function set_midi_in(api,port)
	local portname = DevCombo:get_name()
	printLOG("opening midi in:", APIcombo:get_name(),portname,"\n")
	if m_in then m_in:close_port(); m_in:free();m_in = nil end
	if portname=="none" then return end
	m_in = rtmidi.rtmidi_in(api)
	m_in:open_port( port,"Mi input port" );
	if m_in.ok == false then error(ffi.string(m_in.msg)) end
	m_in:in_ignore_types( false, false, false );
end


local msg = ffi.new("unsigned char[?]",256)
local size = ffi.new("size_t[1]")
local function readmidi()
	if not m_in then return end
	size[0] = 255
	local stamp = m_in:in_get_message(msg, size)
	if m_in.ok == false then error(ffi.string(m_in.msg)) end
	if size[0] > 0 then
		for i=0,tonumber(size[0])-1 do
			igLOG:Add(string.format("Byte %d = %d, " ,i ,msg[i]))
		end
		igLOG:Add(string.format("stamp %f\n",stamp))
		if m_out then m_out:out_send_message(msg, size[0]) end
	end
end

function win:draw()
	local viewport = ig.GetMainViewport();
    --Submit a window filling the entire viewport
    ig.SetNextWindowPos(viewport.WorkPos);
    ig.SetNextWindowSize(viewport.WorkSize);
    ig.SetNextWindowViewport(viewport.ID);
	
	ig.Begin("midi test")
	APIcombo:draw()
	DevCombo:draw()
	if ig.Button("set midi in") then
		local _,apii = APIcombo:get()
		local _,porti = DevCombo:get()
		set_midi_in(info.APIbyi[apii],porti-1)
	end
	ig.Separator()
	oAPIcombo:draw()
	oDevCombo:draw()
	if ig.Button("set midi out") then
		local _,apii = oAPIcombo:get()
		local _,porti = oDevCombo:get()
		set_midi_out(info.APIbyi[apii],porti-1)
	end
	ig.Separator()
	igLOG:Draw("log window")
	ig.End()
	readmidi()
end

win:start()

if m_in then m_in:close_port(); m_in:free() end
if m_out then m_out:close_port(); m_out:free() end
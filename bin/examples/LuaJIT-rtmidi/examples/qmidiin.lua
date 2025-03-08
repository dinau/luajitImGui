local rtmidi = require"rtmidi_ffi"
local ffi = require"ffi"
local tim = require"luapower.time"

print("------compiled APIs")
local api_count = rtmidi.get_compiled_api(nil,0)
local apis_data = ffi.new("enum RtMidiApi[?]",api_count)
rtmidi.get_compiled_api(apis_data, api_count);
for i=0,api_count-1 do
	local api = tonumber(apis_data[i])
	local displayName = rtmidi.api_display_name(api);
	displayName = displayName==nil and "" or displayName
	print(i,api,ffi.string(displayName))
end
local chossed_api
if api_count > 1 then
	print"Choose api"
	local pp = io.read"*l"
	assert(tonumber(pp) < api_count)
	chossed_api = apis_data[tonumber(pp)]
else
	chossed_api = apis_data[0]
end

local m_in = rtmidi.rtmidi_in(chossed_api)
local capi = m_in:in_get_current_api()

--Check inputs.
local nPorts = m_in:get_port_count();
print("There are ", nPorts ," MIDI input ports available.")
for i=0,nPorts-1 do
    local portName = m_in:get_port_name(i);
    print("  Input Port #", i ,": ",ffi.string(portName))
end

local chossed_port
print"Choose port"
local pp = io.read"*l"
assert(tonumber(pp) < nPorts)
local chossed_port = tonumber(pp)

m_in:open_port( chossed_port,"Mi input port" );
if m_in.ok == false then error(ffi.string(m_in.msg)) end
m_in:in_ignore_types( false, false, false );

local msg = ffi.new("unsigned char[?]",256)
local size = ffi.new("size_t[1]")
while true do
	size[0] = 255
	local stamp = m_in:in_get_message(msg, size)
	if m_in.ok == false then error(ffi.string(m_in.msg)) end
	for i=0,tonumber(size[0])-1 do
      io.write(string.format("Byte %d = %d, " ,i ,msg[i]))
	end
	if size[0] > 0 then io.write(string.format("stamp %f\n",stamp)) end
	tim.sleep(0.01)
end

m_in:free()
local rtmidi = require"rtmidi_ffi"
local ffi = require"ffi"

--map of api names
print("------posible APIs")
local apiMap = {}
for i=rtmidi.API_UNSPECIFIED,rtmidi.API_NUM do
	local str = rtmidi.api_name(i)
	str = str==nil and "" or str
	local displayName = rtmidi.api_display_name(i);
	displayName = displayName==nil and "" or displayName
	print(i,ffi.string(str),ffi.string(displayName))
	apiMap[i] = ffi.string(displayName)
end

print("------compiled APIs")
local api_count = rtmidi.get_compiled_api(nil,0)
local apis_data = ffi.new("enum RtMidiApi[?]",api_count)
rtmidi.get_compiled_api(apis_data, api_count);
for i=0,api_count-1 do
	local api = tonumber(apis_data[i])
	print(i,apis_data[i],apiMap[api])
end

print"-------probing"
for i=0,api_count-1 do
	local api = tonumber(apis_data[i])
	print("probing with",apiMap[api])
	local m_in = rtmidi.rtmidi_in(api)
	local capi = m_in:in_get_current_api()
	print("Current input API: ",apiMap[tonumber(capi)])
	-- Check inputs.
    local nPorts = m_in:get_port_count();
    print("There are ", nPorts ," MIDI input ports available.")
	for i=0,nPorts-1 do
        local portName = m_in:get_port_name(i);
        print("  Input Port #", i ,": ",ffi.string(portName))
    end
	local m_out = rtmidi.rtmidi_out(api)
	local capi = m_out:out_get_current_api()
	print("Current Output API: ",apiMap[tonumber(capi)])
	-- Check outpus.
    local nPorts = m_out:get_port_count();
    print("There are ", nPorts ," MIDI output ports available.")
	for i=0,nPorts-1 do
        local portName = m_out:get_port_name(i);
        print("  output Port #", i ,": ",ffi.string(portName))
    end
	m_in:free()
	m_out:free()
end
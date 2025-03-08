local rtmidi = require"rtmidi_ffi"
local ffi = require"ffi"

local api_count = rtmidi.get_compiled_api(nil,0)
local apis_data = ffi.new("enum RtMidiApi[?]",api_count)
rtmidi.get_compiled_api(apis_data, api_count);
print("----Api Names")
for i=0, api_count-1 do
    local str = rtmidi.api_name(apis_data[i])
    print(str==nil and "no name" or ffi.string(str))
    local displayName = rtmidi.api_display_name(apis_data[i]);
    print("displayName",displayName==nil and "no name" or ffi.string(displayName))
end
--unknown apis
local str = rtmidi.api_name(-1)
print("Unknown api",str==nil and "no name" or ffi.string(str))
local displayName = rtmidi.api_display_name(-1);
print("displayName for unknown",displayName==nil and "no name" or ffi.string(displayName))
print("-------Api id by name")
for i=0, api_count-1 do
    local str = rtmidi.api_name(apis_data[i])
    str = str == nil and "" or str
    local api_id = rtmidi.compiled_api_by_name(str)
    assert(api_id==apis_data[i])
    print(ffi.string(str),api_id)
end

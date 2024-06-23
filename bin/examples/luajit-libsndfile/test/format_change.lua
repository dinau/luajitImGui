local sndfile = require"sndfile_ffi"
local ffi = require"ffi"


print(sndfile.version_string())

---copy file changing format

--open origin
local sf = sndfile.Sndfile([[african_room.wav]])
print("channels",sf:channels())
print("frames",sf:frames())
print("samplerate",sf:samplerate())
print("format",sf:format())

--open destination
local sf2 = sndfile.Sndfile([[./sample_conv.aiff]],"w",sf:samplerate(),sf:channels(),sndfile.SF_FORMAT_AIFF+sndfile.SF_FORMAT_FLOAT)

--copy data
print"copy data"
local data = ffi.new("double[?]",sf:channels()*1024)

while true do
	local readcount = sf:readf_double(data,1024)
	print(readcount)
	if readcount == 0 then break end
	sf2:writef_double(data,readcount)
end
print"done copy to sample_conv.aiff"

-- will close even without it
sf2:close()
sf:close()



local sndfile = require"sndfile_ffi"
local ffi = require"ffi"

print(sndfile.version_string())

local sf = sndfile.Sndfile([[african_room.wav]])

local fr_out = 1024 --*2--100

local data_out = ffi.new("float[?]",sf:channels()*fr_out)
local resampler = sf:resampler_create()

--open write
local sf2 = sndfile.Sndfile([[./sample_conv.aiff]],"w",sf:samplerate(),sf:channels(),sndfile.SF_FORMAT_AIFF +sndfile.SF_FORMAT_FLOAT)

print"going"
local totalread = 0
for i=1,2 do
	resampler:seek(0)
	while true do
		local ratio = 1.5 + 0.06*math.sin(2*math.pi*tonumber(totalread)/40000)
		local readfr = resampler:readf_float(data_out, fr_out, ratio)
		if readfr ==0 then
			break
		end
		totalread = totalread + readfr
		sf2:writef_float(data_out,readfr)
	end
end
print"ended"




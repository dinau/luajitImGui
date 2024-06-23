local sndfile = require"sndfile_ffi"
local ffi = require"ffi"

print(sndfile.version_string())
local  buffer =ffi.new("char[128]") ;
sndfile.sf_command (nil, sndfile.SFC_GET_LIB_VERSION, buffer, ffi.sizeof (buffer)) ;
print("version",ffi.string(buffer))

--list formats
local majfor = sndfile.major_formats()
for i,v in ipairs(majfor) do
	print("major format:",v.name,v.format_en)
	local subf = sndfile.format_subtypes(v.format)
	for j,w in ipairs(subf) do
		print("\tsubtype:",w.name,w.format_en)
	end
end


local ffi = require"ffi"


--local ffi_cdef = ffi.cdef
local ffi_cdef = function(code)
    local ret,err = pcall(ffi.cdef,code)
    if not ret then
        local lineN = 1
        for line in code:gmatch("([^\n\r]*)\r?\n") do
            print(lineN, line)
            lineN = lineN + 1
        end
        print(err)
        error"bad cdef"
    end
end


ffi_cdef[[
enum
{
 SF_FORMAT_WAV = 0x010000,
 SF_FORMAT_AIFF = 0x020000,
 SF_FORMAT_AU = 0x030000,
 SF_FORMAT_RAW = 0x040000,
 SF_FORMAT_PAF = 0x050000,
 SF_FORMAT_SVX = 0x060000,
 SF_FORMAT_NIST = 0x070000,
 SF_FORMAT_VOC = 0x080000,
 SF_FORMAT_IRCAM = 0x0A0000,
 SF_FORMAT_W64 = 0x0B0000,
 SF_FORMAT_MAT4 = 0x0C0000,
 SF_FORMAT_MAT5 = 0x0D0000,
 SF_FORMAT_PVF = 0x0E0000,
 SF_FORMAT_XI = 0x0F0000,
 SF_FORMAT_HTK = 0x100000,
 SF_FORMAT_SDS = 0x110000,
 SF_FORMAT_AVR = 0x120000,
 SF_FORMAT_WAVEX = 0x130000,
 SF_FORMAT_SD2 = 0x160000,
 SF_FORMAT_FLAC = 0x170000,
 SF_FORMAT_CAF = 0x180000,
 SF_FORMAT_WVE = 0x190000,
 SF_FORMAT_OGG = 0x200000,
 SF_FORMAT_MPC2K = 0x210000,
 SF_FORMAT_RF64 = 0x220000,
 SF_FORMAT_PCM_S8 = 0x0001,
 SF_FORMAT_PCM_16 = 0x0002,
 SF_FORMAT_PCM_24 = 0x0003,
 SF_FORMAT_PCM_32 = 0x0004,
 SF_FORMAT_PCM_U8 = 0x0005,
 SF_FORMAT_FLOAT = 0x0006,
 SF_FORMAT_DOUBLE = 0x0007,
 SF_FORMAT_ULAW = 0x0010,
 SF_FORMAT_ALAW = 0x0011,
 SF_FORMAT_IMA_ADPCM = 0x0012,
 SF_FORMAT_MS_ADPCM = 0x0013,
 SF_FORMAT_GSM610 = 0x0020,
 SF_FORMAT_VOX_ADPCM = 0x0021,
 SF_FORMAT_NMS_ADPCM_16 = 0x0022,
 SF_FORMAT_NMS_ADPCM_24 = 0x0023,
 SF_FORMAT_NMS_ADPCM_32 = 0x0024,
 SF_FORMAT_G721_32 = 0x0030,
 SF_FORMAT_G723_24 = 0x0031,
 SF_FORMAT_G723_40 = 0x0032,
 SF_FORMAT_DWVW_12 = 0x0040,
 SF_FORMAT_DWVW_16 = 0x0041,
 SF_FORMAT_DWVW_24 = 0x0042,
 SF_FORMAT_DWVW_N = 0x0043,
 SF_FORMAT_DPCM_8 = 0x0050,
 SF_FORMAT_DPCM_16 = 0x0051,
 SF_FORMAT_VORBIS = 0x0060,
 SF_FORMAT_OPUS = 0x0064,
 SF_FORMAT_ALAC_16 = 0x0070,
 SF_FORMAT_ALAC_20 = 0x0071,
 SF_FORMAT_ALAC_24 = 0x0072,
 SF_FORMAT_ALAC_32 = 0x0073,
 SF_ENDIAN_FILE = 0x00000000,
 SF_ENDIAN_LITTLE = 0x10000000,
 SF_ENDIAN_BIG = 0x20000000,
 SF_ENDIAN_CPU = 0x30000000,
 SF_FORMAT_SUBMASK = 0x0000FFFF,
 SF_FORMAT_TYPEMASK = 0x0FFF0000,
 SF_FORMAT_ENDMASK = 0x30000000
} ;
enum
{ SFC_GET_LIB_VERSION = 0x1000,
 SFC_GET_LOG_INFO = 0x1001,
 SFC_GET_CURRENT_SF_INFO = 0x1002,
 SFC_GET_NORM_DOUBLE = 0x1010,
 SFC_GET_NORM_FLOAT = 0x1011,
 SFC_SET_NORM_DOUBLE = 0x1012,
 SFC_SET_NORM_FLOAT = 0x1013,
 SFC_SET_SCALE_FLOAT_INT_READ = 0x1014,
 SFC_SET_SCALE_INT_FLOAT_WRITE = 0x1015,
 SFC_GET_SIMPLE_FORMAT_COUNT = 0x1020,
 SFC_GET_SIMPLE_FORMAT = 0x1021,
 SFC_GET_FORMAT_INFO = 0x1028,
 SFC_GET_FORMAT_MAJOR_COUNT = 0x1030,
 SFC_GET_FORMAT_MAJOR = 0x1031,
 SFC_GET_FORMAT_SUBTYPE_COUNT = 0x1032,
 SFC_GET_FORMAT_SUBTYPE = 0x1033,
 SFC_CALC_SIGNAL_MAX = 0x1040,
 SFC_CALC_NORM_SIGNAL_MAX = 0x1041,
 SFC_CALC_MAX_ALL_CHANNELS = 0x1042,
 SFC_CALC_NORM_MAX_ALL_CHANNELS = 0x1043,
 SFC_GET_SIGNAL_MAX = 0x1044,
 SFC_GET_MAX_ALL_CHANNELS = 0x1045,
 SFC_SET_ADD_PEAK_CHUNK = 0x1050,
 SFC_UPDATE_HEADER_NOW = 0x1060,
 SFC_SET_UPDATE_HEADER_AUTO = 0x1061,
 SFC_FILE_TRUNCATE = 0x1080,
 SFC_SET_RAW_START_OFFSET = 0x1090,
 SFC_SET_DITHER_ON_WRITE = 0x10A0,
 SFC_SET_DITHER_ON_READ = 0x10A1,
 SFC_GET_DITHER_INFO_COUNT = 0x10A2,
 SFC_GET_DITHER_INFO = 0x10A3,
 SFC_GET_EMBED_FILE_INFO = 0x10B0,
 SFC_SET_CLIPPING = 0x10C0,
 SFC_GET_CLIPPING = 0x10C1,
 SFC_GET_CUE_COUNT = 0x10CD,
 SFC_GET_CUE = 0x10CE,
 SFC_SET_CUE = 0x10CF,
 SFC_GET_INSTRUMENT = 0x10D0,
 SFC_SET_INSTRUMENT = 0x10D1,
 SFC_GET_LOOP_INFO = 0x10E0,
 SFC_GET_BROADCAST_INFO = 0x10F0,
 SFC_SET_BROADCAST_INFO = 0x10F1,
 SFC_GET_CHANNEL_MAP_INFO = 0x1100,
 SFC_SET_CHANNEL_MAP_INFO = 0x1101,
 SFC_RAW_DATA_NEEDS_ENDSWAP = 0x1110,
 SFC_WAVEX_SET_AMBISONIC = 0x1200,
 SFC_WAVEX_GET_AMBISONIC = 0x1201,
 SFC_RF64_AUTO_DOWNGRADE = 0x1210,
 SFC_SET_VBR_ENCODING_QUALITY = 0x1300,
 SFC_SET_COMPRESSION_LEVEL = 0x1301,
    SFC_SET_OGG_PAGE_LATENCY_MS = 0x1302,
    SFC_SET_OGG_PAGE_LATENCY = 0x1303,
 SFC_SET_CART_INFO = 0x1400,
 SFC_GET_CART_INFO = 0x1401,
 SFC_SET_ORIGINAL_SAMPLERATE = 0x1500,
 SFC_GET_ORIGINAL_SAMPLERATE = 0x1501,
 SFC_TEST_IEEE_FLOAT_REPLACE = 0x6001,
 SFC_SET_ADD_HEADER_PAD_CHUNK = 0x1051,
 SFC_SET_ADD_DITHER_ON_WRITE = 0x1070,
 SFC_SET_ADD_DITHER_ON_READ = 0x1071
} ;
enum
{ SF_STR_TITLE = 0x01,
 SF_STR_COPYRIGHT = 0x02,
 SF_STR_SOFTWARE = 0x03,
 SF_STR_ARTIST = 0x04,
 SF_STR_COMMENT = 0x05,
 SF_STR_DATE = 0x06,
 SF_STR_ALBUM = 0x07,
 SF_STR_LICENSE = 0x08,
 SF_STR_TRACKNUMBER = 0x09,
 SF_STR_GENRE = 0x10
} ;
enum
{
 SF_FALSE = 0,
 SF_TRUE = 1,
 SFM_READ = 0x10,
 SFM_WRITE = 0x20,
 SFM_RDWR = 0x30,
 SF_AMBISONIC_NONE = 0x40,
 SF_AMBISONIC_B_FORMAT = 0x41
} ;
enum
{ SF_ERR_NO_ERROR = 0,
 SF_ERR_UNRECOGNISED_FORMAT = 1,
 SF_ERR_SYSTEM = 2,
 SF_ERR_MALFORMED_FILE = 3,
 SF_ERR_UNSUPPORTED_ENCODING = 4
} ;
enum
{ SF_CHANNEL_MAP_INVALID = 0,
 SF_CHANNEL_MAP_MONO = 1,
 SF_CHANNEL_MAP_LEFT,
 SF_CHANNEL_MAP_RIGHT,
 SF_CHANNEL_MAP_CENTER,
 SF_CHANNEL_MAP_FRONT_LEFT,
 SF_CHANNEL_MAP_FRONT_RIGHT,
 SF_CHANNEL_MAP_FRONT_CENTER,
 SF_CHANNEL_MAP_REAR_CENTER,
 SF_CHANNEL_MAP_REAR_LEFT,
 SF_CHANNEL_MAP_REAR_RIGHT,
 SF_CHANNEL_MAP_LFE,
 SF_CHANNEL_MAP_FRONT_LEFT_OF_CENTER,
 SF_CHANNEL_MAP_FRONT_RIGHT_OF_CENTER,
 SF_CHANNEL_MAP_SIDE_LEFT,
 SF_CHANNEL_MAP_SIDE_RIGHT,
 SF_CHANNEL_MAP_TOP_CENTER,
 SF_CHANNEL_MAP_TOP_FRONT_LEFT,
 SF_CHANNEL_MAP_TOP_FRONT_RIGHT,
 SF_CHANNEL_MAP_TOP_FRONT_CENTER,
 SF_CHANNEL_MAP_TOP_REAR_LEFT,
 SF_CHANNEL_MAP_TOP_REAR_RIGHT,
 SF_CHANNEL_MAP_TOP_REAR_CENTER,
 SF_CHANNEL_MAP_AMBISONIC_B_W,
 SF_CHANNEL_MAP_AMBISONIC_B_X,
 SF_CHANNEL_MAP_AMBISONIC_B_Y,
 SF_CHANNEL_MAP_AMBISONIC_B_Z,
 SF_CHANNEL_MAP_MAX
} ;
typedef struct SNDFILE_tag SNDFILE ;
typedef int64_t sf_count_t ;
struct SF_INFO
{ sf_count_t frames ;
 int samplerate ;
 int channels ;
 int format ;
 int sections ;
 int seekable ;
} ;
typedef struct SF_INFO SF_INFO ;
typedef struct
{ int format ;
 const char *name ;
 const char *extension ;
} SF_FORMAT_INFO ;
enum
{ SFD_DEFAULT_LEVEL = 0,
 SFD_CUSTOM_LEVEL = 0x40000000,
 SFD_NO_DITHER = 500,
 SFD_WHITE = 501,
 SFD_TRIANGULAR_PDF = 502
} ;
typedef struct
{ int type ;
 double level ;
 const char *name ;
} SF_DITHER_INFO ;
typedef struct
{ sf_count_t offset ;
 sf_count_t length ;
} SF_EMBED_FILE_INFO ;
typedef struct
{ int32_t indx ;
 uint32_t position ;
 int32_t fcc_chunk ;
 int32_t chunk_start ;
 int32_t block_start ;
 uint32_t sample_offset ;
 char name [256] ;
} SF_CUE_POINT ;
typedef struct { uint32_t cue_count ; SF_CUE_POINT cue_points [100] ; } SF_CUES ;
enum
{
 SF_LOOP_NONE = 800,
 SF_LOOP_FORWARD,
 SF_LOOP_BACKWARD,
 SF_LOOP_ALTERNATING
} ;
typedef struct
{ int gain ;
 char basenote, detune ;
 char velocity_lo, velocity_hi ;
 char key_lo, key_hi ;
 int loop_count ;
 struct
 { int mode ;
  uint32_t start ;
  uint32_t end ;
  uint32_t count ;
 } loops [16] ;
} SF_INSTRUMENT ;
typedef struct
{
 short time_sig_num ;
 short time_sig_den ;
 int loop_mode ;
 int num_beats ;
 float bpm ;
 int root_key ;
 int future [6] ;
} SF_LOOP_INFO ;
typedef struct { char description [256] ; char originator [32] ; char originator_reference [32] ; char origination_date [10] ; char origination_time [8] ; uint32_t time_reference_low ; uint32_t time_reference_high ; short version ; char umid [64] ; int16_t loudness_value ; int16_t loudness_range ; int16_t max_true_peak_level ; int16_t max_momentary_loudness ; int16_t max_shortterm_loudness ; char reserved [180] ; uint32_t coding_history_size ; char coding_history [256] ; } SF_BROADCAST_INFO ;
struct SF_CART_TIMER
{ char usage [4] ;
 int32_t value ;
} ;
typedef struct SF_CART_TIMER SF_CART_TIMER ;
typedef struct { char version [4] ; char title [64] ; char artist [64] ; char cut_id [64] ; char client_id [64] ; char category [64] ; char classification [64] ; char out_cue [64] ; char start_date [10] ; char start_time [8] ; char end_date [10] ; char end_time [8] ; char producer_app_id [64] ; char producer_app_version [64] ; char user_def [64] ; int32_t level_reference ; SF_CART_TIMER post_timers [8] ; char reserved [276] ; char url [1024] ; uint32_t tag_text_size ; char tag_text [256] ; } SF_CART_INFO ;
typedef sf_count_t (*sf_vio_get_filelen) (void *user_data) ;
typedef sf_count_t (*sf_vio_seek) (sf_count_t offset, int whence, void *user_data) ;
typedef sf_count_t (*sf_vio_read) (void *ptr, sf_count_t count, void *user_data) ;
typedef sf_count_t (*sf_vio_write) (const void *ptr, sf_count_t count, void *user_data) ;
typedef sf_count_t (*sf_vio_tell) (void *user_data) ;
struct SF_VIRTUAL_IO
{ sf_vio_get_filelen get_filelen ;
 sf_vio_seek seek ;
 sf_vio_read read ;
 sf_vio_write write ;
 sf_vio_tell tell ;
} ;
typedef struct SF_VIRTUAL_IO SF_VIRTUAL_IO ;
SNDFILE* sf_open (const char *path, int mode, SF_INFO *sfinfo) ;
SNDFILE* sf_open_fd (int fd, int mode, SF_INFO *sfinfo, int close_desc) ;
SNDFILE* sf_open_virtual (SF_VIRTUAL_IO *sfvirtual, int mode, SF_INFO *sfinfo, void *user_data) ;
int sf_error (SNDFILE *sndfile) ;
const char* sf_strerror (SNDFILE *sndfile) ;
const char* sf_error_number (int errnum) ;
int sf_perror (SNDFILE *sndfile) ;
int sf_error_str (SNDFILE *sndfile, char* str, size_t len) ;
int sf_command (SNDFILE *sndfile, int command, void *data, int datasize) ;
int sf_format_check (const SF_INFO *info) ;
enum
{ SF_SEEK_SET =                0                       ,
 SF_SEEK_CUR =               1                      ,
 SF_SEEK_END =               2
} ;
sf_count_t sf_seek (SNDFILE *sndfile, sf_count_t frames, int whence) ;
int sf_set_string (SNDFILE *sndfile, int str_type, const char* str) ;
const char* sf_get_string (SNDFILE *sndfile, int str_type) ;
const char * sf_version_string (void) ;
int sf_current_byterate (SNDFILE *sndfile) ;
sf_count_t sf_read_raw (SNDFILE *sndfile, void *ptr, sf_count_t bytes) ;
sf_count_t sf_write_raw (SNDFILE *sndfile, const void *ptr, sf_count_t bytes) ;
sf_count_t sf_readf_short (SNDFILE *sndfile, short *ptr, sf_count_t frames) ;
sf_count_t sf_writef_short (SNDFILE *sndfile, const short *ptr, sf_count_t frames) ;
sf_count_t sf_readf_int (SNDFILE *sndfile, int *ptr, sf_count_t frames) ;
sf_count_t sf_writef_int (SNDFILE *sndfile, const int *ptr, sf_count_t frames) ;
sf_count_t sf_readf_float (SNDFILE *sndfile, float *ptr, sf_count_t frames) ;
sf_count_t sf_writef_float (SNDFILE *sndfile, const float *ptr, sf_count_t frames) ;
sf_count_t sf_readf_double (SNDFILE *sndfile, double *ptr, sf_count_t frames) ;
sf_count_t sf_writef_double (SNDFILE *sndfile, const double *ptr, sf_count_t frames) ;
sf_count_t sf_read_short (SNDFILE *sndfile, short *ptr, sf_count_t items) ;
sf_count_t sf_write_short (SNDFILE *sndfile, const short *ptr, sf_count_t items) ;
sf_count_t sf_read_int (SNDFILE *sndfile, int *ptr, sf_count_t items) ;
sf_count_t sf_write_int (SNDFILE *sndfile, const int *ptr, sf_count_t items) ;
sf_count_t sf_read_float (SNDFILE *sndfile, float *ptr, sf_count_t items) ;
sf_count_t sf_write_float (SNDFILE *sndfile, const float *ptr, sf_count_t items) ;
sf_count_t sf_read_double (SNDFILE *sndfile, double *ptr, sf_count_t items) ;
sf_count_t sf_write_double (SNDFILE *sndfile, const double *ptr, sf_count_t items) ;
int sf_close (SNDFILE *sndfile) ;
void sf_write_sync (SNDFILE *sndfile) ;
struct SF_CHUNK_INFO
{ char id [64] ;
 unsigned id_size ;
 unsigned datalen ;
 void *data ;
} ;
typedef struct SF_CHUNK_INFO SF_CHUNK_INFO ;
int sf_set_chunk (SNDFILE * sndfile, const SF_CHUNK_INFO * chunk_info) ;
typedef struct SF_CHUNK_ITERATOR SF_CHUNK_ITERATOR ;
SF_CHUNK_ITERATOR *
sf_get_chunk_iterator (SNDFILE * sndfile, const SF_CHUNK_INFO * chunk_info) ;
SF_CHUNK_ITERATOR *
sf_next_chunk_iterator (SF_CHUNK_ITERATOR * iterator) ;
int
sf_get_chunk_size (const SF_CHUNK_ITERATOR * it, SF_CHUNK_INFO * chunk_info) ;
int
sf_get_chunk_data (const SF_CHUNK_ITERATOR * it, SF_CHUNK_INFO * chunk_info) ;]]
ffi_cdef[[static const int SF_STR_FIRST = SF_STR_TITLE;
static const int SF_STR_LAST = SF_STR_GENRE;]]
ffi_cdef[[
]]local formats = {}
formats[1] = "SF_FORMAT_PCM_S8"
formats[2] = "SF_FORMAT_PCM_16"
formats[3] = "SF_FORMAT_PCM_24"
formats[4] = "SF_FORMAT_PCM_32"
formats[5] = "SF_FORMAT_PCM_U8"
formats[6] = "SF_FORMAT_FLOAT"
formats[7] = "SF_FORMAT_DOUBLE"
formats[16] = "SF_FORMAT_ULAW"
formats[17] = "SF_FORMAT_ALAW"
formats[18] = "SF_FORMAT_IMA_ADPCM"
formats[19] = "SF_FORMAT_MS_ADPCM"
formats[32] = "SF_FORMAT_GSM610"
formats[33] = "SF_FORMAT_VOX_ADPCM"
formats[34] = "SF_FORMAT_NMS_ADPCM_16"
formats[35] = "SF_FORMAT_NMS_ADPCM_24"
formats[36] = "SF_FORMAT_NMS_ADPCM_32"
formats[48] = "SF_FORMAT_G721_32"
formats[49] = "SF_FORMAT_G723_24"
formats[50] = "SF_FORMAT_G723_40"
formats[64] = "SF_FORMAT_DWVW_12"
formats[65] = "SF_FORMAT_DWVW_16"
formats[66] = "SF_FORMAT_DWVW_24"
formats[67] = "SF_FORMAT_DWVW_N"
formats[80] = "SF_FORMAT_DPCM_8"
formats[81] = "SF_FORMAT_DPCM_16"
formats[96] = "SF_FORMAT_VORBIS"
formats[100] = "SF_FORMAT_OPUS"
formats[112] = "SF_FORMAT_ALAC_16"
formats[113] = "SF_FORMAT_ALAC_20"
formats[114] = "SF_FORMAT_ALAC_24"
formats[115] = "SF_FORMAT_ALAC_32"
formats[65535] = "SF_FORMAT_SUBMASK"
formats[65536] = "SF_FORMAT_WAV"
formats[131072] = "SF_FORMAT_AIFF"
formats[196608] = "SF_FORMAT_AU"
formats[262144] = "SF_FORMAT_RAW"
formats[327680] = "SF_FORMAT_PAF"
formats[393216] = "SF_FORMAT_SVX"
formats[458752] = "SF_FORMAT_NIST"
formats[524288] = "SF_FORMAT_VOC"
formats[655360] = "SF_FORMAT_IRCAM"
formats[720896] = "SF_FORMAT_W64"
formats[786432] = "SF_FORMAT_MAT4"
formats[851968] = "SF_FORMAT_MAT5"
formats[917504] = "SF_FORMAT_PVF"
formats[983040] = "SF_FORMAT_XI"
formats[1048576] = "SF_FORMAT_HTK"
formats[1114112] = "SF_FORMAT_SDS"
formats[1179648] = "SF_FORMAT_AVR"
formats[1245184] = "SF_FORMAT_WAVEX"
formats[1441792] = "SF_FORMAT_SD2"
formats[1507328] = "SF_FORMAT_FLAC"
formats[1572864] = "SF_FORMAT_CAF"
formats[1638400] = "SF_FORMAT_WVE"
formats[2097152] = "SF_FORMAT_OGG"
formats[2162688] = "SF_FORMAT_MPC2K"
formats[2228224] = "SF_FORMAT_RF64"
formats[268369920] = "SF_FORMAT_TYPEMASK"
formats[805306368] = "SF_FORMAT_ENDMASK"
-------------samplerate conversion
local srconv = require"samplerate"

ffi_cdef[[
typedef struct RESAMPLER RESAMPLER;
typedef struct SNDFILE_ref
{
    SNDFILE *sf ;
    SF_INFO sfinfo[1] ;
    int mode ;
    RESAMPLER *resampler;
} SNDFILE_ref;

typedef struct RESAMPLER
{
  SRC_STATE *src_state;
  unsigned long resampler_frames;
  float * resampler_buffer;
  double ratio;
  SNDFILE_ref *sf;
} RESAMPLER;

]]


local lib = ffi.load"sndfile"

local M = {C=lib, srconv=srconv}

M.formats = formats

local function ffi_string(str)
    if str==nil then
        return ""
    else
        return ffi.string(str)
    end
end

local function input_cb_orig(cb_data, out)
  local resam = ffi.cast("RESAMPLER *", cb_data)
  local readframes = resam.sf:readf_float(resam.resampler_buffer, resam.resampler_frames)
  out[0] = resam.resampler_buffer
  return readframes
end
M.resampler_input_cb = input_cb_orig

local RESAMPLER = {}
RESAMPLER.__index = RESAMPLER
function RESAMPLER:__new(sf,fr_read, converter,input_cb,ratio )
	input_cb = input_cb or input_cb_orig
    local ret = ffi.new"RESAMPLER"
    fr_read = fr_read or 1024
    converter = converter or srconv.SRC_SINC_BEST_QUALITY
    local buf = ffi.new("float[?]",fr_read * sf:channels())
    ret.sf = sf
    ret.resampler_frames = fr_read
    ret.resampler_buffer = buf
    ret.ratio = ratio or 1
    local err = ffi.new"int[1]"
    local src_state = srconv.src_callback_new(input_cb, converter, sf:channels(), err, ret)
    if src_state == nil then 
        local errstr = ffi_string(srconv.src_strerror(err[0]))
        error(errstr,2) 
    end
    ret.src_state = src_state
    ffi.gc(ret,function(t) ret:delete(buf) end) --anchor buf
    return ret
end
function RESAMPLER:delete()
    ffi.gc(self,nil)
    if self.src_state~=nil then
        srconv.src_delete(self.src_state)
    end
end
function RESAMPLER:set_ratio(ratio)
    self.ratio = ratio
    srconv.src_set_ratio(self.src_state, ratio)
end
function RESAMPLER:read(data_out, fr_out, ratio)
    if ratio then
        self.ratio = ratio
    end
    local readfr = srconv.src_callback_read(self.src_state, self.ratio, fr_out, data_out)
    local err = srconv.src_error(self.src_state)
    if err~=0 then 
        local errstr = ffi_string(srconv.src_strerror(err))
        error("RESAMPLER read error"..errstr,2) 
    end
    return readfr
end
function RESAMPLER:readf_float(data_out, fr_out, ratio)
    return self:read(data_out, fr_out, ratio)
end
function RESAMPLER:readf_int(data_out, fr_out, ratio)
    local len = fr_out*self.sf:channels()
    local bufferf = ffi.new("float[?]", len)
    local readfr = self:read(bufferf, fr_out, ratio)
    srconv.src_float_to_int_array (bufferf, data_out,len)
    return readfr
end
function RESAMPLER:readf_short(data_out, fr_out, ratio)
    local len = fr_out*self.sf:channels()
    local bufferf = ffi.new("float[?]", len)
    local readfr = self:read(bufferf, fr_out, ratio)
    srconv.src_float_to_short_array(bufferf, data_out,len)
    return readfr
end
function RESAMPLER:seek(frame_count,whence)
    srconv.src_reset(self.src_state)
    return self.sf:seek(frame_count,whence)
end
function RESAMPLER:reset()
    return srconv.src_reset(self.src_state)
end
M.RESAMPLER = ffi.metatype("RESAMPLER",RESAMPLER)

local Sndfile = {}
Sndfile.__index = Sndfile
function Sndfile.__new(tt,filename,mode,sr,ch,format)

    local sndfile_ref = ffi.new"SNDFILE_ref"
    sndfile_ref.sfinfo[0].samplerate = sr or 0
    sndfile_ref.sfinfo[0].channels = ch or 0
    sndfile_ref.sfinfo[0].format = format or 0
    
    if mode == nil or mode == "r" then
        mode = lib.SFM_READ
    elseif mode == "w" then
        mode = lib.SFM_WRITE
    elseif mode == "rw" then
        mode = lib.SFM_RDWR
    end
    sndfile_ref.mode = mode
    local sf = lib.sf_open(filename,mode,sndfile_ref.sfinfo)
    sndfile_ref.sf = sf
    if sf==nil then
        error(ffi_string(lib.sf_strerror(nil)).." "..filename, 2)
    end
    ffi.gc(sndfile_ref,function(t) return sndfile_ref.close(t,sf) end)
    return sndfile_ref
end
function Sndfile:close()
    ffi.gc(self,nil)
    local ret = lib.sf_close(self.sf)
    if ret~=0 then
        error(ffi_string(lib.sf_error_number(ret)),2)
    end
    self.sf = nil
end
function Sndfile:frames()
    return self.sfinfo[0].frames
end
function Sndfile:channels()
    return self.sfinfo[0].channels
end
function Sndfile:format()
    local form = self.sfinfo[0].format
    local formM = bit.band(form,lib.SF_FORMAT_TYPEMASK)
    local formS = bit.band(form,lib.SF_FORMAT_SUBMASK)
    return form, formats[formM],formats[formS]
end
function Sndfile:samplerate()
    return self.sfinfo[0].samplerate
end
function Sndfile:seek(frame_count,whence)
    return lib.sf_seek(self.sf,frame_count,whence or lib.SF_SEEK_SET)
end

function Sndfile:readf_double(buffer,frames)
    return lib.sf_readf_double(self.sf,buffer,frames)
end
function Sndfile:readf_float(buffer,frames)
    return lib.sf_readf_float(self.sf,buffer,frames)
end
function Sndfile:readf_int(buffer,frames)
    return lib.sf_readf_int(self.sf,buffer,frames)
end
function Sndfile:readf_short(buffer,frames)
    return lib.sf_readf_short(self.sf,buffer,frames)
end

function Sndfile:read_double(buffer,items)
    return lib.sf_read_double(self.sf,buffer,items)
end
function Sndfile:read_float(buffer,items)
    return lib.sf_read_float(self.sf,buffer,items)
end
function Sndfile:read_int(buffer,items)
    return lib.sf_read_int(self.sf,buffer,items)
end
function Sndfile:read_short(buffer,items)
    return lib.sf_read_short(self.sf,buffer,items)
end

function Sndfile:writef_double(buffer,frames)
    return lib.sf_writef_double(self.sf,buffer,frames)
end
function Sndfile:writef_float(buffer,frames)
    return lib.sf_writef_float(self.sf,buffer,frames)
end
function Sndfile:writef_int(buffer,frames)
    return lib.sf_writef_int(self.sf,buffer,frames)
end
function Sndfile:writef_short(buffer,frames)
    return lib.sf_writef_short(self.sf,buffer,frames)
end

function Sndfile:write_double(buffer,items)
    return lib.sf_write_double(self.sf,buffer,items)
end
function Sndfile:write_float(buffer,items)
    return lib.sf_write_float(self.sf,buffer,items)
end
function Sndfile:write_int(buffer,items)
    return lib.sf_write_int(self.sf,buffer,items)
end
function Sndfile:write_short(buffer,items)
    return lib.sf_write_short(self.sf,buffer,items)
end
---------------
local t_double = ffi.typeof"double[]"
local t_float = ffi.typeof"float[]"
local t_short = ffi.typeof"short[]"
local t_int = ffi.typeof"int[]"
local istype = ffi.istype
local sizeof = ffi.sizeof

function Sndfile:readf(buffer)
    local bsize = sizeof(buffer)
    --print(buffer,bsize,type(buffer))
    local readfunc,frames
    local ch = self:channels()
    if istype(t_double,buffer) then
        readfunc = lib.sf_readf_double
        frames = bsize/sizeof"double"/ch
    elseif istype(t_float,buffer) then
        readfunc = lib.sf_readf_float
        frames = bsize/sizeof"float"/ch
    elseif istype(t_int,buffer) then
        readfunc = lib.sf_readf_int
        frames = bsize/sizeof"int"/ch
    elseif istype(t_short,buffer) then
        readfunc = lib.sf_readf_short
        frames = bsize/sizeof"short"/ch
    else
        error("unknown type of buffer in Sndfile:readf",2)
    end
    assert(math.floor(frames)==frames,"sizeof buffer is not multiple of channels and type")
    return readfunc(self.sf,buffer,frames)
end

function Sndfile:writef(buffer)
    local bsize = sizeof(buffer,nframes)
    --print(buffer,bsize,type(buffer))
    local readfunc,frames
    local ch = self:channels()
    if istype(t_double,buffer) then
        readfunc = lib.sf_writef_double
        frames = bsize/sizeof"double"/ch
    elseif istype(t_float,buffer) then
        readfunc = lib.sf_writef_float
        frames = bsize/sizeof"float"/ch
    elseif istype(t_int,buffer) then
        readfunc = lib.sf_writef_int
        frames = bsize/sizeof"int"/ch
    elseif istype(t_short,buffer) then
        readfunc = lib.sf_writef_short
        frames = bsize/sizeof"short"/ch
    else
        error("unknown type of buffer in Sndfile:writef",2)
    end
    assert(math.floor(frames)==frames,"sizeof buffer is not multiple of channels and type")
    nframes = nframes or frames
    local ret = readfunc(self.sf,buffer,nframes)
    assert(ret==nframes,"error writing file")
end

function Sndfile:resampler_create(fr_read, converter,inputcb)
    assert(self.resampler==nil, "resampler_create already used.")
    self.resampler = M.RESAMPLER(self,fr_read, converter,inputcb)
    return self.resampler
end



M.Sndfile = ffi.metatype("SNDFILE_ref",Sndfile)

function M.get_info(filename)
   local sf = M.Sndfile(filename)
   local info = {samplerate = sf.sfinfo[0].samplerate,
                channels = sf.sfinfo[0].channels,
                frames = sf.sfinfo[0].frames,
                format = sf.sfinfo[0].format
                }
    sf:close()
    return info
end
function M.version_string()
    return ffi_string(lib.sf_version_string())
end

function M.simple_format_count()
    local  count = ffi.new"int[1]"
    lib.sf_command (nil, lib.SFC_GET_SIMPLE_FORMAT_COUNT, count, ffi.sizeof("int")) ;
    return count[0]
end

function M.simple_format(n)
    local format_info = ffi.new"SF_FORMAT_INFO[1]"
    format_info[0].format = n
    local ret = lib.sf_command (nil, lib.SFC_GET_SIMPLE_FORMAT, format_info, ffi.sizeof(format_info[0]))
    if(ret~=0) then
        print("GET_SIMPLE_FORMAT",n,ffi_string(lib.sf_error_number(ret)))
        error("GET_SIMPLE_FORMAT",2)
    end
    return format_info[0]
end

function M.simple_formats()
    local count = M.simple_format_count()
    local ret = {}
    for i=0,count-1 do
        local finfo = M.simple_format(i)
        table.insert(ret,{format_en=formats[finfo.format], format=finfo.format,name=ffi_string(finfo.name),ext=ffi_string(finfo.extension)})
    end
    return ret
end

function M.major_format_count()
    local  count = ffi.new"int[1]"
    lib.sf_command (nil, lib.SFC_GET_FORMAT_MAJOR_COUNT, count, ffi.sizeof("int")) ;
    return count[0]
end

function M.major_format(n)
    local format_info = ffi.new"SF_FORMAT_INFO[1]"
    format_info[0].format = n
    local ret = lib.sf_command (nil, lib.SFC_GET_FORMAT_MAJOR, format_info, ffi.sizeof(format_info[0]))
    if(ret~=0) then
        print("SFC_GET_FORMAT_MAJOR",n,ffi_string(lib.sf_error_number(ret)))
        error("SFC_GET_FORMAT_MAJOR",2)
    end
    return format_info[0]
end

function M.major_formats()
    local count = M.major_format_count()
    local ret = {}
    for i=0,count-1 do
        local finfo = M.major_format(i)
        table.insert(ret,{format_en=formats[finfo.format], format=finfo.format,name=ffi_string(finfo.name),ext=ffi_string(finfo.extension)})
    end
    return ret
end

function M.format_subtype_count()
    local  count = ffi.new"int[1]"
    lib.sf_command (nil, lib.SFC_GET_FORMAT_SUBTYPE_COUNT, count, ffi.sizeof("int")) ;
    return count[0]
end

function M.format_subtype(n)
    local format_info = ffi.new"SF_FORMAT_INFO[1]"
    format_info[0].format = n
    local ret = lib.sf_command (nil, lib.SFC_GET_FORMAT_SUBTYPE, format_info, ffi.sizeof(format_info[0]))
    if(ret~=0) then
        print("SFC_GET_FORMAT_SUBTYPE",n,ffi_string(lib.sf_error_number(ret)))
        error("SFC_GET_FORMAT_SUBTYPE",2)
    end
    return format_info[0]
end

function M.format_subtypes(parent)
    local count = M.format_subtype_count()
    local ret = {}
    for i=0,count-1 do
        local finfo = M.format_subtype(i)
        if (not parent) or bit.bor(parent,finfo.format) then
            table.insert(ret,{format_en=formats[finfo.format], format=finfo.format,name=ffi_string(finfo.name)})
        end
    end
    return ret
end

setmetatable(M,{
__index = function(t,k)
    local ok,ptr = pcall(function(str) return lib["sf_"..str] end,k)
    if not ok then ok,ptr = pcall(function(str) return lib["SF_"..str] end,k) end
    if not ok then ok,ptr = pcall(function(str) return lib[str] end,k) end --some defines without sf_
    if not ok then error(k.." not found",2) end
    rawset(M, k, ptr)
    return ptr
end
})


return M
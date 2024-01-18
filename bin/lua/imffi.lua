local im = {}
local ffi = require"ffi"

ffi.cdef[[
struct _imFile
{
  int is_new;
  void* attrib_table;    /**< in fact is a imAttribTable, but we hide this here */

  void* line_buffer;     /**< used for line conversion, contains all components if packed, or only one if not */
  int line_buffer_size;
  int line_buffer_extra; /**< extra bytes to be allocated */
  int line_buffer_alloc; /**< total allocated so far */
  int counter;

  int convert_bpp;       /**< number of bpp to unpack/pack to/from 1 byte. 
                              When reading converts n packed bits to 1 byte (unpack). If n>1 will also expand to 0-255. 
                              When writing converts 1 byte to 1 bit (pack). 
                              If negative will only expand to 0-255 (no unpack or pack). */
  int switch_type;       /**< flag to switch the original data type: char-byte, short-ushort, uint-int, double-float */

  long palette[256];
  int palette_count;

  int user_color_mode,
      user_data_type,
      file_color_mode,   /* these two must be filled by te driver always. */
      file_data_type;

  /* these must be filled by the driver when reading,
     and given by the user when writing. */

  char compression[10];
  int image_count,
      image_index,
      width,           
      height;
};
typedef struct _imFile imFile;
typedef struct _imImage
{
  int width;     
  int height;    
  int color_space;   
  int data_type;     
  int has_alpha;      
  int depth;         
  int line_size;    
  int plane_size;   
  int size;         
  int count;        
  void** data;        
  long *palette;     
  int palette_count; 
  void* attrib_table;
} imImage;

enum imErrorCodes	
{
  IM_ERR_NONE,     /**< No error. */
  IM_ERR_OPEN,     /**< Error while opening the file (read or write). */
  IM_ERR_ACCESS,   /**< Error while accessing the file (read or write). */
  IM_ERR_FORMAT,   /**< Invalid or unrecognized file format. */
  IM_ERR_DATA,     /**< Invalid or unsupported data. */
  IM_ERR_COMPRESS, /**< Invalid or unsupported compression. */
  IM_ERR_MEM,      /**< Insufficient memory */
  IM_ERR_COUNTER   /**< Interrupted by the counter */
};
enum imDataType
{
  IM_BYTE,   /**< "unsigned char". 1 byte from 0 to 255.                  */
  IM_SHORT,  /**< "short". 2 bytes from -32,768 to 32,767.                */
  IM_USHORT, /**< "unsigned short". 2 bytes from 0 to 65,535.             */
  IM_INT,    /**< "int". 4 bytes from -2,147,483,648 to 2,147,483,647.    */
  IM_FLOAT,  /**< "float". 4 bytes single precision IEEE floating point.  */
  IM_DOUBLE, /**< "double". 8 bytes double precision IEEE floating point. */
  IM_CFLOAT, /**< complex "float". 2 float values in sequence, real and imaginary parts.   */
  IM_CDOUBLE /**< complex "double". 2 double values in sequence, real and imaginary parts.   */
};
enum imColorSpace
{
  IM_RGB,    /**< Red, Green and Blue (nonlinear).              */
  IM_MAP,    /**< Indexed by RGB color map (data_type=IM_BYTE). */
  IM_GRAY,   /**< Shades of gray, luma (nonlinear Luminance), or an intensity value that is not related to color. */
  IM_BINARY, /**< Indexed by 2 colors: black (0) and white (1) (data_type=IM_BYTE).     */
  IM_CMYK,   /**< Cian, Magenta, Yellow and Black (nonlinear).                          */
  IM_YCBCR,  /**< ITU-R 601 Y'CbCr. Y' is luma (nonlinear Luminance).                   */
  IM_LAB,    /**< CIE L*a*b*. L* is Lightness (nonlinear Luminance, nearly perceptually uniform). */
  IM_LUV,    /**< CIE L*u*v*. L* is Lightness (nonlinear Luminance, nearly perceptually uniform). */
  IM_XYZ     /**< CIE XYZ. Linear Light Tristimulus, Y is linear Luminance.             */
};
enum imColorModeConfig
{
  IM_ALPHA    = 0x100,  /**< adds an Alpha channel */
  IM_PACKED   = 0x200,  /**< packed components (rgbrgbrgb...) */
  IM_TOPDOWN  = 0x400   /**< orientation from top down to bottom */
};
enum imComplex2Real { IM_CPX_REAL, IM_CPX_IMAG, IM_CPX_MAG, IM_CPX_PHASE };
enum imGammaFactor {
  IM_GAMMA_LINEAR = 0, IM_GAMMA_LOGLITE = -10, IM_GAMMA_LOGHEAVY = -1000, IM_GAMMA_EXPLITE = 2,
  IM_GAMMA_EXPHEAVY = 7
};
enum imCastMode { IM_CAST_MINMAX, IM_CAST_FIXED, IM_CAST_DIRECT, IM_CAST_USER };
enum  	imToneGamut {
  IM_GAMUT_NORMALIZE, IM_GAMUT_POW, IM_GAMUT_LOG, IM_GAMUT_EXP,
  IM_GAMUT_INVERT, IM_GAMUT_ZEROSTART, IM_GAMUT_SOLARIZE, IM_GAMUT_SLICE,
  IM_GAMUT_EXPAND, IM_GAMUT_CROP, IM_GAMUT_BRIGHTCONT
};
enum  	imToneGamutFlags { IM_GAMUT_MINMAX = 0x0100 };
void imImageAddAlpha 	( 	imImage *  	image 	 ) ;
imImage* imFileImageLoad(const char *file_name, int index, int *error);	
imImage * 	imFileImageLoadBitmap (const char *file_name, int index, int *error);
void* imImageGetOpenGLData(const imImage* image, int *glformat);
imImage* imImageCreateFromOpenGLData(int width, int height, int glformat, const void* gldata);
int imFileImageSave(const char* file_name, const char* format, const void* image);
void imImageDestroy (void *image);
void* imFileNew(const char *  file_name,const char *  	format,int *  	error) ;
void imImageSetAttribute (const void *  image,const char *  attrib,int  data_type,int  	count,const void *  	data) ;	
void imImageSetAttribInteger(const imImage * image,const char * attrib,int data_type,int value );
void imFileSetAttribute(void *  ifile,const char *  	attrib,int  	data_type,int  	count,const void *  data) ;			
int imFileReadImageInfo(imFile* ifile, int index, int *width, int *height, int *file_color_mode, int *file_data_type);
void imImageSetAttribReal(const void *  image,const char *  attrib,int  data_type,double  	value) 	;
const void* imImageGetAttribute(const imImage *image,const char *attrib, int *data_type, int *count);			

void imFileGetInfo(imFile* ifile, char* format, char* compression, int *image_count);
imFile* imFileOpen(const char* file_name, int *error);
void imFileClose(void *  	ifile) ;		
int imFormatInfo(const char* format, char* desc, char* ext, int *can_sequence);
int imFileSaveImage(void* ifile,const void* image);	
int imFileWriteImageInfo(void * ifile,int width,int height,int user_color_mode,int user_data_type); 
int imFileWriteImageData(void * ifile,void * data);	
void 	imConvertPacking (const void *src_data, void *dst_data, int width, int height, int src_depth, int dst_depth, int data_type, int src_is_packed);							
void imProcessFlip(const imImage* src_image, imImage* dst_image);
void imProcessInsert (const imImage *src_image, const imImage *region_image, imImage *dst_image, int xmin, int ymin);
void imProcessCrop(const imImage* src_image, imImage* dst_image, int xmin, int ymin);
void imProcessMirror(const imImage* src_image, imImage* dst_image);
void imProcessReduceBy4(const imImage* src_image, imImage* dst_image);
int 	imProcessResize (const imImage *src_image, imImage *dst_image, int order);
int imProcessReduce (const imImage *src_image,imImage *dst_image,int order);
int 	imProcessAddMargins (const imImage *src_image, imImage *dst_image, int xmin, int ymin);
imImage* imImageCreateBased(const imImage* image, int width, int height, int color_space, int data_type);

const char* imColorModeSpaceName(int color_mode);
const char* imDataTypeName(int data_type);
int imImageDataSize(int width, int height, int color_mode, int data_type);

void imFileGetAttributeList(imFile* ifile, char** attrib, int *attrib_count);
const void* imFileGetAttribute(imFile* ifile, const char* attrib, int *data_type, int *count);
int imProcessConvertDataType (const imImage *src_image, imImage *dst_image, int cpx2real, double gamma, int absolute, int cast_mode);
int imConvertDataType(const imImage *src_image,imImage *dst_image,int cpx2real,double gamma,int absolute,int cast_mode);
int imProcessConvertColorSpace (const imImage *src_image, imImage *dst_image);
int imConvertColorSpace (const imImage *src_image, imImage *dst_image);
void imProcessThreshold (const imImage *src_image, imImage *dst_image, double level, int value);

int 	imProcessGrayMorphConvolve (const imImage *src_image, imImage *dst_image, const imImage *kernel, int ismax);
int 	imProcessGrayMorphErode (const imImage *src_image, imImage *dst_image, int kernel_size);
int 	imProcessGrayMorphDilate (const imImage *src_image, imImage *dst_image, int kernel_size);
int 	imProcessGrayMorphOpen (const imImage *src_image, imImage *dst_image, int kernel_size);
int 	imProcessGrayMorphClose (const imImage *src_image, imImage *dst_image, int kernel_size);
int 	imProcessGrayMorphTopHat (const imImage *src_image, imImage *dst_image, int kernel_size);
int 	imProcessGrayMorphWell (const imImage *src_image, imImage *dst_image, int kernel_size);
int 	imProcessGrayMorphGradient (const imImage *src_image, imImage *dst_image, int kernel_size);

void 	imProcessNegative (const imImage *src_image, imImage *dst_image);
void 	imProcessToneGamut (const imImage *src_image, imImage *dst_image, int op, double *params);
int 	imProcessOtsuThreshold (const imImage *src_image, imImage *dst_image);
]]

--[[
local oldffistr = ffi.string
ffi.string = function(str)
	if str~=nil then
		return oldffistr(str)
	else
		print"ffistring-----------------------------------------------------------------------"
		return nil
	end
end
--]]

-- local imffi = ffi.load"imdlls_debug/libim"
-- local improc = ffi.load"imdlls_debug/libim_process_omp"
local imffi = ffi.load"im"
local improc = ffi.load"im_process"
-- local imffi = ffi.load"iupdlls/im"
-- local improc = ffi.load"iupdlls/im_process_omp"

im.imffi = imffi
im.improc = improc

im.BYTE = imffi.IM_BYTE 
im.SHORT  = imffi.IM_SHORT 
im.USHORT = imffi.IM_USHORT
im.INT   = imffi.IM_INT  
im.FLOAT  = imffi.IM_FLOAT 
im.DOUBLE = imffi.IM_DOUBLE
im.CFLOAT = imffi.IM_CFLOAT
im.CDOUBLE = imffi.IM_CDOUBLE

function im.FormatInfo(format)
	assert(format)
	local desc = ffi.new("char[50]")
	local ext = ffi.new("char[50]")
	local can_sequence = ffi.new"int[1]"
	local err = imffi.imFormatInfo(format, desc, ext, can_sequence)
	return err,ffi.string(desc),ffi.string(ext),can_sequence[0]
end
function im.FileImageLoad(file_name, index, err)
	index = index or 0
	err = err or ffi.new("int[1]")
	return imffi.imFileImageLoad(file_name, index, err),err[0]
end
function im.FileImageLoadBitmap(file_name, index, err)
	index = index or 0
	err = err or ffi.new("int[1]")
	return imffi.imFileImageLoadBitmap(file_name, index, err),err[0]
end
function im.ImageCreateBased(image,width,height, color_space,data_type)
	width = width or -1
	height = height or -1
	color_space = color_space or -1
	data_type = data_type or -1
	return imffi.imImageCreateBased(image,width,height, color_space,data_type)
end
function im.ImageCreateFromOpenGLData(width, height, glformat, gldata)
	return imffi.imImageCreateFromOpenGLData(width, height, glformat, gldata)
end
-- function im.FileImageSave(file_name,format,image);
	-- return imffi.imFileImageSave(file_name, format,image);
-- end
function im.ColorModeHasAlpha(cm)
	return bit.band(cm,imffi.IM_ALPHA)
end
function im.ColorModeIsPacked(cm)
	return bit.band(cm,imffi.IM_PACKED)
end
function im.ColorModeIsTopDown(cm)
	return bit.band(cm,imffi.IM_TOPDOWN)
end
function im.DataTypeName(dt)
	return ffi.string(imffi.imDataTypeName(dt))
end
function im.ImageDataSize(width, height, color_mode,data_type)
	return imffi.imImageDataSize(width, height, color_mode,data_type);
end
function im.ColorModeSpaceName(cm)
	return ffi.string(imffi.imColorModeSpaceName(cm))
end
im.ERR_NONE = imffi.IM_ERR_NONE
function im.ErrorStr(err)
	local msg = {}
	msg[imffi.IM_ERR_OPEN] = "Error Opening File."
	msg[imffi.IM_ERR_MEM] = "Insufficient memory."
	msg[imffi.IM_ERR_ACCESS] = "Error Accessing File."
	msg[imffi.IM_ERR_DATA] = "Image type not Supported."
	msg[imffi.IM_ERR_FORMAT] = "Invalid Format."
	msg[imffi.IM_ERR_COMPRESS] = "Invalid or unsupported compression."
	msg[imffi.IM_ERR_NONE] = "None."
	msg[imffi.IM_ERR_COUNTER] = "Counter Interrupted."
	
	if msg[err] then
		return msg[err]
	else
		return "Unknown Error."
	end
end
function im.ProcessFlip(src,dst)
	improc.imProcessFlip(src,dst)
end
function im.ProcessCrop(src_image, dst_image, xmin, ymin)
	improc.imProcessCrop(src_image, dst_image, xmin, ymin)
end
function im.ProcessInsert(src_image, region_image, dst_image, xmin, ymin)
	improc.imProcessInsert(src_image, region_image, dst_image, xmin, ymin)
end
function im.ProcessResize(src_image, dst_image,order)
	return improc.imProcessResize (src_image, dst_image,order)
end
function im.ProcessReduce(src_image, dst_image,order)
	return improc.imProcessReduce (src_image, dst_image,order)
end
function im.ProcessAddMargins(src_image,dst_image, xmin, ymin)
	return improc.imProcessAddMargins (src_image,dst_image, xmin, ymin)
end
function im.ProcessMirror(src,dst)
	improc.imProcessMirror(src, dst);
end
function im.ProcessMirrorNew(src)
	local dst = im.ImageCreateBased(src)
	improc.imProcessMirror(src, dst);
	return dst
end
function im.ProcessReduceBy4(src,dst)
	improc.imProcessReduceBy4(src, dst);
end
function im.ProcessReduceBy4New(src)
	local dst = im.ImageCreateBased(src,src:Width()*0.5,src:Height()*0.5)
	improc.imProcessReduceBy4(src, dst);
	return dst
end
function im.FileOpen(fname)
	local err = ffi.new("int[1]")
	return imffi.imFileOpen(fname,err),err[0]
end
-------------
local imImage = {}
imImage.__index = imImage
function imImage:Width()
	return self.width
end
function imImage:Height()
	return self.height
end
function imImage:Depth()
	return self.depth
end
function imImage:ColorSpace()
	return self.color_space
end
function imImage:DataType()
	return self.data_type
end
function imImage:Destroy()
	return imffi.imImageDestroy(self)
end
function imImage:GetOpenGLData()
	local glformat = ffi.new("int[1]")
	local data = imffi.imImageGetOpenGLData(self, glformat)
	return data,glformat[0]
end
function imImage:SetAttribInteger(attstr, data_type, value )
	imffi.imImageSetAttribInteger(self, attstr, data_type, value );
end
function imImage:FileSave(file_name,format)
	return imffi.imFileImageSave(file_name, format,self);
end
--end
-- function imImage:ProcessFlip(dest)
-- end
im.Image = ffi.metatype("imImage",imImage)
--------------
local imFile = {}
imFile.__index = imFile
function imFile:Close()
	imffi.imFileClose(self)
end
function imFile:GetInfo()
	local format = ffi.new("char[10]")
	local compression = ffi.new("char[20]")
	local image_count = ffi.new"int[1]"
	imffi.imFileGetInfo(self, format, compression, image_count)
	return ffi.string(format), ffi.string(compression), image_count[0]
end
function imFile:ReadImageInfo(index)
	print("index",self,index)
	local width = ffi.new"int[1]"
	local height = ffi.new"int[1]"
	local file_color_mode = ffi.new"int[1]"
	local file_data_type = ffi.new"int[1]"
	local err = imffi.imFileReadImageInfo(self,index, width, height,file_color_mode,file_data_type);
	print("return", err,width[0],height[0],file_color_mode[0],file_data_type[0])
	return err,width[0],height[0],file_color_mode[0],file_data_type[0]
end
function imFile:GetAttributeList()
	print"imFile:GetAttributeList"
	local count = ffi.new"int[1]"
	imffi.imFileGetAttributeList(self,nil,count);
	print(count[0])
	local at_list = ffi.new("char *[?]",count[0])
	imffi.imFileGetAttributeList(self,at_list,count);
	local atT = {}
	for i=1,count[0] do atT[i] = ffi.string(at_list[i-1]) end
	return atT
end

function imFile:GetAttribute(at,as_string)
	local data_type = ffi.new"int[1]"
	local count = ffi.new"int[1]"
	assert(type(at)=="string","attribute not string")
	local data = imffi.imFileGetAttribute(self,at,data_type,count)
	if data==nil then return nil end
	data_type = data_type[0]
	if as_string and data_type==imffi.IM_BYTE then
		return ffi.string(data,count[0]),data_type
	end
	local dataT = {}
	--cast
	if data_type==imffi.IM_BYTE then
		data = ffi.cast("unsigned char*",data)
	elseif data_type==imffi.IM_SHORT then
		data = ffi.cast("short*",data)
	elseif data_type==imffi.IM_USHORT then
		data = ffi.cast("unsigned short*",data)
	elseif data_type==imffi.IM_INT then
		data = ffi.cast("int*",data)
	elseif data_type==imffi.IM_FLOAT or data_type==imffi.IM_CFLOAT then
		data = ffi.cast("float*",data)
	elseif data_type==imffi.IM_DOUBLE or data_type==imffi.IM_CDOUBLE then
		data = ffi.cast("double*",data)
	end
	if data_type==imffi.IM_CFLOAT or data_type==imffi.IM_CDOUBLE then
		for i=1,count[0] do
			dataT[i] = {data[(i-1)*2],data[(i-1)*2+1]}
		end
	else
		for i=1,count[0] do
			dataT[i] = data[i-1]
		end
	end
	return dataT,data_type
end
im.imFile = ffi.metatype("imFile",imFile)

--print(ffi.C.malloc)
--print(im.imffi.IM_BYTE,ffi.C.IM_BYTE,im.improc.IM_BYTE)
--print(im.imffi.caca)
--print(im.imffi.imFileClose);
--print(im.improc.caca);
--print(ffi.C.imFileClose)
--for k,v in pairs(imffi) do print(k,v) end

im = setmetatable(im, {
	__index = function(self, k)
		--print("pcall",self,k)
		local ok, typ = pcall(function(K) return imffi["IM_"..K] end, k)
		--print("ret pcall",ok,typ)
		if not ok then 
			print(typ)
			error("no se pue") --peta
		end
		rawset(self, k, typ)
		return typ
	end,
})

return im
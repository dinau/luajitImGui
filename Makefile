TC = gcc

# Can't compile
#TC = clang
#TC = msvc

# Must be abusolute path
INSTALL_DIR = $(abspath $(CURDIR))/bin
#
BUILD_OPT += -DLUAJIT_BIN=$(INSTALL_DIR)  # Install folder

# Options
#BUILD_OPT += -DCMAKE_BUILD_TYPE=RelWithDebInfo
BUILD_OPT += -DCMAKE_BUILD_TYPE=Release
#BUILD_OPT += -DANIMA_BUILD_SDL=no
#BUILD_OPT += -DANIMA_BUILD_SNDFILE=no
#BUILD_OPT += -DANIMA_BUILD_RTAUDIO=no
#BUILD_OPT += -DANIMA_BUILD_IM=no

ifeq ($(TC),gcc)
	BUILD_OPT += -G"MSYS Makefiles"
  COPY_DLL1 = ( cp -f dll/32bit/libgcc_s_dw2-1.dll bin/  )
  COPY_DLL2 = (	cp -f dll/32bit/libsamplerate-0.dll bin/ )
	BUILD_INSTALL_CMD = ( make install )
endif

ifeq ($(TC),msvc)
	BUILD_INSTALL_CMD =  (msbuild.exe /m /p:Configuration=Release /p:Platform="Win32" anima.sln)
endif


BUILD_DIR = build

.PHONY: copy_dll build clean $(INSTALL_DIR)

all: $(INSTALL_DIR) $(BUILD_DIR) copy_dll
	(cd $(BUILD_DIR); cmake ../anima $(BUILD_OPT) )
	(cd $(BUILD_DIR); $(BUILD_INSTALL_CMD) )

copy_dll:
	$(COPY_DLL1)
	$(COPY_DLL2)

$(INSTALL_DIR):
	-mkdir -p $@

build:
	-mkdir -p $@

clean:
	-rm -fr $(BUILD_DIR)
	-rm -fr $(INSTALL_DIR)

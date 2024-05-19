# Compile ok MinGW gcc 13.2.0
#TC ?= gcc

# Compile ok / Install NG. Artifacts need to be installed to bin folder by yourself.
# Visual studio 2019 C/C++
#TC ?= msvc

# Compile ok  Clang version 18.1.5 MinGW
TC = clang

# Must be abusolute path
INSTALL_DIR = $(abspath $(CURDIR))/bin
#
BUILD_OPT += -DLUAJIT_BIN=$(INSTALL_DIR)  # Install folder

# Selsct main options
#BUILD_OPT += -DCMAKE_BUILD_TYPE=RelWithDebInfo
BUILD_OPT += -DCMAKE_BUILD_TYPE=Release

# Select libraries
#BUILD_OPT += -DANIMA_BUILD_SDL=no
#BUILD_OPT += -DANIMA_BUILD_SNDFILE=no
#BUILD_OPT += -DANIMA_BUILD_RTAUDIO=no
#BUILD_OPT += -DANIMA_BUILD_IM=no

ifeq ($(TC),msvc)
	BUILD_INSTALL_CMD =  (msbuild.exe /m /p:Configuration=Release /p:Platform="Win32" anima.sln)
else
	BUILD_OPT += -G"MSYS Makefiles"
	BUILD_OPT += -DCMAKE_CXX_STANDARD=11
	BUILD_OPT += -DCMAKE_CXX_FLAGS_RELEASE="-O2"
	BUILD_OPT += -DCMAKE_C_FLAGS_RELEASE="  -O2"
	BUILD_INSTALL_CMD = ( make install )
	ifeq ($(TC),clang)
		BUILD_OPT += -C ../clang.cmake
	  # It has to be installed 'openmp' on MSys/MinGW.
    BUILD_OPT += -DCMAKE_C_FLAGS_RELEASE="-Wno-error"
    BUILD_OPT += -DCMAKE_C_FLAGS_RELEASE="--compile-no-warning-as-error"
		BUILD_OPT += -DCMAKE_C_FLAGS_RELEASE="-Wno-error=implicit-function-declaration"
	  # for c++
    BUILD_OPT += -DCMAKE_CXX_FLAGS_RELEASE="-Wno-error"
    BUILD_OPT += -DCMAKE_CXX_FLAGS_RELEASE="--compile-no-warning-as-error"
		BUILD_OPT += -DCMAKE_CXX_FLAGS_RELEASE="-Wno-error=implicit-function-declaration"
	else
		COPY_DLL1 = ( cp -f dll/32bit/libgcc_s_dw2-1.dll bin/  )
	endif
	COPY_DLL2 = (	cp -f dll/32bit/libsamplerate-0.dll bin/ )
endif

BUILD_DIR = build

.PHONY: copy_dll build clean $(INSTALL_DIR)

all: $(INSTALL_DIR) $(BUILD_DIR) copy_dll
	(cd $(BUILD_DIR); cmake ../anima $(BUILD_OPT) )
	(cd $(BUILD_DIR); $(BUILD_INSTALL_CMD) )
	-strip bin/*

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

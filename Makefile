#TC = clang
TC = gcc

# Must be abusolute path
INSTALL_DIR = $(abspath $(CURDIR))/bin
#
BUILD_OPT += -DLUAJIT_BIN=$(INSTALL_DIR)  # Install folder

BUILD_OPT += -G"MSYS Makefiles"

#BUILD_OPT += -DCMAKE_BUILD_TYPE=RelWithDebInfo
BUILD_OPT += -DCMAKE_BUILD_TYPE=Release
#BUILD_OPT += -DANIMA_BUILD_SDL=no
#BUILD_OPT += -DANIMA_BUILD_SNDFILE=no
#BUILD_OPT += -DANIMA_BUILD_RTAUDIO=no
#BUILD_OPT += -DANIMA_BUILD_IM=no

ifeq ($(TC),clang)
  BUILD_OPT += -C ../clang.cmake
else
  COPY_DLL1 = ( cp -f dll/32bit/libgcc_s_dw2-1.dll bin/  )
  COPY_DLL2 = (	cp -f dll/32bit/libsamplerate-0.dll bin/ )
endif

BUILD_DIR = build

.PHONY: copy_dll build clean $(INSTALL_DIR)

all: $(INSTALL_DIR) $(BUILD_DIR) copy_dll
	(cd $(BUILD_DIR); cmake ../anima $(BUILD_OPT)  ; make install)

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

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

BUILD_DIR = build

all: $(INSTALL_DIR) $(BUILD_DIR)
	(cd $(BUILD_DIR); cmake ../anima $(BUILD_OPT)  ; make install)
	cp -f dll/32bit/libgcc_s_dw2-1.dll bin/

$(INSTALL_DIR):
	-mkdir -p $@

build:
	-mkdir -p $@

clean:
	-rm -fr $(BUILD_DIR)
	-rm -fr $(INSTALL_DIR)

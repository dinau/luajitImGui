CPU_CORE_BITS = 64bit

# Compile ok MinGW gcc 14.2.0
TC ?= gcc

# Compile ok.
# Visual studio 2019 C/C++
#TC ?= msvc

# Compile ok  Clang version 18.1.8 MinGW
#TC ?= clang

# Must be abusolute path
INSTALL_DIR = $(abspath $(CURDIR))/bin
#
BUILD_OPT += -DLUAJIT_BIN=$(INSTALL_DIR)  # Install folder

# Select main options
#BUILD_OPT += -DCMAKE_BUILD_TYPE=RelWithDebInfo
BUILD_OPT += -DCMAKE_BUILD_TYPE=Release

# Select libraries
#BUILD_OPT += -DANIMA_BUILD_SDL=no
#BUILD_OPT += -DANIMA_BUILD_SNDFILE=no
#BUILD_OPT += -DANIMA_BUILD_RTAUDIO=no
#BUILD_OPT += -DANIMA_BUILD_IM=no

ifeq ($(TC),msvc)
	# Compile using build/anima.sln on Microsoft Visual Studio 2022 C/C++ IDE.
	#BUILD_INSTALL_CMD =  (msbuild.exe /m  build/anima.sln)
else
	BUILD_OPT += -G"MSYS Makefiles"
	BUILD_OPT += -DCMAKE_CXX_STANDARD=11
	BUILD_OPT += -DCMAKE_C_FLAGS_RELEASE="-O2"
	BUILD_OPT += -DCMAKE_CXX_FLAGS_RELEASE="-O2"
	BUILD_INSTALL_CMD = ( make install )
	ifeq ($(TC),clang)
		BUILD_OPT += -C ../clang.cmake
	endif
	  # It has to be installed 'openmp' on MSys/MinGW.
	BUILD_OPT += -DCMAKE_C_FLAGS_RELEASE="-Wno-error  \
							 -Wno-error=implicit-function-declaration \
							 -O2"
	# for C++
	BUILD_OPT += -DCMAKE_CXX_FLAGS_RELEASE="-Wno-error  \
							 -Wno-error=implicit-function-declaration \
							 -DIMGUI_ENABLE_WIN32_DEFAULT_IME_FUNCTIONS \
							 -DImDrawIdx=\"unsigned int\" \
							 -O2"
	COPY_DLL1 = (cp -f dll/$(CPU_CORE_BITS)/*.dll bin/)
	COPY_DLL2 = (cp -f dll/$(CPU_CORE_BITS)/luajitw/{lua51.dll,luajitw.exe} bin/)
endif

BUILD_DIR = build

.PHONY: copy_dll build clean $(INSTALL_DIR) update zip

all: clean $(INSTALL_DIR) $(BUILD_DIR)
	(cd $(BUILD_DIR); cmake ../anima $(BUILD_OPT) )
	(cd $(BUILD_DIR); $(BUILD_INSTALL_CMD) )
	$(COPY_DLL1)
	$(COPY_DLL2)
	-(cd examples/tools; nim make_bat.nims)
	@-strip bin/*

copy_dll:
	$(COPY_DLL1)
	$(COPY_DLL2)

$(INSTALL_DIR):
	-mkdir -p $@

build:
	-mkdir -p $@

clean:
	-rm -fr $(BUILD_DIR)
	-rm  bin/*.dll bin/*.exe
	-rm -fr bin/examples
	-rm -fr bin/lua/anima
	-rm -fr bin/lua/imgui
	-rm -fr bin/lua/IPOL
	-rm -fr bin/lua/jit
	-rm -fr bin/lua/lj-async

VER ?= 1.90.8.0
#VER ?= 1.89.9.8
GIT_DIR = .

REPO_NAME = $(CURDIR)
#OPT += -v
#OPT += --dry-run
OPT += --force-submodules

update:
	(cd anima;git pull --recurse-submodules)

zip:
	#(cd $(GIT_DIR);git checkout $(VER))
	git-archive-all $(OPT)   $(REPO_NAME)-v$(VER).zip
	#(cd $(GIT_DIR);git checkout main)


# git-archive-all --help
#  Usage: git-archive-all [-v] [-C BASE_REPO] [--prefix PREFIX]
#  [--no-export-ignore] [--force-submodules] [--include EXTRA1 ...]
#  [--dry-run] [-0 | ... | -9] OUTPUT_FILE
#
# Options:
#   --version             show program's version number and exit
#   -h, --help            show this help message and exit
#   --prefix=PREFIX       prepend PREFIX to each filename in the archive;
#                         defaults to OUTPUT_FILE name
#   -C BASE_REPO          use BASE_REPO as the main git repository to archive;
#                         defaults to the current directory when empty
#   -v, --verbose         enable verbose mode
#   --no-export-ignore, --no-exclude
#                         ignore the [-]export-ignore attribute in
#                         .gitattributes
#   --force-submodules    force `git submodule init && git submodule update` at
#                         each level before iterating submodules
#   --include=EXTRA, --extra=EXTRA
#                         additional files to include in the archive
#   --dry-run             show files to be archived without actually creating
#                         the archive

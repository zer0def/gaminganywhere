export CFLAGS = -fcommon
export FREETYPE_CONFIG = /usr/bin/pkg-config
GADEPS		?= $(HOME)/gaminganywhere/deps.posix
MACHINE		?= $(shell uname -m)
USE_SYSTEM_PACKAGES ?= 0
PARALLEL_MAKE	?= -j5
SYSTEM		= $(shell uname -s)
PACKAGES	= sdl2 sdl2_ttf yasm lame opus ogg vorbis theora vpx \
		  x264 x265 xvid ffmpeg live555
OSX_CLANG_PATCH	= echo '*** Not on OS X: not applied ***'

### package configurations for Mac
ifeq ($(SYSTEM),Darwin)
VPX_EXTRA_CONFIG =
HAS_BREW	?= $(shell if which -s brew; then echo 1; else echo 0; fi)
MACHINE		= $(shell uname -m)-apple-darwin
OSX_CLANG_PATCH = perl -p -i -e "s/-falign-loops=16//g" configure; \
		  perl -p -i -e "s/-fforce-addr//g"     configure
ifeq ($(HAS_BREW),1)
PACKAGES	= osx_brew live555
endif
else
VPX_EXTRA_CONFIG = --enable-shared
endif

### package configurations for Linux
ifeq ($(SYSTEM),Linux)
###### Ubuntu?
LINUXDIST	= $(shell grep '=Ubuntu' /etc/lsb-release | awk -F= '{print $$2}')
ifeq ($(LINUXDIST),Ubuntu)
PACKAGES	= linux_ubuntu x264 vpx x265 ffmpeg live555
endif
endif

include Makefile.packages

all: $(PACKAGES)

osx_brew:
	brew install sdl2 sdl2_ttf yasm lame opus libogg libvorbis theora \
		libvpx x264 x265 xvid
	brew install --with-libvorbis --with-libvpx --with-opus \
		--with-theora --with-x265 --with-tools ffmpeg

linux_ubuntu:
	@echo 'You will need root permissions to install packages'
	sudo apt-get install -y libsdl2-dev libsdl2-ttf-dev yasm \
			libmp3lame-dev libopus-dev libogg-dev \
			libvorbis-dev libtheora-dev \
			libvpx-dev libx264-dev libxvidcore-dev

sdl2:
	mkdir -p $(SDL2DIR)/mybuild
	cd $(SDL2DIR)/mybuild; ../configure --prefix=$(GADEPS) --with-pic
	make -C $(SDL2DIR)/mybuild $(PARALLEL_MAKE)
	make -C $(SDL2DIR)/mybuild install

sdl2_ttf:
	mkdir -p $(SDL2_TTFDIR)/mybuild
	cd $(SDL2_TTFDIR); touch NEWS README AUTHORS ChangeLog; autoreconf -vi
	cd $(SDL2_TTFDIR)/mybuild; ../configure --prefix=$(GADEPS) --with-pic
	make -C $(SDL2_TTFDIR)/mybuild $(PARALLEL_MAKE)
	make -C $(SDL2_TTFDIR)/mybuild install

yasm:
	cd $(YASMDIR); cmake -B "mybuild" -DCMAKE_INSTALL_PREFIX=$(GADEPS)
	make -C $(YASMDIR)/mybuild $(PARALLEL_MAKE)
	make -C $(YASMDIR)/mybuild install

lame:
	cd $(LAMEDIR); ./configure --prefix=$(GADEPS) --with-pic
	make -C $(LAMEDIR) $(PARALLEL_MAKE)
	make -C $(LAMEDIR) install

opus:
	cd $(OPUSDIR); ./autogen.sh; ./configure --prefix=$(GADEPS) --with-pic
	make -C $(OPUSDIR) $(PARALLEL_MAKE)
	make -C $(OPUSDIR) install

ogg:
	cd $(OGGDIR); ./autogen.sh; ./configure --prefix=$(GADEPS) --with-pic
	make -C $(OGGDIR) $(PARALLEL_MAKE)
	make -C $(OGGDIR) install

vorbis:
	cd $(VORBISDIR); ./autogen.sh; ./configure --prefix=$(GADEPS) --build=$(MACHINE) --with-pic
	make -C $(VORBISDIR) $(PARALLEL_MAKE)
	make -C $(VORBISDIR) install

theora:
	cd $(THEORADIR); $(OSX_CLANG_PATCH)
	cd $(THEORADIR); ./autogen.sh; ./configure --prefix=$(GADEPS) --with-pic --disable-examples
	make -C $(THEORADIR) $(PARALLEL_MAKE)
	make -C $(THEORADIR) install

vpx:
	cd $(VPXDIR); ./configure --prefix=$(GADEPS) $(VPX_EXTRA_CONFIG) --enable-pic
	make -C $(VPXDIR) $(PARALLEL_MAKE)
	make -C $(VPXDIR) install

x264:
	cd $(X264DIR); $(OSX_CLANG_PATCH)
	cd $(X264DIR); ./configure --prefix=$(GADEPS) --enable-shared --enable-pic --disable-asm
	make -C $(X264DIR) $(PARALLEL_MAKE)
	make -C $(X264DIR) install

x265:
	cd $(X265DIR)/build/linux; cmake \
		-D CMAKE_INSTALL_PREFIX:PATH=$(GADEPS) \
		-D CMAKE_CXX_FLAGS="-fPIC" -D CMAKE_C_FLAGS="-fPIC" \
		../../source/
	make -C $(X265DIR)/build/linux $(PARALLEL_MAKE)
	make -C $(X265DIR)/build/linux install

xvid:
	cd $(XVIDDIR)/build/generic; ./bootstrap.sh; ./configure --prefix=$(GADEPS)
	make -C $(XVIDDIR)/build/generic $(PARALLEL_MAKE)
	make -C $(XVIDDIR)/build/generic install

ffmpeg: sdl2 sdl2_ttf yasm lame opus ogg vorbis theora vpx  x264 x265 xvid
	# --enable-cuda --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp \

	cd $(FFMPEGDIR); ./configure --prefix=$(GADEPS) \
		--enable-shared --enable-pic \
		--enable-libmp3lame \
		--enable-libtheora --enable-libvorbis \
		--enable-libx264 --enable-libvpx \
		--enable-libx265 \
		--enable-libopus \
		--enable-libxvid \
		--enable-gpl --enable-nonfree --disable-outdev=sdl \
		--extra-cflags="-I$(GADEPS)/include -I/usr/local/cuda/include" \
		--extra-ldflags="-L$(GADEPS)/lib -L/usr/local/cuda/lib64"
	make -C $(FFMPEGDIR) $(PARALLEL_MAKE)
	make -C $(FFMPEGDIR) install

live555:
	# enable -fPIC for macosx and linux
	mv -f $(LIVE555DIR)/config.linux $(LIVE555DIR)/config.linux.old
	mv -f $(LIVE555DIR)/config.macosx $(LIVE555DIR)/config.macosx.old
	cat $(LIVE555DIR)/config.linux.old | sed -e 's,^COMPILE_OPTS.*$$,& -fPIC,' > $(LIVE555DIR)/config.linux
	cat $(LIVE555DIR)/config.macosx.old | sed -e 's,^COMPILE_OPTS.*$$,& -fPIC,' > $(LIVE555DIR)/config.macosx
	# need to apply the 4MB buffer patch?
	cd $(LIVE555DIR); cat ../patches/live555-* | patch -p1
	#
	cd $(LIVE555DIR); ./genMakefiles $(shell uname -s | tr A-Z a-z | sed -e 's,darwin,macosx,' -e 's,cygwin.*,cygwin,')
	make -C $(LIVE555DIR) $(PARALLEL_MAKE)
	-mkdir -p $(GADEPS)/lib
	find $(LIVE555DIR) -name '*.a' -exec cp -f {} $(GADEPS)/lib \;
	-mkdir -p $(GADEPS)/include/live555
	find $(LIVE555DIR) -name '*.hh' -exec cp -f {} $(GADEPS)/include/live555 \;
	cp -f $(LIVE555DIR)/groupsock/include/NetCommon.h $(GADEPS)/include/live555

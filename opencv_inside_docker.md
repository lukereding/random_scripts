## running opencv in a docker container

Download the docker image from [here](https://hub.docker.com/r/miiha/python-opencv-ffmpeg/) with

`https://hub.docker.com/r/miiha/python-opencv-ffmpeg/`

(optional) Once it's downloaded, I renamed `miiha/python-opencv-ffmpeg` to `cv` with

`docker rename miiha/python-opencv-ffmpeg cv`

I then `cd`ed into the directory containing the python code I wanted to run and the input files. I then ran

`docker run -it -v $(pwd):/home/ miiha/python-opencv-ffmpeg bash`

Breaking this down:

- run: to run the container
- -it: to make it an interactive session
- -v: mounts the current directory as the home directory in the container
- miiha/python-opencv-ffmpeg: the name of the image
- bash: a command. Leaving this out results in an iteractive python session that I can't seem to exit without exiting from the container.


Running this line should put you into the container at a command prompt. You should be able to `cd home` then `ls` to check and make sure there are some familiar-looking files in there. This directory is shared between your container and your host's filesystem.

I was then able to run my python code as I normally would.


In case this changes in the future, he's the Dockerfile you need to create the image without using `docker pull`:


```
FROM jjanzic/docker-python3-opencv


ENV         FFMPEG_VERSION=3.2.2 \
            FDKAAC_VERSION=0.1.4 \
            LAME_VERSION=3.99.5  \
            OGG_VERSION=1.3.2    \
            OPUS_VERSION=1.1.1   \
            THEORA_VERSION=1.1.1 \
            YASM_VERSION=1.3.0   \
            VORBIS_VERSION=1.3.5 \
            VPX_VERSION=1.6.0    \
            XVID_VERSION=1.3.4   \
            X265_VERSION=2.0     \
            X264_VERSION=20160826-2245-stable \
            PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
            SRC=/usr/local


RUN         buildDeps="autoconf \
                       automake \
                       cmake \
                       curl \
                       bzip2 \
                       g++ \
                       gcc \
                       git \
                       libtool \
                       make \
                       nasm \
                       perl \
                       pkg-config \
                       python \
                       libssl-dev \
                       yasm \
                       zlib1g-dev" && \
            export MAKEFLAGS="-j$(($(nproc) + 1))" && \
            apt-get -yqq update && \
            apt-get install -yq --no-install-recommends ${buildDeps} ca-certificates && \

            DIR=$(mktemp -d) && cd ${DIR} && \
## x264 http://www.videolan.org/developers/x264.html
            curl -sL https://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
            tar -jx --strip-components=1 && \
            ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-pic --enable-shared --disable-cli && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## x265 http://x265.org/
            curl -sL https://download.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz  | \
            tar -zx && \
            cd x265_${X265_VERSION}/build/linux && \
            ./multilib.sh && \
            make -C 8bit install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## libogg https://www.xiph.org/ogg/
            curl -sL http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz | \
            tar -zx --strip-components=1 && \
            ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --datarootdir=${DIR} && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## libopus https://www.opus-codec.org/
            curl -sL http://downloads.xiph.org/releases/opus/opus-${OPUS_VERSION}.tar.gz | \
            tar -zx --strip-components=1 && \
            autoreconf -fiv && \
            ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## libvorbis https://xiph.org/vorbis/
            curl -sL http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz | \
            tar -zx --strip-components=1 && \
            ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
            --disable-static --datadir="${DIR}" && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## libtheora http://www.theora.org/
            curl -sL http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.bz2 | \
            tar -jx --strip-components=1 && \
            ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
            --disable-static --datadir="${DIR}" && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## libvpx https://www.webmproject.org/code/
            curl -sL https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
            tar -zx --strip-components=1 && \
            ./configure --prefix="${SRC}" --enable-vp8 --enable-vp9 --enable-pic --disable-debug --disable-examples --disable-docs --disable-install-bins --enable-shared && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## libmp3lame http://lame.sourceforge.net/
            curl -sL https://downloads.sf.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | \
            tar -zx --strip-components=1 && \
            ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --enable-nasm --datarootdir="${DIR}" && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## xvid https://www.xvid.com/
            curl -sL http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz | \
            tar -zx && \
            cd xvidcore/build/generic && \
            ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --datadir="${DIR}" --disable-static --enable-shared && \
            make && \
            make install && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## fdk-aac https://github.com/mstorsjo/fdk-aac
            curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
            tar -zx --strip-components=1 && \
            autoreconf -fiv && \
            ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
            make && \
            make install && \
            make distclean && \
            rm -rf ${DIR} && \
            DIR=$(mktemp -d) && cd ${DIR} && \
## ffmpeg https://ffmpeg.org/
            curl -sL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | \
            tar -zx --strip-components=1 && \
            ./configure --prefix="${SRC}" \
            --extra-cflags="-I${SRC}/include" \
            --extra-ldflags="-L${SRC}/lib" \
            --bindir="${SRC}/bin" \
            --disable-doc \
            #--disable-static \
            #--enable-shared \
            --enable-static \
            --disable-shared \
            --disable-ffplay \
            --extra-libs=-ldl \
            --enable-version3 \
            --enable-libfdk_aac \
            --enable-libmp3lame \
            --enable-libopus \
            --enable-libtheora \
            --enable-libvorbis \
            --enable-libvpx \
            --enable-libx264 \
            --enable-libx265 \
            --enable-libxvid \
            --enable-gpl \
            --enable-avresample \
            --enable-postproc \
            --enable-nonfree \
            --disable-debug \
            --enable-small \
            --enable-openssl && \
            make && \
            make install && \
            make distclean && \
            hash -r && \
            cd tools && \
            make qt-faststart && \
            cp qt-faststart ${SRC}/bin && \
            rm -rf ${DIR} && \
## cleanup
            cd && \
            apt-get purge -y ${buildDeps} && \
            apt-get autoremove -y && \
            apt-get clean -y && \
            rm -rf /var/lib/apt/lists && \
            ffmpeg -buildconf
```

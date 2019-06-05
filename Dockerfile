FROM ruby:2.6.3

ENV FFMPEG_VERSION=3.3

WORKDIR ffmpeg_sources

RUN apt-get update -qq && apt-get -y --force-yes install \
  ca-certificates curl wget \
  autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev \
  libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev \
  yasm libx264-dev libmp3lame-dev libopus-dev \
  && wget http://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.bz2 \
  && tar xjvf ffmpeg-$FFMPEG_VERSION.tar.bz2

RUN  cd ffmpeg-$FFMPEG_VERSION \
  && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="/usr/local/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libx264 \
  --enable-nonfree \
  && PATH="/$HOME/bin:$PATH" make \
  && make install \
  && make distclean \
  && hash -r
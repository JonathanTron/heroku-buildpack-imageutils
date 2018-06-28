FROM heroku/heroku:16-build

ENV DEBIAN_FRONTEND noninteractive

COPY src/mozjpeg-3.2-release-source.tar.gz /tmp/
COPY src/libpng-1.6.34.tar.gz /tmp/
COPY src/pngquant-2.12.1 /tmp/pngquant/
COPY src/gifsicle-v1.91 /tmp/gifsicle/

RUN apt-get update \
  && apt-get install -y nasm \
  && rm -rf /var/lib/apt/lists/*

RUN \
  cd /tmp/ && \
  tar xvzf mozjpeg-3.2-release-source.tar.gz && \
  cd mozjpeg && \
  autoreconf -fiv && \
  mkdir build && \
  cd build && \
  ../configure --prefix=/app/vendor/imageutils && \
  make install

RUN \
  cd /tmp/pngquant && \
  tar xvzf ../libpng-1.6.34.tar.gz && \
  cd libpng-1.6.34 && \
  ./configure --enable-static && \
  make && \
  cd .. && \
  ./configure --prefix=/app/vendor/imageutils && \
  make install

RUN \
  cd /tmp/gifsicle && \
  ./bootstrap.sh && \
  ./configure --prefix=/app/vendor/imageutils && \
  make install

RUN \
  cd /app/vendor/imageutils && \
  rm -rf share && \
  tar zcf /tmp/imageutils.tar.gz .

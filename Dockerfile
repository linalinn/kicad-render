FROM ubuntu:24.04 as ubuntu-kicad

ARG DEBIAN_FRONTEND=noninteractive

ARG VERSION=no-version

ARG KICAD_PPA=kicad/kicad-9.0-releases

ARG KICAD_PACKAGE=kicad

ENV VERSION=$VERSION

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:${KICAD_PPA} && \
    apt-get install $KICAD_PACKAGE ffmpeg -y && \ 
    rm -rf /var/lib/apt/lists/*

FROM ubuntu-kicad

COPY *.sh /usr/bin/

RUN chmod +rx /usr/bin/render-pcb.sh && chmod +rx /usr/bin/kicad_animation.sh

WORKDIR /pwd
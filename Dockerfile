FROM kicad/kicad:nightly

RUN sudo apt update -y && \
    sudo apt install -y ffmpeg

ARG DEBIAN_FRONTEND=noninteractive

ARG VERSION=no-version

ENV VERSION=$VERSION

COPY *.sh /usr/bin/

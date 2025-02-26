FROM ghcr.io/linalinn/kicad:nightly-2024-04-09-13-16

COPY *.sh /usr/bin/

RUN chmod a+rx /usr/bin/render-pcb.sh && chmod a+rx /usr/bin/kicad_animation.sh

WORKDIR /pwd

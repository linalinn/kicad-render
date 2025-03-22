#!/bin/env bash
echo "#"
echo "# HI RUNNING PRE RENDERING SCRIPT"
echo "#"

echo "# INSTALLING MS FONTS"
echo "#"
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install ttf-mscorefonts-installer

KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS -p transparent"
KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS -z 2 transparent"

export KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS -b transparent"
export INPUT_PREFIX="prefix-via-pre-render"

#!/bin/env bash
echo "#"
echo "# HI RUNNING PRE RENDERING SCRIPT"
echo "#"

echo "# INSTALLING MS FONTS"
echo "#"
apt-get update --yes 
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get install --yes ttf-mscorefonts-installer

KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS -zoom 2"

export KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS"
export INPUT_PREFIX="prefix-via pre-render"

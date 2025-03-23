#!/bin/bash

set -e

help() {
    echo "Convert .kicad_pcb file to front and back image and optionaly render an animation"
    echo
    echo "Syntax: render-pcb.sh [-f|o|a|h]"
    echo "options:"
    echo "f     Path to .kicad_pcb file"
    echo "b     Image background. Options: transparent, opaque. Default: opaque for JPEG, transparent for PNG"
    echo "o     Directory where the images and optinally the animation should be written to."
    echo "p     Set a prefix for the images diffrent from project name"
    echo "a     Render animation and select animation output format (mp4 or gif)."
    echo "z     Camera zoom default 1"
    echo "v     Print protgram version"
    echo "h     Print this Help."
    echo
    exit
}

extract_project_name() {
  echo "$1" | rev | cut -d '/' -f 1 | rev | sed -e "s/.kicad_pcb//g"
}

extract_output_path() {
  echo "$1" | sed -e 's/[^\/]*\.kicad_pcb//g'
}

background="opaque"

while getopts :f:o:p:a:b:z:hv option
do
    case "${option}" in
        f) kicad_pcb=${OPTARG};;
        o) output_path=${OPTARG};;
        p) filename_prefix=${OPTARG};;
        a) animation=${OPTARG};;
        b) background=${OPTARG};;
        z) zoom=${OPTARG};;
        h) help;;
        v) echo "IMAGE version: ${VERSION:-none}" && exit;;
        \?)
            echo "Error: -${OPTARG} is invalid option"
            exit;
    esac
done

if [[ -z "$kicad_pcb" ]]; then
    help
fi

if [[ -z "$output_path" ]]; then
    path=$(extract_output_path "$2")
    extracted_project_name=$(extract_project_name "$2")
    name="${filename_prefix:-$extracted_project_name}"
    echo "name: $name"
    echo "path: $path"
    output_path="$path"
    output_top="${path}${name}_top.png"
    output_bottom="${path}${name}_bottom.png"
    echo "output_top: $output_top"
    echo "output_bottom: $output_bottom"
else
    if [[ -n "$filename_prefix" ]]; then
        output_top="$output_path/${filename_prefix}_top.png"
        output_bottom="$output_path/${filename_prefix}_bottom.png"
        output_animation="$output_path"
    else
        output_top="$output_path/top.png"
        output_bottom="$output_path/bottom.png"
        output_animation="$output_path"
    fi
fi


KICAD_CLI=$(which kicad-cli || which kicad-cli-nightly)

echo "$output_path"

mkdir -p "$output_path"


if [[ -n "$zoom" ]]; then
    KICAD_CLI_OPTIONAL_ARGS="$KICAD_CLI_OPTIONAL_ARGS --zoom $zoom"
fi

echo "rendering top"
# This is somewhat smart but also cursed
RENDER_TOP="$KICAD_CLI pcb render --side top --background $background -o \"$output_top\" $KICAD_CLI_OPTIONAL_ARGS \"$kicad_pcb\""
echo $RENDER_TOP
eval $RENDER_TOP
echo "rendering bottom"
# This is somewhat smart but also cursed
RENDER_BOTTOM="$KICAD_CLI pcb render --side bottom --background $background -o \"$output_bottom\" $KICAD_CLI_OPTIONAL_ARGS \"$kicad_pcb\""
echo $RENDER_TOP
eval $RENDER_TOP

if [[ -n "$animation" ]]; then
    echo "rendering animation"
    kicad_animation.sh $animation "$kicad_pcb" "$output_animation"
fi

ls "$output_path"

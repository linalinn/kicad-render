#!/bin/bash

help() {
    echo "Convert .kicad_pcb file to front and back image and optionaly render an animation"
    echo
    echo "Syntax: render-pcb.sh [-f|o|a|h]"
    echo "options:"
    echo "f     Path to .kicad_pcb file"
    echo "b     Image background. Options: transparent, opaque. Default: transparent for PNG, opaque for JPEG"
    echo "o     Directory where the images and optinally the animation should be written to."
    echo "a     Render animation and select animation output format (mp4 or gif)."
    echo "v     Print protgram version"
    echo "h     Print this Help."
    echo
    exit
}

output_path="/pwd"
background="transparent"

while getopts :f:o:a:b:hv option
do
    case "${option}" in
        f) kicad_pcb=${OPTARG};;
        o) output_path=${OPTARG};;
        a) animation=${OPTARG};;
        b) background=${OPTARG};;
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

if [[ -n "$animation" ]]; then
    if [ "$animation" != "gif" ] -a [[ "$animation" != "mp4" ]]; then
        help
    fi
fi



KICAD_CLI=$(which kicad-cli || which kicad-cli-nightly)

echo "$output_path"

mkdir -p "$output_path"
echo "rendering top"
$KICAD_CLI pcb render --side top --background $background -o "$output_path/top.png" "$kicad_pcb"
echo "rendering bottom"
$KICAD_CLI pcb render --side bottom --background $background -o "$output_path/bottom.png" "$kicad_pcb"

if [[ -n "$animation" ]]; then
    echo "rendering animation"
    kicad_animation.sh $animation "$kicad_pcb" "$output_path"
fi

ls "$output_path"
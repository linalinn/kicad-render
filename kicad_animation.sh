#!/bin/bash

# 
# Original by: arturo182
# gist: https://gist.github.com/arturo182/57ab066e6a4a36ee22979063e4d5cce1
#

extract_project_name() {
  echo "$1" | rev | cut -d '/' -f 1 | rev | sed -e "s/.kicad_pcb//g"
}

extract_output_path() {
  echo "$1" | sed -e "s/[^\/]*\.kicad_pcb//g"
}

OUTPUT_FILE=""

if [[ -z "$3" ]]; then
    path=$(extract_output_path "$2")
    name=$(extract_project_name "$2")
    OUTPUT_FILE="${path}${name}"
    echo "OUTPUT_FILE: $OUTPUT_FILE"
else
    OUTPUT_FILE="$3/rotating"
fi

FORMAT="$1"
OUTPUT_DIR="${3:-/pwd}"
FRAME_DIR="/tmp/render"
INPUT_FILE="$2"
ZOOM=0.7
WIDTH=300
HEIGHT=300
ROTATE_X=0
ROTATE_Z=45
ROTATION=360 # Total rotation angle
STEP=3 # Rotation step in degrees
FRAMERATE=30 # Framerate for the final video

KICAD_CLI=$(which kicad-cli || which kicad-cli-nightly)

mkdir -p $OUTPUT_DIR
mkdir -p $FRAME_DIR

let FRAMES=ROTATION/STEP
for ((i = 0; i < FRAMES; i++)); do
    ROTATE_Y=-$(($i * STEP))
    OUTPUT_PATH="$FRAME_DIR/frame$i.png"
    echo "Rendering frame $i ($ROTATE_Y degrees) to $OUTPUT_PATH"
    $KICAD_CLI pcb render --rotate "$ROTATE_X,$ROTATE_Y,$ROTATE_Z" --zoom $ZOOM -w $WIDTH -h $HEIGHT --background opaque -o $OUTPUT_PATH "$INPUT_FILE" > /dev/null
done

# Combine frames into an MP4 with the specified framerate
if [[ $FORMAT == "mp4" ]]; then
    echo "Combining frames into an MP4..."
    ffmpeg -y -framerate $FRAMERATE -i "$FRAME_DIR/frame%d.png" -c:v libx264 -r 30 -pix_fmt yuv420p "$OUTPUT_FILE.mp4"
    echo "MP4 created successfully."
elif [[ $FORMAT == "gif" ]]; then
    echo "Combining frames into an GIF..."
    ffmpeg -y -framerate $FRAMERATE -i "$FRAME_DIR/frame%d.png" "$OUTPUT_FILE.gif"
    echo "GIF created successfully."
else
    # TODO: this should be vaildated before rendering anything
    echo first argument must be mp4 or gif
fi

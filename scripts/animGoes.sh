#!/bin/bash

#Bash script to animate GOES satellite images downloaded by the
#getGoes.sh script

if [ $# -eq 1 ]
then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    echo Usage: animGoes.sh day source_directory destination_directory
    echo "day is the day in format %Y%j (j is day of year). YOu can get todays date with the command \`date +%Y%j\` or yesterdays date with the command \`date +%Y%j --date "-1 days"\`"
    exit 0
  fi
fi

if [ $# -ne 3 ]
then
  echo Incorrect number of parameters. Run animGoes.sh --help to see usage information
  exit 1
fi

DATE=$1
SOURCE=$2
DESTINATION=$3

#use ffmpeg to create the animation
#options are
# -y                           force overwrite of file if it exists
# -r 5                         display five images per second in a 5fps video
# -pattern_type glob           indicates the input file is actually a wildcarded glob
# -i "$SOURCE/$DATE*.jpg"      specify input files - note quotes are required to stop the shell expanding the wildcard
# -c:v mjpeg                   specify the video codec as mjpeg. Note libx264 seems to work well too
# -pix_fmt rgb24               8 bit per chanel rgb pixels
# $DESTINATION/$DATE.mp4       The last parameter with no dash is the output file
# note - could set -filter:v fps=25 to make this a 25fps video. It wouldn't reduce the duration it would just duplicate frames
ffmpeg -y -r 5 -pattern_type glob -i "$SOURCE/$DATE*.jpg" -c:v mjpeg -pix_fmt rgb24 $DESTINATION/$DATE.mp4



#!/bin/bash

#Bash script to crop GOES satellite images downloaded by the
#getGoes.sh script

if [ $# -eq 1 ]
then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    echo Usage: cropGoes.sh source_directory destination_directory
    exit 0
  fi
fi

if [ $# -ne 2 ]
then
  echo Incorrect number of parameters. Run getGoes.sh --help to see usage information
  exit 1
fi

SOURCE=$1
DESTINATION=$2

mkdir -p $DESTINATION

FULLSIZEFILES=`ls $SOURCE | grep 4000x4000.jpg`

for FULLSIZEFILE in $FULLSIZEFILES
do
  BASENAME=`basename "$FULLSIZEFILE" .jpg`
  CROPPEDFILE=$BASENAME-cropped.jpg
  LISTED=`ls "$DESTINATION" | grep $CROPPEDFILE`
  if [ "$LISTED" == "" ]
  then
    convert $SOURCE/$FULLSIZEFILE -crop 1500x1250+2500+2100 $DESTINATION/$CROPPEDFILE
  fi
done


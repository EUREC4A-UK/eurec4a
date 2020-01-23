#!/bin/bash

#Bash script to download and crop sets of GOES images
#basically combines all the grabbing of GOES data into
#one script

if [ $# -eq 1 ]
then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    echo Usage: allGoes.sh destination_directory
    exit 0
  fi
fi

if [ $# -ne 1 ]
then
  echo Incorrect number of parameters. Run getGoes.sh --help to see usage information
  exit 1
fi

DESTINATION=$1
SCRIPTDIRECTORY=`dirname $0`

$SCRIPTDIRECTORY/getGoes.sh GEOCOLOR $DESTINATION/GEOCOLOR
$SCRIPTDIRECTORY/cropGoes.sh $DESTINATION/GEOCOLOR $DESTINATION/GEOCOLOR/crop
$SCRIPTDIRECTORY/annotateGoes.sh $DESTINATION/GEOCOLOR/crop $DESTINATION/GEOCOLOR/crop/annotated


#!/bin/bash

#Bash script to download GOES data from the noaa web page
#If you hover over a link to an image you can get the prefix
#and postfix
#set start and end dates and destination then run the script
#at an appropriate interval using cron

if [ $# -eq 1 ]
then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    echo Usage: getGoes.sh product destination_directory
    echo product may be any of GEOCOLOR, AirMass, Sandwich, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16
    echo destination_directory is the location to save the images
    exit 0
  else
    echo Incorrect number of parameters. Run getGoes.sh --help to see usage information
    exit 1
  fi
fi

if [ $# -ne 2 ]
then
  echo Incorrect number of parameters. Run getGoes.sh --help to see usage information
  exit 1
fi


PRODUCT=$1
#PRODUCT=GEOCOLOR
PREFIX=https://cdn.star.nesdis.noaa.gov/GOES16/ABI/SECTOR/car/$PRODUCT/
POSTFIX=_GOES16-ABI-car-$PRODUCT-4000x4000
EXTENSION=jpg

#yyyyjjjhhmm jjj is day of year
START=20200140000
END=20210010000

DESTINATION=$2
#DESTINATION=$HOME/GOES




mkdir -p $DESTINATION
NOW=`date +%Y%j%H%M`

START_YEAR=$((START/10000000))
END_YEAR=$((END/10000000))

MINUTES='00 10 20 30 40 50'
HOURS='00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23'
DAYS=`seq -w 1 1 366`
YEARS=`seq -w $START_YEAR 1 $END_YEAR`

for YEAR in $YEARS
do
  for DAY in $DAYS
  do
    for HOUR in $HOURS
    do
      for MINUTE in $MINUTES
      do
        FILE=$YEAR$DAY$HOUR$MINUTE$POSTFIX.$EXTENSION
        TEMPFILE=$YEAR$DAY$HOUR$MINUTE$POSTFIX-temp.$EXTENSION
        #echo $FILE
        URL=$PREFIX$FILE
        if [ $YEAR$DAY$HOUR$MINUTE -gt $START ]
        then
          if [ $YEAR$DAY$HOUR$MINUTE -lt $NOW ]
          then
            LISTED=`ls "$DESTINATION" | grep $FILE`
            if [ "$LISTED" == "" ]
            then
              wget $URL -O "$DESTINATION/$TEMPFILE" && mv "$DESTINATION/$TEMPFILE" "$DESTINATION/$FILE"
              #echo $URL
              #if a download fails we end up with empty temp files - remove them
              rm -f "$DESTINATION/$TEMPFILE"
            fi
          fi
        fi
      done
    done
  done
done


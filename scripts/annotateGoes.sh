#!/bin/bash

#Bash script to annotate already cropped goes images
#annotateGoes.sh script

if [ $# -eq 1 ]
then
  if [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    echo Usage: annotateGoes.sh source_directory destination_directory
    exit 0
  fi
fi

if [ $# -ne 2 ]
then
  echo Incorrect number of parameters. Run annotateGoes.sh --help to see usage information
  exit 1
fi

SOURCE=$1
DESTINATION=$2

mkdir -p $DESTINATION

INPUTFILES=`ls $SOURCE | grep 4000x4000-cropped.jpg`

for INPUTFILE in $INPUTFILES
do
  BASENAME=`basename "$INPUTFILE" .jpg`
  OUTPUTFILE=$BASENAME-annotated.jpg
  LISTED=`ls "$DESTINATION" | grep $OUTPUTFILE`
  if [ "$LISTED" == "" ]
  then

    COMMAND="convert $SOURCE/$INPUTFILE"

    #ADD THE DATE AND TIME

    YEAR=`echo $INPUTFILE | cut -c1-4`
    DAY=`echo $INPUTFILE | cut -c5-7`
    HOUR=`echo $INPUTFILE | cut -c8-9`
    MINUTE=`echo $INPUTFILE | cut -c10-11`
    echo $YEAR $DAY $HOUR $MINUTE
    UTC=`date -d "$YEAR-01-01 +$DAY days -1 day $HOUR:$MINUTE" +%a\ %d\ %H:%M\ %Y\ UTC`
    LOCAL=`date -d "$YEAR-01-01 +$DAY days -1 day $HOUR:$MINUTE +4" +%a\ %d\ %H:%M\ %Y\ LOCAL`
    echo $UTC
    echo $LOCAL

    COMMAND="$COMMAND -fill red -stroke red -pointsize 50 -draw \"text 20,50 '$UTC'\" -draw \"text 20,100 '$LOCAL'\""


    #ADD the circle
    
    COMMAND="$COMMAND -fill none -stroke orange -draw \"ellipse 554,412 110,109 0,360\""

    #GENERATE THE GRID

    XPOINTS=(430 449 467 486 504 523 541 560 578 597 615 633 652 670 689)
    XMIN=430
    XMAX=689
    YPOINTS=(298 317 335 353 372 390 409 427 445 464 482 501 519 537)
    YMIN=298
    YMAX=537

    XTEXT=411
    YTEXT=555
    XLABELS=(N M L K J I H G F E D C B A)
    YLABELS=(13 12 11 10 9 8 7 6 5 4 3 2 1)

    COMMAND="$COMMAND -fill red -stroke red -pointsize 20"
    for XPOINT in ${XPOINTS[*]}
    do
      #echo $XPOINT
      COMMAND="$COMMAND -draw \"line $XPOINT,$YMIN $XPOINT,$YMAX\""
    done

    for YPOINT in ${YPOINTS[*]}
    do
      #echo $YPOINT 
      COMMAND="$COMMAND -draw \"line $XMIN,$YPOINT $XMAX,$YPOINT\""
    done

    for i in ${!XLABELS[*]}
    do
      COMMAND="$COMMAND -draw \"text ${XPOINTS[i]},$YTEXT '${XLABELS[i]}'\""
    done

    for i in ${!YLABELS[*]}
    do
      COMMAND="$COMMAND -draw \"text $XTEXT,${YPOINTS[i+1]} '${YLABELS[i]}'\""
    done


    COMMAND="$COMMAND $DESTINATION/$OUTPUTFILE"

    #I thought I could just put $COMMAND here to run the command, but
    #this doesn't work. Instead output the command to a script and run
    #it.
    echo $COMMAND > test.sh
    source test.sh


    #$COMMAND
    #convert $SOURCE/$INPUTFILE -fill red -stroke red -draw "line 0,0 1000,1000" $DESTINATION/$OUTPUTFILE
    #convert $SOURCE/$FULLSIZEFILE -crop 1500x1250+2500+2100 $DESTINATION/$CROPPEDFILE
  fi
done


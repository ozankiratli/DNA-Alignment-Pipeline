#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

IN=$1
VCDIR=$WD/vcready
TMPDIR=$WD/tmp
ID=`echo $IN | sed 's/\_sorted/ /g' | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
CLEAN=$TMPDIR/$ID"_clean.bam"
RGTAG=$TMPDIR/$ID"_RGTAG.bam"
MARKDUP=$TMPDIR/$ID"_md.bam"
VCREADY=$VCDIR/$ID".bam"

echo "Cleaning bam file"
echo " "
$PICARD CleanSam I=$IN O=$CLEAN
echo "Done!"
echo " "
echo "Adding Groups"
$PICARD AddOrReplaceReadGroups I=$CLEAN O=$RGTAG RGID=$ID RGLB=Hahn1 RGPL=Illumina RGPU= HahnLab RGSM=$ID VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true
echo " "
echo "Done!"
echo " "
echo "Marking Duplicates"
$PICARD MarkDuplicates I=$RGTAG O=$MARKDUP M=$TMPDIR/$ID.txt
echo " "
echo "Done!"
echo " "
echo "Fixing Mate Info"
$PICARD FixMateInformation I=$MARKDUP O=$VCREADY VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true ASSUME_SORTED=false 
echo " "
echo "Done!"
sleep 1

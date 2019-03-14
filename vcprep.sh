#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

IN=$1

ID=`echo $IN | sed 's/\_sorted/ /g' | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
CLEAN=$TMPDIR/$ID"_clean.bam"
RGTAG=$TMPDIR/$ID"_RGTAG.bam"
SORTED=$TMPDIR/$ID"_sorted.bam"
MARKDUP=$TMPDIR/$ID"_md.bam"
VCREADY=$VCREADYDIR/$ID".bam"

echo "Cleaning bam file"
echo " "
$PICARD CleanSam I=$IN O=$CLEAN
echo "Done!"
echo " "
echo "Adding Groups"
$PICARD AddOrReplaceReadGroups I=$CLEAN O=$RGTAG RGID=$ID $ADDGROUPOPTIONS1 RGSM=$ID $ADDGROUPOPTIONS2
echo " "
echo "Done!"
echo " "
echo "Sorting with Picard"
$PICARD SortSam I=$RGTAG O=$SORTED $PICARDSORTOPTIONS 
echo " "
echo "Done!"
echo " "
echo "Marking Duplicates"
$PICARD MarkDuplicates I=$SORTED O=$MARKDUP M=$TMPDIR/$ID.txt
echo " "
echo "Done!"
echo " "
echo "Fixing Mate Info"
$PICARD FixMateInformation I=$MARKDUP O=$VCREADY $FIXMATEOPTIONS 
echo " "
echo "Done!"

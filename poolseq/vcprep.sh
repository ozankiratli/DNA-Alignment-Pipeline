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

echo "Cleaning bam file: $ID"
$PICARD CleanSam I=$IN O=$CLEAN
wait
echo "Adding Groups: $ID"
$PICARD AddOrReplaceReadGroups I=$CLEAN O=$RGTAG RGID=$ID $ADDGROUPOPTIONS1 RGSM=$ID $ADDGROUPOPTIONS2
wait
rm $CLEAN
wait
echo "Sorting with Picard: $ID"
$PICARD SortSam I=$RGTAG O=$SORTED $PICARDSORTOPTIONS 
wait
rm $RGTAG
wait
echo "Marking Duplicates: $ID"
$PICARD MarkDuplicates I=$SORTED O=$MARKDUP M=$TMPDIR/$ID.txt
wait
rm $SORTED
wait
echo "Fixing Mate Info: $ID"
$PICARD FixMateInformation I=$MARKDUP O=$VCREADY $FIXMATEOPTIONS 
wait
rm $MARKDUP
wait

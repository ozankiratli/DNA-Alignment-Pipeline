#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

REPORTDIR=$REPORTSDIR/alignment

ID=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\.bam/ /g' | awk '{print $1}'`
OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\.bam/\_alignment\_report\.txt/g'`
BAM=$INPUT
REPORT=$TREPORTSDIR/$OUTPUT

echo "--------------------------------------------------------" > $REPORT
echo "Alignment Report For: $ID" >> $REPORT
echo "--------------------------------------------------------" >> $REPORT
$BAMTOOLS stats -in $BAM >> $REPORT
wait
echo " " >> $REPORT
echo " " >> $REPORT
echo " " >> $REPORT

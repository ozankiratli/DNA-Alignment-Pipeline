#!/bin/bash

source PROGRAMPATHS
source PARAMETERS

R1=$1
I1=$2
I2=$3

WD=`pwd`

REFDIR=$WD/Reference
SAMDIR=$WD/SAM
BAMDIR=$WD/BAM
SORTEDDIR=$WD/sorted
REPORTSDIR=$WD/reports/alignment

REFERENCE=$R1
INPUT1=$I1
INPUT2=$I2

OUTPUT=`echo $INPUT1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`
OUTPUT="out_$OUTPUT"
SAM=$SAMDIR/$OUTPUT.sam
BAM=$BAMDIR/$OUTPUT.bam
SORTED=$SORTEDDIR/$OUTPUT"_sorted.bam"
REPORT=$REPORTSDIR/$OUTPUT"_alignment_report.txt"
ID=`echo $I1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`


$BWA mem $BWAOPTIONS $REFERENCE $INPUT1 $INPUT2 > $SAM
$SAMTOOLS view -bS $SAM -o $BAM
$SAMTOOLS sort $BAM -o $SORTED
$SAMTOOLS index $SORTED
echo "--------------------------------------------------------" > $REPORT
echo "Alignment Report For: $ID" >> $REPORT
echo "--------------------------------------------------------" >> $REPORT
$BAMTOOLS stats -in $BAM >> $REPORT
echo " " >> $REPORT
echo " " >> $REPORT
echo " " >> $REPORT

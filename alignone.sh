#!/bin/bash

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES

R1=$1
DIR=$2
I1=$3
I2=$4

TSAMDIR=$SAMDIR/$DIR
TBAMDIR=$BAMDIR/$DIR
TSORTEDDIR=$SORTEDDIR/$DIR
TREPORTSDIR=$REPORTSDIR/alignment/$DIR

mkdir -p $TSAMDIR
mkdir -p $TBAMDIR
mkdir -p $TSORTEDDIR
mkdir -p $TREPORTSDIR

REFERENCE=$R1
INPUT1=$I1
INPUT2=$I2

OUTPUT=`echo $INPUT1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_R[0-9]_/ /g' | awk '{print $1}'`
SAM=$TSAMDIR/$OUTPUT.sam
BAM=$TBAMDIR/$OUTPUT.bam
SORTED=$TSORTEDDIR/$OUTPUT"_sorted.bam"
REPORT=$TREPORTSDIR/$OUTPUT"_alignment_report.txt"
ID=`echo $I1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_R[0-9]_/ /g' | awk '{print $1}'`

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

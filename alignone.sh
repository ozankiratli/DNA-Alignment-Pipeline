
#!/bin/bash

source PARAMETERS

R1=$1
I1=$2
I2=$3

WD=`pwd`
PICARD=/usr/local/bin/picard.jar

REFDIR=$WD/Reference
SAMDIR=$WD/SAM
BAMDIR=$WD/BAM
SORTEDDIR=$WD/sorted
REPORTSDIR=$WD/reports/alignment

THREADS=$BWATHREADS
BWA_T=30

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


bwa mem -t $BWAOPTIONS $REFERENCE $INPUT1 $INPUT2 > $SAM
samtools view -bS $SAM -o $BAM
samtools sort $BAM -o $SORTED
samtools index $SORTED
echo "--------------------------------------------------------" > $REPORT
echo "Alignment Report For: $ID" >> $REPORT
echo "--------------------------------------------------------" >> $REPORT
bamtools stats -in $BAM >> $REPORT
echo " " >> $REPORT
echo " " >> $REPORT
echo " " >> $REPORT

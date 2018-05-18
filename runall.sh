#!/bin/bash

R1=$1

WD=`pwd`
DATADIR=$WD/Data
TRIMDIR=$WD/trimmed
ANALYSISDIR=$WD
REFDIR=$WD/Reference

mkdir -p Reference
mkdir -p trimmed
mkdir -p unpaired
mkdir -p reports
mkdir -p SAM
mkdir -p BAM
mkdir -p sorted
mkdir -p reports/fastqc
mkdir -p reports/trim
mkdir -p reports/alignment


cp $R1 $REFDIR/
REF=`echo $R1 | sed 's/\// /g' | awk '{print $NF}'`
REFERENCE=$REFDIR/$REF
./buildref.sh $REFERENCE > reports/buildreference_report.txt
wait

LIST1=`ls $DATADIR/*_R1_*`
wait
for f1 in $LIST1 ; do
	ID=`echo $f1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`
	RAW1=$f1
	RAW2=`echo $f1 | sed 's/\_R1_/_R2_/g'`
	./trimone.sh $RAW1 $RAW2 > reports/trim/TrimReport_$ID.txt
	wait
done
wait


LIST2=`ls $TRIMDIR/*_R1_*`
for f2 in $LIST2 ; do
	INPUT1=$f2
	ID=`echo $f2 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`
	SEARCHSTR=$TRIMDIR/$ID"*_R2_*"
	INPUT2=`ls $SEARCHSTR`
	./alignone.sh $REFERENCE $INPUT1 $INPUT2
done

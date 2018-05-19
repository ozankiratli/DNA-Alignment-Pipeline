#!/bin/bash

WD=`pwd`

source PARAMETERS
R1=$REFERENCEFILE

Test1=`ls $R1`
if [ ! -f $Test1 ] ; then
	echo "Reference file not found! Check PARAMETERS file"
	exit 1
else
	echo "Reference file is: $R1"
fi

if [ -d $DATASOURCE  ] ; then
	DATAIN=$DATASOURCE
	echo "The data source  is set to: $DATAIN"
else
	echo "Data directory does not exist! Check PARAMETERS file"
	exit 1
fi

DATADIR=$WD/Data
if [[ $DATAIN -ef Data ]] ; then
	echo "No need to copy. Data is already in: $DATADIR"
else
	mkdir -p $DATADIR
	echo "Copying the files to $DATADIR"
	sudo cp $DATASOURCE/* $DATADIR/
	echo "Files are copied"
fi

TRIMDIR=$WD/trimmed
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

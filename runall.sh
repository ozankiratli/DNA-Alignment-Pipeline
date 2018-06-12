#!/bin/bash
echo "Starting script..."
sleep 2
echo " "

WD=`pwd`
TRIMDIR=$WD/trimmed
REFDIR=$WD/Reference
DATADIR=$WD/Data
SORTEDDIR=$WD/sorted

source PARAMETERS
source PROGRAMPATHS

R1=$REFERENCEFILE

echo "Checking REFERENCE file..."
sleep 1
Test1=`ls $R1`
if [ ! -f $Test1 ] ; then
	echo "Reference file not found! Check PARAMETERS file"
	exit 1
else
	echo "Reference file is: $R1"
	sleep 1
fi
echo " "

echo "Checking DATA files..."
sleep 1
if [ -d $DATASOURCE  ] ; then
	DATAIN=$DATASOURCE
	echo "The data source  is set to: $DATAIN"
	sleep 1
else
	echo "Data directory does not exist! Check PARAMETERS file"
	exit 1
fi

if [[ $DATAIN -ef Data ]] ; then
	echo "No need to copy. Data is already in: $DATADIR"
	sleep 1
else
	mkdir -p $DATADIR
	echo "Copying the files to $DATADIR..."
	sleep 1
	sudo cp $DATASOURCE/* $DATADIR/
	echo "Files are copied!"
	sleep 1
fi
echo " "

echo "Creating folders..."
mkdir -p Reference
mkdir -p trimmed
mkdir -p unpaired
mkdir -p reports
mkdir -p SAM
mkdir -p BAM
mkdir -p Consensus
mkdir -p Consensus/FASTQ
mkdir -p Consensus/FASTA
mkdir -p sorted
mkdir -p reports/fastqc
mkdir -p reports/trim
mkdir -p reports/alignment
echo "Folders created!"
sleep 1
echo " "
echo " "
echo "Building Reference..."
cp $R1 $REFDIR/
REF=`echo $R1 | sed 's/\// /g' | awk '{print $NF}'`
REFERENCE=$REFDIR/$REF
echo " "
echo "Running: ./buildref.sh $REFERENCE > reports/buildreference_report.txt"
./buildref.sh $REFERENCE
wait
echo " "
echo "Reference building script completed!"
sleep 1

echo " "
echo "Starting trimming..."
sleep 1
LIST1=`ls $DATADIR/*_R1_*`
wait
for f1 in $LIST1 ; do
	ID=`echo $f1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`
	RAW1=$f1
	RAW2=`echo $f1 | sed 's/\_R1_/_R2_/g'`
	echo "Running: ./trimone.sh $RAW1 $RAW2 > reports/trim/TrimReport_$ID.txt"
	sleep 1
	./trimone.sh $RAW1 $RAW2 > reports/trim/TrimReport_$ID.txt
	wait
	echo "Trimming $RAW1 and $RAW2 is done!"
	echo " "
	sleep 1
done
wait
echo "Trimming process is done!"
echo " "
echo " "
sleep 1
echo "Starting aligning..."
sleep 1
LIST2=`ls $TRIMDIR/*_R1_*`
for f2 in $LIST2 ; do
	INPUT1=$f2
	ID=`echo $f2 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`
	SEARCHSTR=$TRIMDIR/$ID"*_R2_*"
	INPUT2=`ls $SEARCHSTR`
	echo "Running: ./alignone.sh $REFERENCE $INPUT1 $INPUT2"
	./alignone.sh $REFERENCE $INPUT1 $INPUT2
	wait
	sleep 1
	echo " "
	echo " "
done
wait
echo "Aligning process is done!"
echo " "
echo " "
sleep 1

echo "Starting to build consensus sequences..."
echo " "
sleep 1
LIST3=`ls $SORTEDDIR/*.bam`
for f3 in $LIST3 ; do
	INPUT=$f3
	echo $INPUT
	echo "Running: ./consensusone.sh $REFERENCE $INPUT"
	./consensusone.sh $REFERENCE $INPUT
	wait
	sleep 1
	echo " "
done
wait
echo " "
echo "End of generating consensus sequences!"
echo " "
sleep 1

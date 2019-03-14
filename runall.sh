#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

echo "Starting script..."
echo " "
echo "Checking whether the required programs installed..."
source $WD/checkinstalled.sh
echo " "
CHECKPT1=`grep "not" $WD/checkinstalled.tmp`
if [ ! -z "$CHECKPT1" ]
then
	echo "Please install the missing programs or correct their paths in PROGRAMPATHS file"
	rm -f $WD/checkinstalled.tmp
	exit 1
else
	rm -f $WD/checkinstalled.tmp
fi

echo "Checking REFERENCE file..."
R1=$REFERENCEFILE
Test1=`ls $R1`
if [ -z "$Test1" ] ; then
	echo "Reference file not found! Check PARAMETERS file"
	exit 1
else
	echo "Reference file is: $R1"
fi
echo " "

echo "Checking DATA files..."
if [ -d $DATASOURCE  ] ; then
	DATAIN=$DATASOURCE
	echo "The data source  is set to: $DATAIN"
else
	echo "Data directory does not exist! Check PARAMETERS file"
	exit 1
fi

if [[ $DATAIN -ef Data ]] ; then
	echo "No need to copy. Data is already in: $DATADIR"
else
	mkdir -p $DATADIR
	echo "Copying the files to $DATADIR..."
	cp -r $DATASOURCE/* $DATADIR/
	echo "Files are copied!"
fi
echo " "

if [ $MERGE -eq 0 ] ; then
	DATADIRS="Data"
elif [ $MERGE -eq 1 ] ; then
	DATADIRS=`ls $DATADIR`
else
	echo "Please correct your paremeters file MERGE takes values either 0 or 1"
fi

echo "Creating folders..."
$WD/makedirectories.sh
echo "Folders created!"
echo " "

echo "Building Reference..."
cp $R1 $REFDIR/
REF=`echo $R1 | sed 's/\// /g' | awk '{print $NF}'`
REFERENCE=$REFDIR/$REF
$WD/buildref.sh $REFERENCE > $REPORTSDIR/buildreference_report.txt
wait
echo "Reference building is completed!"
echo " "

echo "Starting trimming..."
for dir in $DATADIRS ; do
	wait
	$WD/trimall.sh $dir > $REPORTSDIR/trim/TrimReport_$dir.txt
	wait
done
wait
echo "Trimming process is done!"
echo " "
echo " "

echo "Starting aligning..."
for dir in $DATADIRS ; do
	TRIMMEDDIR=$TRIMDIR/$dir
	LIST=`ls $TRIMMEDDIR`
	for file in $LIST ; do
		newfile=`echo $file | sed 's/_val_[0-9]//' `
		mv $TRIMMEDDIR/$file $TRIMMEDDIR/$newfile 2>/dev/null
	done
	wait
	FILE=$TRIMMEDDIR"/*_R1_*.fq.gz"
	$PARALLEL -j $THREADS $WD/alignone.sh $REFERENCE $dir {} {=s/_R1_/_R2_/=} ::: $FILE
	wait
done
wait
echo "Aligning process is done!"
echo " "
echo " "

echo "Starting merging..."
DIRTMP=`echo $DATADIRS | awk '{print $1}'`
DIRINDEX=$SORTEDDIR/$DIRTMP
LIST=`ls $DIRINDEX/*.bam`
for file in $LIST ; do
	LABEL=`echo $file | sed 's/\// /g' | awk '{print $NF}' |  sed 's/_/ /g' | awk '{print $1}'`
	BAMSTR=""
	for dir in $DATADIRS ; do
		TDIR=$SORTEDDIR/$dir
		TSTR=`ls $TDIR/$LABEL*.bam`
		BAMSTR="$BAMSTR $TSTR"
	done
	$WD/mergebams.sh $REFERENCE $BAMSTR 
done
wait
echo "Merging process is done!"
echo " "
echo " "

echo "Starting to preprocess for variant calling and building consensus..."
INPUT=$MERGEDDIR"/*.bam"
$PARALLEL -j $THREADS $WD/vcprep.sh {} ::: $INPUT
wait
echo "End of Preprocessing!"
echo " "

echo "Starting to build consensus files..."
echo " "
INPUT=$VCREADYDIR"/*.bam"
$PARALLEL -j $THREADS $WD/consensusone.sh $REFERENCE {} ::: $INPUT
wait
echo " "
echo "End of Building Consensus files!"
$WD/vcfcaller.sh $REFERENCE
echo "Done!"
echo " "
echo "Copying results to $RESULTSDIR ..."
$WD/copyresults.sh
echo "Done!"
echo " "
echo "End of script!"

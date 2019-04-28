#!/bin/bash

echo "Starting script..."
echo " "
source PROGRAMPATHS
source DIRECTORIES
echo "Calculating the number of cores needed for different programs..."
$WD/calculatecores.sh
echo " "
echo "CORES will be such that:"
cat CORES
echo " "
echo " "
source CORES
source PARAMETERS

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
wait

echo " "

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
wait

echo "Checking DATA files..."
if [ -d $DATASOURCE  ] ; then
	DATAIN=$DATASOURCE
	echo "The data source  is set to: $DATAIN"
else
	echo "Data directory does not exist! Check PARAMETERS file"
	exit 1
fi
wait

if [[ $DATAIN -ef Data ]] ; then
	echo "No need to copy. Data is already in: $DATADIR"
else
	mkdir -p $DATADIR
	echo "Copying the files to $DATADIR..."
	cp -r $DATASOURCE/* $DATADIR/
	echo "Files are copied!"
fi
echo " "
wait


echo "Creating folders..."
$WD/makedirectories.sh
echo "Folders created!"
echo " "
wait

echo "Building Reference..."
cp $R1 $REFDIR/
REF=`echo $R1 | sed 's/\// /g' | awk '{print $NF}'`
REFERENCE=$REFDIR/$REF
$WD/buildref.sh $REFERENCE > $REPORTSDIR/buildreference_report.txt
wait
echo "Reference building is completed!"
echo " "


echo "Starting trimming..."
wait
$WD/trimall.sh # > $REPORTSDIR/trim/TrimReport$dir.txt
wait
echo "Trimming process is done!"
echo " "
echo " "

echo "Starting aligning..."
TRIMMEDDIR=$TRIMDIR
LIST=`ls $TRIMMEDDIR`
for file in $LIST ; do
	newfile=`echo $file | sed 's/_val_[0-9]//' `
	echo "$file $newfile"
	mv $TRIMMEDDIR/$file $TRIMMEDDIR/$newfile 2>/dev/null
done
wait
FILE=$TRIMMEDDIR"/*_R1_*.fq.gz"
$PARALLEL -j $BWAJOBS $WD/alignone.sh $REFERENCE {} {=s/_R1_/_R2_/=} ::: $FILE
wait
echo "Aligning process is done!"
echo " "
echo " "


#echo "Starting to preprocess for variant calling and building consensus..."
#INPUT=$SORTEDDIR"/*.bam"
#$PARALLEL -j $JOBS $WD/vcprep.sh {} ::: $INPUT
#wait
#echo "End of Preprocessing!"
#echo " "

#echo "Starting to build consensus files..."
#echo " "
#INPUT=$VCREADYDIR"/*.bam"
#$PARALLEL -j $THREADS $WD/consensusone.sh $REFERENCE {} ::: $INPUT
#wait
#echo " "
#echo "End of Building Consensus files!"
#$WD/vcfcaller.sh $REFERENCE
#wait
#echo "Done!"
echo " "
echo "Copying results to $RESULTSDIR ..."
$WD/copyresults.sh
wait
echo "Done!"
echo " "
echo "End of script!"

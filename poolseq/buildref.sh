#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

REFERENCE=$1
REF=`echo $1 | sed 's/\./ /g'  | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
REFDICT=$REFDIR/$REF.dict

echo "Creating BWA index..."
CT=`( ls $REFDIR/*.bwt 2>/dev/null && ls $REFDIR/*.ann 2>/dev/null && ls $REFDIR/*.amb 2>/dev/null && ls $REFDIR/*.pac 2>/dev/null && ls $REFDIR/*.sa 2>/dev/null ) | wc -l`
if [ $CT -eq 5 ] ; then
	echo "Index files exist! No need to create the index again!"
else
	$BWA index -a bwtsw $REFERENCE
fi
wait
echo "Done!"
echo " "
echo "Creating samtools fai index..."
CT=`( ls $REFDIR/*.fai 2>/dev/null ) | wc -l`
if [ $CT -eq 1 ] ; then
	echo "Index file exists! No need to create the index again!"
else
	$SAMTOOLS faidx $REFERENCE
fi
wait
echo "Done!"
echo " "
echo "Creating picard reference dictionary..."
CT=`( ls $REFDIR/*.dict 2>/dev/null ) | wc -l`
if [ $CT -eq 1 ] ; then
	echo "Index file exists! No need to create the index again!"
else
	$PICARD CreateSequenceDictionary REFERENCE=$REFERENCE OUTPUT=$REFDICT
fi
wait
echo "Done!"

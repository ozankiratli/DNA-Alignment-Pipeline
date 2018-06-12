#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

REFDIR=$WD/Reference
REFERENCE=$1
REF=`echo $1 | sed 's/\./ /g'  | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
REFDICT=$REFDIR/$REF.dict

echo "Creating BWA index..."
sleep 1
$BWA index -a bwtsw $REFERENCE
echo " "
echo "Done!"
sleep 1
echo " "
echo "Creating samtools index..."
sleep 1
$SAMTOOLS faidx $REFERENCE
echo " "
echo "Done!"
sleep 1
echo " "
echo "Creating picard reference dictionary..."
sleep 1
$PICARD CreateSequenceDictionary REFERENCE=$REFERENCE OUTPUT=$REFDICT
echo " "
echo "Done!"
sleep 1

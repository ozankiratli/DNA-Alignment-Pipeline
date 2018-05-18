#!/bin/bash

R1=$1

WD=`pwd`
PICARD=/usr/local/bin/picard.jar

REFDIR=$WD/Reference
REFERENCE=$R1
REF=`echo $R1 | sed 's/\./ /g'  | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
REFDICT=$REFDIR/$REF.dict

bwa index -a bwtsw $REFERENCE
samtools faidx $REFERENCE
java -jar $PICARD CreateSequenceDictionary REFERENCE=$REFERENCE OUTPUT=$REFDICT

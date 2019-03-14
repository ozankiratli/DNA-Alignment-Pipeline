#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

REFERENCE=$1
I1=$2
INPUT=""
shift
if [ -z $1 ] ; then
	echo "No input to merge"
	exit 1
elif [ -z $2 ] ; then
	exit 1
fi

while test $# -gt 0 ; do
	INPUT="$INPUT $1"
	shift
done

LABEL=`echo $I1 | sed 's\\/\ \g' | awk '{print $NF}' | sed 's\_\ \g' | awk '{print $1"_"$2"_"$3}'`
STR="_merged.bam"
OUTPUT="$MERGEDDIR/$LABEL$STR"


$SAMTOOLS merge -f --reference $REFERENCE $OUTPUT $INPUT

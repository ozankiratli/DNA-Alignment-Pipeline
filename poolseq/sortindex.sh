#!/bin/bash

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

OUTPUT=`echo $INPUT | sed 's/\// /g' | awk '{print $NF}' | sed 's/\.bam/\_sorted.bam/g'`

BAM=$INPUT
SORTED=$SORTEDDIR/$OUTPUT

echo "Sorting $BAM ..."
$SAMTOOLS sort $BAM -o $SORTED
echo "Indexing $SORTED ..."
$SAMTOOLS index $SORTED

#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

DATADIR=$WD/Data

INPUT1=$1
INPUT2=$2

$TRIMGALORE $TRIMGALOREOPTIONS $INPUT1 $INPUT2
wait
mv *.zip reports/fastqc
mv *.html reports/fastqc
mv *.txt reports/trim
mv *_unpaired_* unpaired/
mv *val* trimmed/

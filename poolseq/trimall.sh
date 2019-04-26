#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

SOURCEDIR=$DATADIR
FILE="*_R1_*.fastq.gz"

mkdir -p $REPORTSDIR/fastqc
mkdir -p $REPORTSDIR/trim
mkdir -p $UNPAIREDDIR
mkdir -p $TRIMDIR
wait

$PARALLEL -j $THREADS $TRIMGALORE $TRIMGALOREOPTIONS {} {=s/_R1_/_R2_/=} ::: $SOURCEDIR/$FILE
wait
mv *.zip $REPORTSDIR/fastqc
mv *.html $REPORTSDIR/fastqc
mv *.txt $REPORTSDIR/trim
mv *_unpaired_* $UNPAIREDDIR
mv *val* $TRIMDIR
wait

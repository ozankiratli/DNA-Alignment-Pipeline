#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

DIR=$1
SOURCEDIR=$DATADIR/$DIR
FILE="*_R1_*.fastq.gz"

mkdir -p $REPORTSDIR/fastqc/$DIR
mkdir -p $REPORTSDIR/trim/$DIR
mkdir -p $UNPAIREDDIR/$DIR
mkdir -p $TRIMDIR/$DIR

$PARALLEL -j $THREADS $TRIMGALORE $TRIMGALOREOPTIONS {} {=s/_R1_/_R2_/=} ::: $SOURCEDIR/$FILE

wait
mv *.zip $REPORTSDIR/fastqc/$DIR
mv *.html $REPORTSDIR/fastqc/$DIR
mv *.txt $REPORTSDIR/trim/$DIR
mv *_unpaired_* $UNPAIREDDIR/$DIR
mv *val* $TRIMDIR/$DIR

#!/bin/bash

source DIRECTORIES
source PARAMETERS

mkdir -p $BAMDIR
mkdir -p $CONSENSUSDIR
mkdir -p $FADIR
mkdir -p $FQDIR
if [ $MERGE -eq 1 ] ; then
	mkdir -p $MERGEDDIR
fi
mkdir -p $REPORTSDIR
mkdir -p $REPORTSDIR/fastqc
mkdir -p $REPORTSDIR/trim
mkdir -p $REPORTSDIR/alignment
mkdir -p $REFDIR
mkdir -p $RESULTSDIR
mkdir -p $SAMDIR
mkdir -p $SORTEDDIR
mkdir -p $TMPDIR
mkdir -p $TRIMDIR
mkdir -p $UNPAIREDDIR
mkdir -p $VCREADYDIR
mkdir -p $VCFDIR
wait

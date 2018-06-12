#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

DATADIR=$WD/Data

INPUT1=$1
INPUT2=$2

sudo $TRIMGALORE $TRIMGALOREOPTIONS $INPUT1 $INPUT2
wait
sudo mv *.zip reports/fastqc
sudo mv *.html reports/fastqc
sudo mv *.txt reports/trim
sudo mv *_unpaired_* unpaired/
sudo mv *val* trimmed/

#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

I1=$1
I2=$2

WD=`pwd`
DATADIR=$WD/Data

INPUT1=$I1
INPUT2=$I2

ID=`echo $I1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`

sudo $TRIMGALORE $TRIMGALOREOPTIONS $INPUT1 $INPUT2
wait
sudo mv *.zip reports/fastqc
sudo mv *.html reports/fastqc
sudo mv *.txt reports/trim
sudo mv *_unpaired_* unpaired/
sudo mv *val* trimmed/

#!/bin/bash

I1=$1
I2=$2

WD=`pwd`
TRIMGALORE=trim_galore

DATADIR=$WD/Data

TRIMQUALITY=25
TRIMOPTIONS="--fastqc --nextera --paired -q $TRIMQUALITY --retain_unpaired"

INPUT1=$I1
INPUT2=$I2

ID=`echo $I1 | sed 's/\// /g' | awk '{print $NF}' | sed 's/\_L001_/ /g' | awk '{print $1}'`

sudo $TRIMGALORE $TRIMOPTIONS $INPUT1 $INPUT2
wait
sudo mv *.zip reports/fastqc
sudo mv *.html reports/fastqc
sudo mv *.txt reports/trim

sudo mv *_unpaired_* unpaired/
sudo mv *val* trimmed/

#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

REF=$1
IN=$2

VCFDIR=$WD/VCF
VCFFILE=$VCFDIR/output.vcf

echo "Creating VCF file..."
echo " "
$SAMTOOLS mpileup -uf $REF $IN | $BCFTOOLS call -Ov -o $VCFFILE --threads 2 -v -m
echo "Done!"
sleep 1
echo " "


#!/bin/bash

source PARAMETERS
source PROGRAMPATHS
source DIRECTORIES

REF=$1

VCFFILE=$VCFDIR/output.vcf

echo "Creating VCF file..."
echo " "

#$SAMTOOLS mpileup -uf $REF $IN | $BCFTOOLS call $VARCALLOPTIONS -o $VCFFILE
$FREEBAYES -f $REF $FREEBAYESOPTIONS $VCREADYDIR/*.bam > $VCFFILE
echo "Done!"
echo " "


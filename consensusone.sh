#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

REF=$1
IN=$2

FQDIR=$WD/Consensus/FASTQ
FADIR=$WD/Consensus/FASTA

ID=`echo $IN | sed 's/\_sorted/ /g' | awk '{print $1}' | sed 's/\// /g' | awk '{print $NF}'`
FQFILE=$FQDIR/$ID"_cns.fq"
FAFILE=$FADIR/$ID"_cns.fasta"

echo "Creating fastq consensus file..."
echo " "
$SAMTOOLS mpileup -uf $REF $IN | $BCFTOOLS call -c --ploidy $PLOIDY | $VCFUTILS vcf2fq > $FQFILE
echo "Done!"
echo " "
echo "Converting fastq to fasta file..."
$SEQTK seq -A $FQFILE > $FAFILE
echo "Done!"
echo " "
sleep 1

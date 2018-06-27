
#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

REF=$1
IN=$2

VCFDIR=$WD/VCF
VCFFILE=$VCFDIR/output.vcf

echo "Creating VCF file..."
echo " "
$SAMTOOLS mpileup -uf $REF $IN | $BCFTOOLS call $VARCALLOPTIONS -o $VCFFILE
#/usr/local/bin/freebayes/bin/freebayes -f ~/data/Dmel_mtDNA_ref_v6.fasta -k --pooled-discrete -m 30 --min-alternate-fraction 0.75 --min-alternate-count 2 *.bam >output.vcf
echo "Done!"
sleep 1
echo " "


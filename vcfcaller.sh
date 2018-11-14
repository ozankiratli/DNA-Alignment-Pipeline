
#!/bin/bash

source PARAMETERS
source PROGRAMPATHS

REF=$1
IN=$2

VCFDIR=$WD/VCF
VCFFILE=$VCFDIR/output.vcf

echo "Creating VCF file..."
echo " "

#$SAMTOOLS mpileup -uf $REF $IN | $BCFTOOLS call $VARCALLOPTIONS -o $VCFFILE
$FREEBAYES -f $REF $FREEBAYESOPTIONS $IN/*.bam > $VCFFILE
echo "Done!"
sleep 1
echo " "


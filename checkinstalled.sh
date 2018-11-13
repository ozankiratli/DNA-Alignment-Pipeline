#!/bin/bash

source PROGRAMPATHS

touch checkinstalled.tmp

JAVP=`$JAVA -version`
if [ -z "$JAVP" ]
then
	echo "java is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "java is installed" >> checkinstalled.tmp
fi

PICNP=`ls $PICARDP`
if [ -z "$PICNP" ]
then
	echo "picard.jar is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "picard.jar is installed" >> checkinstalled.tmp
fi

SAMP=`$SAMTOOLS --version`
if [ -z "$SAMP" ]
then
	echo "samtools is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "samtools is installed" >> checkinstalled.tmp
fi

BAMP=`$BAMTOOLS --version`
if [ -z "$BAMP" ]
then
	echo "bamtools is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "bamtools is installed" >> checkinstalled.tmp
fi

VUTP=`ls $VCFUTILS`
if [ -z "$VUTP" ]
then
	echo "vcfutils.pl is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "vcfutils.pl is installed" >> checkinstalled.tmp
fi

BCFP=`$BCFTOOLS -v`
if [ -z "$BCFP" ]
then
	echo "bcfools is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "bcftools is installed" >> checkinstalled.tmp
fi

SQTP=`$SEQTK 2>&1 | grep "Version"`
if [ -z "$SQTP" ]
then
	echo "seqtk is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "seqtk is installed" >> checkinstalled.tmp
fi

BWAP=`$BWA 2>&1 | grep "Version"`
if [ -z "$BWAP" ]
then
	echo "bwa is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "bwa is installed" >> checkinstalled.tmp
fi

TGLP=`$TRIMGALORE --version`
if [ -z "$TGLP" ]
then
	echo "trim_galore is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "trim_galore is installed" >> checkinstalled.tmp
fi

FBYP=`$FREEBAYES --version`
if [ -z "$FBYP" ]
then
	echo "freebayes is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
else
	echo "freebayes is installed" >> checkinstalled.tmp
fi

FQCP=`fastqc --version`
if [ ! -z "$FQCP" ]
then
	echo "fastqc is installed" >> checkinstalled.tmp
else
	FASTQCPATH=`echo $FASTQC | sed 's/fastqc/ /g'` 
	PATH=$PATH:$FASTQCPATH
	export PATH
	FQCP=`$FASTQC --version`
	if [ -z "$FQCP" ]
	then
		echo "fastqc is not installed or wrong path in PROGRAMPATHS file." >> checkinstalled.tmp
	fi
fi

cat checkinstalled.tmp

#!/bin/bash

THREADS=`grep THREADS= PARAMETERS | sed 's/=/ /' | awk '{print $2}'`
THREADS=$(($THREADS))

TMPCORES=$(( $THREADS/9 ))
if [ $TMPCORES -gt 0 ] ; then
	TRIMCORES=2
	TRIMJOBS=$TMPCORES
else
	TRIMCORES=1
	TRIMJOBS=$THREADS
fi


if [ $(( $THREADS/8 )) -gt 0 ] ; then
	BWACORES=8
	BWAJOBS=$(( $THREADS/8 ))
elif [ $(( $THREADS/4 )) -gt 0 ] ; then
	BWACORES=4
	BWAJOBS=$(( $THREADS/4 ))
elif [ $(( $THREADS/2 )) -gt 0 ] ; then
	BWACORES=2
	BWAJOBS=$(( $THREADS/2 ))
else
	BWACORES=1
	BWAJOBS=$THREADS
fi

echo "JOBS=$THREADS" > CORES
echo "TRIMCORES=$TRIMCORES" >> CORES 
echo "TRIMJOBS=$TRIMJOBS" >> CORES
echo "BWACORES=$BWACORES" >> CORES
echo "BWAJOBS=$BWAJOBS" >> CORES

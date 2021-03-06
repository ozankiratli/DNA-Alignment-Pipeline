#!/bin/bash 

INPUT=$1

source PROGRAMPATHS
source PARAMETERS
source DIRECTORIES
source CORES

case $TEMPFILES in 
	A)
		echo "Moving the folder $INPUT to $ARCHIVEDIR"
		mkdir -p $ARCHIVEDIR
		mv $INPUT $ARCHIVEDIR
		;;
	D)
		echo "Deleting the folder $INPUT"
		rm -r $INPUT
		;;
	K)
		echo "Keeping the folder $INPUT"
		;;
	*)
		echo Wrong parameter set for TEMPFILES in PARAMETERS file. Keeping the folder $INPUT. If you're getting this message and don't want to keep the folder, stop the script here and re-assign the value in your PARAMETERS file.
		;;

	esac

#!/bin/bash

mkdir -p Output
cp -r vcready Output/
cp -r VCF Output/
cp -r Consensus Output/
cp -r reports Output/

./resetanalysis.sh

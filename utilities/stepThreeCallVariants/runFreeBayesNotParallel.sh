#!/bin/bash
# run from within "repo" directory

EXPERIMENT=$1
SAMPLEID=$2
refFasta=$3
fastaIndex=$4
PLOIDY=$5

toolNAME=freebayes

inputFile="$EXPERIMENT/analyzed/$SAMPLEID/freebayes/$SAMPLEID.dupMarked.fixedHeader.bam"
outputFile="$EXPERIMENT/analyzed/$SAMPLEID/freebayes/$SAMPLEID.freebayes.test.vcf"

#numCPU=16
#fastaRegions="hg38.regions.100kb.tmp"

cmdToRun="freebayes -f $refFasta -p $PLOIDY -q 20 $inputFile > $outputFile"

JOURNAL=$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).$toolNAME.log
echo "Starting..." >> $JOURNAL
date >> $JOURNAL
echo "$cmdToRun" >> $JOURNAL
eval "$cmdToRun"
date >> $JOURNAL
echo "Done" >> $JOURNAL

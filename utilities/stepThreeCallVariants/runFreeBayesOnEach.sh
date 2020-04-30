#!/bin/bash
# run from within repo 

EXPERIMENT=$1
codeHomeDir=$2
refFasta=$3
fastaIndex=$4
PLOIDY=$5

CURRENTEXPNUMBER=1
CURRENTSAMPLENUMBER=1
for fileName in $EXPERIMENT/analyzed/* ; do
    echo "Working on sample $CURRENTSAMPLENUMBER of experiment $CURRENTEXPNUMBER"
    SAMPLEID=`basename "$fileName"`

    fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/runFreeBayes.sh $EXPERIMENT $SAMPLEID $refFasta $fastaIndex $PLOIDY"
    echo "$fullCmd"
    bsub -M "96000" -J "$EXPERIMENT.FreeBayes.$CURRENTSAMPLENUMBER" -o "$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).FreeBayes.bsub.stdout" -e "$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).FreeBayes.bsub.stderr" -n 8 "$fullCmd"
    echo ""

    CURRENTSAMPLENUMBER=$((CURRENTSAMPLENUMBER+1))
done
echo "Submitted all samples to FreeBayes"
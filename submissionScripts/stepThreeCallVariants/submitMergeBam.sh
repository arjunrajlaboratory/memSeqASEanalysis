#!/bin/bash
# run from within repo

if [[ ! -z "$1" ]]; then
    EXPERIMENT="$1"
fi

#Need to use samtools 1.1 or greater for this to preserve sample names

cmdToRun="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/mergeBam.sh $EXPERIMENT"

bsub -M "96000" -J "$EXPERIMENT.mergeBam" -o $EXPERIMENT/logs/mergeBam.out -e  $EXPERIMENT/logs/mergeBam.err $cmdToRun

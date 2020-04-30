#!/bin/bash
# run from within repo

if [[ ! -z "$1" ]]; then
    EXPERIMENT="$1"
fi

cmdToRun="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/mergeVCF.sh $EXPERIMENT"

bsub -M "64000" -J "$EXPERIMENT.mergeVCF.test" -o $EXPERIMENT/logs/mergeVCF.test.out -e  $EXPERIMENT/logs/mergeVCF.test.err $cmdToRun

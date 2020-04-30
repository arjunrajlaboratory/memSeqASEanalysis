#!/bin/bash
# run from within repo

if [[ ! -z "$1" ]]; then
    EXPERIMENT="$1"
fi

cmdToRun="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/replaceReadGroup.sh $EXPERIMENT"

bsub -M "96000" -J "$EXPERIMENT.replaceReadGroup" -o $EXPERIMENT/logs/replaceReadGroup.out -e  $EXPERIMENT/logs/replaceReadGroup.err $cmdToRun

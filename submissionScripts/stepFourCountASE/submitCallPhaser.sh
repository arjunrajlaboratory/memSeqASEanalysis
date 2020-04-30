#!/bin/bash
# run from within repo 
if [[ ! -z "$1" ]]; then
    VCF="$1"
fi

if [[ ! -z "$2" ]]; then
    phaserBlackList="$2"
fi

if [[ ! -z "$3" ]]; then
    haplotypeBlacklist="$3"
fi

if [ ! -d $EXPERIMENT/logs/stepFourCountASE ]; then
    mkdir $EXPERIMENT/logs/stepFourCountASE
fi

cmdToRun="python $codeHomeDir/memSeqASEanalysis/utilities/stepFourCountASE/callPhaser.py -e $EXPERIMENT -f $samplePrefix -v $VCF -b $phaserBlackList -H $haplotypeBlacklist $PHASERFLAGS"
echo "$cmdToRun"
eval "$cmdToRun"

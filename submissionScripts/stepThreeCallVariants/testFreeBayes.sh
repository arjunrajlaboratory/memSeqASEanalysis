#!/bin/bash
# run from within repo 

# SAMPLEID="WM989-12"

# fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/runFreeBayes.sh $EXPERIMENT $SAMPLEID $refFasta $fastaIndex $PLOIDY"

# bsub -M "64000" -n 16 -R "span[hosts=1]" -J "$EXPERIMENT.FreeBayes.test" -o "$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).FreeBayes.test.stdout" -e "$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).FreeBayes.test.stderr" "$fullCmd"

SAMPLEID="WM989-20"

fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/runFreeBayesNotParallel.sh $EXPERIMENT $SAMPLEID $refFasta $fastaIndex $PLOIDY"

bsub -M "64000" -J "$EXPERIMENT.FreeBayes.test" -o "$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).FreeBayes.test.stdout" -e "$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).FreeBayes.test.stderr" "$fullCmd"

# echo "$cmdToRun"
# eval "$cmdToRun"
# echo "done submitting star jobs, wait until all jobs are complete before proceeding to the next step. use the bjobs command to monitor their progress."


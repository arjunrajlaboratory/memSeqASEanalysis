#!/bin/bash
# run from within repo 

cmdToRun="$codeHomeDir/memSeqASEanalysis/utilities/stepThreeCallVariants/runFreeBayesOnEach.sh $EXPERIMENT $codeHomeDir $refFasta $fastaIndex $PLOIDY"

echo "$cmdToRun"
eval "$cmdToRun"
echo "done submitting free-bayes jobs, wait until all jobs are complete before proceeding to the next step. use the bjobs command to monitor their progress."


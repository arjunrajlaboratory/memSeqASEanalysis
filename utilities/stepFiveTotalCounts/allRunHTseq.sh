#!/bin/bash
# run from within "repo" directory

EXPERIMENT=$1
codeHomeDir=$2
gtfFile=$3
ALIGNMENT_TOOL_NAME=star


allSamplePaths=( ${EXPERIMENT}/analyzed/* )
thisSampleNumber=$((LSB_JOBINDEX-1))
thisSamplePath=${allSamplePaths[$thisSampleNumber]}
sampleID=`basename "$thisSamplePath"`

echo "... running HTSeq"
fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepFiveTotalCounts/runHTSeq.sh $EXPERIMENT $sampleID $gtfFile"
eval "$fullCmd"

# echo "... removing temporary Sams/bams prepared for HTSeq"
# fullCmd="$codeHomeDir/rajlabseqtools/Utilities/stepThreeGenerateCounts/teardownSamForHTSeq.sh $EXPERIMENT $sampleID"
# eval "$fullCmd"
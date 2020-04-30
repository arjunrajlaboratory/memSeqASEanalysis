#!/bin/bash
# run from within "repo" directory

EXPERIMENT=$1
codeHomeDir=$2
PROJECT=$3
ALIGNMENT_TOOL_NAME=star


allSamplePaths=( ${EXPERIMENT}/analyzed/* )
thisSampleNumber=$((LSB_JOBINDEX-1))
thisSamplePath=${allSamplePaths[$thisSampleNumber]}
sampleID=`basename "$thisSamplePath"`

#This section removes multi-mapped reads.
echo "Starting ..."
fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepTwoPrepareAlignments/keepUniquelyMappedBam.sh \
    $EXPERIMENT $sampleID"
echo "$fullCmd"
eval "$fullCmd"
echo "Done ..."

#This section runs fixmate and marks duplicate reads.
echo "Starting ..."
fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepTwoPrepareAlignments/markDuplicates.sh \
    $EXPERIMENT $sampleID star"
echo "$fullCmd"
eval "$fullCmd"
echo "Done ..."

# This adds read group header to the bam files
echo "Starting ..."
fullCmd="$codeHomeDir/memSeqASEanalysis/utilities/stepTwoPrepareAlignments/addReadGroups.sh \
    $EXPERIMENT $sampleID"
echo "$fullCmd"
eval "$fullCmd"
echo "Done ..."
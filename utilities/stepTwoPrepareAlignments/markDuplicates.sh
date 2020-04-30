#!/bin/bash
# run from within "repo" directory

EXPERIMENT=$1
SAMPLEID=$2

ALIGNMENT_TOOL_NAME=star

if [[ ! -z "$3" ]]; then
    ALIGNMENT_TOOL_NAME="$3"
fi

commandName=markDuplicates

if [ ! -d $EXPERIMENT/analyzed/$SAMPLEID/log ]; then
    mkdir $EXPERIMENT/analyzed/$SAMPLEID/log
fi
JOURNAL=$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).$commandName.log


# if [ ! -d $EXPERIMENT/analyzed/$SAMPLEID/freebayes ]; then
#     mkdir $EXPERIMENT/analyzed/$SAMPLEID/freebayes
# fi

#Need to name sort then fix mate reads before marking duplicates with samtools. 
readNameSortCmd="samtools sort -n \
    $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.sorted.mapped.unique.bam \
    $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.nameSorted"

fixMateCmd="samtools fixmate \
    $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.nameSorted.bam \
    $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.nameSorted.mateFixed.bam"

#Need to sort back to position order before marking duplicates
coordSortCmd="samtools sort \
    $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.nameSorted.mateFixed.bam \
    $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.coordSorted.mateFixed"

markDuplicates="MarkDuplicates \
    I=$EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.coordSorted.mateFixed.bam \
    O=$EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.dupMarked.bam \
    M=$EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.markdup_metrics.txt"

echo "Starting..." >> $JOURNAL
date >> $JOURNAL
echo "$readNameSortCmd" >> $JOURNAL
eval "$readNameSortCmd"
echo "$fixMateCmd" >> $JOURNAL
eval "$fixMateCmd"
echo "$coordSortCmd" >> $JOURNAL
eval "$coordSortCmd"
echo "$markDuplicates" >> $JOURNAL
eval "$markDuplicates"
date >> $JOURNAL
echo "Done" >> $JOURNAL

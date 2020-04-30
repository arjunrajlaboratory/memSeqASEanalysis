#!/bin/bash
# run from within "repo" directory

EXPERIMENT=$1
samplePrefix=$2

ALIGNMENT_TOOL_NAME=star

if [[ ! -z "$3" ]]; then
    ALIGNMENT_TOOL_NAME="$3"
fi

commandName=mergeBam

JOURNAL=$EXPERIMENT/logs/$(date +%Y-%m-%d_%H-%M).$commandName.log

#Need to name sort then fix mate reads before marking duplicates with samtools. 
mergeBamCmd="samtools merge \
    $EXPERIMENT/$EXPERIMENT.star.combined.bam \
    $EXPERIMENT/analyzed/$samplePrefix*/$ALIGNMENT_TOOL_NAME/*.dupMarked.fixedHeader.bam"

indexBam="samtools index $EXPERIMENT/$EXPERIMENT.star.combined.bam"

echo "Starting..." >> $JOURNAL
date >> $JOURNAL
echo "$mergeBamCmd" >> $JOURNAL
eval "$mergeBamCmd"
echo "$indexBam" >> $JOURNAL
eval "$indexBam"

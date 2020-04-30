#!
# run from within "repo" directory

EXPERIMENT=$1
SAMPLEID=$2

ALIGNMENT_TOOL_NAME=star

if [[ ! -z "$3" ]]; then
    ALIGNMENT_TOOL_NAME="$3"
fi

commandName=addReadGroups

if [ ! -d $EXPERIMENT/analyzed/$SAMPLEID/log ]; then
    mkdir $EXPERIMENT/analyzed/$SAMPLEID/log
fi

JOURNAL=$EXPERIMENT/analyzed/$SAMPLEID/log/$(date +%Y-%m-%d_%H-%M).$commandName.log

#Add read groups to bam files in order to perform joint variant calling. Note that setting the read group ID to the experiment name since assuming all the samples
#Come from the same cell line for which we are trying to call variants.
addReadGroups="AddOrReplaceReadGroups \
	I=$EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.dupMarked.bam \
	O=$EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.dupMarked.fixedHeader.bam \
	RGID=$EXPERIMENT \
	RGLB=$EXPERIMENT \
	RGPL=illumina \
    RGPU=unit1 \
    RGSM=$SAMPLEID"

indexBam="samtools index $EXPERIMENT/analyzed/$SAMPLEID/$ALIGNMENT_TOOL_NAME/$SAMPLEID.dupMarked.fixedHeader.bam"

echo "Starting..." >> $JOURNAL
date >> $JOURNAL
echo "$addReadGroups" >> $JOURNAL
eval "$addReadGroups"
echo "$indexBam" >> $JOURNAL
eval "$indexBam"
date >> $JOURNAL
echo "Done" >> $JOURNAL

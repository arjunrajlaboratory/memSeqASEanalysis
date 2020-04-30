#!
# run from within "repo" directory

EXPERIMENT=$1

ALIGNMENT_TOOL_NAME=star

if [[ ! -z "$2" ]]; then
    ALIGNMENT_TOOL_NAME="$2"
fi

commandName=replaceReadGroup

JOURNAL=$EXPERIMENT/logs/$(date +%Y-%m-%d_%H-%M).$commandName.log

#Replace read group information with the same tags to be treated as a single sample by freebayes/GATK
replaceReadGroup="AddOrReplaceReadGroups \
	I=$EXPERIMENT/$EXPERIMENT.$ALIGNMENT_TOOL_NAME.combined.bam \
	O=$EXPERIMENT/$EXPERIMENT.$ALIGNMENT_TOOL_NAME.combined.singleRG.bam \
	RGID=$EXPERIMENT \
	RGLB=$EXPERIMENT \
	RGPL=illumina \
    RGPU=unit1 \
    RGSM=$EXPERIMENT"

indexBam="samtools index $EXPERIMENT/$EXPERIMENT.$ALIGNMENT_TOOL_NAME.combined.singleRG.bam"

echo "Starting..." >> $JOURNAL
date >> $JOURNAL
echo "$replaceReadGroup" >> $JOURNAL
eval "$replaceReadGroup"
echo "$indexBam" >> $JOURNAL
eval "$indexBam"
date >> $JOURNAL
echo "Done" >> $JOURNAL

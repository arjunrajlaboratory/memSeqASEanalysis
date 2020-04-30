#!/bin/bash
# run from within "repo" directory

EXPERIMENT=$1
PREFIX=$2
freebayesDir=freebayes

if [[ ! -z "$3" ]]; then
    freebayesDir="$3"
fi

commandName=mergeVCF

JOURNAL=$EXPERIMENT/logs/$(date +%Y-%m-%d_%H-%M).$commandName.log

# Concatanate VCF files from different chromosomes. 
catVCF="bcftools concat -o $EXPERIMENT/$freebayesDir/$PREFIX.freebayes.vcf $EXPERIMENT/$freebayesDir/$PREFIX.chr*.freebayes.vcf"
#Sort VCF files
sortVCF="bcftools sort -o $EXPERIMENT/$freebayesDir/$PREFIX.freebayes.sorted.vcf $EXPERIMENT/$freebayesDir/$PREFIX.freebayes.vcf"
#Compress
compressVCF="bgzip -c $EXPERIMENT/$freebayesDir/$PREFIX.freebayes.sorted.vcf > $EXPERIMENT/$freebayesDir/$PREFIX.freebayes.sorted.vcf.gz"
#Index VCF file
indexVCF="bcftools index --tbi $EXPERIMENT/$freebayesDir/$PREFIX.freebayes.sorted.vcf.gz"

echo "Starting..." >> $JOURNAL
date >> $JOURNAL
echo "$catVCF" >> $JOURNAL
eval "$catVCF"
echo "$sortVCF" >> $JOURNAL
eval "$sortVCF"
echo "$compressVCF" >> $JOURNAL
eval "$compressVCF"
echo "$indexVCF" >> $JOURNAL
eval "$indexVCF"

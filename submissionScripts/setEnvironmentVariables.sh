#!/bin/bash
# run this script before running any submission scripts!
# this script allows you to use samtools, ngstools, etc.

## Do not change this section of code unless you want to change software versions!
# within an interactive node (type "bsub -Is bash" to get to one), 
# you can see the list of available software versions by typing "module avail"
module load FastQC-0.11.2
module load samtools-1.1
module load ngsutils-0.5.7
module load STAR/2.7.1a
module load picard/1.96
#conda activate py27 #This is my conda environment that has freebayes installed.                              

STARFLAGS="--readFilesCommand zcat --twopassMode Basic --outSAMtype BAM SortedByCoordinate"
genomeDirSTAR="/project/arjunrajlab/refs/STAR/hg38"    # This file contains an index used by the STAR aligner. Change the index if you're not using the hg38 reference genome. For hg19, use /home/apps/STAR/indexes/hg19
gtfFile="/project/arjunrajlab/refs/hg38/hg38.gtf"      # This file contains transcript information for hg38 genes. Change it to a different file for a different reference genome. For hg19, use /project/arjunrajlab/resources/htseq/hg19/hg19.gtf
refFasta="/project/arjunrajlab/refs/hg38/hg38.fa"
fastaIndex="/project/arjunrajlab/refs/hg38/hg38.fa.fai"
refChrName="/project/arjunrajlab/refs/STAR/hg38/chrName.txt"
PLOIDY=2
PHASERFLAGS="-a star -o Q30_DP5_Het_intersect -t 4 -p 0 --pass_only 0 --unphased_vars 1 --sample WM983b"
phaserBlackList="/project/arjunrajlab/memSeqASEanalysis/repo/refs/hg38_hla.bed"
haplotypeBlacklist="/project/arjunrajlab/memSeqASEanalysis/repo/refs/hg38_haplo_count_blacklist.bed"
#######################

## Update these variables below to your project name, experiment name, number of samples,
#  code home directory (where your "rajlabseqtools/Utilities" folder is. if it's in your
#  home directory (e.g. /home/esanford), you can leave the "~" symbol)
PROJECT="memSeqASEanalysis"
EXPERIMENT="WM983b"
samplePrefix="983B"
RAWDATA_DIRECTORY="/home/bemert/memSeqASErawData/WM983b"
N_SAMPLES=48
PAIRED_OR_SINGLE_END_FRAGMENTS="single"  # this variable must be "single" or "paired". change to "paired" if your reads... are paired.
codeHomeDir=~                            # "~" is a shortcut for your home directory. alternatively you can use /home/<YOUR_PMACS_USERNAME>
VCF="/project/arjunrajlab/memSeqASEanalysis/repo/WM983b/freebayes/WM983b.singleRG.freebayes.filtered.Q30.DP5.het.intersect/0002.vcf.gz"

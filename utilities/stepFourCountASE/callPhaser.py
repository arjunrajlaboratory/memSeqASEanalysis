#Script to call phAser on each sample in your Experiment. Run from repo directory
import os, subprocess
from argparse import ArgumentParser
import glob
from datetime import datetime
import regex as re

#Command line parser
parser = ArgumentParser()
parser.add_argument("-e", "--experiment", help = "Specify experiment directory", type = str)
parser.add_argument("-f", "--prefix", help = "Specify sample prefix", type = str)
parser.add_argument("-a", "--aligner", help = "Specify aligner. default is star", type = str, default = 'star')
parser.add_argument("-v", "--vcf", help = "Specify the input vcf file. Should be bgzipped and indexed", type = str, default=None)
parser.add_argument("-s", "--sample", help = "From phASER: Name of sample to use in VCF file.", type = str, default = None)
parser.add_argument("-b", "--blacklist", help = "From phASER: list of sites to blacklist from phasing (.bed file)", type = str, default = None)
parser.add_argument("-H", "--haploBlacklist", help = "From phASER: list of sites to blacklist when generating allelic counts. These are sites that we have previously identified as having mapping bias", type = str, default = None)
parser.add_argument("-m", "--mapq", help = "From phASER: minimum mapping quality of reads to use for phasing and ASE. Default is 255 (uniquely mapped by star)", type = str, default = "255")
parser.add_argument("-q", "--baseq", help = "From phASER: minimum base quality at the heterozygous SNP for a read to be used. Default is 20", type = str, default = "20")
parser.add_argument("-p", "--paired", help = "Specify whether reads come from single (0) or paired-end (1) experiment. Default is 0", type = str, default = "0")
parser.add_argument("-o", "--outDir", help = "If you plan to run phaser with different VCF files, specify a subdirectory to save results from this analysis. Default is just sampleName/phaser/", type = str, default = None)
parser.add_argument("-t", "--threads", help = "Specify the number of threads. Default is 4.", type = str, default = '4')
parser.add_argument("--pass_only", help = "From phASER: Only use variants labled with PASS in the VCF filter field (0,1) the number of threads. Default is 0", type = str, default = '0')
parser.add_argument("--unphased_vars", help = "From phASER: Output unphased variants (singletons) in the haplotypic_counts and haplotypes files (0,1). Default is 1", type = str, default = '1')
args = parser.parse_args()

phaserPath = '~/code/phaser/phaser/phaser.py'

logFilesPath = os.path.join(args.experiment,'logs/stepFourCountASE')

if not os.path.exists(logFilesPath):
	os.makedirs(logFilesPath)

#Get list of alignments
alignments = glob.glob("{}/analyzed/{}*/{}/*.dupMarked.fixedHeader.bam".format(args.experiment, args.prefix, args.aligner))
print alignments

additionalArguments =["--paired_end", args.paired, "--baseq", args.baseq, "--mapq", args.mapq, '--threads', args.threads, "--pass_only", args.pass_only, "--unphased_vars", args.unphased_vars] 

if args.blacklist is None:
	additionalArguments.extend(["--sample", args.experiment])
else:
	additionalArguments.extend(["--sample", args.sample])

if args.blacklist is not None:
	additionalArguments.extend(["--blacklist", args.blacklist])

if args.haploBlacklist is not None:
	additionalArguments.extend(["--haplo_count_blacklist", args.haploBlacklist])

journalPath = os.path.join(args.experiment, "logs", "callPhaser")
if not os.path.exists(journalPath):
	os.makedirs(journalPath)

now = datetime.now()
journal = os.path.join(journalPath, "{}.callPhaser.log".format(now.strftime("%Y-%m-%d_%H-%M")))
regexSample = re.compile('{}[-a-zA-Z0-9]+[-A-Z0-9-0-9]*'.format(args.prefix))

with open(journal, 'w') as out:
	for i, sample in enumerate(alignments):
		print sample
		sampleName = regexSample.search(os.path.basename(sample)).group()
		print sampleName
		if args.outDir is not None:
			outpath = os.path.join(args.experiment, "analyzed", sampleName, "phaser", args.outDir)
		else:
			outpath = os.path.join(args.experiment, "analyzed", sampleName, "phaser")
		if not os.path.exists(outpath):
			os.makedirs(outpath)
		command = ["bsub", "-M", "96000", "-J", "phaser.{}".format(sampleName), "-o", "{}/{}.phaser.stdout".format(logFilesPath, sampleName), "-e", "{}/{}.phaser.stderr".format(logFilesPath, sampleName), \
					"python", phaserPath, "--vcf", args.vcf, "--bam", sample] + additionalArguments + ["--o", os.path.join(outpath, sampleName)]
		print(command)
		out.write("\t".join(command)+"\n")
		subprocess.call(command)

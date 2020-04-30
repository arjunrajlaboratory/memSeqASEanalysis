#Script to call freebayes on each chromosome separately using combined alignment file. 
import os, subprocess
from argparse import ArgumentParser
import glob
from datetime import datetime

#Command line parser
parser = ArgumentParser()
parser.add_argument("-e", "--experiment", help = "Specify experiment directory", type = str)
parser.add_argument("-b", "--inFile", help = "Option to specify the input bam file. Default is EXPERIMENT.star.combined.bam", type = str, default=None)
parser.add_argument("-o", "--outPrefix", help = "Option to specify the prefix for the output VCF. Default is EXPERIMENT", type = str, default=None)
parser.add_argument("-r", "--refFasta", help = "Specify the path to the reference genome fasta", type = str)
parser.add_argument("-i", "--fastaIndex", help = "Specify the path to the index file for the reference genome fasta", type = str)
parser.add_argument("-c", "--chrNames", help = "Specify the path to the txt files containg the names of the chromosomes", type = str)
parser.add_argument("-p", "--ploidy", help = "Specify ploidy used for freebayes", type = str, default="2")
parser.add_argument("-q", "--minQ", help = "From freebayes: Exclude alleles from analysis if their supporting base quality is less than Q", type = str, default="20")
parser.add_argument("-d", "--minCverage", help = "From freebayes: Require at least this coverage to process a site", type = str, default="2")
parser.add_argument("-G", "--minAltTotal", help = "From freebayes: Require at least this count of observations supporting an alternate allele", type = str, default="1")
parser.add_argument("-k", "--noPopulationPriors", help = "From freebayes: Equivalent to --pooled-discrete --hwe-priors-off and removal of Ewens Sampling Formula component of priors.", action='store_true')
args = parser.parse_args()

logFilesPath = os.path.join(args.experiment,'logs/stepThreeCallVariants')

if not os.path.exists(logFilesPath):
	os.makedirs(logFilesPath)

outFileDir = os.path.join(args.experiment,'freebayes')

if not os.path.exists(outFileDir):
	os.makedirs(outFileDir)

#Get list of chromosome names. 
with open(args.chrNames, 'r') as chrFile:
    chrName = chrFile.readlines()

chrName = [i.strip('\n') for i in chrName]

if args.inFile is None :
	combinedBam = os.path.join(args.experiment, "{}.star.combined.bam".format(args.experiment))
else:
	combinedBam = args.inFile

if args.outPrefix is None :
	outPrefix = args.experiment
else:
	outPrefix = args.outPrefix

additionalArguments =[]
if not args.minCverage == "0":
	additionalArguments.extend(["--min-coverage", args.minCverage])

if not args.minAltTotal == "0":
	additionalArguments.extend(["--min-alternate-total", args.minAltTotal])

if args.noPopulationPriors:
	additionalArguments.append("--no-population-priors")

journalPath = os.path.join(args.experiment, "logs", "callFreebayes")
if not os.path.exists(journalPath):
	os.makedirs(journalPath)

now = datetime.now()
journal = os.path.join(journalPath, "{}.callFreebayes.log".format(now.strftime("%Y-%m-%d_%H-%M")))

with open(journal, 'w') as out:
	for i in chrName:
		command = ["bsub", "-M", "96000", "-J", "{}.freeBayesChr{}".format(outPrefix, i), "-o", "{}/{}_chr{}.freeBayes.stdout".format(logFilesPath, outPrefix, i), "-e", "{}/{}_chr{}.freeBayes.stderr".format(logFilesPath, outPrefix, i), \
					"freebayes", "-f", args.refFasta, "-r", i, "-p", args.ploidy, "-q", args.minQ] + \
					additionalArguments + \
					[combinedBam, ">", "{}/{}.chr{}.freebayes.vcf".format(outFileDir, outPrefix, i)]
		print(command)
		out.write("\t".join(command)+"\n")
		subprocess.call(command)

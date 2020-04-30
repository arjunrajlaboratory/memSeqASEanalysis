#Script to call freebayes on each chromosome separately using combined alignment file. 
import os, subprocess
from argparse import ArgumentParser
import glob

#Command line parser
parser = ArgumentParser()
parser.add_argument("-e", "--experiment", help = "Specify experiment directory", type = str)
parser.add_argument("-r", "--refFasta", help = "Specify the path to the reference genome fasta", type = str)
parser.add_argument("-i", "--fastaIndex", help = "Specify the path to the index file for the reference genome fasta", type = str)
parser.add_argument("-c", "--chrNames", help = "Specify the path to the txt files containg the names of the chromosomes", type = str)
parser.add_argument("-p", "--ploidy", help = "Specify ploidy used for freebayes", type = str, default="2")
parser.add_argument("-q", "--minQ", help = "From freebayes: Exclude alleles from analysis if their supporting base quality is less than Q", type = str, default="20")
parser.add_argument("-d", "--minCverage", help = "From freebayes: Require at least this coverage to process a site", type = str, default="0")
parser.add_argument("-G", "--minAltTotal", help = "From freebayes: Require at least this count of observations supporting an alternate allele", type = str, default="0")

args = parser.parse_args()

logFilesPath = os.path.join(args.experiment,'logs/stepThreeCallVariants/')

if not os.path.exists(logFilesPath):
	os.makedirs(logFilesPath)

outFileDir = os.path.join(args.experiment,'freebayes')

if not os.path.exists(outFileDir):
	os.makedirs(outFileDir)

#Get list of chromosome names. 
with open(ars.chrNames, 'r') as chrFile:
    chrName = chrFile.readlines()

chrName = [i.strip('\n') for i in chrName]

combinedBam = os.path.join(args.experiment, "{}.star.combined.bam".format(args.experiment))

additionalArguments =[]
if not args.minCverage == "0":
	additionalArguments.extend(["--min-coverage", args.minCverage])

if not args.minAltTotal == "0":
	additionalArguments.extend(["--min-alternate-total", args.minAltTotal])

for i in chrName:
	command = ["bsub", "-M", "64000", "-J", "freeBayes{}".format(i), "-o", "{}/{}.freeBayes.stdout".format(logFilesPath, i), "-e", "{}/{}.freeBayes.stderr".format(logFilesPath, i), \
				"freebayes", "-f", args.refFasta, "-r", i, "-p", args.ploidy, "-q", args.minQ] + \
				additionalArguments + \
				[combinedBam, ">", "{}/{}.chr{}.freebayes.vcf".format(outFileDir, args.experiment, i)]
	print(command)
	subprocess.call(command)

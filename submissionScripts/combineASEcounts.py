#Script to combine ASE count data after running phASER. 
#This script requires python 3, specifically for recursive glob search and regular expression matching. 

import os
from argparse import ArgumentParser
import glob
import re

#Command line parser
parser = ArgumentParser()
parser.add_argument("-e", "--experiment", help = "Specify experiment directory", type = str)
parser.add_argument("-f", "--prefix", help = "Specify sample prefix", type = str)
parser.add_argument("-I", "--info", help = "Option to specify metadata for a Info column. Recommend including description of VCF file used for phASER", type = str, default = None)
args = parser.parse_args()

#Get list of sample paths. 
sampleDirs = glob.glob("{}/analyzed/{}*".format(args.experiment, args.prefix))
sampleNameRegex = re.compile('{}[-a-zA-Z0-9]+[-A-Z0-9-0-9]*'.format(args.prefix))

if args.info is not None:
	allelicHeader ="experiment\tinfo\tsample\tcontig\tposition\tvariantID\tref\talt\trefCount\taltCount\ttotal"
	hapHeader = "experiment\tinfo\tsample\tcontig\tstart\tstop\tvariants\tref\talt\trefCount\taltCount\ttotal"
#	header = "experiment\tinfo\tsample\tvariantID\tcontig\tstart\tstop\tref\talt\trefCount\taltCount\ttotal"
	outFileASE = os.path.join(args.experiment, "phaserAllelicCounts_{}.tsv".format(args.info))
	outFileHap = os.path.join(args.experiment, "phaserHapCounts_{}.tsv".format(args.info))
else:
	allelicHeader = "experiment\tsample\tcontig\tposition\tvariantID\tref\talt\trefCount\taltCount\ttotal"
	hapHeader = "experiment\tsample\tcontig\tstart\tstop\tvariants\tref\talt\trefCount\taltCount\ttotal"
	outFileASE = os.path.join(args.experiment, "phaserAllelicCounts.tsv")
	outFileHap = os.path.join(args.experiment, "phaserHapCounts.tsv")

with open(outFileASE, 'w') as outFile:
	outFile.write(allelicHeader)
	for i in sampleDirs:
		sampleName = sampleNameRegex.search(i).group()
		print(sampleName)
		countFile = glob.glob("{}/**/{}.allelic_counts.txt".format(i, sampleName), recursive = True)
		with open(countFile[0], 'r') as infile:
			skipHeader = infile.readline()
			sampleInfo = [args.experiment] + [args.info] + [sampleName]
			for line in infile:
				outFile.write('\n' + '\t'.join(sampleInfo) + '\t')
				outFile.write(line.strip('\n'))

with open(outFileHap, 'w') as outFile:
	outFile.write(hapHeader)
	for i in sampleDirs:
		sampleName = sampleNameRegex.search(i).group()
		countFile = glob.glob("{}/**/{}.haplotypic_counts.txt".format(i, sampleName), recursive = True)
		with open(countFile[0], 'r') as infile:
			skipHeader = infile.readline()
			sampleInfo = [args.experiment] + [args.info] + [sampleName]
			for line in infile:
				outFile.write('\n' + '\t'.join(sampleInfo) + '\t')
				line = line.strip('\n').split('\t')
				newLine = line[0:4] + line[7:12]
				outFile.write('\t'.join(newLine))



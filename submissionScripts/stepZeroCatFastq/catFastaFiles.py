#Script to merge fasta files from the same pooled libraries sequenced on multiple runs. 
#Gets the list of sample names from the first input directory. So expected the same sapmple names in all subsequent runs. 
import os, shutil
from argparse import ArgumentParser
import glob
import regex as re

#Command line parser
parser = ArgumentParser()
parser.add_argument("-i", "--inDirs", help = "Specify the input directories. Minimum 2.", nargs = '+')
parser.add_argument("-s", "--sampleName", help = "Specify the sample name")
parser.add_argument("-o", "--outDir", help = "Specify the output directory")
args = parser.parse_args()

inputDirectories = args.inDirs
if not os.path.exists(args.outDir):
	os.makedirs(args.outDir)


sampleRegex = re.compile(r'(WM9-)') #Rename WM9 samples to WM989. But leave MDA and WM983b as is
if sampleRegex.match(args.sampleName):
	outFile = os.path.join(args.outDir, args.sampleName.replace('WM9', 'WM989') + '.fastq.gz')
else:
	outFile = os.path.join(args.outDir, args.sampleName + '.fastq.gz')		
with open(outFile, 'w') as out:
	for i in inputDirectories:
		inFiles = glob.glob(os.path.join(i, args.sampleName, args.sampleName + '*.fastq.gz'))
		print inFiles
		for j in inFiles:
			shutil.copyfileobj(open(j, 'r'), out)
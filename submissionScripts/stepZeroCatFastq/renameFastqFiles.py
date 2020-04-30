#Script to rename fastq files 
import os, subprocess, shutil
from argparse import ArgumentParser
import glob

#Command line parser
parser = ArgumentParser()
parser.add_argument("-i", "--inDir", help = "Specify the input directory")
args = parser.parse_args()

#get sample file names
sampleFiles = glob.glob(os.path.join(args.inDir, 'raw/*'))
sampleFiles = [os.path.basename(i) for i in sampleFiles]

for sample in sampleFiles:
	originalFastQ = glob.glob(os.path.join(args.inDir, 'raw/{}/*'.format(sample)))
	originalFastQ = originalFastQ[0]
	newFastQ = originalFastQ.replace(".fastq.gz", "_R1.fastq.gz")
	shutil.move(originalFastQ, newFastQ)


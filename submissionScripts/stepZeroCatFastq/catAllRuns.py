#Script to merge fasta files from the same pooled libraries sequenced on multiple runs. 
#Gets the list of sample names from the first input directory. So expected the same sapmple names in all subsequent runs. 
import os, subprocess
from argparse import ArgumentParser
import glob

#Command line parser
parser = ArgumentParser()
parser.add_argument("-i", "--inDirs", help = "Specify the input directories for each run you wish to concatanate. Minimum 2.", nargs = '+')
parser.add_argument("-c", "--cellLine", help = "Specify the cell line . Options are WM9, MDA or 983b")
parser.add_argument("-o", "--outDir", help = "Specify the output directory")
args = parser.parse_args()

inputDirectories = args.inDirs
catFastaPath = 'submissionScripts/stepZeroCatFastq/catFastaFiles.py'

logFilesPath = os.path.join(args.outDir,'logs/stepZeroCatFastq')

if not os.path.exists(logFilesPath):
	os.makedirs(logFilesPath)

#Get list of sample names. Uses the first input directory. Can update in the future to take a specific list of sample names 
sampleFileNames = glob.glob(os.path.join(inputDirectories[1], "{}*".format(args.cellLine)))
sampleNames = [os.path.basename(i) for i in sampleFileNames]

#Call catFastaFiles.py on each 
for i in sampleNames:
	if args.cellLine == "WM9":
		out = os.path.join(args.outDir, 'raw', i.replace("WM9", "WM989"))
	else:
		out = os.path.join(args.outDir, 'raw', i)
	command = ["bsub",  "-J", "catFasta{}".format(i), "-o", "{}/{}.catFasta.stdout".format(logFilesPath, i), "-e", "{}/{}.catFasta.stderr".format(logFilesPath, i), \
				"python", catFastaPath, "-i"] + inputDirectories + ["-s", i, "-o", out]
	print(command)
	subprocess.call(command)

#gzip cat-ed fasta files then remove the old ones. 	
# for i in sampleNames:
# 	if args.cellLine == "WM9":
# 		outFile = os.path.join(args.outDir, i.replace("WM9", "WM989"), "{}.fastq".format(i.replace("WM9", "WM989")))
# 	else:
# 		outFile = os.path.join(args.outDir, i, "{}.fastq".format(i))
# 	command = ["bsub", "gzip", outFile]
# 	#print(command)
# 	subprocess.call(command)

# for i in sampleNames:
# 	for j in inputDirectories:
# 		shutil.rmtree(os.path.join(j, i))


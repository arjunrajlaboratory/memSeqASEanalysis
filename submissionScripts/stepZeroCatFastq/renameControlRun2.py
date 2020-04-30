#Script to rename memSeq control run2 directors

import os, shutil
import glob

inPath = '/project/arjunrajlab/CancerSeq/repo/memSeqASE/WM989/heritabilityControls2/raw'

#First rename MDA files
sampleFiles = glob.glob('{}/M-*'.format(inPath))
samples = [os.path.basename(i) for i in sampleFiles]

for i in samples:
	inFile = os.path.join(inPath, i, '{}.fastq'.format(i))
	newName = i.replace('M', "MDA")
	outFile = os.path.join(inPath, newName, '{}.fastq'.format(newName))
	os.makedirs(os.path.join(inPath, '{}/'.format(newName)))
	if os.path.exists(inFile):
		shutil.move(inFile, outFile)

#Repeat for WM989 files
sampleFiles = glob.glob('{}/W-*'.format(inPath))
samples = [os.path.basename(i) for i in sampleFiles]

for i in samples:
	inFile = os.path.join(inPath, i, '{}.fastq'.format(i))
	newName = i.replace('W', "WM9")
	outFile = os.path.join(inPath, newName, '{}.fastq'.format(newName))
	os.makedirs(os.path.join(inPath, '{}/'.format(newName)))
	if os.path.exists(inFile):
		shutil.move(inFile, outFile)
#!
# run from within repo

cmdToRun="$codeHomeDir/memSeqASEanalysis/utilities/stepTwoPrepareAlignments/allPrepAlignments.sh $EXPERIMENT $codeHomeDir $PROJECT"

JOB_ARRAY_PARAMETER_TEMPLATE="prepAlignments[1-tk]"

#The expression within ${} below replaces "tk" with the correct number of samples (defined in the setEnvironmentVariables.sh script)
bsub -M "64000" -J ${JOB_ARRAY_PARAMETER_TEMPLATE/tk/$N_SAMPLES} -o $EXPERIMENT/logs/prepAlignments.out.%I -e $EXPERIMENT/logs/prepAlignments.err.%I $cmdToRun

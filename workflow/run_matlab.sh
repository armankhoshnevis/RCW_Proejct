#!/bin/bash
# Wrapper script to run MATLAB with module loading

# Load the MATLAB module
module load MATLAB/2023b

# Change to the specified directory
cd "$1"

# Run MATLAB command with proper exit handling
matlab -nodisplay -nosplash -r "try; $2; exit(0); catch ME; disp(ME.message); exit(1); end;" >& "$3"
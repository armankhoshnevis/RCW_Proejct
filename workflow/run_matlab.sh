#!/bin/bash
# Wrapper script to run MATLAB with module loading

# Check if the 'module' command exists
if command -v module &> /dev/null; then
    # Load the MATLAB module for the cluster
    module load MATLAB/2023b
fi

# Change to the specified directory
cd "$1"

# Run MATLAB command with proper exit handling
matlab -nodisplay -nosplash -r "try; $2; exit(0); catch ME; disp(ME.message); exit(1); end;" >& "$3"
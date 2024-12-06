# Running the Snakefile on a Local Machine

## Prerequisites
- [Install Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) in a Python environment.

## Steps
- Clone the [repository](https://github.com/armankhoshnevis/RCW_Proejct) in your desired directory.
- Activate the Python environment where Snakemake is installed.
- Go to the workflow directory inside the cloned repository (`cd RCW_Proejct/workflow`).
- To check what tasks will be executed (without actually running them), use the following command: `snakemake -n`
- To execute the workflow, specify the number of cores to use `snakemake --cores <n>`. Replace `<n>` with the number of cores you want to utilize.

## Guides/Notes on the workflow logic
- All MATLAB functions and scripts required for the workflow are located in the `/src/PSO` directory.
    - `main_loop_hpcc_function.m" is the core script for PSO optimization.
    - Other scripts/functions explained in the [Explanation](../explanation/index.md).
- Metadata for each polyurea nanocomposite is located in the `/src/PSO/PSOSetup` directory.
    - Each .dat file contains parameters such as the model name, variable bounds, experimental data details, and PSO settings.
    - Refer to the [Explanation](../explanation/index.md) section in the documentation for detailed information about metadata structure and usage.
- The workflow uses `matlab_run.sh` to execute MATLAB scripts.
- Upon successful workflow execution, the optimization results (.mat files) will be saved in:
    - `/src/PSO/OptimizationResults/FMG_FMG` for FMG-FMG models.
    - `/src/PSO/OptimizationResults/FMM_FMG` for FMM-FMG models.
- To run a specific case:
    - Remove unwanted metadata files from the `/src/PSO/PSOSetup` directory.
    - Keep only the metadata file for the desired case.
    - Execute the workflow as described above.
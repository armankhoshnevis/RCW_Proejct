# Running the Snakefile on a Cluster (with Slurm Job Scheduler)

## Prerequisites
- [Install Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) in a Python environment.
- On HPCC systems, you might need to purge existing modules and load `Miniforge3` to set up and activate a conda environment:
  ```bash
  module purge
  module load Miniforge3
  ```
For instance, refer to this [guide](https://docs.icer.msu.edu/Using_conda/) for more information.

## Steps
- Clone the [repository](https://github.com/armankhoshnevis/RCW_Proejct) in your desired directory.
- Activate the Python environment where Snakemake is installed.
- Go to the workflow directory inside the cloned repository (`cd RCW_Proejct/workflow`).
- To check what tasks will be executed (without actually running them), use the following command: `snakemake --dryrun --cores <n> --workflow-profile slurm`
- To submit the workflow to the SLURM job scheduler, use the following command: `snakemake --cores <n> --workflow-profile slurm`.
    - Note: Here, `--cores <n>` allows Snakemake to manage up to `<n>` simultaneous processes locally (e.g., generating outputs, managing job submissions).
    - Note: The maximum number of SLURM jobs Snakemake will submit to the cluster simultaneously is specified in the `config.yaml` file (as referred a bit down below).

## Guides/Notes on the workflow logic
- All MATLAB functions and scripts required for the workflow are located in the `/src/PSO` directory.
    - `main_loop_hpcc_function.m" is the core script for PSO optimization.
    - Other scripts/functions explained in the [Explanation](../explanation/index.md).
- Metadata for each polyurea nanocomposite is located in the `/src/PSO/PSOSetup` directory.
    - Each .dat file contains parameters such as the model name, variable bounds, experimental data details, and PSO settings.
    - Refer to the [Explanation](../explanation/index.md) section in the documentation for detailed information about metadata structure and usage.
- The workflow uses `matlab_run.sh` to execute MATLAB scripts.
    - This shell ensures that a MATLAB module is loaded properly: `module load MATLAB/2023b`. For example, refer to [this guide](https://docs.icer.msu.edu/Matlab/) for more information on loading and running MATLAB on a cluster.
- Upon successful workflow execution, the optimization results (.mat files) will be saved in:
    - `/src/PSO/OptimizationResults/FMG_FMG` for FMG-FMG models.
    - `/src/PSO/OptimizationResults/FMM_FMG` for FMM-FMG models.
- To run a specific case:
    - Remove unwanted metadata files from the `/src/PSO/PSOSetup` directory.
    - Keep only the metadata file for the desired case.
    - Execute the workflow as described above.
- Modify the `default-resources` specification in the `/workflow/slurm/config.yaml` file to match the requirements for your optimization runs.
    - For example, adjust memory, runtime, and the number of CPUs based on the complexity of the metadata.
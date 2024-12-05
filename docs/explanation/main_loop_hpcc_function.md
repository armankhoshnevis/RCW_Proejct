# main_loop_hpcc_function.m

## Purpose
The script performs Particle Swarm Optimization (PSO) for a given model (FMG-FMG or FMM-FMG) and dataset (20, 30 or 40 HSWF with 0.0, 0.5, 1.0, or 1.5 %wt. xGnP). It:
1. Reads parameters and data from a `.dat` metadata file and Excel sheet.
2. Defines the optimization problem.
3. Configures and executes PSO for multiple runs as PSO is inherently stochastic.
4. Saves optimization results and optionally generates a convergence plot.

---

## Key Components

### **1. Input Handling**
- Reads a `.dat` file (specified by `metadata`) to extract:
  - Sheet name (`sheetName`) and data range (`validRange`) for experimental data.
  - Model name (`modelName`).
  - Variable bounds (`lower_bounds`, `upper_bounds`).
  - PSO setup parameters (`pso_setup`).
- Loads experimental data from the specified Excel sheet.

---

### **2. Problem Definition**
- Defines the optimization model and experimental data:
  - `problem.model`: Name of the model.
  - `problem.variableMin`, `problem.variableMax`: Lower and upper limits for model parameters (i.e., a search space for the optimized model parameters).
  - `problem.expData`, `problem.modelData`: Experimental data and model prediction.

---

### **3. PSO Parameters**
- Configures PSO with:
  - Maximum iterations for each run and swarm size (`params.maxIterations`, `params.swarmSize`).
  - Dynamic inertia coefficient (`params.inertiaVector`).
  - Acceleration coefficients (`params.personalAccCoeff`, `params.socialAccCoeff`).

---

### **4. Optimization Loop**
- Runs PSO multiple times (`numRuns`) and records:
  - Best solutions and costs.
  - Least-Squares Error (LSE) for model fitting.

---

### **5. Output Handling**
- Saves optimization results to a structured directory (`savePath`).
- (Optional) Generates a convergence plot (commented out).

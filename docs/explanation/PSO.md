# PSO.m

## Purpose
The `PSO` function implements the Particle Swarm Optimization (PSO) algorithm to obtain the optimized model parameters. It models a population of particles moving through the search space to find the optimal solution based on inertia, personal best, and global best positions.

---

## Key Components

### **1. Problem Definition**
- Defines the optimization problem's dimensionality and boundaries:
  - **`numVariables`**: Number of decision variables.
  - **`variableMin`**, **`variableMax`**: Lower and upper bounds for variables (i.e., search space).

---

### **2. PSO Parameters**
- Configures algorithm-specific parameters:
  - **`maxIterations`**: Maximum number of iterations for each run.
  - **`swarmSize`**: Number of particles in the swarm (swarm population).
  - **`inertiaVector`**: Dynamic inertia weights for velocity updates.
  - **`personalAccCoeff`**, **`socialAccCoeff`**: Acceleration coefficients for personal and social influence (effect of personal best and global best cost values).

---

### **3. Initialization**
- Initializes the swarm with random positions (within the search space) and zero velocities.
- Evaluates the cost function for each particle:
  - Updates personal best (`particles(i).best`) and global best (`globalBest`).

---

### **4. Main PSO Loop**
- For each iteration:
  - Updates particle velocities and positions using PSO equations.
  - Applies velocity and position bounds to keep particles within the search space.
  - Updates personal and global bests based on new cost evaluations.
- Stores the best cost for each iteration in `bestCosts`.

---

### **5. Output**
- Returns:
  - **`out.population`**: Final swarm state.
  - **`out.bestSolution`**: Best solution and its cost.
  - **`out.bestCosts`**: Cost evolution over iterations.
  - **`out.outputData`**: Iteration-wise data including Least Squares Error (LSE), Mean Squared Error (MSE), and best position

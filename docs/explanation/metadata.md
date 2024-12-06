# Metadata Explanation ``:

## Purpose
This metadata file specifies the input parameters for the Particle Swarm Optimization (PSO) workflow. It defines:
1. Experimental data range.
2. The constitutive model used.
3. Variable bounds for optimization.
4. PSO settings.
5. Output file name for storing results.

The name of each metadata corresponds a certain nanocomposite system with specific HS and GnP value. The metadata files are located at `/src/PSOSetup`.

---

## Breakdown of the Metadata
### Material Identifier
- **`20HS`**: The identifier for the polyurea nanocomposite material under analysis. This is used to select the relevant data range from the experimental dataset.

---

### Experimental Data Range
- **`B51:D145`**: The range of cells in the Excel file containing experimental data:
  - Column `B`: Frequencies (\(\omega\)).
  - Column `C`: Storage modulus (\(E'\)).
  - Column `D`: Loss modulus (\(E''\)).

---

### Constitutive Model
- `FMG_FMG`: The constitutive model to be used in the optimization. 

---

## Variable Bounds
- The next two lines specify the **lower bounds** and **upper bounds** for the optimization variables in the following order:
    - \(E_{c1}\), \(\tau_{c1}\), \(alpha_1\), \(\beta_1\), \(E_{c2}\), \(\alpha_2\), and \(\beta_2\).

---

## PSO Settings
- First numnber: Maximum number of iterations for each PSO run.
- Second number: Swarm size (number of particles).
- Third number: Number of independent runs to perform.

---

## Output File Name
- The name of the `.mat` file where the optimization results will be saved.
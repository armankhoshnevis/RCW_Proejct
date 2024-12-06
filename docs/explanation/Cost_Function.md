# Cost_Function.m

## Purpose
This function calculates a multi-objective cost value for optimization by comparing experimental and model data. The cost quantifies the difference between the experimental storage and loss moduli (\(E'\) and \(E''\)) and their corresponding model predictions.

---
## Key Components

### **1. Inputs**
- **`problem`**: Struct containing:
  - **`expData`**: Experimental data for storage modulus (\(E'\)) and loss modulus (\(E''\)).
  - **`weight`**: Weights for the cost function components.
- **`params`**: Model parameters to evaluate.

---

### **2. Multi-Objective Cost Function**

\(\min_{\mathbf{q}} \left(w_1 g_1(\mathbf{q}) + w_2 g_2(\mathbf{q})\right)\), where

- \(w_1 = w_2 = \frac{1}{2}\)
- \(g_1(\mathbf{q}) = \sum_{i=1}^{N_d} \left(\log(\frac{E_{\text{exp}}^{'}}{E_{\text{model}}^{'}})\right)^2, \)
\(g_2(\mathbf{q}) = \sum_{i=1}^{N_d} \left(\log(\frac{E_{\text{exp}}^{''}}{E_{\text{model}}^{''}})\right)^2.\)
- \(\mathbf{q}\) is the vector of model parameters.

---

### **3. Output**
- **`cost`**: Multi-objective cost value used in the optimization process.
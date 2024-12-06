# Constitutive_Model.m

## Purpose
This function computes the **storage modulus** \(E'\) and **loss modulus** \(E''\) for constitutive models (FMG-FMG or FMM-FMG). It can also support similar models (i.e., FMM-FMM, FMG-FMM) with branches representing fractional-order viscoelastic behaviors.

---

## Key Components

### **1. Inputs**
- **`problem`**: Struct containing `modelData`, including shifted frequency data.
- **`params`**: Parameters for the constitutive model:
  - \(E_{c1}\), \(E_{c2}\): Characteristic Module for each branch.
  - \(\tau_{c1}, \tau_{c2}\): Characteristic relaxation time for each branch.
  - \(\alpha_1, \beta_1, \alpha_2, \beta_2\): Fractional-order power exponents controlling viscoelastic behavior.

---

### **2. Mathematical Definitions**
#### Storage Modulus (\(E'\)):
\(E^{\prime}_{model}(x) = \sum_{k=1}^2 E_{c_k} \frac{\left(x\tau_{c_k}\right)^{\alpha_k} \cos\left(\frac{\pi\alpha_k}{2}\right) + \left(x\tau_{c_k}\right)^{2\alpha_k-\beta_k} \cos\left(\frac{\pi\beta_k}{2}\right)}{1 + \left(x\tau_{c_k}\right)^{\alpha_k-\beta_k} \cos\left(\frac{\pi\left(\alpha_k-\beta_k\right)}{2}\right) + \left(x\tau_{c_k}\right)^{2\left(\alpha_k-\beta_k\right)}} \)

#### Loss Modulus (\(E''\)):
\(E^{\prime\prime}_{model}(x) = \sum_{k=1}^2 E_{c_k} \frac{\left(x\tau_{c_k}\right)^{\alpha_k} \sin\left(\frac{\pi\alpha_k}{2}\right) + \left(x\tau_{c_k}\right)^{2\alpha_k-\beta_k} \sin\left(\frac{\pi\beta_k}{2}\right)}{1 + \left(x\tau_{c_k}\right)^{\alpha_k-\beta_k} \cos\left(\frac{\pi\left(\alpha_k-\beta_k\right)}{2}\right) + \left(x\tau_{c_k}\right)^{2\left(\alpha_k-\beta_k\right)}} \)

---

### **3. Calculations**
- Calculates the equivalent storage and loss moduli of the constitutive model:
  - Updates `problem.modelData(2, :)` with \(E'\).
  - Updates `problem.modelData(3, :)` with \(E''\).

---

### **4. Outputs**
- **`problem`**: Struct with updated `modelData`:
  - **`modelData(2, :)`**: Storage modulus values.
  - **`modelData(3, :)`**: Loss modulus values.

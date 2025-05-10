# ASEN-5212-Composites-Project

## Team Members
- Claire Kent, AES PhD Student
- Bryce Pfuetze, AES BS, 2025
- Samuel Hatton, AES BS, 2023, MS, 2025

## Project Summary

## Code Summary

### `project_main.m`
- **Purpose**: Main script for running composite laminate analysis, including material property definition, mass calculations, stiffness and strength checks, and brute-force/parallelized layup searches.
- **Usage**: Not intended to be run in full; run individual sections as needed. Demonstrates use of all major functions and workflows for the project.

### `t_from_Vf.m`
- **Purpose**: Calculates the thickness of a lamina based on the fiber volume fraction (`V_f`).
- **Inputs**:
  - `V_f`: Volume fraction of fibers (0 ≤ `V_f` ≤ 1).
  - `n` (optional): Number of lamina in the layup.
- **Outputs**:
  - `t`: Thickness of the lamina (scalar or vector, mm).
- **Method**:
  - Assumes a constant fiber thickness of 0.05 mm.
  - Validates `V_f` and ensures the calculated thickness meets expected physical constraints.

### `calculate_Q_S_matrix.m`
- **Purpose**: Computes the stiffness (`Q`) and compliance (`S`) matrices for a composite lamina.
- **Inputs**:
  - `fiber_properties`: [E_1f, E_2f, G_12f, nu_12f]
  - `matrix_properties`: [E_m, nu_m]
  - `composite_properties`: [V_f, xi_1, xi_2, theta]
- **Outputs**:
  - `Q`: Stiffness matrix
  - `S`: Compliance matrix
- **Method**:
  - Uses rule of mixtures and Halpin-Tsai equations to calculate effective material properties.
  - Constructs and transforms the `Q` and `S` matrices for the given ply orientation.

### `calculate_ABD_matrix.m`
- **Purpose**: Builds the global ABD stiffness matrix for a composite laminate.
- **Inputs**:
  - `Q_combined`: Combined stiffness matrices for all plies
  - `t_vector`: Thicknesses of each lamina
- **Outputs**:
  - `ABD`: 6x6 ABD stiffness matrix
- **Method**:
  - Computes the `A`, `B`, and `D` submatrices using the thickness and stiffness properties of each lamina.
  - Assembles the submatrices into the full ABD matrix.

### `build_Q_comb.m`
- **Purpose**: Constructs a combined `Q` matrix for all plies in a laminate.
- **Inputs**:
  - `fiber_properties`, `matrix_properties`, `composite_properties`, `layup`
- **Outputs**:
  - `Q_combined`: Combined stiffness matrices for all plies
- **Method**:
  - Loops through each ply, calculates its `Q` matrix using `calculate_Q_S_matrix`, and concatenates the results.

### `build_angle_combos.m`
- **Purpose**: Generates all possible symmetric combinations of ply angles for a laminate layup.
- **Inputs**:
  - `thetas`: Vector of allowable ply angles (degrees)
  - `n`: Total number of lamina
  - `n_fill`: Number of fixed mid-layers
- **Outputs**:
  - `angle_combinations`: Array of all possible angle combinations
  - `num_combinations`: Number of combinations
- **Method**:
  - Enforces symmetry and generates all combinations using `ndgrid`.

### `build_T.m`
- **Purpose**: Constructs the 3x3 transformation matrix for a given ply angle.
- **Inputs**:
  - `theta`: Ply angle in radians
- **Outputs**:
  - `T`: 3x3 transformation matrix

### `build_z_from_t.m`
- **Purpose**: Computes the z-coordinates of the top and bottom surfaces of each lamina in the laminate.
- **Inputs**:
  - `t_vector`: Vector of thicknesses for each lamina
- **Outputs**:
  - `z`: Vector of z-coordinates for each interface

### `check_tsaiwu_2d.m`
- **Purpose**: Evaluates the Tsai-Wu failure criterion for a 2D stress state in a lamina.
- **Inputs**:
  - `sigma`: 3xn stress matrix
  - `F`: Strength parameters [F_1t; F_1c; F_2t; F_2c; F_6]
- **Outputs**:
  - `failure`: Boolean vector indicating failure
  - `tsai_wu_criteria`: Numerical value of the criterion

### `compute_lamina_strain.m`
- **Purpose**: Computes the strain in each lamina given midplane strains and curvatures.
- **Inputs**:
  - `laminate_strain`: 6x1 vector (midplane strain and curvature)
  - `t_vector`: Thickness vector for each lamina
- **Outputs**:
  - `lamina_strain`: 3xn matrix of strains in each lamina

### `compute_lamina_stress.m`
- **Purpose**: Computes the stress in each lamina given strains and stiffness matrices.
- **Inputs**:
  - `Q_combined`: Combined stiffness matrices for all plies
  - `lamina_strain`: Strain in each lamina (or laminate strain and t_vector)
- **Outputs**:
  - `lamina_stress`: Stress in each lamina

### `Failure_Criteria.m`
- **Purpose**: Computes the strength criteria for a composite lamina based on the fiber volume fraction.
- **Inputs**:
  - `Vf`: Fiber volume fraction
- **Outputs**:
  - `F1t`, `F1c`, `F2t`, `F2c`, `F6`: Strengths (MPa)

### `get_abd.m`
- **Purpose**: Computes the inverse ABD (compliance) matrix for a laminate.
- **Inputs**:
  - `ABD`: 6x6 ABD stiffness matrix
- **Outputs**:
  - `abd`: 6x6 compliance matrix

### `get_E_ratio.m`
- **Purpose**: Computes the ratio of the larger modulus to the smaller modulus.
- **Inputs**:
  - `Ex`, `Ey`: Moduli in x and y directions
- **Outputs**:
  - `E_ratio`: Ratio of the larger modulus to the smaller modulus

### `get_mass.m`
- **Purpose**: Computes the areal mass of the composite laminate.
- **Inputs**:
  - `V_f`: Fiber volume fraction
  - `thickness`: Total laminate thickness (mm)
- **Outputs**:
  - `mass`: Areal mass (kg/m²)

### `laminate_stiffness.m`
- **Purpose**: Computes laminate stiffness properties and matrices.
- **Inputs**:
  - `fiber_properties`, `matrix_properties`, `composite_properties`, `layup`, `t`
- **Outputs**:
  - `Ex`, `Ey`: Average laminate stiffness in x and y
  - `ABD`: 6x6 ABD matrix
  - `Q_combined`: Combined Q matrices
  - `t_vector`: Thickness vector

### `rotate_stress.m`
- **Purpose**: Rotates a stress vector from global (xy) to local (12) coordinates for each ply.
- **Inputs**:
  - `stress_xy`: Stress in global coordinates
  - `theta_vec`: Ply angles (radians)
- **Outputs**:
  - `stress_12`: Stress in local coordinates

### `stiffnessCheck.m`
- **Purpose**: Checks if a laminate passes stiffness criteria for project requirements.
- **Inputs**:
  - `ABD`: 6x6 laminate stiffness matrix
  - `plot_lever` (optional): Plot results if true
- **Outputs**:
  - `passVec`: 4x1 logical vector for [A_xx, A_xx_bar, D_xx, D_yy] criteria

### `strengthCheck.m`
- **Purpose**: Checks if a laminate passes strength criteria under specified loads.
- **Inputs**:
  - `layup`: Ply angles (radians)
  - `V_f`: Fiber volume fraction
  - `plot_lever` (optional): Plot results if true
- **Outputs**:
  - `pass`: Boolean for pass/fail
  - `criteria`: Tsai-Wu criteria for each ply

### `checkBoth.m`
- **Purpose**: Checks both stiffness and strength criteria for a given laminate layup and volume fraction.
- **Inputs**:
  - `layup`: Ply angles (degrees)
  - `V_f`: Fiber volume fraction
  - `plot_lever` (optional): Plot results if true
- **Outputs**:
  - `pass`: 5-element logical vector ([Axx, Axx_bar, Dxx, Dyy, Tsai-Wu])
  - `criteria`: Tsai-Wu criteria for each ply

### Parallelized and Coder-Compatible Functions

#### Parallelized MATLAB Functions

- **`parStiffnessCheck.m`**
  Parallelized search for all symmetric layups passing stiffness criteria.

- **`parStrengthCheck.m`**
  Parallelized search for all symmetric layups passing strength criteria.

#### MATLAB Coder-Compatible Functions (`*_c.m`)

- **`parCheck_c.m`**
  Coder-compatible version of a parallelized laminate check function for use with MATLAB Coder.

- **`parStrengthCheck_c.m`**
  Coder-compatible version of `parStrengthCheck` for C code generation.

> **Note:**
> The `_c.m` functions are designed for use with MATLAB Coder to generate C code. These functions use fixed-size arrays and other codegen-compatible constructs. After code generation, you can call the compiled C code in MATLAB via the corresponding `.mexw64` files.

#### Compiled MEX Functions (`.mexw64`)

- **`parCheck_c_mex.mexw64`**
- **`parStrengthCheck_3_mex.mexw64`**
- **`parStrengthCheck_4_mex.mexw64`**
- **`parStrengthCheck_5_mex.mexw64`**
- **`parStrengthCheck_6_mex.mexw64`**
- **`parStrengthCheck_7_mex.mexw64`**
- **`parStrengthCheck_8_mex.mexw64`**

> **Note:**
> These `.mexw64` files are compiled binaries generated from the corresponding `_c.m` MATLAB Coder-compatible functions. They can be called directly from MATLAB for significantly faster brute-force laminate searches.


---


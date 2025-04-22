# ASEN-5212-Composites-Project

## Team Members
- Claire Kent, AES PhD Student
- Bryce Pfuetze, AES BS, 2025
- Samuel Hatton, AES BS, 2023, MS, 2025

## Project Summary

## Code Summary

### `t_from_Vf.m`
- **Purpose**: Calculates the thickness of a lamina based on the fiber volume fraction (`V_f`).
- **Inputs**:
  - `V_f`: Volume fraction of fibers (0 ≤ `V_f` ≤ 1).
- **Outputs**:
  - `t`: Thickness of the lamina in millimeters.
- **Method**:
  - Assumes a constant fiber thickness of 0.05 mm.
  - Validates `V_f` and ensures the calculated thickness meets expected physical constraints.

### `calculate_Q_S_matrix.m`
- **Purpose**: Computes the stiffness (`Q`) and compliance (`S`) matrices for a composite lamina.
- **Inputs**:
  - `fiber_properties`: Fiber material properties (`E_1f`, `E_2f`, `G_12f`, `nu_12f`).
  - `matrix_properties`: Matrix material properties (`E_m`, `nu_m`).
  - `composite_properties`: Composite properties (`V_f`, `xi_1`, `xi_2`, `theta`).
- **Outputs**:
  - `Q`: Stiffness matrix.
  - `S`: Compliance matrix.
- **Method**:
  - Uses rule of mixtures and Halpin-Tsai equations to calculate effective material properties.
  - Constructs and transforms the `Q` and `S` matrices for the given ply orientation.

### `calculate_ABD_matrix.m`
- **Purpose**: Builds the global ABD stiffness matrix for a composite laminate.
- **Inputs**:
  - `Q_combined`: Combined stiffness matrices for all plies.
  - `t_vector`: Thicknesses of each lamina.
- **Outputs**:
  - `ABD`: 6x6 ABD stiffness matrix.
- **Method**:
  - Computes the `A`, `B`, and `D` submatrices using the thickness and stiffness properties of each lamina.
  - Assembles the submatrices into the full ABD matrix.

### `build_Q_comb.m`
- **Purpose**: Constructs a combined `Q` matrix for all plies in a laminate.
- **Inputs**:
  - `fiber_properties`: Fiber material properties.
  - `matrix_properties`: Matrix material properties.
  - `composite_properties`: Composite properties (`V_f`, `xi_1`, `xi_2`).
  - `theta`: Vector of ply angles (in radians).
- **Outputs**:
  - `Q_combined`: Combined stiffness matrices for all plies.
- **Method**:
  - Loops through each ply, calculates its `Q` matrix using `calculate_Q_S_matrix`, and concatenates the results.

### `project_main.m`
- **Purpose**: Main script for the composite design project.
- **Key Sections**:
  - **Material Property Definition**: Defines material properties for fibers, matrix, and composite.
  - **Design for Stiffness**: Specifies stiffness criteria for the laminate.
  - **Design for Strength**: Specifies strength requirements for the laminate under various loads.
  - **Design for Stiffness and Strength**: Combines stiffness and strength requirements for final design.
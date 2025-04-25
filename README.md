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
  - `layup`: Vector of ply angles (in radians).
- **Outputs**:
  - `Q_combined`: Combined stiffness matrices for all plies.
- **Method**:
  - Loops through each ply, calculates its `Q` matrix using `calculate_Q_S_matrix`, and concatenates the results.

### `build_T.m`
- **Purpose**: Constructs the 3x3 transformation matrix for a given ply angle.
- **Inputs**:
  - `theta`: Ply angle in radians.
- **Outputs**:
  - `T`: 3x3 transformation matrix.

### `build_z_from_t.m`
- **Purpose**: Computes the z-coordinates of the top and bottom surfaces of each lamina in the laminate.
- **Inputs**:
  - `t_vector`: Vector of thicknesses for each lamina.
- **Outputs**:
  - `z`: Vector of z-coordinates for each interface.

### `check_tsaiwu_2d.m`
- **Purpose**: Evaluates the Tsai-Wu failure criterion for a 2D stress state in a lamina.
- **Inputs**:
  - `stress`: Stress vector for the lamina.
  - `strengths`: Material strength parameters.
- **Outputs**:
  - `failure`: Boolean indicating if failure occurs.
  - `margin`: Margin of safety.

### `compute_lamina_strain.m`
- **Purpose**: Computes the strain in each lamina given midplane strains and curvatures.
- **Inputs**:
  - `midplane_strain`: Midplane strain vector.
  - `curvature`: Curvature vector.
  - `z`: Vector of z-coordinates for each lamina.
- **Outputs**:
  - `lamina_strain`: Strain in each lamina.

### `compute_lamina_stress.m`
- **Purpose**: Computes the stress in each lamina given strains and stiffness matrices.
- **Inputs**:
  - `lamina_strain`: Strain in each lamina.
  - `Q_combined`: Combined stiffness matrices for all plies.
- **Outputs**:
  - `lamina_stress`: Stress in each lamina.

### `get_abd.m`
- **Purpose**: Computes the inverse ABD (compliance) matrix for a laminate.
- **Inputs**:
  - `ABD`: 6x6 ABD stiffness matrix.
- **Outputs**:
  - `abd`: 6x6 compliance matrix.

### `get_E_ratio.m`
- **Purpose**: Computes the ratio of the larger modulus to the smaller modulus.
- **Inputs**:
  - `Ex`: Modulus in the x-direction.
  - `Ey`: Modulus in the y-direction.
- **Outputs**:
  - `E_ratio`: Ratio of the larger modulus to the smaller modulus.

### `laminate_stiffness.m`
- **Purpose**: Computes laminate stiffness properties and matrices.
- **Inputs**:
  - `fiber_properties`: Fiber material properties.
  - `matrix_properties`: Matrix material properties.
  - `composite_properties`: Composite properties.
  - `layup`: Vector of ply angles (in radians).
  - `t`: Thickness of each lamina.
- **Outputs**:
  - `Ex`: Average laminate stiffness in the x-direction.
  - `Ey`: Average laminate stiffness in the y-direction.
  - `ABD`: 6x6 ABD stiffness matrix.
  - `Q_combined`: Combined stiffness matrices for all plies.
  - `t_vector`: Vector of thicknesses for each lamina.

### `rotate_vector.m`
- **Purpose**: Rotates a stress or strain vector by a given ply angle using the transformation matrix.
- **Inputs**:
  - `vector`: Stress or strain vector.
  - `theta`: Ply angle in radians.
- **Outputs**:
  - `rotated_vector`: Rotated vector.

### `project_main.m`
- **Purpose**: Main script to run the composite laminate analysis workflow.
- **Inputs/Outputs**: Varies depending on analysis setup.

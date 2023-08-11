# BernoulliBeam_2D_FEM
Implementation in **Fortran90** of Finite Element Procedures for the analysis of 2D planar structures with Bernoulli beam finite elements
![alt text](https://github.com/PieroChiaia/BernoulliBeam_2D_FEM/blob/main/Examples/DeformedStructure.png)

<img src="https://github.com/PieroChiaia/BernoulliBeam_2D_FEM/blob/main/Examples/DeformedStructure.png" width="100" height="100">

The main program, that can be compiled with any Fortran compiler and here provided, is structured in the following way
- **PROG_Main.f90**: contains the main program procedure and the subsequent subroutine calling
- **MOD_Data.f90**: contains the main module _MOD_DATA_, in which the main information about the frame 2D elements are defined, the global variables are declared and internal variables are initialized
- **PRE_Preprocessor.f90**: contains subroutine _PREPROCESSING_, in this subroutine the global (enmarated) nodes list, the definition of elements by its connectivity, material properties and boundary conditions applied to each beam elements are read and memorized in the structural variables;
- **MAT_Stiffness_Matrix.f90**:, contains subroutine _STIFFNESS_MATRIX_, in which the element stiffness matrix is computed in the local reference frame, then converted to the global reference frame and finally assembled in the global stiffness matrix;
- **MAT_Load_Vector.f90**:, contains subroutine _LOAD_VECTOR_, in which the nodal forces, the nodal torque and distributd loads are eventually computed and applied by assembling the global forces vector adopting the same assembling procedure defined for the stiffness matrix;
- **MAT_BC.f90**:, contains subroutine _BC_ROUTINE_, in which the geometrical boundary conditions are applied to the structures by removing the rows/coloumns of the global finite element stiffness matrix and forces vector. IN this subroutine, only pinned/hinged/clamped boundary conditions can be applied;
- **SYS_LinearSystem.f90**:, contains subroutine _LIN_SYS_LU_, in which an elementary Gaussian backforword elimination algorithm is implemented for the computation of the solution of the final system of equations;
- **POST_Postprocessor.f90**:, contains subroutine _POSTPROCESSING_, in which the results are printed to video and file, by printing element by element, node by node, the displacemet components obtained;

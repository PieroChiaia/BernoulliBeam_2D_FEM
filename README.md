# Unified FEM 1D2D: v.1.0
Implementation in **Fortran90** of Finite Element Procedures for the linear static analysis of 2D planar structures. Available models implemented are the unidirectional truss finite elements and Euler-Bernoulli beam finite elements.

<img src="https://github.com/PieroChiaia/BernoulliBeam_2D_FEM/blob/main/Examples/DeformedStructure.png" width="570" height="340">

## Main structure of the code
The main program, which can be compiled with any Fortran compiler and here provided, is structured in the following way
- **PROG_Main.f90**: contains the main program procedure and the subsequent subroutine calling
- **MOD_Data.f90**: contains the main module _MOD_DATA_, in which the main information about the frame 2D elements are defined, the global variables are declared and internal variables are initialized
- **PRE_Preprocessor.f90**: contains subroutine _PREPROCESSING_, in this subroutine the global (enumerated) nodes list, the definition of elements by its connectivity, material properties, and boundary conditions applied to each beam elements are read and memorized in the structural variables;
- **MAT_Stiffness_Matrix.f90**: contains subroutine _STIFFNESS_MATRIX_, in which the element stiffness matrix is computed in the local reference frame, then converted to the global reference frame and finally assembled in the global stiffness matrix;
- **MAT_Load_Vector.f90**: contains subroutine _LOAD_VECTOR_, in which the nodal forces, the nodal torque, and distributed loads are eventually computed and applied by assembling the global forces vector adopting the same assembling procedure defined for the stiffness matrix;
- **MAT_BC.f90**: contains subroutine _BC_ROUTINE_, in which the geometrical boundary conditions are applied to the structures by removing the rows/columns of the global finite element stiffness matrix and forces vector. In this subroutine, only pinned/hinged/clamped boundary conditions can be applied;
- **SYS_LinearSystem.f90**: contains subroutine _LIN_SYS_LU_, in which an elementary Gaussian back forward elimination algorithm is implemented for the computation of the solution of the final system of equations;
- **POST_Postprocessor.f90**: contains subroutine _POSTPROCESSING_, in which the results are printed to video and file, by printing element by element, node by node, the displacement components obtained;

## Set up the analysis
The input files are related to the geometry, list node, cross-section and material properties and boundary conditions:
- **NODES_LIST.dat**: in this file, first the total number of nodes to define must be declared, and then in an ordered way one defines:
  
|  1       |     2   |    3    |   4  |   5  |  6   |
| -------- | ------- | ------- | ---- | ---- | ---- |
| NODE_ID  | X_COORD | Y_COORD |  FX  |  FY  |  MZ  |
  In the case of truss elements, the sixth column is not read since there is no rotational degree of freedom.


- **BC_LIST.dat**: in this file, first the total number of geometric boundary conditions to define must be declared, and then in an ordered way one defines. In this case, to prescribe a constraint, the number "0" must be used to constraint that DOF, and the number "1" to let the DOF be free

|  1                |    2   |    3   |       4    |
| ----------------- | ------ | ------ | ---------- |
| NODE_TO_APPLY_BC  | X_DISP | Y_DISP |  ROT_DISP  |
   In the case of truss elements, the fourth column is not read since there is no rotational degree of freedom.


    
- **CONNECTIVITY.dat**: in this file, in the first line the total number of finite elements to define and the element type (1 for truss, 2 for Bernoulli beam) must be declared, and then in an ordered way one defines:

|  1      |       2      |        3      |    4    |   5    |   6  |
| ------- | ------------ | ------------- | ------- | ------ | ---- |
| ELE_ID  |  FIRST_NODE  |  SECOND_NODE  |  YOUNG  |  AREA  |  J_Y |

    In the case of truss elements, the sixth column is not read since there is no rotational degree of freedom.



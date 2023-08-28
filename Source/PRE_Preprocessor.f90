SUBROUTINE PREPROCESSING_FRAME
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I
    REAL(8), DIMENSION(6) :: TEMP
    
    
   
    
    
    
    
    
    !==================================================================================
    ! Per ogni elemento, si procede in definitiva con il pre-processing
    ! Lettura di nodi, connectivity, materiale, forze e BC da input, memorizzazione nelle
    ! variabili globali e inizilizzazione di ogni elemento Bernoulli
    
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input della lista dei nodi
    OPEN  (unit = 50, file = 'INPUT/NODES_LIST.dat', status = 'old')
    
        READ(50,*) TOTAL_NODES
        
        DOF_TOTAL = DOF_NODE*TOTAL_NODES
        
        ALLOCATE(  GLOBAL_NODES(TOTAL_NODES,3)  )
        ALLOCATE(        FORCES(TOTAL_NODES,4)  )
        
        ! Memorizzo la lista dei nodi globali e delle forze nodali applicate
        DO I=1,TOTAL_NODES,1
           READ(50,*) TEMP(1:6)
           GLOBAL_NODES(I,1)=TEMP(1)   ! <-- ID del nodo
           GLOBAL_NODES(I,2)=TEMP(2)   ! <-- Coordinata X
           GLOBAL_NODES(I,3)=TEMP(3)   ! <-- Coordinata Y
                 FORCES(I,1)=TEMP(1)   ! <-- ID del nodo
                 FORCES(I,2)=TEMP(4)   ! <-- Componente X della forza nodale
                 FORCES(I,3)=TEMP(5)   ! <-- Componente Y della forza nodale
                 FORCES(I,4)=TEMP(6)   ! <-- Componente Z della momento nodale applicato
        END DO
        
        ! Conto il numeo di forze applicate
        DO I=1,TOTAL_NODES,1
           IF( FORCES(I,2) .NE. 0.0D0)   N_FORCES = N_FORCES +1
           IF( FORCES(I,3) .NE. 0.0D0)   N_FORCES = N_FORCES +1
        END DO
    
    CLOSE(50)
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input della CONNECTIVITY dei nodi
    OPEN  (unit = 50, file = 'INPUT/CONNECTIVITY.dat', status = 'old')
    
        READ(50,*) TOTAL_ELEMENTS
        ALLOCATE(  CONNECTIVITY(TOTAL_ELEMENTS,6)  )
        
        DO I=1,TOTAL_ELEMENTS,1        ! <-- L'indice I RAPPRESENTA L'ID DELL'ELEMENTO
           READ(50,*) TEMP(1:6)
           CONNECTIVITY(I,1)=TEMP(1)   ! <-- ID dell'elemento
           CONNECTIVITY(I,2)=TEMP(2)   ! <-- Indice I del primo nodo
           CONNECTIVITY(I,3)=TEMP(3)   ! <-- Indice J del secondo nodo
           CONNECTIVITY(I,4)=TEMP(4)   ! <-- Rigidezza dell'elemento ELE
           CONNECTIVITY(I,5)=TEMP(5)   ! <-- Area della sezione dell'elemento ELE
           CONNECTIVITY(I,6)=TEMP(6)   ! <-- Momento di inerzia J della sezione dell'elemento ELE
        END DO
    
    CLOSE(50)

    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input della lista di condizioni al contorno
    OPEN  (unit = 50, file = 'INPUT/BC_LIST.dat', status = 'old')
    
        READ(50,*) TOTAL_BC
        ALLOCATE(  BC_NODES(TOTAL_BC,4)  )
        
        DO I=1,TOTAL_BC,1
           READ(50,*) TEMP(1:4)
           BC_NODES(I,1)=TEMP(1)   ! <-- ID del nodo SUL QUALE E' APPLICATA LA BC
           BC_NODES(I,2)=TEMP(2)   ! <-- BC da applicare, spostamento orizzontale
           BC_NODES(I,3)=TEMP(3)   ! <-- BC da applicare, spostamento verticale 
           BC_NODES(I,4)=TEMP(4)   ! <-- BC da applicare, rotazione
        END DO
        
        DO I=1,TOTAL_BC,1
           IF( BC_NODES(I,2) .EQ. 0.0D0)   N_BC = N_BC +1
           IF( BC_NODES(I,3) .EQ. 0.0D0)   N_BC = N_BC +1
           IF( BC_NODES(I,4) .EQ. 0.0D0)   N_BC = N_BC +1
        END DO

    
    CLOSE(50)
    
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " READING INPUT NODES AND CONNECTIVITY:"
    WRITE(*,'(A19,I4)') "--> No. NODES   :", TOTAL_NODES
    WRITE(*,'(A19,I4)') "--> No. ELEMENTS:", TOTAL_ELEMENTS
    WRITE(*,'(A19,I4)') "--> No. DOFS    :", DOF_TOTAL
    WRITE(*,'(A19,I4)') "--> No. FORCES  :", N_FORCES
    WRITE(*,'(A19,I4)') "--> No. BCs     :", N_BC
    WRITE(*,*) 
    
    
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Si memorizzano le informazioni lette in ogni elemento FRAME
    
    ALLOCATE( FRAME_ELE(TOTAL_ELEMENTS) )
    
        DO I=1,TOTAL_ELEMENTS,1
            
            FRAME_ELE(I)%N_DOF     = DOF_NODE
            FRAME_ELE(I)%NODE_I(1) = GLOBAL_NODES( CONNECTIVITY(I,2), 2 )
            FRAME_ELE(I)%NODE_I(2) = GLOBAL_NODES( CONNECTIVITY(I,2), 3 )
            FRAME_ELE(I)%NODE_J(1) = GLOBAL_NODES( CONNECTIVITY(I,3), 2 )
            FRAME_ELE(I)%NODE_J(2) = GLOBAL_NODES( CONNECTIVITY(I,3), 3 )
            FRAME_ELE(I)%INDEX_I   = CONNECTIVITY(I,2)
            FRAME_ELE(I)%INDEX_J   = CONNECTIVITY(I,3)
            FRAME_ELE(I)%E         = CONNECTIVITY(I,4)
            FRAME_ELE(I)%A         = CONNECTIVITY(I,5)
            FRAME_ELE(I)%J         = CONNECTIVITY(I,6)
            
        END DO
        
    
     !------------------------------------------------------------------------------------------------------------------------------------------
     ! Si allocano le matrici di rigidezza, ora che è nota la dimensione del sistema finale
    
        
        
        WRITE(*,*) "**************************************************"
        WRITE(*,*) " MATRIX ALLOCATION:"
        WRITE(*,'(A22)',advance='NO') "   --> LOC. MATRIX:"
        ALLOCATE( K_ELE(2*DOF_NODE,2*DOF_NODE) )  
        WRITE(*,*) "   OK"
        WRITE(*,'(A22)',advance='NO') "   --> GLOB. MATRIX:"
        ALLOCATE( K_GLOB(DOF_TOTAL,DOF_TOTAL)  )
        WRITE(*,*) "   OK"
        WRITE(*,'(A22)',advance='NO') "   --> FRC VECTOR:"
        ALLOCATE( F(DOF_TOTAL)  )
        WRITE(*,*) "   OK"
        WRITE(*,'(A22)',advance='NO') "   --> DISP VECTOR:"
        ALLOCATE( UNK(DOF_TOTAL)  )
        WRITE(*,*) "   OK"
        
        K_GLOB  = 0.0D0
        F       = 0.0D0
        UNK     = 0.0D0
    
    END SUBROUTINE PREPROCESSING_FRAME
    


! *******************************************************************************************
! *******************************************************************************************
! *******************************************************************************************
! *******************************************************************************************




    SUBROUTINE PREPROCESSING_TRUSS
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I
    REAL(8), DIMENSION(5) :: TEMP
    
    
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input della lista dei nodi
    OPEN  (unit = 50, file = 'INPUT/NODES_LIST.dat', status = 'old')
    
        READ(50,*) TOTAL_NODES
        ALLOCATE(  GLOBAL_NODES(TOTAL_NODES,3)  )
        ALLOCATE(        FORCES(TOTAL_NODES,3)  )
        
        DO I=1,TOTAL_NODES,1
           READ(50,*) TEMP(1:5)
           GLOBAL_NODES(I,1)=TEMP(1)   ! <-- ID del nodo
           GLOBAL_NODES(I,2)=TEMP(2)   ! <-- Coordinata X
           GLOBAL_NODES(I,3)=TEMP(3)   ! <-- Coordinata Y
                 FORCES(I,1)=TEMP(1)   ! <-- ID del nodo
                 FORCES(I,2)=TEMP(4)   ! <-- Componente X della forza nodale
                 FORCES(I,3)=TEMP(5)   ! <-- Componente Y della forza nodale
        END DO
        
        DO I=1,TOTAL_NODES,1
           IF( FORCES(I,2) .NE. 0.0D0)   N_FORCES = N_FORCES +1
           IF( FORCES(I,3) .NE. 0.0D0)   N_FORCES = N_FORCES +1
        END DO
        
        
        DOF_TOTAL = DOF_NODE*TOTAL_NODES
    
    CLOSE(50)
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input della CONNECTIVITY dei nodi
    OPEN  (unit = 50, file = 'INPUT/CONNECTIVITY.dat', status = 'old')
    
        READ(50,*) TOTAL_ELEMENTS
        ALLOCATE(  CONNECTIVITY(TOTAL_ELEMENTS,5)  )
        
        DO I=1,TOTAL_ELEMENTS,1        ! <-- L'indice I RAPPRESENTA L'ID DELL'ELEMENTO
           READ(50,*) TEMP(1:5)
           CONNECTIVITY(I,1)=TEMP(1)   ! <-- ID dell'elemento
           CONNECTIVITY(I,2)=TEMP(2)   ! <-- Indice I del primo nodo
           CONNECTIVITY(I,3)=TEMP(3)   ! <-- Indice J del secondo nodo
           CONNECTIVITY(I,4)=TEMP(4)   ! <-- Rigidezza dell'elemento ELE
           CONNECTIVITY(I,5)=TEMP(5)   ! <-- Area della sezione dell'elemento ELE
        END DO
    
    CLOSE(50)

    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input della lista di condizioni al contorno
    OPEN  (unit = 50, file = 'INPUT/BC_LIST.dat', status = 'old')
    
        READ(50,*) TOTAL_BC
        ALLOCATE(  BC_NODES(TOTAL_BC,3)  )
        
        DO I=1,TOTAL_BC,1
           READ(50,*) TEMP(1:3)
           BC_NODES(I,1)=TEMP(1)   ! <-- ID del nodo SUL QUALE E' APPLICATA LA BC
           BC_NODES(I,2)=TEMP(2)   ! <-- BC da applicare
           BC_NODES(I,3)=TEMP(3)   ! <-- BC da applicare
        END DO
        
        DO I=1,TOTAL_BC,1
           IF( BC_NODES(I,2) .EQ. 0.0D0)   N_BC = N_BC +1
           IF( BC_NODES(I,3) .EQ. 0.0D0)   N_BC = N_BC +1
        END DO

    
    CLOSE(50)
    
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " READING INPUT NODES AND CONNECTIVITY:"
    WRITE(*,'(A19,I4)') "--> No. NODES   :", TOTAL_NODES
    WRITE(*,'(A19,I4)') "--> No. ELEMENTS:", TOTAL_ELEMENTS
    WRITE(*,'(A19,I4)') "--> No. DOFS    :", DOF_TOTAL
    WRITE(*,'(A19,I4)') "--> No. FORCES  :", N_FORCES
    WRITE(*,'(A19,I4)') "--> No. BCs     :", N_BC
    WRITE(*,*) 
    
    
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Si memorizzano le informazioni lette in ogni elemento TRUSS
    
    ALLOCATE( TRUSS_ELE(TOTAL_ELEMENTS) )
    
        DO I=1,TOTAL_ELEMENTS,1
            
            TRUSS_ELE(I)%N_DOF     = DOF_NODE
            TRUSS_ELE(I)%NODE_I(1) = GLOBAL_NODES( CONNECTIVITY(I,2), 2 )
            TRUSS_ELE(I)%NODE_I(2) = GLOBAL_NODES( CONNECTIVITY(I,2), 3 )
            TRUSS_ELE(I)%NODE_J(1) = GLOBAL_NODES( CONNECTIVITY(I,3), 2 )
            TRUSS_ELE(I)%NODE_J(2) = GLOBAL_NODES( CONNECTIVITY(I,3), 3 )
            TRUSS_ELE(I)%INDEX_I   = CONNECTIVITY(I,2)
            TRUSS_ELE(I)%INDEX_J   = CONNECTIVITY(I,3)
            TRUSS_ELE(I)%E         = CONNECTIVITY(I,4)
            TRUSS_ELE(I)%A         = CONNECTIVITY(I,5)
            
        END DO
        
    
     !------------------------------------------------------------------------------------------------------------------------------------------
     ! Si allocano le matrici di rigidezza, ora che è nota la dimensione del sistema finale
    
        
        
        WRITE(*,*) "**************************************************"
        WRITE(*,*) " MATRIX ALLOCATION:"
        WRITE(*,'(A22)',advance='NO') "   --> LOC. MATRIX:"
        ALLOCATE( K_ELE(2*DOF_NODE,2*DOF_NODE) )  
        WRITE(*,*) " OK"
        WRITE(*,'(A22)',advance='NO') "   --> GLOB. MATRIX:"
        ALLOCATE( K_GLOB(DOF_TOTAL,DOF_TOTAL)  )
        WRITE(*,*) " OK"
        WRITE(*,'(A22)',advance='NO') "   --> FRC VECTOR:"
        ALLOCATE( F(DOF_TOTAL)  )
        WRITE(*,*) " OK"
        WRITE(*,'(A22)',advance='NO') "   --> DISP VECTOR:"
        ALLOCATE( UNK(DOF_TOTAL)  )
        WRITE(*,*) " OK"
        
        K_GLOB  = 0.0D0
        F       = 0.0D0
        UNK     = 0.0D0
    
    
    END SUBROUTINE PREPROCESSING_TRUSS
    
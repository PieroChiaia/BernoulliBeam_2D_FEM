SUBROUTINE LOAD_VECTOR
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I, J, II, NODE
    REAL(8) :: FxI, FyI, Mz
    
    WRITE(*,*) ""
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " LOAD VECTOR COMPUTATION:"
    
    
    
    
    !==================================================================================
    ! Per ogni elemento FRAME, si procede con il calcolo del vettore delle forze:
    ! Nel caso di forze/momenti concentrati, si tratta solo di inserirli nel vett. forze
    ! Nel caso di pressioni distribuite sull'asse di trave, vanno integrate e assemblate
    
    F = 0
    
    DO NODE=1,TOTAL_NODES,1
        
        WRITE(*,'(A19,I2)') "   --> F, NODE:", NODE
        
           I   = FORCES(NODE,1)
           FxI = FORCES(NODE,2)
           FyI = FORCES(NODE,3)
           Mz = FORCES(NODE,4)
        
        WRITE(*,'(A13,I3)')    "    -  I:", I
        WRITE(*,'(A13,E12.5)') "    - Fx:", FxI
        WRITE(*,'(A13,E12.5)') "    - Fy:", FyI
        WRITE(*,'(A13,E12.5)') "    - Mz:", Mz

        !!******************************************************************
        ! Assemblaggio del vettore delle forze
        
        WRITE(*,'(A23,I4)', ADVANCE='NO') "   (*) ASSEMBLING, NODE:", NODE
        
           F(3*I-2)  = F(3*I-2) +  FxI
           F(3*I-1)  = F(3*I-1) +  FyI
           F(3*I  )  = F(3*I  ) +  Mz
        
        WRITE(*,*) "OK"
        WRITE(*,*) ""
        
    END DO
        
        !******************************************************************
        ! Stampiamo il vettore delle forze su un file per verificare la correttezza della procedura
        OPEN  (unit = 70, file = 'RESULTS/FRC.dat')
        
        DO II=1,DOF_TOTAL,1
          WRITE(70,'(E18.9)')  F(II)
        END DO
        
        CLOSE( 70 )
        
    
    END SUBROUTINE LOAD_VECTOR
    

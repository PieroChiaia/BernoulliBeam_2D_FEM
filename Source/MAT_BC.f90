SUBROUTINE BC_ROUTINE_FRAME
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I, K, II, JJ, ID_BC
    INTEGER(4) :: IK,IL
    
    WRITE(*,*) ""
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " BC APPLICATION:"
    
    
    
    
    !==================================================================================
    ! Per ogni BC richiesta, si procede con la manipolazione della mat rigidezza
    
    
    DO ID_BC=1,TOTAL_BC,1
        
        WRITE(*,'(A19,I2)') "   --> BC, ID:", ID_BC
        
        ! Individuo il nodo in cui è applicata la BC, i dof saranno, per costruzione del codice 3*I-2, 3I-1, 3I
        I   = BC_NODES(ID_BC,1) 
        
        !******************************************************************
        ! Applico le BC al DOF_Ux se bloccato
        IF ( BC_NODES(ID_BC,2) .EQ. 0.0D0 ) THEN
            
            IK = 3*I-2
            
            DO K=1,DOF_TOTAL,1
                IF ( K .EQ. IK ) THEN
                    IF( ABS(K_GLOB( IK, IK )) .LE. 1D-8 ) THEN
                        K_GLOB( IK, IK )  =  1D20
                    ELSE
                        K_GLOB( IK, IK )  = K_GLOB( IK, IK ) * 10D10
                    ENDIF
                ELSE
                    K_GLOB( IK,K )  =  0;
                    K_GLOB( K,IK)   =  0;
                ENDIF
            END DO
        ENDIF
        
        !******************************************************************
        ! Applico le BC al DOF_Uy se bloccato
        IF ( BC_NODES(ID_BC,3) .EQ. 0.0D0 ) THEN
            
            IK = 3*I-1
            
            DO K=1,DOF_TOTAL,1
                IF ( K .EQ. IK ) THEN
                    IF( ABS(K_GLOB( IK, IK )) .LE. 1D-8 ) THEN
                        K_GLOB( IK, IK )  =  1D20
                    ELSE
                        K_GLOB( IK, IK )  = K_GLOB( IK, IK ) * 10D10
                    ENDIF
                ELSE
                    K_GLOB( IK,K )  =  0;
                    K_GLOB( K,IK)   =  0;
                ENDIF
            END DO
        ENDIF
        
        !******************************************************************
        ! Applico le BC al DOF_Rz se bloccato
        IF ( BC_NODES(ID_BC,4) .EQ. 0.0D0 ) THEN
            
            IK = 3*I
            
            DO K=1,DOF_TOTAL,1
                IF ( K .EQ. IK ) THEN
                    IF( ABS(K_GLOB( IK, IK )) .LE. 1D-8 ) THEN
                        K_GLOB( IK, IK )  =  1D20
                    ELSE
                        K_GLOB( IK, IK )  = K_GLOB( IK, IK ) * 10D10
                    ENDIF
                ELSE
                    K_GLOB( IK,K )  =  0;
                    K_GLOB( K,IK)   =  0;
                ENDIF
            END DO
        ENDIF
    
    END DO
    
    
    
        !******************************************************************
        ! Stampiamo la matrice di rigidezza su un file per verificare la correttezza della procedura
        OPEN  (unit = 80, file = 'RESULTS/K_MAT_BC.dat')
        
        DO II=1,DOF_TOTAL,1
            DO JJ=1,DOF_TOTAL,1
                WRITE(80,'(E18.9)',ADVANCE='NO')  K_GLOB(II,JJ)
            END DO
            WRITE(80,*) ""
        END DO
        
        CLOSE( 80 )
        
    
    END SUBROUTINE BC_ROUTINE_FRAME
    
    

! *******************************************************************************************
! *******************************************************************************************
! *******************************************************************************************
! *******************************************************************************************



    SUBROUTINE BC_ROUTINE_TRUSS
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I, K, II, JJ, ID_BC
    INTEGER(4) :: IK,IL
    
    WRITE(*,*) ""
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " BC APPLICATION:"
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lavoriamo sulla matrice di rigidezza 
    
    DO ID_BC=1,TOTAL_BC,1
        
        WRITE(*,'(A19,I2)') "   --> BC, ID:", ID_BC
        
        I   = BC_NODES(ID_BC,1) ! <-- Individuo il nodo in cui è applicata la BC, i dof saranno, per costruzione del codice 2*I-1 e 2I
        
        
        IF ( BC_NODES(ID_BC,2) .EQ. 0.0D0 ) THEN
            
            IK = 2*I-1
            
            DO K=1,DOF_TOTAL,1
                IF ( K .EQ. IK ) THEN
                    IF( ABS(K_GLOB( IK, IK )) .LE. 1D-8 ) THEN
                        K_GLOB( IK, IK )  =  1D20
                    ELSE
                        K_GLOB( IK, IK )  = K_GLOB( IK, IK ) * 10D10
                    ENDIF
                ELSE
                    K_GLOB( IK,K )  =  0;
                    K_GLOB( K,IK)   =  0;
                ENDIF
            END DO
        ENDIF
        
        IF ( BC_NODES(ID_BC,3) .EQ. 0.0D0 ) THEN
            
            IK = 2*I
            
            DO K=1,DOF_TOTAL,1
                IF ( K .EQ. IK ) THEN
                    IF( ABS(K_GLOB( IK, IK )) .LE. 1D-8 ) THEN
                        K_GLOB( IK, IK )  =  1D20
                    ELSE
                        K_GLOB( IK, IK )  = K_GLOB( IK, IK ) * 10D10
                    ENDIF
                ELSE
                    K_GLOB( IK,K )  =  0;
                    K_GLOB( K,IK)   =  0;
                ENDIF
            END DO
        ENDIF
    
    END DO
    
    
        ! Stampiamo la matrice di rigidezza su un file per verificare la correttezza della procedura
        OPEN  (unit = 80, file = 'RESULTS/K_MAT_BC.dat')
        
        DO II=1,DOF_TOTAL,1
            DO JJ=1,DOF_TOTAL,1
                WRITE(80,'(E18.9)',ADVANCE='NO')  K_GLOB(II,JJ)
            END DO
            WRITE(80,*) ""
        END DO
        
        CLOSE( 80 )
        
    
    END SUBROUTINE BC_ROUTINE_TRUSS
    
    
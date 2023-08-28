SUBROUTINE STIFFNESS_MATRIX_FRAME
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I, J, II,JJ, ELE
    REAL(8) :: X1,Y1,X2,Y2
    REAL(8) :: E, A, L, Iy, EA, EJ
    REAL(8) :: Theta
    
    WRITE(*,*) ""
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " STIFFNESS MATRIX COMPUTATION:"
    
    
    !==================================================================================
    ! Per ogni elemento FRAME, si procede con il calcolo della matrice di rigidezza:
    ! Si costruisce la matrice di rigidezza locale elemento per elemento, si applica
    ! la matrice di trasformazione per LOC->GLB, e si assembla secondo procedura
    
    K_GLOB = 0.0D0
    
    DO ELE=1,TOTAL_ELEMENTS,1
        
        WRITE(*,'(A19,I2)') "   --> K_LOC, ELE:", ELE
        
           X1 = 0.0D0
           Y1 = 0.0D0
           X2 = 0.0D0
           Y2 = 0.0D0
            I = 0.0D0
            J = 0.0D0
            E = 0.0D0
            A = 0.0D0
        Theta = 0.0D0
        K_ELE = 0.0D0
        !------------------------------------------------------------------------------------------------------------------------------------------
        ! Proprietà meccaniche e geometriche dell'elemento per il calcolo del nucleo
        
        X1 = FRAME_ELE(ELE)%NODE_I(1)
        Y1 = FRAME_ELE(ELE)%NODE_I(2)
        X2 = FRAME_ELE(ELE)%NODE_J(1)
        Y2 = FRAME_ELE(ELE)%NODE_J(2)
         I = FRAME_ELE(ELE)%INDEX_I  
         J = FRAME_ELE(ELE)%INDEX_J  
         E = FRAME_ELE(ELE)%E        
         A = FRAME_ELE(ELE)%A  
        Iy = FRAME_ELE(ELE)%J  
        
        L = SQRT((X2-X1)**(2.) + (Y2-Y1)**(2.))
               
        IF( ABS(X2-X1) < 1D-10 ) THEN
            IF( (Y2-Y1) > 0.0D0 ) THEN
                Theta = PI/2.
            ELSEIF ( (Y2-Y1) < 0.0D0 ) THEN
                Theta = -PI/2.
            ENDIF
        ELSE
            Theta = ATAN((Y2-Y1)/(X2-X1))
        ENDIF
        
        WRITE(*,'(A13,E12.5)') "    - E:", E
        WRITE(*,'(A13,E12.5)') "    - A:", A
        WRITE(*,'(A13,E12.5)') "    - L:", L
        WRITE(*,'(A13,F12.5)') "    - t:", Theta*180/(PI)
        
        CALL K_NUC_FRAME( K_ELE, E,A,L,Iy, Theta)
        
        
        !------------------------------------------------------------------------------------------------------------------------------------------
        ! Assemblaggio della matrice di rigidezza
        
        WRITE(*,'(A23,I4)', ADVANCE='NO') "   (*) ASSEMBLING, ELE:", ELE
        
        K_GLOB(3*I-2 , 3*I-2)  = K_GLOB(3*I-2 , 3*I-2) +  K_ELE(1,1)
        K_GLOB(3*I-2 , 3*I-1)  = K_GLOB(3*I-2 , 3*I-1) +  K_ELE(1,2)
        K_GLOB(3*I-2 , 3*I  )  = K_GLOB(3*I-2 , 3*I  ) +  K_ELE(1,3)
        K_GLOB(3*I-2 , 3*J-2)  = K_GLOB(3*I-2 , 3*J-2) +  K_ELE(1,4)
        K_GLOB(3*I-2 , 3*J-1)  = K_GLOB(3*I-2 , 3*J-1) +  K_ELE(1,5)
        K_GLOB(3*I-2 , 3*J  )  = K_GLOB(3*I-2 , 3*J  ) +  K_ELE(1,6)
        
        K_GLOB(3*I-1 , 3*I-2)  = K_GLOB(3*I-1 , 3*I-2) +  K_ELE(2,1)
        K_GLOB(3*I-1 , 3*I-1)  = K_GLOB(3*I-1 , 3*I-1) +  K_ELE(2,2)
        K_GLOB(3*I-1 , 3*I  )  = K_GLOB(3*I-1 , 3*I  ) +  K_ELE(2,3)
        K_GLOB(3*I-1 , 3*J-2)  = K_GLOB(3*I-1 , 3*J-2) +  K_ELE(2,4)
        K_GLOB(3*I-1 , 3*J-1)  = K_GLOB(3*I-1 , 3*J-1) +  K_ELE(2,5)
        K_GLOB(3*I-1 , 3*J  )  = K_GLOB(3*I-1 , 3*J  ) +  K_ELE(2,6)
        
        K_GLOB(3*I   , 3*I-2)  = K_GLOB(3*I   , 3*I-2) +  K_ELE(3,1)
        K_GLOB(3*I   , 3*I-1)  = K_GLOB(3*I   , 3*I-1) +  K_ELE(3,2)
        K_GLOB(3*I   , 3*I  )  = K_GLOB(3*I   , 3*I  ) +  K_ELE(3,3)
        K_GLOB(3*I   , 3*J-2)  = K_GLOB(3*I   , 3*J-2) +  K_ELE(3,4)
        K_GLOB(3*I   , 3*J-1)  = K_GLOB(3*I   , 3*J-1) +  K_ELE(3,5)
        K_GLOB(3*I   , 3*J  )  = K_GLOB(3*I   , 3*J  ) +  K_ELE(3,6)
        
        K_GLOB(3*J-2 , 3*I-2)  = K_GLOB(3*J-2 , 3*I-2) +  K_ELE(4,1)
        K_GLOB(3*J-2 , 3*I-1)  = K_GLOB(3*J-2 , 3*I-1) +  K_ELE(4,2)
        K_GLOB(3*J-2 , 3*I  )  = K_GLOB(3*J-2 , 3*I  ) +  K_ELE(4,3)
        K_GLOB(3*J-2 , 3*J-2)  = K_GLOB(3*J-2 , 3*J-2) +  K_ELE(4,4)
        K_GLOB(3*J-2 , 3*J-1)  = K_GLOB(3*J-2 , 3*J-1) +  K_ELE(4,5)
        K_GLOB(3*J-2 , 3*J  )  = K_GLOB(3*J-2 , 3*J  ) +  K_ELE(4,6)
        
        K_GLOB(3*J-1 , 3*I-2)  = K_GLOB(3*J-1 , 3*I-2) +  K_ELE(5,1)
        K_GLOB(3*J-1 , 3*I-1)  = K_GLOB(3*J-1 , 3*I-1) +  K_ELE(5,2)
        K_GLOB(3*J-1 , 3*I  )  = K_GLOB(3*J-1 , 3*I  ) +  K_ELE(5,3)
        K_GLOB(3*J-1 , 3*J-2)  = K_GLOB(3*J-1 , 3*J-2) +  K_ELE(5,4)
        K_GLOB(3*J-1 , 3*J-1)  = K_GLOB(3*J-1 , 3*J-1) +  K_ELE(5,5)
        K_GLOB(3*J-1 , 3*J  )  = K_GLOB(3*J-1 , 3*J  ) +  K_ELE(5,6)
        
        K_GLOB(3*J   , 3*I-2)  = K_GLOB(3*J   , 3*I-2) +  K_ELE(6,1)
        K_GLOB(3*J   , 3*I-1)  = K_GLOB(3*J   , 3*I-1) +  K_ELE(6,2)
        K_GLOB(3*J   , 3*I  )  = K_GLOB(3*J   , 3*I  ) +  K_ELE(6,3)
        K_GLOB(3*J   , 3*J-2)  = K_GLOB(3*J   , 3*J-2) +  K_ELE(6,4)
        K_GLOB(3*J   , 3*J-1)  = K_GLOB(3*J   , 3*J-1) +  K_ELE(6,5)
        K_GLOB(3*J   , 3*J  )  = K_GLOB(3*J   , 3*J  ) +  K_ELE(6,6)
                                 
        
        WRITE(*,*) "OK"
        WRITE(*,*) ""
        
    END DO
    
        ! Stampiamo la matrice di rigidezza su un file per verificare la correttezza della procedura
        OPEN  (unit = 60, file = 'RESULTS/K_MAT.dat')
        
        DO II=1,DOF_TOTAL,1
            DO JJ=1,DOF_TOTAL,1
                WRITE(60,'(E18.9)',ADVANCE='NO')  K_GLOB(II,JJ)
            END DO
            WRITE(60,*) ""
        END DO
        
        CLOSE( 60 )
        
    
    END SUBROUTINE STIFFNESS_MATRIX_FRAME
    
    
    SUBROUTINE K_NUC_FRAME( K, E,A,L,J, Theta)
    
        REAL(8) :: E,A,L,J, COST
        REAL(8) :: Theta
        REAL(8) :: K(6,6)
        REAL(8) :: K_loc(6,6)
        REAL(8) :: R(6,6)
        
        R = 0.0D0
        
        ! Definizione della matrice di trasformazione
        R(1,1) =  COS(THETA)
        R(1,2) =  SIN(THETA)
        
        R(2,1) = -SIN(THETA)
        R(2,2) =  COS(THETA)
        
        R(3,3) =  1.0D0
        
        R(4,4) =  COS(THETA)
        R(4,5) =  SIN(THETA)
        
        R(5,4) = -SIN(THETA)
        R(5,5) =  COS(THETA)
        
        R(6,6) =  1.0D0
        
        
        
        ! Definizione della matrice di rigidezza locale
        K_loc(1,1) =   A*L**(2.)
        K_loc(1,2) =   0.0D0
        K_loc(1,3) =   0.0D0
        K_loc(1,4) =  -A*L**(2.)
        K_loc(1,5) =   0.0D0
        K_loc(1,6) =   0.0D0
                     
        K_loc(2,1) =   0.0D0
        K_loc(2,2) =  12.0D0*J
        K_loc(2,3) =   6.0D0*L*J
        K_loc(2,4) =   0.0D0
        K_loc(2,5) = -12.0D0*J 
        K_loc(2,6) =   6.0D0*L*J
        
        K_loc(3,1) =   0.0D0
        K_loc(3,2) =   6.0D0*L*J
        K_loc(3,3) =   4.0D0*J*L**(2.)
        K_loc(3,4) =   0.0D0
        K_loc(3,5) =  -6.0D0*L*J
        K_loc(3,6) =   2.0D0*J*L**(2.)
        
        K_loc(4,1) =  -A*L**(2.)
        K_loc(4,2) =   0.0D0
        K_loc(4,3) =   0.0D0
        K_loc(4,4) =   A*L**(2.)
        K_loc(4,5) =   0.0D0
        K_loc(4,6) =   0.0D0
        
        K_loc(5,1) =   0.0D0
        K_loc(5,2) = -12.0D0*J
        K_loc(5,3) =  -6.0D0*L*J
        K_loc(5,4) =   0.0D0
        K_loc(5,5) =  12.0D0*J 
        K_loc(5,6) =  -6.0D0*L*J
        
        K_loc(6,1) =   0.0D0
        K_loc(6,2) =   6.0D0*L*J
        K_loc(6,3) =   2.0D0*J*L**(2.)
        K_loc(6,4) =   0.0D0
        K_loc(6,5) =  -6.0D0*L*J
        K_loc(6,6) =   4.0D0*J*L**(2.)
        
        COST = E/( L**(3.) )
        
        
        ! Costruzione della matrice di rigidezza globale
        
        K = MATMUL(TRANSPOSE(R), MATMUL(K_loc,R) )
        
        K = COST*K
        
    END SUBROUTINE K_NUC_FRAME





! *******************************************************************************************
! *******************************************************************************************
! *******************************************************************************************
! *******************************************************************************************




    SUBROUTINE STIFFNESS_MATRIX_TRUSS
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I, J, II,JJ, ELE
    REAL(8) :: X1,Y1,X2,Y2
    REAL(8) :: E
    REAL(8) :: A
    REAL(8) :: L
    REAL(8) :: Theta
    
    WRITE(*,*) ""
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " STIFFNESS MATRIX COMPUTATION:"
    
    K_GLOB = 0.0D0
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! PER OGNI ELEMENTO TRUSS, SCRIVIAMO E CALCOLIAMO LA SUA MATRICE DI RIGIDEZZA
    
    DO ELE=1,TOTAL_ELEMENTS,1
        
        WRITE(*,'(A19,I2)') "   --> K_LOC, ELE:", ELE
        
           X1 = 0.0D0
           Y1 = 0.0D0
           X2 = 0.0D0
           Y2 = 0.0D0
            I = 0.0D0
            J = 0.0D0
            E = 0.0D0
            A = 0.0D0
        Theta = 0.0D0
        K_ELE = 0.0D0
        !------------------------------------------------------------------------------------------------------------------------------------------
        ! Proprietà meccaniche e geometriche dell'elemento per il calcolo del nucleo
        
        X1 = TRUSS_ELE(ELE)%NODE_I(1)
        Y1 = TRUSS_ELE(ELE)%NODE_I(2)
        X2 = TRUSS_ELE(ELE)%NODE_J(1)
        Y2 = TRUSS_ELE(ELE)%NODE_J(2)
         I = TRUSS_ELE(ELE)%INDEX_I  
         J = TRUSS_ELE(ELE)%INDEX_J  
         E = TRUSS_ELE(ELE)%E        
         A = TRUSS_ELE(ELE)%A  
        
        L = SQRT((X2-X1)**(2.) + (Y2-Y1)**(2.))
               
        IF( ABS(X2-X1) < 1D-10 ) THEN
            IF( (Y2-Y1) > 0.0D0 ) THEN
                Theta = PI/2.
            ELSEIF ( (Y2-Y1) < 0.0D0 ) THEN
                Theta = -PI/2.
            ENDIF
        ELSE
            Theta = ATAN((Y2-Y1)/(X2-X1))
        ENDIF
        
        WRITE(*,'(A13,E12.5)') "    - E:", E
        WRITE(*,'(A13,E12.5)') "    - A:", A
        WRITE(*,'(A13,E12.5)') "    - L:", L
        WRITE(*,'(A13,F12.5)') "    - t:", Theta*180/(PI)
        
        CALL K_NUC_TRUSS( K_ELE, E,A,L,Theta)
        
        !------------------------------------------------------------------------------------------------------------------------------------------
        ! Assemblaggio della matrice di rigidezza
        
        WRITE(*,'(A23,I4)', ADVANCE='NO') "   (*) ASSEMBLING, ELE:", ELE
        
        K_GLOB(2*I-1 , 2*I-1)  = K_GLOB(2*I-1 , 2*I-1) +  K_ELE(1,1)
        K_GLOB(2*I-1 , 2*I  )  = K_GLOB(2*I-1 , 2*I  ) +  K_ELE(1,2)
        K_GLOB(2*I-1 , 2*J-1)  = K_GLOB(2*I-1 , 2*J-1) +  K_ELE(1,3)
        K_GLOB(2*I-1 , 2*J  )  = K_GLOB(2*I-1 , 2*J  ) +  K_ELE(1,4)
                                 
        K_GLOB(2*I   , 2*I-1)  = K_GLOB(2*I   , 2*I-1) +  K_ELE(2,1)
        K_GLOB(2*I   , 2*I  )  = K_GLOB(2*I   , 2*I  ) +  K_ELE(2,2)
        K_GLOB(2*I   , 2*J-1)  = K_GLOB(2*I   , 2*J-1) +  K_ELE(2,3)
        K_GLOB(2*I   , 2*J  )  = K_GLOB(2*I   , 2*J  ) +  K_ELE(2,4)
                                                     
        K_GLOB(2*J-1 , 2*I-1)  = K_GLOB(2*J-1 , 2*I-1) +  K_ELE(3,1)
        K_GLOB(2*J-1 , 2*I  )  = K_GLOB(2*J-1 , 2*I  ) +  K_ELE(3,2)
        K_GLOB(2*J-1 , 2*J-1)  = K_GLOB(2*J-1 , 2*J-1) +  K_ELE(3,3)
        K_GLOB(2*J-1 , 2*J  )  = K_GLOB(2*J-1 , 2*J  ) +  K_ELE(3,4)
                                                     
        K_GLOB(2*J   , 2*I-1)  = K_GLOB(2*J   , 2*I-1) +  K_ELE(4,1)
        K_GLOB(2*J   , 2*I  )  = K_GLOB(2*J   , 2*I  ) +  K_ELE(4,2)
        K_GLOB(2*J   , 2*J-1)  = K_GLOB(2*J   , 2*J-1) +  K_ELE(4,3)
        K_GLOB(2*J   , 2*J  )  = K_GLOB(2*J   , 2*J  ) +  K_ELE(4,4)
        
        WRITE(*,*) "OK"
        WRITE(*,*) ""
        
    END DO
    
        ! Stampiamo la matrice di rigidezza su un file per verificare la correttezza della procedura
        OPEN  (unit = 60, file = 'RESULTS/K_MAT.dat')
        
        DO II=1,DOF_TOTAL,1
            DO JJ=1,DOF_TOTAL,1
                WRITE(60,'(E18.9)',ADVANCE='NO')  K_GLOB(II,JJ)
            END DO
            WRITE(60,*) ""
        END DO
        
        CLOSE( 60 )
        
    
    END SUBROUTINE STIFFNESS_MATRIX_TRUSS
    
    
    SUBROUTINE K_NUC_TRUSS( K, E,A,L,THETA)
    
        REAL(8) :: E
        REAL(8) :: A
        REAL(8) :: L
        REAL(8) :: Theta
        REAL(8) :: K(4,4)
        REAL(8) :: K_loc(2,2)
        REAL(8) :: R(2,4)
        
        ! Definizione della matrice di trasformazione
        R(1,1) = COS(THETA)
        R(1,2) = SIN(THETA)
        R(1,3) = 0.0D0
        R(1,4) = 0.0D0
        
        R(2,1) = 0.0D0
        R(2,2) = 0.0D0
        R(2,3) = COS(THETA)
        R(2,4) = SIN(THETA)
        
        ! Definizione della matrice di rigidezza locale
        K_loc(1,1) =  E*A/L
        K_loc(1,2) = -E*A/L
        K_loc(2,1) = -E*A/L
        K_loc(2,2) =  E*A/L
        
        ! Costruzione della matrice di rigidezza globale
        
        K = MATMUL(TRANSPOSE(R), MATMUL(K_loc,R) )
        
    END SUBROUTINE K_NUC_TRUSS
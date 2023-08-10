SUBROUTINE POSTPROCESSING
    
    USE MOD_DATA
    
    IMPLICIT NONE
    
    INTEGER(4) :: I, J, ELE, ELE_ID,NODE_ID
    REAL(8) :: X1,Y1,X2,Y2
    REAL(8) :: UX1,UY1,RZ1,UX2,UY2,RZ2
        
    WRITE(*,*) ""
    WRITE(*,*) "**************************************************"
    WRITE(*,*) " POST PROCESSING - NODAL QUANTITIES:"
    
    
    
    !==================================================================================
    ! Per ogni elemento FRAME, si procede in definitiva con il post
    ! processing in termini di spostamento ottenuto
    
    OPEN  (unit = 50, file = 'RESULTS/RESULTS.dat', status = 'unknown')
    
    IF(ABS(UX1) .EQ. 0.0D0 ) UX1=0.0D0
    IF(ABS(UY1) .EQ. 0.0D0 ) UY1=0.0D0
    IF(ABS(UX2) .EQ. 0.0D0 ) UX2=0.0D0
    IF(ABS(UY2) .EQ. 0.0D0 ) UY2=0.0D0
    
    WRITE(*,'(1A6,1A10,1A12,3A16)') "ELE", "NODE ID","X", "Y", "UX","UY"
    
    DO ELE=1,TOTAL_ELEMENTS,1
        
        !******************************************************************
        ! Individuo coordinate dei nodi del post-processing e indici ler i DOF
        X1 = FRAME_ELE(ELE)%NODE_I(1)
        Y1 = FRAME_ELE(ELE)%NODE_I(2)
        X2 = FRAME_ELE(ELE)%NODE_J(1)
        Y2 = FRAME_ELE(ELE)%NODE_J(2)
         I = FRAME_ELE(ELE)%INDEX_I  
         J = FRAME_ELE(ELE)%INDEX_J  
         
        UX1 = UNK(3*I-2)
        UY1 = UNK(3*I-1)
        RZ1 = UNK(3*I  )
        UX2 = UNK(3*J-2)
        UY2 = UNK(3*J-1)
        RZ2 = UNK(3*J  )
        
        !******************************************************************
        ! Stampa a video e file dei DOF
        
        WRITE(*, '(1I5,1I8,1F20.8,1F16.8,3E18.9)')  ELE, I, X1,Y1, UX1,UY1,RZ1
        WRITE(50,'(1I5,1I8,1F20.8,1F16.8,3E18.9)')  ELE, I, X1,Y1, UX1,UY1,RZ1
        WRITE(* ,'(1I5,1I8,1F20.8,1F16.8,3E18.9)')  ELE, J, X2,Y2, UX2,UY2,RZ2
        WRITE(50,'(1I5,1I8,1F20.8,1F16.8,3E18.9)')  ELE, J, X2,Y2, UX2,UY2,RZ2
        WRITE(*,*) ""
        
    END DO
    
    CLOSE(50)
    
    END SUBROUTINE POSTPROCESSING
    
 PROGRAM PC_FRAMEFEM2D
    
    
     USE MOD_DATA
     
     IMPLICIT NONE
     
     
     WRITE(*,*) ""
	 WRITE(*,*) "+************************************************+"
	 WRITE(*,*) "|            FEM 2D - FRAME ELEMENTS             |"
	 WRITE(*,*) "|                                                |"
	 WRITE(*,*) "|             Linear static analysis             |"
	 WRITE(*,*) "|                Educational code                |"
	 WRITE(*,*) "|              Piero Chiaia - MUL2               |"
	 WRITE(*,*) "+************************************************+"
	 WRITE(*,*) ""
     
     
    ! Input vengono letti, e gli elementi FRAME vengono generati, allocati e memorizzati
     CALL PREPROCESSING
      
    
    ! Si genera la matrice di rigidezza, dalla locale si assembla direttamente la globale
     CALL STIFFNESS_MATRIX
      
     
    ! Si genera il vettore dei carichi, dal locale si assembla direttamente il globale
     CALL LOAD_VECTOR
      
 
    ! Si applicano le condizioni al contorno
     CALL BC_ROUTINE
      
 
    
    ! Si risolve il sistema lineare attraverso il BiCGStab
     CALL LIN_SYS_LU
      
     
    ! Si procede con il post-processing
     CALL POSTPROCESSING
     write(*,*) ""
 
 END PROGRAM PC_FRAMEFEM2D

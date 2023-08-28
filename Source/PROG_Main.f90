 PROGRAM PC_FRAMEFEM2D
    
    
     USE MOD_DATA
     
     IMPLICIT NONE
     
     
    WRITE(*,*) ""
	 WRITE(*,*) "+************************************************+"
	 WRITE(*,*) "|            FEM 1D - FRAME ELEMENTS             |"
	 WRITE(*,*) "|                                                |"
	 WRITE(*,*) "|             Linear static analysis             |"
	 WRITE(*,*) "|                Educational code                |"
	 WRITE(*,*) "|              Piero Chiaia - MUL2               |"
	 WRITE(*,*) "+************************************************+"
	 WRITE(*,*) ""
     

    ! Si seleziona il tipo di elemento tramite lettura da input:
     OPEN  (unit = 50, file = 'INPUT/CONNECTIVITY.dat', status = 'old')
        READ(50,*) TEMP_READ, ELEM_TYPE
    CLOSE(50)

     SELECT CASE (ELEM_TYPE)
        
        !== ELEMENTI DI TIPO TRUSS ==!
        CASE(1)
         WRITE(*,*) ""
         WRITE(*,*) "**************************************************"
         WRITE(*,*) " --> STATIC ANALYSIS WITH TRUSS ELEMENTS <--"
        DOF_NODE = 2
        ! Input vengono letti, e gli elementi TRUSS vengono generati, allocati e memorizzati
         CALL PREPROCESSING_TRUSS
        ! Si genera la matrice di rigidezza, dalla locale si assembla direttamente la globale
         CALL STIFFNESS_MATRIX_TRUSS
        ! Si genera il vettore dei carichi, dal locale si assembla direttamente il globale
         CALL LOAD_VECTOR_TRUSS
        ! Si applicano le condizioni al contorno
         CALL BC_ROUTINE_TRUSS
        ! Si risolve il sistema lineare attraverso il BiCGStab
         CALL LIN_SYS_LU
        ! Si procede con il post-processing
         CALL POSTPROCESSING_TRUSS
     

        !== ELEMENTI DI TIPO FRAME ==!
        CASE(2)
         WRITE(*,*) ""
         WRITE(*,*) "**************************************************"
         WRITE(*,*) " --> STATIC ANALYSIS WITH FRAME ELEMENTS <--"
        DOF_NODE = 3
        ! Input vengono letti, e gli elementi TRUSS vengono generati, allocati e memorizzati
         CALL PREPROCESSING_FRAME
        ! Si genera la matrice di rigidezza, dalla locale si assembla direttamente la globale
         CALL STIFFNESS_MATRIX_FRAME
        ! Si genera il vettore dei carichi, dal locale si assembla direttamente il globale
         CALL LOAD_VECTOR_FRAME
        ! Si applicano le condizioni al contorno
         CALL BC_ROUTINE_FRAME
        ! Si risolve il sistema lineare attraverso il BiCGStab
         CALL LIN_SYS_LU
        ! Si procede con il post-processing
         CALL POSTPROCESSING_FRAME
      END SELECT

     
     write(*,*) ""
 
 END PROGRAM PC_FRAMEFEM2D

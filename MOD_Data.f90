MODULE MOD_DATA
    
    IMPLICIT NONE
    
       INTEGER(4)   :: N_ELE
       INTEGER(4)   :: DOF_NODE = 3  ! <--  U, V, THETA
       INTEGER(4)   :: N_NODES
       INTEGER(4)   :: N_FORCES
       INTEGER(4)   :: N_BC
       INTEGER(4)   :: DOF_TOTAL
       INTEGER(4)   :: TOTAL_NODES
       INTEGER(4)   :: TOTAL_ELEMENTS
       INTEGER(4)   :: TOTAL_BC
       REAL(8)      :: PI=4.D0*DATAN(1.D0)
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Definizione dell'elemento FRAME unidimensionale
    TYPE FRAME      
       REAL(8)     :: N_DOF          ! <-- DOF per nodo (2 nel caso 2D, 3 nel caso 3D)
       REAL(8)     :: NODE_I(2)      ! <-- Coordinate fisiche del nodo I-esimo di trave
       REAL(8)     :: NODE_J(2)      ! <-- Coordinate fisiche del nodo J-esimo di trave
       INTEGER(4)  :: INDEX_I        ! <-- Indice nella matrice di connettività globale del nodo I-esimo
       INTEGER(4)  :: INDEX_J        ! <-- Indice nella matrice di connettività globale del nodo J-esimo
       REAL(8)     :: E,A,J          ! <-- Modulo di Young, area e momento di inerzia della sezione
    END TYPE FRAME
    
    TYPE(FRAME), DIMENSION(:), ALLOCATABLE  :: FRAME_ELE
    
    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Lettura da input di connecitivty e lista dei nodi separatamente
    
        REAL(8),    DIMENSION(:,:),   ALLOCATABLE :: GLOBAL_NODES  ! <-- ( ID del nodo, coordinata x del nodo, coordinata y del nodo )
        REAL(8),    DIMENSION(:,:),   ALLOCATABLE :: BC_NODES      ! <-- ( ID del nodo, componente x del vincolo, componente y del vincolo )
        REAL(8),    DIMENSION(:,:),   ALLOCATABLE :: FORCES        ! <-- ( ID del nodo, componente x della forza, componente y della forza )
        INTEGER(8), DIMENSION(:,:),   ALLOCATABLE :: CONNECTIVITY  ! <-- ( ID dell'elemento, indice I della conn, indice J della conn )
    

    !------------------------------------------------------------------------------------------------------------------------------------------
    ! Dopo la lettura di nodi e connectivitym siamo già in grado di allocare la matrice di rigidezza globale
        
        REAL(8), DIMENSION(:,:), ALLOCATABLE :: K_ELE
        REAL(8), DIMENSION(:,:), ALLOCATABLE :: K_GLOB
        REAL(8), DIMENSION(:),   ALLOCATABLE :: F, UNK
    
END MODULE
    
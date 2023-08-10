!** THANKS CHATGPT **
    
SUBROUTINE LIN_SYS_LU
		
	USE MOD_DATA
    
	IMPLICIT NONE
 
    real :: temp
    integer :: i, j, k

    ! Forward elimination
    do k = 1, DOF_TOTAL-1
        do i = k+1, DOF_TOTAL
            temp = K_GLOB(i,k) / K_GLOB(k,k)
            K_GLOB(i,k+1:DOF_TOTAL) = K_GLOB(i,k+1:DOF_TOTAL) - temp * K_GLOB(k,k+1:DOF_TOTAL)
            F(i) = F(i) - temp * F(k)
        end do
    end do

    ! Back substitution
    UNK(DOF_TOTAL) = F(DOF_TOTAL) / K_GLOB(DOF_TOTAL,DOF_TOTAL)
    do i = DOF_TOTAL-1, 1, -1
        UNK(i) = (F(i) - dot_product(K_GLOB(i,i+1:DOF_TOTAL), UNK(i+1:DOF_TOTAL))) / K_GLOB(i,i)
    end do
    
	
END SUBROUTINE
    
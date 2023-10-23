program PointerExample
  implicit none

  ! Declare variables
  integer :: a = 10
  integer, pointer :: ptr

  ! Point 'ptr' to the address of 'a'
  ptr => a

  ! Display the values of 'a' and the value pointed to by 'ptr'
  print *, "a = ", a
  print *, "ptr = ", ptr
  print *, "Value pointed to by ptr = ", ptr

  ! Modify the value through the pointer
  ptr = 20
  print *, "a after modifying through ptr = ", a

  ! Dynamic memory allocation
  integer, pointer :: dyn_ptr(:)
  integer, dimension(3) :: dyn_array = [1, 2, 3]

  dyn_ptr => dyn_array

  print *, "Dynamic array elements:"
  print *, dyn_ptr

  ! Deallocate the dynamic pointer
  nullify(dyn_ptr)

  ! Ensure we don't use a dangling pointer
  print *, "Dynamic pointer after deallocation:"
  print *, dyn_ptr

end program PointerExample

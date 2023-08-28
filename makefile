##################################################
#      Makefile                                  #
##################################################
FC=gfortran-9
# FC=ifort

#CFLAGS= -g -fPIC -fopenmp
#CFLAGS= -g -O0 -fbacktrace -fcheck=bounds
#CFLAGS=  -g -DALLOW_NON_INIT -Ofast -m64 -Wall -pg -fbacktrace -fcheck=bounds -fPIC -static -ffpe-trap=invalid
#CFLAGS = -g -Wall -Wextra -Warray-temporaries -Wconversion -fimplicit-none -fbacktrace -ffree-line-length-0 -fcheck=all -ffpe-trap=invalid,zero,overflow,underflow -finit-real=nan 

COMPFLAG = -w -fdefault-real-8 -O3 -ftree-vectorize -msse2 -fbacktrace -fcheck=bounds
 
# EXECUTABLE=peroni
EXECUTABLE=code_run_fem1D2D


SOURCES=\
Source/MOD_Data.f90\
Source/MAT_BC.f90\
Source/MAT_Load_Vector.f90\
Source/MAT_Stiffness_Matrix.f90\
Source/POST_Postprocessor.f90\
Source/PRE_Preprocessor.f90\
Source/SYS_LinearSystem.f90\
Source/PROG_Main.f90\




# Compiled objects and modules
OBJECTS=$(SOURCES:%.f%=%.o) 
\
# Compile source files
%.o: %.for 
	$(FC) -c  $(CFLAGS) $<  -o $@ 

#Make all
all: $(EXECUTABLE)

#Main executable object
$(EXECUTABLE): $(OBJECTS) 
	$(FC) $(OBJECTS)  \
-Wl,--start-group \
-Wl,--end-group -L"../../../../compiler/lib/intel64" \
-fopenmp -lpthread -lm -ldl  \
 -o  $@ 



# Clean
clean:
	rm -rf fort.*
	rm -rf code_run_fem1D2D
	rm -rf *.mod
	rm -rf src_new/*.o


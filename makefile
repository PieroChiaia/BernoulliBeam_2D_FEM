##################################################
#      Makefile                                  #
##################################################
FC=gfortran-9

COMPFLAG = -w -fdefault-real-8 -O3 -ftree-vectorize -msse2 -fbacktrace -fcheck=bounds
 
EXECUTABLE=code_run_fem1d

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
	rm -rf code_run_fem1d
	rm -rf *.mod
	rm -rf src_new/*.o


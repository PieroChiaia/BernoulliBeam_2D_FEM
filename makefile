##################################################
#      Makefile                                  #
##################################################
FC=gfortran-8
# FC=ifort

#CFLAGS= -g -fPIC -fopenmp
#CFLAGS= -g -O0 -fbacktrace -fcheck=bounds
#CFLAGS=  -g -DALLOW_NON_INIT -Ofast -m64 -Wall -pg -fbacktrace -fcheck=bounds -fPIC -static -ffpe-trap=invalid
#CFLAGS = -g -Wall -Wextra -Warray-temporaries -Wconversion -fimplicit-none -fbacktrace -ffree-line-length-0 -fcheck=all -ffpe-trap=invalid,zero,overflow,underflow -finit-real=nan 

COMPFLAG = -w -fdefault-real-8 -O3 -ftree-vectorize -msse2 -fbacktrace -fcheck=bounds
 
# EXECUTABLE=peroni
EXECUTABLE=Mul2_NL_BPSS_v3

MKLROOT=./lib/

SOURCES=\
SRC/dgetv0.f\
SRC/dlaqrb.f\
SRC/dmout.f\
SRC/dnaitr.f\
SRC/dnapps.f\
SRC/dnaup2.f\
SRC/dnaupd.f\
SRC/dnconv.f\
SRC/dneigh.f\
SRC/dneupd.f\
SRC/dngets.f\
SRC/dsaitr.f\
SRC/dsapps.f\
SRC/dsaup2.f\
SRC/dsaupd.f\
SRC/dsband.f\
SRC/dsconv.f\
SRC/dseigt.f\
SRC/dsesrt.f\
SRC/dseupd.f\
SRC/dsgets.f\
SRC/dsortc.f\
SRC/dsortr.f\
SRC/dstatn.f\
SRC/dstats.f\
SRC/dstqrb.f\
SRC/dvout.f\
SRC/modules.for\
SRC/modules_1d_lag.for\
SRC/modules_2d_lag.for\
SRC/modules_gauss.for\
SRC/modules_3d_lag.for\
SRC/modules_mitc.for\
SRC/modules_2d_TE.for\
SRC/modules_mat.for\
SRC/modules_1d_TE.for\
SRC/modules_NONLINEAR.for\
SRC/modules_postprocessing.for\
SRC/1d_CUF_integ_PRESS.for\
SRC/1d_CUF_integration.for\
SRC/1d_CUF_integration_PRESS_SECT.for\
SRC/1d_fem_integration_BF.for\
SRC/1d_fem_integration.for\
SRC/1d_fem_integration_MITC.for\
SRC/2d_CUF_integ_PRESS.for\
SRC/2d_CUF_integration_BF.for\
SRC/2d_CUF_integration.for\
SRC/2d_CUF_integration_PRESS_SECT.for\
SRC/2d_fem_integration_BF.for\
SRC/2d_fem_integration.for\
SRC/2d_fem_integration_MITC.for\
SRC/2d_fem_integration_shell_tow.for\
SRC/2d_fem_integration_tow.for\
SRC/3d_CUF_integration_BEAM_GEOM.for\
SRC/3d_CUF_integration_BEAM_GEOM_TOW.for\
SRC/3d_CUF_integration_PLATE_GEOM.for\
SRC/3d_CUF_integration_PLATE_GEOM_TOW.for\
SRC/3d_CUF_integration_SHELL_GEOM.for\
SRC/3d_CUF_integration_SHELL_GEOM_TOW.for\
SRC/3d_CUF_integration_BEAM_GEOM_D.for\
SRC/3d_CUF_integration_PLATE_GEOM_D.for\
SRC/3d_CUF_integration_SHELL_GEOM_D.for\
SRC/3d_fem_integration.for\
SRC/3d_fem_integration_MITC.for\
SRC/3D_TOWANGLE_integration.for\
SRC/allocation.for\
SRC/BC_subroutines.for\
SRC/CRS_matrix_operations.for\
SRC/eig_sol_real_arp_para_buck.for\
SRC/eig_sol_real_arp_para_buck_v2.for\
SRC/eig_sol_real_arp_para.for\
SRC/eig_sol_real_arp_para_QEP.for\
SRC/D_PRESS.for\
SRC/F_BF.for\
SRC/K_GEO_D_MATRIX.for\
SRC/F_INTERNAL_VECTOR.for\
SRC/F_INTERNAL_VECTOR_TOW.for\
SRC/F_PRESS.for\
SRC/F_PRESS_Y.for\
SRC/freq_resp_real_solver.for\
SRC/input_processing.for\
SRC/ivout.f\
SRC/K_GEO_matrix.for\
SRC/K_GEO_matrix_TOW.for\
SRC/K_SEC_2.for\
SRC/K_SIGMA.for\
SRC/K_SIGMA_TOW.for\
SRC/K_TAN.for\
SRC/K_TAN_TOW.for\
SRC/K_UH_matrix.for\
SRC/K_UT_matrix.for\
SRC/K_UU_matrix.for\
SRC/K_UU_matrix_tow.for\
SRC/K_UZ_matrix.for\
SRC/license.for\
SRC/lin_sol_comp_pardiso.for\
SRC/lin_sol_real_pardiso.for\
SRC/lin_sol_real_pardiso_nl.for\
SRC/main.for\
SRC/material.for\
SRC/material_TOW.for\
SRC/Matrices_shared.for\
SRC/M_matrix.for\
SRC/newmark_real_solver.for\
SRC/post_buckling.for\
SRC/post_dynamic.for\
SRC/postprocessing.for\
SRC/post_static.for\
SRC/post_static_TOW.for\
SRC/post_write.for\
SRC/procedure_101.for\
SRC/procedure_103.for\
SRC/procedure_104.for\
SRC/procedure_105.for\
SRC/procedure_106.for\
SRC/procedure_108.for\
SRC/procedure_111.for\
SRC/procedure_113.for\
SRC/procedure_121.for\
SRC/procedure_123.for\
SRC/procedure_124.for\
SRC/procedure_126.for\
SRC/procedure_131.for\
SRC/procedure_133.for\
SRC/procedure_161.for\
SRC/procedure_164.for\
SRC/procedure_171.for\
SRC/procedure_206.for\
SRC/procedure_216.for\
SRC/procedure_shared.for\
SRC/read_input.for\
SRC/read_input_freq_resp.for\
SRC/read_input_GNL.for\
SRC/read_input_time_sim.for\
SRC/report_files.for\
SRC/RFpoints.for\
SRC/timestamp.for\
SRC/title.for\
SRC/TOWANGLE_plate_integration.for\
SRC/TOWANGLE_shell_integration.for


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
"${MKLROOT}libmkl_gf_lp64.a" \
"${MKLROOT}libmkl_gnu_thread.a" \
"${MKLROOT}libmkl_core.a" \
-Wl,--end-group -L"../../../../compiler/lib/intel64" \
-fopenmp -lpthread -lm -ldl  \
 -o  $@ 



# Clean
clean:
	rm -rf fort.*
	rm -rf Mul2_NL_BPSS_v3
	rm -rf *.mod
	rm -rf src_new/*.o


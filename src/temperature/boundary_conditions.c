#include "param.h"
#include "parallel.h"
#include "temperature.h"


int temperature_update_boundaries_temp(const param_t *param, const parallel_t *parallel, double *temp){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  /* ! update halo values of temp ! 2 ! */
  parallel_update_halo_ym(parallel, itot, MPI_DOUBLE, &TEMP(1, jsize), &TEMP(1,       0));
  parallel_update_halo_yp(parallel, itot, MPI_DOUBLE, &TEMP(1,     1), &TEMP(1, jsize+1));
  /* ! set boundary values of temp ! 4 ! */
  for(int j=1; j<=jsize; j++){
    TEMP(     0, j) = TEMP_XM;
    TEMP(itot+1, j) = TEMP_XP;
  }
  return 0;
}


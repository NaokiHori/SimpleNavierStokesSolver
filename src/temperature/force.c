#include "param.h"
#include "parallel.h"
#include "temperature.h"


int temperature_compute_force(const param_t *param, const parallel_t *parallel, temperature_t *temperature){
  const int with_thermal_forcing = param->with_thermal_forcing;
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double * restrict temp = temperature->temp;
  double * restrict tempforcex = temperature->tempforcex;
  if(with_thermal_forcing){
    /* ! buoyancy force acting only to wall-normal (x) direction ! 7 ! */
    for(int j=1; j<=jsize; j++){
      for(int i=2; i<=itot; i++){
        double temp_xm = TEMP(i-1, j  );
        double temp_xp = TEMP(i  , j  );
        TEMPFORCEX(i, j) = 0.5*temp_xm+0.5*temp_xp;
      }
    }
  }else{
    for(int j=1; j<=jsize; j++){
      for(int i=2; i<=itot; i++){
        TEMPFORCEX(i, j) = 0.;
      }
    }
  }
  return 0;
}


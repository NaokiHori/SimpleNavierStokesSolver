#include "common.h"
#include "param.h"
#include "parallel.h"
#include "temperature.h"
#include "fileio.h"


static int allocate(const param_t *param, const parallel_t *parallel, temperature_t **temperature){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  /* ! structure is allocated ! 1 ! */
  *temperature = common_calloc(1, sizeof(temperature_t));
  /* ! temperature and buoyancy force fields are allocated ! 2 ! */
  (*temperature)->temp       = common_calloc(1, TEMP_MEMSIZE);
  (*temperature)->tempforcex = common_calloc(1, TEMPFORCEX_MEMSIZE);
  /* ! Runge-Kutta source terms are allocated ! 3 ! */
  (*temperature)->srctempa = common_calloc(1, SRCTEMPA_MEMSIZE);
  (*temperature)->srctempb = common_calloc(1, SRCTEMPB_MEMSIZE);
  (*temperature)->srctempg = common_calloc(1, SRCTEMPG_MEMSIZE);
  return 0;
}

static int init_or_load(const param_t *param, const parallel_t *parallel, temperature_t *temperature){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  double *temp = temperature->temp;
  if(param->load_flow_field){
    /* ! temp is loaded ! 1 ! */
    fileio_r_p_like_parallel(param->dirname_restart, "temp", param, parallel, temperature->temp);
  }else{
    /* ! temp is initialised ! 11 ! */
    // linear temperature distribution with perturbation
    const double factor = 0.1;
    const double *xc = param->xc;
    double *temp = temperature->temp;
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        double x = XC(i);
        double r = -0.5+1.*rand()/RAND_MAX;
        TEMP(i, j) = (TEMP_XP-TEMP_XM)*x+TEMP_XM+factor*r;
      }
    }
  }
  /* ! update boundary and halo values of temp ! 1 ! */
  temperature_update_boundaries_temp(param, parallel, temp);
  return 0;
}

temperature_t *temperature_init(const param_t *param, const parallel_t *parallel){
  temperature_t *temperature = NULL;
  /* ! allocate structure and its members ! 1 ! */
  allocate(param, parallel, &temperature);
  /* ! initialise or load temperature ! 1 ! */
  init_or_load(param, parallel, temperature);
  return temperature;
}


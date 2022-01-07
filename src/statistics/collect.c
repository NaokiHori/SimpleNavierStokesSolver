#include <math.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"
#include "statistics.h"


static int collect_mean_ux(const param_t *param, const parallel_t *parallel, const fluid_t *fluid, statistics_t *statistics){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *ux = fluid->ux;
  double *ux1 = statistics->ux1;
  double *ux2 = statistics->ux2;
  /* ! ux and its square are added ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot+1; i++){
      UX1(i, j) += pow(UX(i, j), 1.);
      UX2(i, j) += pow(UX(i, j), 2.);
    }
  }
  return 0;
}

static int collect_mean_uy(const param_t *param, const parallel_t *parallel, const fluid_t *fluid, statistics_t *statistics){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *uy = fluid->uy;
  double *uy1 = statistics->uy1;
  double *uy2 = statistics->uy2;
  /* ! uy and its square are added ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=0; i<=itot+1; i++){
      UY1(i, j) += pow(UY(i, j), 1.);
      UY2(i, j) += pow(UY(i, j), 2.);
    }
  }
  return 0;
}

static int collect_mean_temp(const param_t *param, const parallel_t *parallel, const temperature_t *temperature, statistics_t *statistics){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *temp = temperature->temp;
  double *temp1 = statistics->temp1;
  double *temp2 = statistics->temp2;
  /* ! temp and its square are added ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=0; i<=itot+1; i++){
      TEMP1(i, j) += pow(TEMP(i, j), 1.);
      TEMP2(i, j) += pow(TEMP(i, j), 2.);
    }
  }
  return 0;
}

int statistics_collect(param_t *param, const parallel_t *parallel, const fluid_t *fluid, const temperature_t *temperature, statistics_t *statistics){
  /* ! collect temporally-averaged quantities ! 3 ! */
  collect_mean_ux(param, parallel, fluid, statistics);
  collect_mean_uy(param, parallel, fluid, statistics);
  collect_mean_temp(param, parallel, temperature, statistics);
  /* ! number of samples is incremented ! 1 ! */
  statistics->num += 1;
  return 0;
}


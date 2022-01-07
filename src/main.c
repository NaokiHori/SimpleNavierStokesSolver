#include <stdio.h>
#include <mpi.h>
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"
#include "statistics.h"
#include "save.h"
#include "logging.h"


static int integrate(const param_t *param, const parallel_t *parallel, fluid_t *fluid, temperature_t *temperature);

int main(void){
  /* ! launch MPI, start timer ! 3 ! */
  MPI_Init(NULL, NULL);
  double wtimes[2] = {0.};
  wtimes[0] = parallel_get_wtime(MPI_MIN);
  /* ! initialise structures ! 5 ! */
  param_t       *param       = param_init();
  parallel_t    *parallel    = parallel_init();
  fluid_t       *fluid       = fluid_init(param, parallel);
  temperature_t *temperature = temperature_init(param, parallel);
  statistics_t  *statistics  = statistics_init(param, parallel);
  /* ! cost evaluations of diffusive term treatments ! 1 ! */
  param_estimate_cost(param, parallel);
  /* main loop */
  for(;;){
    /* ! decide time step size and diffusive term treatment ! 1 ! */
    param_decide_dt(param, parallel, fluid);
    /* ! integrate mass, momentum, and internal energy balances in time ! 1 ! */
    integrate(param, parallel, fluid, temperature);
    /* ! step and time are incremented ! 2 ! */
    param->step += 1;
    param->time += param->dt;
    /* ! output log ! 4 ! */
    if(param->log.next < param->time){
      logging(param, parallel, fluid, temperature);
      param->log.next += param->log.rate;
    }
    /* ! save flow fields ! 4 ! */
    if(param->save.next < param->time){
      save(param, parallel, fluid, temperature);
      param->save.next += param->save.rate;
    }
    /* ! collect statistics ! 4 ! */
    if(param->stat.next < param->time){
      statistics_collect(param, parallel, fluid, temperature, statistics);
      param->stat.next += param->stat.rate;
    }
    /* ! terminate when the simulation is finished ! 3 ! */
    if(param->time > param->timemax){
      break;
    }
    /* ! terminate when wall time limit is reached ! 4 ! */
    wtimes[1] = parallel_get_wtime(MPI_MAX);
    if(wtimes[1]-wtimes[0] > param->wtimemax){
      break;
    }
  }
  /* ! check duration ! 3 ! */
  if(parallel->mpirank == 0){
    printf("elapsed: %.2f [s]\n", wtimes[1]-wtimes[0]);
  }
  /* ! save restart file and statistics at last ! 2 ! */
  save(param, parallel, fluid, temperature);
  statistics_output(param, parallel, statistics);
  /* ! finalise structures ! 5 ! */
  statistics_finalise(statistics);
  temperature_finalise(temperature);
  fluid_finalise(fluid);
  parallel_finalise(parallel);
  param_finalise(param);
  /* ! finalise MPI ! 1 ! */
  MPI_Finalize();
  return 0;
}

static int integrate(const param_t *param, const parallel_t *parallel, fluid_t *fluid, temperature_t *temperature){
  for(int rkstep=0; rkstep<RKSTEPMAX; rkstep++){
    /* ! update boundary and halo values ! 3 ! */
    fluid_update_boundaries_ux(param, parallel, fluid->ux);
    fluid_update_boundaries_uy(param, parallel, fluid->uy);
    fluid_update_boundaries_p(param, parallel, fluid->p);
    /* ! update temperature and thermal forcing ! 5 ! */
    if(param->with_temperature){
      temperature_update_boundaries_temp(param, parallel, temperature->temp);
      temperature_compute_force(param, parallel, temperature);
      temperature_update_temp(param, parallel, rkstep, fluid, temperature);
    }
    /* ! update velocity by integrating momentum equation ! 1 ! */
    fluid_update_velocity(param, parallel, rkstep, fluid, temperature);
    /* ! compute scalar potential ! 1 ! */
    fluid_compute_potential(param, parallel, rkstep, fluid);
    /* ! correct velocity to be solenoidal ! 1 ! */
    fluid_correct_velocity(param, parallel, rkstep, fluid);
    /* ! update pressure ! 1 ! */
    fluid_update_pressure(param, parallel, rkstep, fluid);
  }
  return 0;
}


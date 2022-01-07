#include <stdio.h>
#include <math.h>
#include <mpi.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"


static int emulate(param_t *param, const parallel_t *parallel, const double wtimemax){
  /* emulate the main integration process */
  /* iterate the integration process until the maximum wall time is reached */
  /* return the number of iterations which could be completed */
  double wtimes[2];
  int niter;
  fluid_t *fluid = fluid_init(param, parallel);
  temperature_t *temperature = temperature_init(param, parallel);
  wtimes[0] = parallel_get_wtime(MPI_MAX);
  for(niter=0; ;niter++){
    const int rkstep = 0;
    fluid_update_boundaries_ux(param, parallel, fluid->ux);
    fluid_update_boundaries_uy(param, parallel, fluid->uy);
    fluid_update_boundaries_p(param, parallel, fluid->p);
    if(param->with_temperature){
      temperature_update_boundaries_temp(param, parallel, temperature->temp);
      temperature_compute_force(param, parallel, temperature);
      temperature_update_temp(param, parallel, rkstep, fluid, temperature);
    }
    fluid_update_velocity(param, parallel, rkstep, fluid, temperature);
    fluid_compute_potential(param, parallel, rkstep, fluid);
    fluid_correct_velocity(param, parallel, rkstep, fluid);
    fluid_update_pressure(param, parallel, rkstep, fluid);
    wtimes[1] = parallel_get_wtime(MPI_MIN);
    if(wtimes[1]-wtimes[0] > wtimemax){
      break;
    }
  }
  fluid_finalise(fluid);
  temperature_finalise(temperature);
  return niter;
}

int param_estimate_cost(param_t *param, const parallel_t *parallel){
  const int mpirank = parallel->mpirank;
  const double wtimemax = 1.;
  const double dt = 1.e-8;
  // check computational costs for all combinations of the diffusive treatments
  if(mpirank == 0){
    printf("------- Check optimal diffusive term treatment -------\n");
  }
  for(int implicity=0; implicity<2; implicity++){
    for(int implicitx=0; implicitx<2; implicitx++){
      param->dt = dt;
      param->implicitx = implicitx;
      param->implicity = implicity;
      // number of iterations which can be done in wtimemax seconds
      int niter = emulate(param, parallel, wtimemax);
      // assign performance (sec / iter)
      param->expimp_wtimes[implicity][implicitx] = wtimemax/(1.*niter);
      if(mpirank == 0){
        printf("%s(x)-%s(y): %8d iterations in %.1e [s]\n",
            implicitx ? "IMP" : "EXP",
            implicity ? "IMP" : "EXP",
            niter, wtimemax
        );
      }
    }
  }
  if(mpirank == 0){
    printf("------------------------------------------------------\n");
  }
  return 0;
}


#include <math.h>
#include <float.h>
#include <mpi.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"


int param_decide_dt(param_t *param, const parallel_t *parallel, const fluid_t *fluid){
  /* ! safety factors for two constraints ! 1 ! */
  const double safe_factors[2] = {0.7, 0.9};
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double Ra = param->Ra;
  const double Pr = param->Pr;
  const double diffusivity = fmax(sqrt(Pr)/sqrt(Ra), 1./sqrt(Pr)/sqrt(Ra));
  const double lx = param->lx;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double *ux = fluid->ux;
  const double *uy = fluid->uy;
  /* ! advective constraint, which will be used as dt ! 25 ! */
  double dt_adv;
  {
    // sufficiently small number
    const double small = 1.e-8;
    // grid-size/velocity
    dt_adv = 5.e-2; // max dt_adv
    // ux
    for(int j=1; j<=jsize; j++){
      for(int i=2; i<=itot; i++){
        // to avoid zero-division
        double vel = fmax(fabs(UX(i, j)), small);
        dt_adv = fmin(dt_adv, DXC(i)/vel);
      }
    }
    // uy
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        // to avoid zero-division
        double vel = fmax(fabs(UY(i, j)), small);
        dt_adv = fmin(dt_adv, dy/vel);
      }
    }
    MPI_Allreduce(MPI_IN_PLACE, &dt_adv, 1, MPI_DOUBLE, MPI_MIN, MPI_COMM_WORLD);
    dt_adv *= safe_factors[0];
  }
  /* ! diffusive constraints in each direction ! 13 ! */
  double dt_dif_x, dt_dif_y;
  {
    // find minimum grid size in x direction
    double dx;
    dx = lx;
    for(int i=2; i<=itot; i++){
      dx = fmin(dx, DXC(i));
    }
    dt_dif_x = 0.25/diffusivity*pow(dx, 2.);
    dt_dif_y = 0.25/diffusivity*pow(dy, 2.);
    dt_dif_x *= safe_factors[1];
    dt_dif_y *= safe_factors[1];
  }
  /* ! find optimal diffusive treatment ! 28 ! */
  double dt = 1.e-2; // put an arbitrary value to avoid a compiler warning
  {
    double optimal_wtime = DBL_MAX;
    int optimal_implicitx = -1;
    int optimal_implicity = -1;
    // check all explicit/implicit combinations
    for(int implicity=0; implicity<2; implicity++){
      for(int implicitx=0; implicitx<2; implicitx++){
        // dt restriction for this combination
        double dt_of_this_combination =
          implicitx ? implicity ? dt_adv                                  // implicit(x)-implicit(y)
                                : fmin(dt_adv, dt_dif_y)                  // implicit(x)-explicit(y)
                    : implicity ? fmin(dt_adv, dt_dif_x)                  // explicit(x)-implicit(y)
                                : fmin(dt_adv, fmin(dt_dif_x, dt_dif_y)); // explicit(x)-implicit(y)
        // estimated number of iterations needed to integrate for 1 free-fall time unit
        double niter = 1./dt_of_this_combination;
        // estimated walltime to complete this procedure
        double wtime = param->expimp_wtimes[implicity][implicitx]*niter;
        // find the most efficient combination in terms of walltime
        if(wtime < optimal_wtime){
          dt = dt_of_this_combination;
          optimal_wtime = wtime;
          optimal_implicitx = implicitx;
          optimal_implicity = implicity;
        }
      }
    }
    param->implicitx = optimal_implicitx;
    param->implicity = optimal_implicity;
  }
  /* ! time step size is assigned ! 1 ! */
  param->dt = dt;
  return 0;
}


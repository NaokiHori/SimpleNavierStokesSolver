#include "param.h"
#include "parallel.h"
#include "fluid.h"


int fluid_correct_velocity(const param_t *param, const parallel_t *parallel, const int rkstep, fluid_t *fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double gamma = param->rkcoefs[rkstep].gamma;
  const double dt = param->dt;
  const double *psi = fluid->psi;
  double *ux = fluid->ux;
  double *uy = fluid->uy;
  /* ! ux is computed from i=2 to itot ! 2 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=2; i<=itot; i++){
      /* ! correct ux ! 4 ! */
      double dxi = 1./DXC(i);
      double psi_xp = PSI(i  , j  );
      double psi_xm = PSI(i-1, j  );
      UX(i, j) -= gamma*dt*(psi_xp-psi_xm)*dxi;
    }
  }
  /* ! update boundary and halo values of ux ! 1 ! */
  fluid_update_boundaries_ux(param, parallel, ux);
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      /* ! correct uy ! 3 ! */
      double psi_yp = PSI(i  , j  );
      double psi_ym = PSI(i  , j-1);
      UY(i, j) -= gamma*dt*(psi_yp-psi_ym)/dy;
    }
  }
  /* ! update boundary and halo values of uy ! 1 ! */
  fluid_update_boundaries_uy(param, parallel, uy);
  return 0;
}


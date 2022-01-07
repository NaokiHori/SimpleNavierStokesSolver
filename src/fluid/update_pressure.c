#include <math.h>
#include "param.h"
#include "parallel.h"
#include "fluid.h"


int fluid_update_pressure(const param_t *param, const parallel_t *parallel, const int rkstep, fluid_t *fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int implicitx = param->implicitx;
  const int implicity = param->implicity;
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double Ra = param->Ra;
  const double Pr = param->Pr;
  const double Re = sqrt(Ra)/sqrt(Pr);
  const double gamma = param->rkcoefs[rkstep].gamma;
  const double dt = param->dt;
  const double *psi = fluid->psi;
  double *p = fluid->p;
  /* ! add correction ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      P(i, j) += PSI(i, j);
    }
  }
  /* ! correction for implicit treatment in x ! 12 ! */
  if(implicitx){
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        double dpsidx_xm = (-PSI(i-1, j  )+PSI(i  , j  ))/DXC(i  );
        double dpsidx_xp = (-PSI(i  , j  )+PSI(i+1, j  ))/DXC(i+1);
        P(i, j) +=
          -(gamma*dt)/(2.*Re)*(
              +(dpsidx_xp-dpsidx_xm)/DXF(i)
        );
      }
    }
  }
  /* ! correction for implicit treatment in y ! 12 ! */
  if(implicity){
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        double dpsidy_ym = (-PSI(i  , j-1)+PSI(i  , j  ))/dy;
        double dpsidy_yp = (-PSI(i  , j  )+PSI(i  , j+1))/dy;
        P(i, j) +=
          -(gamma*dt)/(2.*Re)*(
              +(dpsidy_yp-dpsidy_ym)/dy
        );
      }
    }
  }
  /* ! boundary and halo values are updated ! 1 ! */
  fluid_update_boundaries_p(param, parallel, p);
  return 0;
}


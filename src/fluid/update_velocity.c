#include <string.h>
#include <math.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"
#include "linalg.h"


static int compute_src_ux(const param_t *param, const parallel_t *parallel, fluid_t *fluid, const temperature_t *temperature){
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
  const double * restrict ux = fluid->ux;
  const double * restrict uy = fluid->uy;
  const double * restrict p = fluid->p;
  const double * restrict tempforcex = temperature->tempforcex;
  double * restrict srcuxa = fluid->srcuxa;
  double * restrict srcuxb = fluid->srcuxb;
  double * restrict srcuxg = fluid->srcuxg;
  /* ! previous k-step source term of ux is copied ! 1 ! */
  memcpy(srcuxb, srcuxa, SRCUXA_MEMSIZE);
  // UX(i=1, j) and UX(itot+1, j) are fixed to 0
  for(int j=1; j<=jsize; j++){
    for(int i=2; i<=itot; i++){
      /* advection */
      /* ! x-momentum is transported by ux ! 6 ! */
      double adv1;
      {
        double ux_xm = 0.5*UX(i-1, j  )+0.5*UX(i  , j  );
        double ux_xp = 0.5*UX(i  , j  )+0.5*UX(i+1, j  );
        adv1 = -(ux_xp*ux_xp-ux_xm*ux_xm)/DXC(i);
      }
      /* ! x-momentum is transported by uy ! 10 ! */
      double adv2;
      {
        double c_xm = DXF(i-1)/(2.*DXC(i));
        double c_xp = DXF(i  )/(2.*DXC(i));
        double uy_ym = c_xm*UY(i-1, j  )+c_xp*UY(i  , j  );
        double uy_yp = c_xm*UY(i-1, j+1)+c_xp*UY(i  , j+1);
        double ux_ym = 0.5 *UX(i  , j-1)+0.5 *UX(i  , j  );
        double ux_yp = 0.5 *UX(i  , j  )+0.5 *UX(i  , j+1);
        adv2 = -(uy_yp*ux_yp-uy_ym*ux_ym)/dy;
      }
      /* diffusion */
      /* ! x-momentum is diffused in x ! 7 ! */
      double dif1;
      {
        const double prefactor = sqrt(Pr)/sqrt(Ra);
        double duxdx_xm = (UX(i  , j  )-UX(i-1, j  ))/DXF(i-1);
        double duxdx_xp = (UX(i+1, j  )-UX(i  , j  ))/DXF(i  );
        dif1 = prefactor*(duxdx_xp-duxdx_xm)/DXC(i);
      }
      /* ! x-momentum is diffused in y ! 7 ! */
      double dif2;
      {
        const double prefactor = sqrt(Pr)/sqrt(Ra);
        double duxdy_ym = (UX(i  , j  )-UX(i  , j-1))/dy;
        double duxdy_yp = (UX(i  , j+1)-UX(i  , j  ))/dy;
        dif2 = prefactor*(duxdy_yp-duxdy_ym)/dy;
      }
      /* pressure gradient */
      /* ! pressure gradient in x ! 6 ! */
      double pre;
      {
        double p_xm = P(i-1, j  );
        double p_xp = P(i  , j  );
        pre = -(p_xp-p_xm)/DXC(i);
      }
      /* temperature */
      /* ! buoyancy force ! 1 ! */
      double tmp = TEMPFORCEX(i, j);
      /* summation */
      /* ! summation of ux explicit terms ! 5 ! */
      SRCUXA(i, j) =
        +(adv1+adv2)
        +(1.-1.*implicitx)*dif1
        +(1.-1.*implicity)*dif2
        +tmp;
      /* ! summation of ux implicit terms ! 4 ! */
      SRCUXG(i, j) =
        +(  +1.*implicitx)*dif1
        +(  +1.*implicity)*dif2
        +pre;
    }
  }
  return 0;
}

static int compute_src_uy(const param_t *param, const parallel_t *parallel, fluid_t *fluid){
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
  const double * restrict ux = fluid->ux;
  const double * restrict uy = fluid->uy;
  const double * restrict p = fluid->p;
  double * restrict srcuya = fluid->srcuya;
  double * restrict srcuyb = fluid->srcuyb;
  double * restrict srcuyg = fluid->srcuyg;
  /* ! previous k-step source term of uy is copied ! 1 ! */
  memcpy(srcuyb, srcuya, SRCUYA_MEMSIZE);
  /* ! uy is computed from i=1 to itot ! 2 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      /* advection */
      /* ! y-momentum is transported by ux ! 8 ! */
      double adv1;
      {
        double ux_xm = 0.5*UX(i  , j-1)+0.5*UX(i  , j  );
        double ux_xp = 0.5*UX(i+1, j-1)+0.5*UX(i+1, j  );
        double uy_xm = 0.5*UY(i-1, j  )+0.5*UY(i  , j  );
        double uy_xp = 0.5*UY(i  , j  )+0.5*UY(i+1, j  );
        adv1 = -(ux_xp*uy_xp-ux_xm*uy_xm)/DXF(i);
      }
      /* ! y-momentum is transported by uy ! 6 ! */
      double adv2;
      {
        double uy_ym  = 0.5*UY(i  , j-1)+0.5*UY(i  , j  );
        double uy_yp  = 0.5*UY(i  , j  )+0.5*UY(i  , j+1);
        adv2 = -(uy_yp*uy_yp-uy_ym*uy_ym)/dy;
      }
      /* diffusion */
      /* ! y-momentum is diffused in x ! 7 ! */
      double dif1;
      {
        const double prefactor = sqrt(Pr)/sqrt(Ra);
        double duydx_xm = (UY(i  , j  )-UY(i-1, j  ))/DXC(i  );
        double duydx_xp = (UY(i+1, j  )-UY(i  , j  ))/DXC(i+1);
        dif1 = prefactor*(duydx_xp-duydx_xm)/DXF(i);
      }
      /* ! y-momentum is diffused in y ! 7 ! */
      double dif2;
      {
        const double prefactor = sqrt(Pr)/sqrt(Ra);
        double duydy_ym = (UY(i  , j  )-UY(i  , j-1))/dy;
        double duydy_yp = (UY(i  , j+1)-UY(i  , j  ))/dy;
        dif2 = prefactor*(duydy_yp-duydy_ym)/dy;
      }
      /* pressure gradient */
      /* ! pressure gradient in y ! 6 ! */
      double pre;
      {
        double p_ym = P(i  , j-1);
        double p_yp = P(i  , j  );
        pre = -(p_yp-p_ym)/dy;
      }
      /* summation */
      /* ! summation of uy explicit terms ! 4 ! */
      SRCUYA(i, j) =
        +(adv1+adv2)
        +(1.-1.*implicitx)*dif1
        +(1.-1.*implicity)*dif2;
      /* ! summation of uy implicit terms ! 4 ! */
      SRCUYG(i, j) =
        +(  +1.*implicitx)*dif1
        +(  +1.*implicity)*dif2
        +pre;
    }
  }
  return 0;
}

static int update_ux(const param_t *param, const parallel_t *parallel, const int rkstep, fluid_t *fluid){
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
  const double alpha = param->rkcoefs[rkstep].alpha;
  const double beta  = param->rkcoefs[rkstep].beta;
  const double gamma = param->rkcoefs[rkstep].gamma;
  const double dt = param->dt;
  const double *srcuxa = fluid->srcuxa;
  const double *srcuxb = fluid->srcuxb;
  const double *srcuxg = fluid->srcuxg;
  double *ux = fluid->ux;
  double *qx = NULL;
  double *qy = NULL;
  qx = common_calloc((itot+1)*jsize, sizeof(double));
#define QX(I, J) (qx[((J)-1)*(itot+1)+((I)-1)])
  /* ! compute increments of ux ! 10 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot+1; i++){
      QX(i, j) =
          i ==      1 ? 0.
        : i == itot+1 ? 0.
        : +alpha*dt*SRCUXA(i, j)
          +beta *dt*SRCUXB(i, j)
          +gamma*dt*SRCUXG(i, j);
    }
  }
  if(implicitx){
    /* solve linear system in x direction */
    for(int j=1; j<=jsize; j++){
      // macros for tri-diagonal matrix
      // starts from 1
#define TDM_L(I) (tdm_l[(I)-1])
#define TDM_C(I) (tdm_c[(I)-1])
#define TDM_U(I) (tdm_u[(I)-1])
#define TDM_Q(I) (tdm_q[(I)-1])
      double *tdm_l = NULL;
      double *tdm_c = NULL;
      double *tdm_u = NULL;
      double *tdm_q = NULL;
      tdm_l = common_calloc(itot+1, sizeof(double));
      tdm_c = common_calloc(itot+1, sizeof(double));
      tdm_u = common_calloc(itot+1, sizeof(double));
      tdm_q = common_calloc(itot+1, sizeof(double));
      /* ! set diagonal components of ux linear system in x direction ! 15 ! */
      for(int i=1; i<=itot+1; i++){
        if(i == 1 || i == itot+1){
          TDM_L(i) = 0.;
          TDM_U(i) = 0.;
          TDM_C(i) = 1.;
        }else{
          double prefactor = (gamma*dt*sqrt(Pr))/(2.*sqrt(Ra));
          double coef_xm = 1./DXC(i  )/DXF(i-1);
          double coef_xp = 1./DXC(i  )/DXF(i  );
          double coef_x0 = -coef_xm-coef_xp;
          TDM_L(i) =   -prefactor*coef_xm;
          TDM_U(i) =   -prefactor*coef_xp;
          TDM_C(i) = 1.-prefactor*coef_x0;
        }
      }
      /* ! solve linear system of ux in x direction ! 7 ! */
      for(int i=1; i<=itot+1; i++){
        TDM_Q(i) = QX(i, j);
      }
      my_dgtsv_b(itot+1, tdm_l, tdm_c, tdm_u, tdm_q);
      for(int i=1; i<=itot+1; i++){
        QX(i, j) = TDM_Q(i);
      }
      common_free(tdm_l);
      common_free(tdm_c);
      common_free(tdm_u);
      common_free(tdm_q);
#undef TDM_L
#undef TDM_C
#undef TDM_U
#undef TDM_Q
    }
  }
  if(implicity){
    qy = common_calloc(parallel_get_size(itot+1, mpisize, mpirank)*jtot, sizeof(double));
    /* ! transpose x-aligned ux matrix to y-aligned matrix ! 1 ! */
    parallel_transpose(itot+1, jtot, sizeof(double), MPI_DOUBLE, qx, qy);
    /* solve linear system in y direction */
    for(int i=1; i<=parallel_get_size(itot+1, mpisize, mpirank); i++){
      // macros for tri-diagonal matrix
      // starts from 1
#define TDM_L(J) (tdm_l[(J)-1])
#define TDM_C(J) (tdm_c[(J)-1])
#define TDM_U(J) (tdm_u[(J)-1])
#define TDM_Q(J) (tdm_q[(J)-1])
      double *tdm_l = NULL;
      double *tdm_c = NULL;
      double *tdm_u = NULL;
      double *tdm_q = NULL;
      tdm_l = common_calloc(jtot, sizeof(double));
      tdm_c = common_calloc(jtot, sizeof(double));
      tdm_u = common_calloc(jtot, sizeof(double));
      tdm_q = common_calloc(jtot, sizeof(double));
      /* ! set diagonal components of ux linear system in y direction ! 9 ! */
      for(int j=1; j<=jtot; j++){
        double prefactor = (gamma*dt*sqrt(Pr))/(2.*sqrt(Ra));
        double coef_ym = 1./dy/dy;
        double coef_yp = 1./dy/dy;
        double coef_y0 = -coef_ym-coef_yp;
        TDM_L(j) =   -prefactor*coef_ym;
        TDM_U(j) =   -prefactor*coef_yp;
        TDM_C(j) = 1.-prefactor*coef_y0;
      }
#define QY(I, J) (qy[((I)-1)*(jtot  )+((J)-1)])
      /* ! solve linear system of ux in y direction ! 7 ! */
      for(int j=1; j<=jtot; j++){
        TDM_Q(j) = QY(i, j);
      }
      my_dgtsv_p(jtot, tdm_l, tdm_c, tdm_u, tdm_q);
      for(int j=1; j<=jtot; j++){
        QY(i, j) = TDM_Q(j);
      }
#undef QY
      common_free(tdm_l);
      common_free(tdm_c);
      common_free(tdm_u);
      common_free(tdm_q);
#undef TDM_L
#undef TDM_C
#undef TDM_U
#undef TDM_Q
    }
    /* ! transpose y-aligned ux matrix to x-aligned matrix ! 1 ! */
    parallel_transpose(jtot, itot+1, sizeof(double), MPI_DOUBLE, qy, qx);
    common_free(qy);
  }
  /* ! update ux ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=2; i<=itot; i++){
      UX(i, j) += QX(i, j);
    }
  }
#undef QX
  common_free(qx);
  fluid_update_boundaries_ux(param, parallel, ux);
  return 0;
}

static int update_uy(const param_t *param, const parallel_t *parallel, const int rkstep, fluid_t *fluid){
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
  const double alpha = param->rkcoefs[rkstep].alpha;
  const double beta  = param->rkcoefs[rkstep].beta;
  const double gamma = param->rkcoefs[rkstep].gamma;
  const double dt = param->dt;
  const double *srcuya = fluid->srcuya;
  const double *srcuyb = fluid->srcuyb;
  const double *srcuyg = fluid->srcuyg;
  double *uy = fluid->uy;
  double *qx = NULL;
  double *qy = NULL;
  qx = common_calloc(itot*jsize, sizeof(double));
#define QX(I, J) (qx[((J)-1)*(itot)+((I)-1)])
  /* ! compute increments of uy ! 8 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      QX(i, j) =
        +alpha*dt*SRCUYA(i, j)
        +beta *dt*SRCUYB(i, j)
        +gamma*dt*SRCUYG(i, j);
    }
  }
  if(implicitx){
    /* solve linear system in x direction */
    for(int j=1; j<=jsize; j++){
      // macros for tri-diagonal matrix
      // starts from 1
#define TDM_L(I) (tdm_l[(I)-1])
#define TDM_C(I) (tdm_c[(I)-1])
#define TDM_U(I) (tdm_u[(I)-1])
#define TDM_Q(I) (tdm_q[(I)-1])
      double *tdm_l = NULL;
      double *tdm_c = NULL;
      double *tdm_u = NULL;
      double *tdm_q = NULL;
      tdm_l = common_calloc(itot, sizeof(double));
      tdm_c = common_calloc(itot, sizeof(double));
      tdm_u = common_calloc(itot, sizeof(double));
      tdm_q = common_calloc(itot, sizeof(double));
      /* ! set diagonal components of uy linear system in x direction ! 8 ! */
      for(int i=1; i<=itot; i++){
        double prefactor = (gamma*dt*sqrt(Pr))/(2.*sqrt(Ra));
        double coef_xm = 1./DXF(i)/DXC(i  );
        double coef_xp = 1./DXF(i)/DXC(i+1);
        double coef_x0 = -coef_xm-coef_xp;
        TDM_L(i) =   -prefactor*coef_xm;
        TDM_U(i) =   -prefactor*coef_xp;
        TDM_C(i) = 1.-prefactor*coef_x0;
      }
      /* ! solve linear system of uy in x direction ! 7 ! */
      for(int i=1; i<=itot; i++){
        TDM_Q(i) = QX(i, j);
      }
      my_dgtsv_b(itot, tdm_l, tdm_c, tdm_u, tdm_q);
      for(int i=1; i<=itot; i++){
        QX(i, j) = TDM_Q(i);
      }
      common_free(tdm_l);
      common_free(tdm_c);
      common_free(tdm_u);
      common_free(tdm_q);
#undef TDM_L
#undef TDM_C
#undef TDM_U
#undef TDM_Q
    }
  }
  if(implicity){
    qy = common_calloc(parallel_get_size(itot+1, mpisize, mpirank)*jtot, sizeof(double));
    /* ! transpose x-aligned uy matrix to y-aligned matrix ! 1 ! */
    parallel_transpose(itot, jtot, sizeof(double), MPI_DOUBLE, qx, qy);
    /* solve linear system in y direction */
    for(int i=1; i<=parallel_get_size(itot, mpisize, mpirank); i++){
      // macros for tri-diagonal matrix
      // starts from 1
#define TDM_L(J) (tdm_l[(J)-1])
#define TDM_C(J) (tdm_c[(J)-1])
#define TDM_U(J) (tdm_u[(J)-1])
#define TDM_Q(J) (tdm_q[(J)-1])
      double *tdm_l = NULL;
      double *tdm_c = NULL;
      double *tdm_u = NULL;
      double *tdm_q = NULL;
      tdm_l = common_calloc(jtot, sizeof(double));
      tdm_c = common_calloc(jtot, sizeof(double));
      tdm_u = common_calloc(jtot, sizeof(double));
      tdm_q = common_calloc(jtot, sizeof(double));
      /* ! set diagonal components of uy linear system in y direction ! 8 ! */
      for(int j=1; j<=jtot; j++){
        double prefactor = (gamma*dt*sqrt(Pr))/(2.*sqrt(Ra));
        double coef_ym = 1./dy/dy;
        double coef_yp = 1./dy/dy;
        double coef_y0 = -coef_ym-coef_yp;
        TDM_L(j) =   -prefactor*coef_ym;
        TDM_U(j) =   -prefactor*coef_yp;
        TDM_C(j) = 1.-prefactor*coef_y0;
      }
#define QY(I, J) (qy[((I)-1)*(jtot  )+((J)-1)])
      /* ! solve linear system of uy in y direction ! 7 ! */
      for(int j=1; j<=jtot; j++){
        TDM_Q(j) = QY(i, j);
      }
      my_dgtsv_p(jtot, tdm_l, tdm_c, tdm_u, tdm_q);
      for(int j=1; j<=jtot; j++){
        QY(i, j) = TDM_Q(j);
      }
#undef QY
      common_free(tdm_l);
      common_free(tdm_c);
      common_free(tdm_u);
      common_free(tdm_q);
#undef TDM_L
#undef TDM_C
#undef TDM_U
#undef TDM_Q
    }
    /* ! transpose y-aligned uy matrix to x-aligned matrix ! 1 ! */
    parallel_transpose(jtot, itot, sizeof(double), MPI_DOUBLE, qy, qx);
    common_free(qy);
  }
  /* ! update uy ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      UY(i, j) += QX(i, j);
    }
  }
#undef QX
  common_free(qx);
  fluid_update_boundaries_uy(param, parallel, uy);
  return 0;
}

int fluid_update_velocity(const param_t *param, const parallel_t *parallel, const int rkstep, fluid_t *fluid, const temperature_t *temperature){
  /* ! source terms of Runge-Kutta scheme are updated ! 2 ! */
  compute_src_ux(param, parallel, fluid, temperature);
  compute_src_uy(param, parallel, fluid);
  /* ! velocities are updated ! 2 ! */
  update_ux(param, parallel, rkstep, fluid);
  update_uy(param, parallel, rkstep, fluid);
  return 0;
}


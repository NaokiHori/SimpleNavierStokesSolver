#include <string.h>
#include <math.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"
#include "linalg.h"


static int compute_src(const param_t *param, const parallel_t *parallel, const fluid_t *fluid, temperature_t *temperature){
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
  const double * restrict temp = temperature->temp;
  double * restrict srctempa = temperature->srctempa;
  double * restrict srctempb = temperature->srctempb;
  double * restrict srctempg = temperature->srctempg;
  /* ! previous k-step source term of temp is copied ! 1 ! */
  memcpy(srctempb, srctempa, SRCTEMPA_MEMSIZE);
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      /* advection */
      /* ! T is transported by ux ! 8 ! */
      double adv1;
      {
        double ux_xm = UX(i  , j  );
        double ux_xp = UX(i+1, j  );
        double t_xm = 0.5*TEMP(i-1, j  )+0.5*TEMP(i  , j  );
        double t_xp = 0.5*TEMP(i  , j  )+0.5*TEMP(i+1, j  );
        adv1 = -(ux_xp*t_xp-ux_xm*t_xm)/DXF(i);
      }
      /* ! T is transported by uy ! 8 ! */
      double adv2;
      {
        double uy_ym = UY(i  , j  );
        double uy_yp = UY(i  , j+1);
        double t_ym = 0.5*TEMP(i  , j-1)+0.5*TEMP(i  , j  );
        double t_yp = 0.5*TEMP(i  , j  )+0.5*TEMP(i  , j+1);
        adv2 = -(uy_yp*t_yp-uy_ym*t_ym)/dy;
      }
      /* diffusion */
      /* ! T is diffused in x ! 7 ! */
      double dif1;
      {
        const double prefactor = 1./sqrt(Pr)/sqrt(Ra);
        double dtdx_xm = (TEMP(i  , j  )-TEMP(i-1, j  ))/DXC(i  );
        double dtdx_xp = (TEMP(i+1, j  )-TEMP(i  , j  ))/DXC(i+1);
        dif1 = prefactor*(dtdx_xp-dtdx_xm)/DXF(i);
      }
      /* ! T is diffused in y ! 7 ! */
      double dif2;
      {
        const double prefactor = 1./sqrt(Pr)/sqrt(Ra);
        double dtdy_ym = (TEMP(i  , j  )-TEMP(i  , j-1))/dy;
        double dtdy_yp = (TEMP(i  , j+1)-TEMP(i  , j  ))/dy;
        dif2 = prefactor*(dtdy_yp-dtdy_ym)/dy;
      }
      /* summation */
      /* ! summation of explicit terms ! 4 ! */
      SRCTEMPA(i, j) =
        +(adv1+adv2)
        +(1.-1.*implicitx)*dif1
        +(1.-1.*implicity)*dif2;
      /* ! summation of implicit terms ! 3 ! */
      SRCTEMPG(i, j) =
        +(  +1.*implicitx)*dif1
        +(  +1.*implicity)*dif2;
    }
  }
  return 0;
}

static int update_temp(const param_t *param, const parallel_t *parallel, const int rkstep, temperature_t *temperature){
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
  const double * restrict srctempa = temperature->srctempa;
  const double * restrict srctempb = temperature->srctempb;
  const double * restrict srctempg = temperature->srctempg;
  double * restrict temp = temperature->temp;
  double *qx = NULL;
  double *qy = NULL;
  qx = common_calloc(itot*jsize, sizeof(double));
#define QX(I, J) (qx[((J)-1)*(itot)+((I)-1)])
  /* ! compute increment of T ! 8 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      QX(i, j) =
        +alpha*dt*SRCTEMPA(i, j)
        +beta *dt*SRCTEMPB(i, j)
        +gamma*dt*SRCTEMPG(i, j);
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
      /* ! set diagonal components of the linear system in x direction ! 9 ! */
      for(int i=1; i<=itot; i++){
        double prefactor = (gamma*dt)/(2.*sqrt(Pr)*sqrt(Ra));
        double coef_xm = 1./DXF(i)/DXC(i  );
        double coef_xp = 1./DXF(i)/DXC(i+1);
        double coef_x0 = -coef_xm-coef_xp;
        TDM_L(i) =   -prefactor*coef_xm;
        TDM_U(i) =   -prefactor*coef_xp;
        TDM_C(i) = 1.-prefactor*coef_x0;
      }
      /* ! solve linear system in x direction ! 7 ! */
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
    qy = common_calloc(parallel_get_size(itot, mpisize, mpirank)*jtot, sizeof(double));
    /* ! transpose x-aligned matrix to y-aligned matrix ! 1 ! */
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
      /* ! set diagonal components of the linear system in y direction ! 9 ! */
      for(int j=1; j<=jtot; j++){
        double prefactor = (gamma*dt)/(2.*sqrt(Pr)*sqrt(Ra));
        double coef_ym = 1./dy/dy;
        double coef_yp = 1./dy/dy;
        double coef_y0 = -coef_ym-coef_yp;
        TDM_L(j) =   -prefactor*coef_ym;
        TDM_U(j) =   -prefactor*coef_yp;
        TDM_C(j) = 1.-prefactor*coef_y0;
      }
#define QY(I, J) (qy[((I)-1)*(jtot)+((J)-1)])
      /* ! solve linear system in y direction ! 7 ! */
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
    /* ! transpose y-aligned matrix to x-aligned matrix ! 1 ! */
    parallel_transpose(jtot, itot, sizeof(double), MPI_DOUBLE, qy, qx);
    common_free(qy);
  }
  /* ! update temperature ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      TEMP(i, j) += QX(i, j);
    }
  }
#undef QX
  common_free(qx);
  temperature_update_boundaries_temp(param, parallel, temp);
  return 0;
}

int temperature_update_temp(const param_t *param, const parallel_t *parallel, const int rkstep, const fluid_t *fluid, temperature_t *temperature){
  /* ! source terms of Runge-Kutta scheme are updated ! 1 ! */
  compute_src(param, parallel, fluid, temperature);
  /* ! temperature field is updated ! 1 ! */
  update_temp(param, parallel, rkstep, temperature);
  return 0;
}


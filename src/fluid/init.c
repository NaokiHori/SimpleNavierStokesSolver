#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "fileio.h"


static int allocate(const param_t *param, const parallel_t *parallel, fluid_t **fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  /* ! structure is allocated ! 1 ! */
  *fluid = common_calloc(1, sizeof(fluid_t));
  /* ! velocity, pressure, scalar potential are allocated ! 4 ! */
  (*fluid)->ux  = common_calloc(1, UX_MEMSIZE);
  (*fluid)->uy  = common_calloc(1, UY_MEMSIZE);
  (*fluid)->p   = common_calloc(1, P_MEMSIZE);
  (*fluid)->psi = common_calloc(1, PSI_MEMSIZE);
  /* ! Runge-Kutta source terms are allocated ! 6 ! */
  (*fluid)->srcuxa = common_calloc(1, SRCUXA_MEMSIZE);
  (*fluid)->srcuxb = common_calloc(1, SRCUXB_MEMSIZE);
  (*fluid)->srcuxg = common_calloc(1, SRCUXG_MEMSIZE);
  (*fluid)->srcuya = common_calloc(1, SRCUYA_MEMSIZE);
  (*fluid)->srcuyb = common_calloc(1, SRCUYB_MEMSIZE);
  (*fluid)->srcuyg = common_calloc(1, SRCUYG_MEMSIZE);
  return 0;
}

static int init_or_load(const param_t *param, const parallel_t *parallel, fluid_t *fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  double *ux = fluid->ux;
  double *uy = fluid->uy;
  double *p  = fluid->p;
  /* ux */
  if(param->load_flow_field){
    /* ! ux is loaded ! 1 ! */
    fileio_r_ux_like_parallel(param->dirname_restart, "ux", param, parallel, fluid->ux);
  }else{
    /* ! ux is initialised ! 5 ! */
    for(int j=1; j<=jsize; j++){
      for(int i=2; i<=itot; i++){
        UX(i, j) = 0.;
      }
    }
  }
  /* ! update boundary and halo values of ux ! 1 ! */
  fluid_update_boundaries_ux(param, parallel, ux);
  /* uy */
  if(param->load_flow_field){
    /* ! uy is loaded ! 1 ! */
    fileio_r_uy_like_parallel(param->dirname_restart, "uy", param, parallel, fluid->uy);
  }else{
    /* ! uy is initialised ! 5 ! */
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        UY(i, j) = 0.;
      }
    }
  }
  /* ! update boundary and halo values of uy ! 1 ! */
  fluid_update_boundaries_uy(param, parallel, uy);
  /* pressure */
  if(param->load_flow_field){
    /* ! p is loaded ! 1 ! */
    fileio_r_p_like_parallel(param->dirname_restart, "p", param, parallel, fluid->p);
  }else{
    /* ! p is initialised ! 5 ! */
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        P(i, j) = 0.;
      }
    }
  }
  /* ! update boundary and halo values of p ! 1 ! */
  fluid_update_boundaries_p(param, parallel, p);
  return 0;
}

fluid_t *fluid_init(const param_t *param, const parallel_t *parallel){
  fluid_t *fluid = NULL;
  /* ! allocate structure and its members ! 1 ! */
  allocate(param, parallel, &fluid);
  /* ! initialise or load velocity and pressure ! 1 ! */
  init_or_load(param, parallel, fluid);
  return fluid;
}


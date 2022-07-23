#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>
#include <math.h>
#include <mpi.h>
#include "common.h"
#include "param.h"
#include "fileio.h"


#define PRINTF_MAIN(...) { \
  int mpirank; \
  MPI_Comm_rank(MPI_COMM_WORLD, &mpirank); \
  if(mpirank == 0){ \
    printf(__VA_ARGS__); \
  } \
}

static char *load_env_as_string(const char varname[]){
  // load and environmental variable "varname"
  //   return string which contains result in char*
  //   return NULL when the ENV is not found
  char *string = NULL;
  char *buf = getenv(varname);
  if(buf != NULL){
    size_t nchar = strlen(buf);
    string = common_calloc(nchar+1, sizeof(char));
    // copy contents since buf can be changed
    memcpy(string, buf, sizeof(char)*nchar);
    string[nchar] = 0x00;
  }
  return string;
}

static bool load_bool(const char varname[], const bool default_val){
  // return true when ENV is defined
  bool retval = default_val;
  char *string = load_env_as_string(varname);
  if(string != NULL){
    if(0 == memcmp(string, "true", sizeof(char)*4)){
      retval = true;
      PRINTF_MAIN("  %s: %s\n", varname, "true");
    }else if(0 == memcmp(string, "false", sizeof(char)*5)){
      retval = false;
      PRINTF_MAIN("  %s: %s\n", varname, "false");
    }else{
      PRINTF_MAIN("  %s: %s (default)\n", varname, retval ? "true" : "false");
    }
  }else{
    PRINTF_MAIN("  %s: %s (default)\n", varname, retval ? "true" : "false");
  }
  common_free(string);
  return retval;
}

static int load_int(const char varname[], const int default_val){
  int retval = default_val;
  char *string = load_env_as_string(varname);
  if(string != NULL){
    long tmp = strtol(string, NULL, 10);
    tmp = INT_MIN > tmp ? INT_MIN : tmp;
    tmp = INT_MAX < tmp ? INT_MAX : tmp;
    retval = (int)tmp;
    PRINTF_MAIN("  %s: %d\n", varname, retval);
  }else{
    PRINTF_MAIN("  %s: %d (default)\n", varname, retval);
  }
  common_free(string);
  return retval;
}

static double load_double(const char varname[], const double default_val){
  double retval = default_val;
  char *string = load_env_as_string(varname);
  if(string != NULL){
    retval = strtod(string, NULL);
    PRINTF_MAIN("  %s: %.3e\n", varname, retval);
  }else{
    PRINTF_MAIN("  %s: %.3e (default)\n", varname, retval);
  }
  common_free(string);
  return retval;
}

static int load_config(param_t *param){
  /* load parameters from ENV variables */
  PRINTF_MAIN("------- parameters are loaded -------\n");
  /* ! try to load the name of the directory having restart data ! 8 ! */
  param->dirname_restart = load_env_as_string("dirname_restart");
  if(param->dirname_restart == NULL){
    param->load_flow_field = false;
    PRINTF_MAIN("  flow fields are initialised\n");
  }else{
    param->load_flow_field = true;
    PRINTF_MAIN("  flow fields are loaded: %s\n", param->dirname_restart);
  }
  /* ! flags to decide temperature coupling ! 2 ! */
  param->with_temperature     = load_bool("with_temperature",     true);
  param->with_thermal_forcing = load_bool("with_thermal_forcing", true);
  /* ! schedulers ! 8 ! */
  param->timemax    = load_double("timemax",    2.0e+2);
  param->wtimemax   = load_double("wtimemax",   6.0e+2);
  param->log.rate   = load_double("log_rate",   2.0e-1);
  param->log.after  = load_double("log_after",  0.0e+0);
  param->save.rate  = load_double("save_rate",  2.0e+1);
  param->save.after = load_double("save_after", 0.0e+0);
  param->stat.rate  = load_double("stat_rate",  1.0e-1);
  param->stat.after = load_double("stat_after", 1.0e+2);
  /* ! domain ! 5 ! */
  param->itot    = load_int("itot", 128);
  param->jtot    = load_int("jtot", 192);
  param->lx      = LX; // fixed to unity
  param->ly      = load_double("ly", 2.0e+0);
  param->stretch = load_double("stretch", 3.0e+0);
  /* ! non-dimensional parameters ! 2 ! */
  param->Ra      = load_double("Ra", 1.0e+8);
  param->Pr      = load_double("Pr", 1.0e+1);
  PRINTF_MAIN("-------------------------------------\n");
  return 0;
}

static int set_coordinate(param_t *param){
  const double lx = param->lx;
  const double ly = param->ly;
  const int itot = param->itot;
  const int jtot = param->jtot;
  /* ! allocate coordinate vectors ! 6 ! */
  param->xf  = common_calloc(1, XF_MEMSIZE);
  param->xc  = common_calloc(1, XC_MEMSIZE);
  param->dxf = common_calloc(1, DXF_MEMSIZE);
  param->dxc = common_calloc(1, DXC_MEMSIZE);
  param->yf  = common_calloc(1, YF_MEMSIZE);
  param->yc  = common_calloc(1, YC_MEMSIZE);
  double *xf = param->xf;
  double *xc = param->xc;
  double *dxf = param->dxf;
  double *dxc = param->dxc;
  double *yf = param->yf;
  double *yc = param->yc;
  /* ! xf: cell face coordinates ! 27 ! */
  {
    int stretch = param->stretch;
    if(stretch < 0){
      stretch = 0;
    }
    if(stretch >= itot/2){
      // uniform grid
      const double dx = lx/itot;
      for(int i=1; i<=itot+1; i++){
        XF(i) = 1.*(i-1)*dx;
      }
    }else{
      // clipped Chebyshev
      for(int i=1; i<=itot+1; i++){
        XF(i) = cos(M_PI*(1.*(i-1)+stretch)/(itot+2.*stretch));
      }
      // original XF: "1"->"-1", so we need to normalise
      double min = XF(     1);
      double max = XF(itot+1);
      for(int i=1; i<=itot+1; i++){
        XF(i) = lx*(XF(i)-min)/(max-min);
      }
    }
    // force boundary values just in case
    XF(     1) = 0.;
    XF(itot+1) = lx;
  }
  /* ! dxf: distance from cell face to cell face ! 3 ! */
  for(int i=1; i<=itot; i++){
    DXF(i) = XF(i+1)-XF(i  );
  }
  /* ! xc: cell center coordinates ! 6 ! */
  // at boundaries, face positions are assigned
  XC(0) = XF(1);
  for(int i=1; i<=itot; i++){
    XC(i) = 0.5*(XF(i)+XF(i+1));
  }
  XC(itot+1) = XF(itot+1);
  /* ! dxc: distance from cell center to cell center (generally) ! 4 ! */
  // at boundaries, face-center distances are assigned
  for(int i=1; i<=itot+1; i++){
    DXC(i) = XC(i)-XC(i-1);
  }
  /* ! y grid size (uniform) ! 7 ! */
  param->dy = ly/jtot;
  for(int j=1; j<=jtot+1; j++){
    YF(j) = 1.*(j-1)*param->dy;
  }
  for(int j=1; j<=jtot; j++){
    YC(j) = 0.5*(2*j-1)*param->dy;
  }
  return 0;
}

static int set_rk_coefs(param_t *param){
  /* set coefficients which are used by three-step Runge-Kutta scheme */
  // set alpha and beta
  param->rkcoefs[0].alpha =  32./60.;
  param->rkcoefs[0].beta  =   0./60.;
  param->rkcoefs[1].alpha =  25./60.;
  param->rkcoefs[1].beta  = -17./60.;
  param->rkcoefs[2].alpha =  45./60.;
  param->rkcoefs[2].beta  = -25./60.;
  // gamma = alpha + beta
  for(int rkstep=0; rkstep<RKSTEPMAX; rkstep++){
    param->rkcoefs[rkstep].gamma
      = param->rkcoefs[rkstep].alpha
      + param->rkcoefs[rkstep].beta;
  }
  return 0;
}

static double compute_next_schedule(const double rate, const double after, const double time){
  // Example 1
  //   current time (time)          : 13.48
  //   output rate (rate)           :  0.10
  //   do this output after (after) : 20.21
  //     -> next time would be scheduled at 20.30 (round-up)
  // Example 2
  //   current time (time)          : 20.48
  //   output rate (rate)           :  0.10
  //   do this output after (after) : 13.80
  //     -> next time would be scheduled at 20.50 (round-up)
  const double small = 1.e-8;
  double next;
  if(time < after){
    next = rate*ceil((after+small)/rate);
  }else{
    // round-up
    next = rate*ceil((time +small)/rate);
  }
  return next;
}

param_t *param_init(void){
  /* ! allocate structure ! 1 ! */
  param_t *param = common_calloc(1, sizeof(param_t));
  /* ! load parameters from environmental variables ! 1 ! */
  load_config(param);
  /* ! allocate and initialise coordinates ! 1 ! */
  set_coordinate(param);
  /* ! set time step and time ! 7 ! */
  if(param->load_flow_field){
    fileio_r_0d_serial(param->dirname_restart, "step", sizeof(int),    &(param->step));
    fileio_r_0d_serial(param->dirname_restart, "time", sizeof(double), &(param->time));
  }else{
    param->step = 0;
    param->time = 0.;
  }
  /* set Runge-Kutta coefficients */
  set_rk_coefs(param);
  /* ! schedule timings for logging, save, stat ! 3 ! */
  param->log.next  = compute_next_schedule(param->log.rate , param->log.after, param->time);
  param->save.next = compute_next_schedule(param->save.rate, param->save.after, param->time);
  param->stat.next = compute_next_schedule(param->stat.rate, param->stat.after, param->time);
  return param;
}

#undef PRINTF_MAIN


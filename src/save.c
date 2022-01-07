#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"
#include "save.h"
#include "fileio.h"


static int save_param(const char dirname[], const param_t *param){
  fileio_w_0d_serial(dirname, "step", NPYIO_INT,    sizeof(int),    &(param->step));
  fileio_w_0d_serial(dirname, "itot", NPYIO_INT,    sizeof(int),    &(param->itot));
  fileio_w_0d_serial(dirname, "jtot", NPYIO_INT,    sizeof(int),    &(param->jtot));
  fileio_w_0d_serial(dirname, "time", NPYIO_DOUBLE, sizeof(double), &(param->time));
  fileio_w_0d_serial(dirname, "lx",   NPYIO_DOUBLE, sizeof(double), &(param->lx  ));
  fileio_w_0d_serial(dirname, "ly",   NPYIO_DOUBLE, sizeof(double), &(param->ly  ));
  fileio_w_0d_serial(dirname, "Ra",   NPYIO_DOUBLE, sizeof(double), &(param->Ra  ));
  fileio_w_0d_serial(dirname, "Pr",   NPYIO_DOUBLE, sizeof(double), &(param->Pr  ));
  fileio_w_1d_serial(dirname, "xf",   NPYIO_DOUBLE, sizeof(double), param->itot+1, param->xf);
  fileio_w_1d_serial(dirname, "xc",   NPYIO_DOUBLE, sizeof(double), param->itot+2, param->xc);
  fileio_w_1d_serial(dirname, "yf",   NPYIO_DOUBLE, sizeof(double), param->jtot+1, param->yf);
  fileio_w_1d_serial(dirname, "yc",   NPYIO_DOUBLE, sizeof(double), param->jtot  , param->yc);
  return 0;
}

static int save_fluid(const char dirname[], const param_t *param, const parallel_t *parallel, const fluid_t *fluid){
  fileio_w_ux_like_parallel(dirname, "ux", param, parallel, fluid->ux);
  fileio_w_uy_like_parallel(dirname, "uy", param, parallel, fluid->uy);
  fileio_w_p_like_parallel (dirname, "p",  param, parallel, fluid->p );
  return 0;
}

static int save_temperature(const char dirname[], const param_t *param, const parallel_t *parallel, const temperature_t *temperature){
  fileio_w_p_like_parallel(dirname, "temp", param, parallel, temperature->temp);
  return 0;
}

static char *generate_dirname(const int step){
  const char prefix[] = {FILEIO_SAVE "/step"};
  const int nzeros = 10;
  char *dirname = common_calloc(
      strlen(prefix)+nzeros+1, // + NUL
      sizeof(char)
  );
  sprintf(dirname, "%s%0*d", prefix, nzeros, step);
  return dirname;
}

int save(param_t *param, const parallel_t *parallel, const fluid_t *fluid, const temperature_t *temperature){
  /* ! create directory from main process ! 2 ! */
  char *dirname = generate_dirname(param->step);
  fileio_mkdir_by_main_process(dirname, parallel);
  /* ! save parameters ! 4 ! */
  const int mpirank = parallel->mpirank;
  if(mpirank == 0){
    save_param(dirname, param);
  }
  /* ! save flow fields ! 4 ! */
  save_fluid(dirname, param, parallel, fluid);
  if(param->with_temperature){
    save_temperature(dirname, param, parallel, temperature);
  }
  common_free(dirname);
  return 0;
}


#if !defined(PARAM_H)
#define PARAM_H

#include <stdbool.h>

#include "structure.h"
#include "arrays/param.h"

// 3-step Runge-Kutta scheme
#define RKSTEPMAX 3

// wall-to-wall distance is fixed to unity
#define LX 1.

typedef struct rkcoef_t_ {
  double alpha;
  double beta;
  double gamma;
} rkcoef_t;

typedef struct schedule_t_ {
  double rate;
  double after;
  double next;
} schedule_t;

/* ! definition of a structure param_t_ ! 27 !*/
struct param_t_ {
  // restart / initialise
  bool load_flow_field;
  char *dirname_restart;
  // fluid-temperature coupling
  bool with_temperature;
  bool with_thermal_forcing;
  // domain sizes
  int itot, jtot;
  double lx, ly;
  // grid sizes
  double stretch;
  double *xf, *xc;
  double *dxf, *dxc;
  double *yf, *yc;
  double dy;
  // non-dimensional params
  double Ra, Pr;
  // temporal integration
  rkcoef_t rkcoefs[3];
  double time, dt;
  int step, implicitx, implicity;
  double expimp_wtimes[2][2];
  // when to stop, when to write log, etc.
  double timemax, wtimemax;
  schedule_t log, save, stat;
};

extern param_t *param_init(void);
extern int param_finalise(param_t *param);

extern int param_decide_dt(param_t *param, const parallel_t *parallel, const fluid_t *fluid);
extern int param_estimate_cost(param_t *param, const parallel_t *parallel);

#endif // PARAM_H

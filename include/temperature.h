#if !defined(TEMPERATURE_H)
#define TEMPERATURE_H

#include "structure.h"
#include "arrays/temperature.h"

/* ! definition of a structure temperature_t_ ! 5 ! */
struct temperature_t_ {
  double *temp;
  double *tempforcex;
  double *srctempa, *srctempb, *srctempg;
};

extern temperature_t *temperature_init(const param_t *param, const parallel_t *parallel);
extern int temperature_finalise(temperature_t *temperature);

extern int temperature_compute_force(const param_t *param, const parallel_t *parallel, temperature_t *temperature);
extern int temperature_update_temp(const param_t *param, const parallel_t *parallel, const int rkstep, const fluid_t *fluid, temperature_t *temperature);

extern int temperature_update_boundaries_temp(const param_t *param, const parallel_t *parallel, double *temp);

#define TEMP_XM +0.5
#define TEMP_XP -0.5

#endif // TEMPERATURE_H

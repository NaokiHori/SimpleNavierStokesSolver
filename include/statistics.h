#if !defined(STATISTICS_H)
#define STATISTICS_H

#include "structure.h"
#include "arrays/statistics.h"

/* ! definition of a structure statistics_t_ ! 6 ! */
typedef struct {
  int num;
  double *ux1, *ux2;
  double *uy1, *uy2;
  double *temp1, *temp2;
} statistics_t;

extern statistics_t *statistics_init(const param_t *param, const parallel_t *parallel);
extern int statistics_finalise(statistics_t *statistics);

extern int statistics_collect(param_t *param, const parallel_t *parallel, const fluid_t *fluid, const temperature_t *temperature, statistics_t *statistics);
extern int statistics_output(const param_t *param, const parallel_t *parallel, const statistics_t *statistics);

#endif // STATISTICS_H

#include <string.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "statistics.h"


static int allocate(const param_t *param, const parallel_t *parallel, statistics_t **statistics){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  /* ! structure is allocated ! 1 ! */
  *statistics = common_calloc(1, sizeof(statistics_t));
  /* ! arrays are allocated ! 6 ! */
  (*statistics)->ux1 = common_calloc(1,   UX1_MEMSIZE);
  (*statistics)->ux2 = common_calloc(1,   UX2_MEMSIZE);
  (*statistics)->uy1 = common_calloc(1,   UY1_MEMSIZE);
  (*statistics)->uy2 = common_calloc(1,   UY2_MEMSIZE);
  (*statistics)->temp1 = common_calloc(1, TEMP1_MEMSIZE);
  (*statistics)->temp2 = common_calloc(1, TEMP2_MEMSIZE);
  return 0;
}

static int init(const param_t *param, const parallel_t *parallel, statistics_t *statistics){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  /* ! assign 0 ! 7 ! */
  // just in case, 0 is already assigned when allocated since we call calloc inside
  memset(statistics->ux1,   0, UX1_MEMSIZE);
  memset(statistics->ux2,   0, UX2_MEMSIZE);
  memset(statistics->uy1,   0, UY1_MEMSIZE);
  memset(statistics->uy2,   0, UY2_MEMSIZE);
  memset(statistics->temp1, 0, TEMP1_MEMSIZE);
  memset(statistics->temp2, 0, TEMP2_MEMSIZE);
  return 0;
}

statistics_t *statistics_init(const param_t *param, const parallel_t *parallel){
  statistics_t *statistics = NULL;
  /* ! allocate structure and its members ! 1 ! */
  allocate(param, parallel, &statistics);
  /* ! initialise values ! 1 ! */
  init(param, parallel, statistics);
  return statistics;
}


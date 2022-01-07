#include "common.h"
#include "statistics.h"


int statistics_finalise(statistics_t *statistics){
  common_free(statistics->ux1);
  common_free(statistics->ux2);
  common_free(statistics->uy1);
  common_free(statistics->uy2);
  common_free(statistics->temp1);
  common_free(statistics->temp2);
  common_free(statistics);
  return 0;
}


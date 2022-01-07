#include "common.h"
#include "temperature.h"


int temperature_finalise(temperature_t *temperature){
  common_free(temperature->temp);
  common_free(temperature->tempforcex);
  common_free(temperature->srctempa);
  common_free(temperature->srctempb);
  common_free(temperature->srctempg);
  common_free(temperature);
  return 0;
}


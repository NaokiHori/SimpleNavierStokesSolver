#include "common.h"
#include "parallel.h"


int parallel_finalise(parallel_t *parallel){
  common_free(parallel);
  return 0;
}


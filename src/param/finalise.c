#include "common.h"
#include "param.h"


int param_finalise(param_t *param){
  common_free(param->xf);
  common_free(param->xc);
  common_free(param->dxf);
  common_free(param->dxc);
  common_free(param->yf);
  common_free(param->yc);
  common_free(param->dirname_restart);
  common_free(param);
  return 0;
}


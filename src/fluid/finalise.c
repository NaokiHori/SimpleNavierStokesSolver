#include "common.h"
#include "fluid.h"


int fluid_finalise(fluid_t *fluid){
  common_free(fluid->ux);
  common_free(fluid->uy);
  common_free(fluid->p);
  common_free(fluid->psi);
  common_free(fluid->srcuxa);
  common_free(fluid->srcuxb);
  common_free(fluid->srcuxg);
  common_free(fluid->srcuya);
  common_free(fluid->srcuyb);
  common_free(fluid->srcuyg);
  common_free(fluid);
  return 0;
}


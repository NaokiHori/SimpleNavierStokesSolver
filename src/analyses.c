#include <math.h>
#include "param.h"
#include "fluid.h"
#include "temperature.h"
#include "analyses.h"


double analyses_compute_kinetic_dissipation_x(const param_t *param, const fluid_t *fluid, const int i, const int j){
  const int itot = param->itot;
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double Ra = param->Ra;
  const double Pr = param->Pr;
  const double *ux = fluid->ux;
  /* ! kinetic dissipation rate (x-momentum contribution) ! 26 ! */
  double sxjsxj = 0.;
  // left-cell contribution
  if(i != 1){
    double dux   = UX(i  , j  )-UX(i-1, j  );
    double duxdx = dux/DXF(i-1);
    sxjsxj += 0.5/DXC(i)*dux*duxdx;
  }
  // right-cell contribution
  if(i != itot+1){
    double dux   = UX(i+1, j  )-UX(i  , j  );
    double duxdx = dux/DXF(i  );
    sxjsxj += 0.5/DXC(i)*dux*duxdx;
  }
  // bottom-cell contribution
  {
    double dux   = UX(i  , j  )-UX(i  , j-1);
    double duxdy = dux/dy;
    sxjsxj += 0.5/dy*dux*duxdy;
  }
  // top-cell contribution
  {
    double dux   = UX(i  , j+1)-UX(i  , j  );
    double duxdy = dux/dy;
    sxjsxj += 0.5/dy*dux*duxdy;
  }
  return sqrt(Pr)/sqrt(Ra)*sxjsxj;
}

double analyses_compute_kinetic_dissipation_y(const param_t *param, const fluid_t *fluid, const int i, const int j){
  const int itot = param->itot;
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double Ra = param->Ra;
  const double Pr = param->Pr;
  const double *uy = fluid->uy;
  /* ! kinetic dissipation rate (y-momentum contribution) ! 28 ! */
  double syjsyj = 0.;
  // left-cell contribution
  {
    double c = i ==    1 ? 1. : 0.5;
    double duy   = UY(i  , j  )-UY(i-1, j  );
    double duydx = duy/DXC(i  );
    syjsyj += c/DXF(i)*duy*duydx;
  }
  // right-cell contribution
  {
    double c = i == itot ? 1. : 0.5;
    double duy   = UY(i+1, j  )-UY(i  , j  );
    double duydx = duy/DXC(i+1);
    syjsyj += c/DXF(i)*duy*duydx;
  }
  // bottom-cell contribution
  {
    double duy   = UY(i  , j  )-UY(i  , j-1);
    double duydy = duy/dy;
    syjsyj += 0.5/dy*duy*duydy;
  }
  // top-cell contribution
  {
    double duy   = UY(i  , j+1)-UY(i  , j  );
    double duydy = duy/dy;
    syjsyj += 0.5/dy*duy*duydy;
  }
  return sqrt(Pr)/sqrt(Ra)*syjsyj;
}

double analyses_compute_thermal_dissipation(const param_t *param, const temperature_t *temperature, const int i, const int j){
  const int itot = param->itot;
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double Ra = param->Ra;
  const double Pr = param->Pr;
  const double *temp = temperature->temp;
  /* ! thermal dissipation rate ! 28 ! */
  double riri = 0.;
  // left-cell contribution
  {
    double c = i ==    1 ? 1. : 0.5;
    double dtemp   = TEMP(i  , j  )-TEMP(i-1, j  );
    double dtempdx = dtemp/DXC(i  );
    riri += c/DXF(i)*dtemp*dtempdx;
  }
  // right-cell contribution
  {
    double c = i == itot ? 1. : 0.5;
    double dtemp   = TEMP(i+1, j  )-TEMP(i  , j  );
    double dtempdx = dtemp/DXC(i+1);
    riri += c/DXF(i)*dtemp*dtempdx;
  }
  // bottom-cell contribution
  {
    double dtemp   = TEMP(i  , j  )-TEMP(i  , j-1);
    double dtempdy = dtemp/dy;
    riri += 0.5/dy*dtemp*dtempdy;
  }
  // top-cell contribution
  {
    double dtemp   = TEMP(i  , j+1)-TEMP(i  , j  );
    double dtempdy = dtemp/dy;
    riri += 0.5/dy*dtemp*dtempdy;
  }
  return 1./sqrt(Pr)/sqrt(Ra)*riri;
}


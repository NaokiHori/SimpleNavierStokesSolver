#include <stdio.h>
#include <math.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "temperature.h"
#include "fileio.h"
#include "logging.h"
#include "analyses.h"


static int show_progress(const char fname[], const param_t *param, const parallel_t *parallel){
  if(parallel->mpirank == 0){
    char scheme[15];
    sprintf(scheme, "x: %3s, y: %3s",
        param->implicitx ? "IMP" : "EXP",
        param->implicity ? "IMP" : "EXP"
    );
    FILE *fp = NULL;
    if(param->step == 0){
      fp = fileio_fopen(fname, "w");
    }else{
      fp = fileio_fopen(fname, "a");
    }
    if(fp != NULL){
      /* ! show progress to standard output and file ! 2 ! */
      fprintf(fp,     "step %8d, time %7.1f, dt %.2e (%s)\n", param->step, param->time, param->dt, scheme);
      fprintf(stdout, "step %8d, time %7.1f, dt %.2e (%s)\n", param->step, param->time, param->dt, scheme);
      fileio_fclose(fp);
    }
  }
  return 0;
}

static int check_divergence(const char fname[], const param_t *param, const parallel_t *parallel, const fluid_t *fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *dxf = param->dxf;
  const double dy = param->dy;
  const double *ux = fluid->ux;
  const double *uy = fluid->uy;
  double divmax = 0.;
  double divsum = 0.;
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      /* ! compute local divergence ! 7 ! */
      double ux_xm = UX(i  , j  );
      double ux_xp = UX(i+1, j  );
      double uy_ym = UY(i  , j  );
      double uy_yp = UY(i  , j+1);
      double div =
        (ux_xp-ux_xm)/DXF(i)
       +(uy_yp-uy_ym)/dy;
      /* ! check local maximum divergence and global divergence ! 2 ! */
      divmax = fmax(divmax, fabs(div));
      divsum += div;
    }
  }
  /* ! collect information among all processes ! 2 ! */
  MPI_Allreduce(MPI_IN_PLACE, &divmax, 1, MPI_DOUBLE, MPI_MAX, MPI_COMM_WORLD);
  MPI_Allreduce(MPI_IN_PLACE, &divsum, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
  /* ! information are output, similar for other functions ! 10 ! */
  if(mpirank == 0){
    FILE *fp = NULL;
    if(param->step == 0){
      fp = fileio_fopen(fname, "w");
    }else{
      fp = fileio_fopen(fname, "a");
    }
    if(fp != NULL){
      fprintf(fp, "%8.2f % .1e % .1e\n", param->time, divmax, divsum);
      fileio_fclose(fp);
    }
  }
  return 0;
}

static int check_momentum(const char fname[], const param_t *param, const parallel_t *parallel, const fluid_t *fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double *ux = fluid->ux;
  const double *uy = fluid->uy;
  double moms[2] = {0.};
  /* ! compute total x-momentum ! 6 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot+1; i++){
      double cellsize = DXC(i)*dy;
      moms[0] += UX(i, j)*cellsize;
    }
  }
  /* ! compute total y-momentum ! 6 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      double cellsize = DXF(i)*dy;
      moms[1] += UY(i, j)*cellsize;
    }
  }
  MPI_Allreduce(MPI_IN_PLACE, moms, 2, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
  if(mpirank == 0){
    FILE *fp = NULL;
    if(param->step == 0){
      fp = fileio_fopen(fname, "w");
    }else{
      fp = fileio_fopen(fname, "a");
    }
    if(fp != NULL){
      fprintf(fp, "%8.2f % 18.15e % 18.15e\n", param->time, moms[0], moms[1]);
      fileio_fclose(fp);
    }
  }
  return 0;
}

static int check_energy(const char fname[], const param_t *param, const parallel_t *parallel, const fluid_t *fluid, const temperature_t *temperature){
  /* compute kinetic and thermal energies */
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double *ux = fluid->ux;
  const double *uy = fluid->uy;
  const double *temp = temperature->temp;
  double quantities[3] = {0.};
  /* ! compute quadratic quantity in x direction ! 6 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot+1; i++){
      double cellsize = DXC(i)*dy;
      quantities[0] += 0.5*pow(UX(i, j), 2.)*cellsize;
    }
  }
  /* ! compute quadratic quantity in y direction ! 6 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      double cellsize = DXF(i)*dy;
      quantities[1] += 0.5*pow(UY(i, j), 2.)*cellsize;
    }
  }
  /* ! compute thermal energy ! 6 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      double cellsize = DXF(i)*dy;
      quantities[2] += 0.5*pow(TEMP(i, j), 2.)*cellsize;
    }
  }
  MPI_Allreduce(MPI_IN_PLACE, quantities, 3, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
  if(mpirank == 0){
    FILE *fp = NULL;
    if(param->step == 0){
      fp = fileio_fopen(fname, "w");
    }else{
      fp = fileio_fopen(fname, "a");
    }
    if(fp != NULL){
      fprintf(fp, "%8.2f % 18.15e % 18.15e % 18.15e\n", param->time, quantities[0], quantities[1], quantities[2]);
      fileio_fclose(fp);
    }
  }
  return 0;
}

static int check_nusselt(const char fname[], const param_t *param, const parallel_t *parallel, const fluid_t *fluid, const temperature_t *temperature){
  /* compute temperature Nusselt number based on several definintions */
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double lx = param->lx;
  const double ly = param->ly;
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  const double Ra = param->Ra;
  const double Pr = param->Pr;
  const double *ux = fluid->ux;
  const double *temp = temperature->temp;
  /* ! heat flux on the walls ! 12 ! */
  double nu_wall = 0.;
  {
    // line integral on the walls
    for(int j=1; j<=jsize; j++){
      double dtdx0 = (TEMP(     1, j)-TEMP(   0, j))/DXC(     1);
      double dtdx1 = (TEMP(itot+1, j)-TEMP(itot, j))/DXC(itot+1);
      nu_wall -= 0.5*(dtdx0+dtdx1)*dy;
    }
    MPI_Allreduce(MPI_IN_PLACE, &nu_wall, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
    // line average
    nu_wall /= ly;
  }
  /* ! energy injection ! 15 ! */
  double nu_inje = 0.;
  {
    // surface integral
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot+1; i++){
        double integrand = UX(i, j)*0.5*(TEMP(i-1, j)+TEMP(i, j));
        double cellsize = DXC(i)*dy;
        nu_inje += sqrt(Pr)*sqrt(Ra)*integrand*cellsize;
      }
    }
    MPI_Allreduce(MPI_IN_PLACE, &nu_inje, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
    // surface average
    nu_inje /= lx*ly;
    nu_inje += 1.;
  }
  /* ! kinetic energy dissipation rate ! 23 ! */
  double nu_eps_k = 0.;
  {
    // surface integral (x-momentum contribution)
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot+1; i++){
        double cellsize = DXC(i)*dy;
        double integrand = analyses_compute_kinetic_dissipation_x(param, fluid, i, j);
        nu_eps_k += sqrt(Pr)*sqrt(Ra)*integrand*cellsize;
      }
    }
    // surface integral (y-momentum contribution)
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        double cellsize = DXF(i)*dy;
        double integrand = analyses_compute_kinetic_dissipation_y(param, fluid, i, j);
        nu_eps_k += sqrt(Pr)*sqrt(Ra)*integrand*cellsize;
      }
    }
    MPI_Allreduce(MPI_IN_PLACE, &nu_eps_k, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
    // surface average
    nu_eps_k /= lx*ly;
    nu_eps_k += 1.;
  }
  /* ! thermal energy dissipation rate ! 14 ! */
  double nu_eps_h = 0.;
  {
    // surface integral
    for(int j=1; j<=jsize; j++){
      for(int i=1; i<=itot; i++){
        double cellsize = DXF(i)*dy;
        double integrand = analyses_compute_thermal_dissipation(param, temperature, i, j);
        nu_eps_h += sqrt(Pr)*sqrt(Ra)*integrand*cellsize;
      }
    }
    MPI_Allreduce(MPI_IN_PLACE, &nu_eps_h, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
    // surface average
    nu_eps_h /= lx*ly;
  }
  if(mpirank == 0){
    FILE *fp = NULL;
    if(param->step == 0){
      fp = fileio_fopen(fname, "w");
    }else{
      fp = fileio_fopen(fname, "a");
    }
    if(fp != NULL){
      fprintf(fp, "%8.2f % 18.15e % 18.15e % 18.15e % 18.15e\n", param->time, nu_wall, nu_inje, nu_eps_k, nu_eps_h);
      fileio_fclose(fp);
    }
  }
  return 0;
}

int logging(param_t *param, const parallel_t *parallel, const fluid_t *fluid, const temperature_t *temperature){
  show_progress   (FILEIO_LOG "/progress.dat",   param, parallel);
  check_divergence(FILEIO_LOG "/divergence.dat", param, parallel, fluid);
  check_momentum  (FILEIO_LOG "/momentum.dat",   param, parallel, fluid);
  check_energy    (FILEIO_LOG "/energy.dat",     param, parallel, fluid, temperature);
  check_nusselt   (FILEIO_LOG "/nusselt.dat",    param, parallel, fluid, temperature);
  return 0;
}


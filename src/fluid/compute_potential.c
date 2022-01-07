#include <string.h>
#include <math.h>
#include <complex.h>
#include <fftw3.h>
#include "common.h"
#include "param.h"
#include "parallel.h"
#include "fluid.h"
#include "linalg.h"


#define QRX(I, J) (qrx[((J)-1)*(itot)+((I)-1)])
#define QCX(I, J) (qcx[((J)-1)*(itot)+((I)-1)])

int fluid_compute_potential(const param_t *param, const parallel_t *parallel, const int rkstep, fluid_t *fluid){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const double *dxf = param->dxf;
  const double *dxc = param->dxc;
  const double dy = param->dy;
  double *psi = fluid->psi;
  double *qrx = NULL;
  double *qry = NULL;
  fftw_complex *qcx = NULL;
  fftw_complex *qcy = NULL;
  fftw_plan fwrd = NULL;
  fftw_plan bwrd = NULL;
  /* allocate matrix and create fftw plans */
  {
    /* ! allocate buffers (different alignments, datatypes) ! 19 ! */
    // total size in x direction and its MPI-decomposed size
    const int xsize_total  =                   itot;
    const int xsize_decomp = parallel_get_size(itot, mpisize, mpirank);
    // total size in y direction (varying in physical and wave spaces) and their MPI-decomposed sizes
    const int ysize_total_physical  =                   jtot;
    const int ysize_decomp_physical = parallel_get_size(jtot, mpisize, mpirank);
    const int ysize_total_wave      =                   jtot/2+1;
    const int ysize_decomp_wave     = parallel_get_size(jtot/2+1, mpisize, mpirank);
    // datasizes
    size_t size_r = sizeof(double);
    size_t size_c = sizeof(fftw_complex);
    // in real (physical) space, x-aligned (decomposed in y)
    qrx = common_calloc(xsize_total  * ysize_decomp_physical, size_r);
    // in real (physical) space, y-aligned (decomposed in x)
    qry = common_calloc(xsize_decomp * ysize_total_physical,  size_r);
    // in complex (wave) space, x-aligned (decomposed in y)
    qcx = common_calloc(xsize_total  * ysize_decomp_wave,     size_c);
    // in complex (wave) space, y-aligned (decomposed in x)
    qcy = common_calloc(xsize_decomp * ysize_total_wave,      size_c);
    /* ! create fftw plans ! 14 ! */
    fftw_iodim dims[1], hdims[1];
    dims[0].n  = ysize_total_physical;
    dims[0].is = 1;
    dims[0].os = 1;
    // forward transform in y direction, real to complex, physical to wave spaces
    hdims[0].n  = xsize_decomp;
    hdims[0].is = ysize_total_physical;
    hdims[0].os = ysize_total_wave;
    fwrd = fftw_plan_guru_dft_r2c(1, dims, 1, hdims, qry, qcy, FFTW_ESTIMATE);
    // backward transform in y direction, complex to real, wave to physical spaces
    hdims[0].n  = xsize_decomp;
    hdims[0].is = ysize_total_wave;
    hdims[0].os = ysize_total_physical;
    bwrd = fftw_plan_guru_dft_c2r(1, dims, 1, hdims, qcy, qry, FFTW_ESTIMATE);
  }
  /* ! compute right-hand-side ! 17 ! */
  const double gamma = param->rkcoefs[rkstep].gamma;
  const double dt = param->dt;
  const double *ux = fluid->ux;
  const double *uy = fluid->uy;
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      double ux_xm = UX(i  , j  );
      double ux_xp = UX(i+1, j  );
      double uy_ym = UY(i  , j  );
      double uy_yp = UY(i  , j+1);
      QRX(i, j) =
        1./(gamma*dt)*(
         +(ux_xp-ux_xm)/DXF(i)
         +(uy_yp-uy_ym)/dy
        );
    }
  }
  /* ! transpose real x-aligned matrix to y-aligned matrix ! 1 ! */
  parallel_transpose(itot, jtot, sizeof(double), MPI_DOUBLE, qrx, qry);
  /* ! project to wave space ! 1 ! */
  fftw_execute(fwrd);
  /* ! transpose complex y-aligned matrix to x-aligned matrix ! 1 ! */
  parallel_transpose(jtot/2+1, itot, sizeof(fftw_complex), MPI_C_DOUBLE_COMPLEX, qcy, qcx);
  /* solve linear systems */
  {
  // macros for tri-diagonal matrix
  // starts from 1
#define TDM_L(I) (tdm_l[(I)-1])
#define TDM_C(I) (tdm_c[(I)-1])
#define TDM_U(I) (tdm_u[(I)-1])
#define TDM_Q(I) (tdm_q[(I)-1])
    double *tdm_l = NULL;
    double *tdm_c = NULL;
    double *tdm_u = NULL;
    fftw_complex *tdm_q = NULL;
    tdm_l = common_calloc(itot, sizeof(      double));
    tdm_c = common_calloc(itot, sizeof(      double));
    tdm_u = common_calloc(itot, sizeof(      double));
    tdm_q = common_calloc(itot, sizeof(fftw_complex));
    for(int j=1; j<=parallel_get_size(jtot/2+1, mpisize, mpirank); j++){
      /* ! compute eigenvalue of this j position ! 4 ! */
      int joffset = parallel_get_offset(jtot/2+1, mpisize, mpirank);
      double eigenvalue = -4./pow(dy, 2.)*pow(
          sin(M_PI*(j+joffset-1)/(1.*jtot)),
          2.
      );
      /* ! set lower and upper diagonal components ! 4 ! */
      for(int i=1; i<=itot; i++){
        TDM_L(i) = 1./DXC(i  )/DXF(i  );
        TDM_U(i) = 1./DXC(i+1)/DXF(i  );
      }
      /* ! set center diagonal components ! 3 ! */
      for(int i=1; i<=itot; i++){
        TDM_C(i) = -TDM_L(i)-TDM_U(i)+eigenvalue;
      }
      /* ! boundary treatment (Neumann boundary condition) ! 2 ! */
      TDM_C(   1) += TDM_L(   1);
      TDM_C(itot) += TDM_U(itot);
      /* ! solve linear system ! 7 ! */
      for(int i=1; i<=itot; i++){
        TDM_Q(i) = QCX(i, j);
      }
      my_zgtsv_b(itot, tdm_l, tdm_c, tdm_u, tdm_q);
      for(int i=1; i<=itot; i++){
        QCX(i, j) = TDM_Q(i);
      }
    }
    common_free(tdm_l);
    common_free(tdm_c);
    common_free(tdm_u);
    common_free(tdm_q);
#undef TDM_L
#undef TDM_C
#undef TDM_U
#undef TDM_Q
  }
  /* ! transpose complex x-aligned matrix to y-aligned matrix ! 1 ! */
  parallel_transpose(itot, jtot/2+1, sizeof(fftw_complex), MPI_C_DOUBLE_COMPLEX, qcx, qcy);
  /* ! project to physical space ! 1 ! */
  fftw_execute(bwrd);
  /* ! transpose real y-aligned matrix to x-aligned matrix ! 1 ! */
  parallel_transpose(jtot, itot, sizeof(double), MPI_DOUBLE, qry, qrx);
  /* ! normalise and store result ! 5 ! */
  for(int j=1; j<=jsize; j++){
    for(int i=1; i<=itot; i++){
      PSI(i, j) = QRX(i, j)/(1.*jtot);
    }
  }
  // NOTE: psi and p are assumed to have the same array shape
  fluid_update_boundaries_p(param, parallel, psi);
  /* deallocate memories */
  common_free(qrx);
  common_free(qry);
  common_free(qcx);
  common_free(qcy);
  fftw_destroy_plan(fwrd);
  fftw_destroy_plan(bwrd);
  return 0;
}

#undef QRX
#undef QCX


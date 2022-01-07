#include <math.h>
#include <float.h>
#include <complex.h>
#include <fftw3.h>
#include "common.h"
#include "linalg.h"


int my_dgtsv_b(const int n, double *tdm_l, double *tdm_c, double *tdm_u, double *tdm_q){
  /* ! divide first row by center-diagonal term ! 2 ! */
  tdm_u[0] = tdm_u[0]/tdm_c[0];
  tdm_q[0] = tdm_q[0]/tdm_c[0];
  /* ! forward sweep ! 11 ! */
  for(int i=1; i<=n-1; i++){
    double val = tdm_c[i]-tdm_l[i]*tdm_u[i-1];
    if(fabs(val) < DBL_EPSILON){
      tdm_u[i] = 0.;
      tdm_q[i] = 0.;
    }else{
      val = 1./val;
      tdm_u[i] = val* tdm_u[i];
      tdm_q[i] = val*(tdm_q[i]-tdm_l[i]*tdm_q[i-1]);
    }
  }
  /* ! backward sweep ! 3 ! */
  for(int i=n-2; i>=0; i--){
    tdm_q[i] -= tdm_u[i]*tdm_q[i+1];
  }
  return 0;
}

int my_zgtsv_b(const int n, double *tdm_l, double *tdm_c, double *tdm_u, fftw_complex *tdm_q){
  tdm_u[0] = tdm_u[0]/tdm_c[0];
  tdm_q[0] = tdm_q[0]/tdm_c[0];
  for(int i=1; i<=n-1; i++){
    double val = tdm_c[i]-tdm_l[i]*tdm_u[i-1];
    if(fabs(val) < DBL_EPSILON){
      tdm_u[i] = 0.;
      tdm_q[i] = 0.;
    }else{
      val = 1./val;
      tdm_u[i] = val* tdm_u[i];
      tdm_q[i] = val*(tdm_q[i]-tdm_l[i]*tdm_q[i-1]);
    }
  }
  for(int i=n-2; i>=0; i--){
    tdm_q[i] -= tdm_u[i]*tdm_q[i+1];
  }
  return 0;
}

int my_dgtsv_p(const int n, double *tdm_l, double *tdm_c, double *tdm_u, double *tdm_q){
  // 1st small linear system
  double *tdm_l0 = NULL;
  double *tdm_c0 = NULL;
  double *tdm_u0 = NULL;
  double *tdm_q0 = NULL;
  // 2nd small linear system
  double *tdm_l1 = NULL;
  double *tdm_c1 = NULL;
  double *tdm_u1 = NULL;
  double *tdm_q1 = NULL;
  /* ! create 1st small tri-diagonal system ! 10 ! */
  tdm_l0 = common_calloc(n-1, sizeof(double));
  tdm_c0 = common_calloc(n-1, sizeof(double));
  tdm_u0 = common_calloc(n-1, sizeof(double));
  tdm_q0 = common_calloc(n-1, sizeof(double));
  for(int i=0; i<n-1; i++){
    tdm_l0[i] = tdm_l[i];
    tdm_c0[i] = tdm_c[i];
    tdm_u0[i] = tdm_u[i];
    tdm_q0[i] = tdm_q[i];
  }
  /* ! create 2nd small tri-diagonal system ! 13 ! */
  tdm_l1 = common_calloc(n-1, sizeof(double));
  tdm_c1 = common_calloc(n-1, sizeof(double));
  tdm_u1 = common_calloc(n-1, sizeof(double));
  tdm_q1 = common_calloc(n-1, sizeof(double));
  for(int i=0; i<n-1; i++){
    tdm_l1[i] = tdm_l[i];
    tdm_c1[i] = tdm_c[i];
    tdm_u1[i] = tdm_u[i];
    tdm_q1[i]
      = i ==   0 ? -tdm_l[i]
      : i == n-2 ? -tdm_u[i]
      : 0.;
  }
  /* ! solve two small systems ! 2 ! */
  my_dgtsv_b(n-1, tdm_l0, tdm_c0, tdm_u0, tdm_q0);
  my_dgtsv_b(n-1, tdm_l1, tdm_c1, tdm_u1, tdm_q1);
  /* ! compute bottom solution ! 3 ! */
  tdm_q[n-1]
    = (tdm_q[n-1]-tdm_u[n-1]*tdm_q0[0]-tdm_l[n-1]*tdm_q0[n-2])
    / (tdm_c[n-1]+tdm_u[n-1]*tdm_q1[0]+tdm_l[n-1]*tdm_q1[n-2]);
  /* ! assign answers of the original system ! 3 ! */
  for(int i=0; i<=n-2; i++){
    tdm_q[i] = tdm_q0[i]+tdm_q[n-1]*tdm_q1[i];
  }
  common_free(tdm_l0);
  common_free(tdm_c0);
  common_free(tdm_u0);
  common_free(tdm_q0);
  common_free(tdm_l1);
  common_free(tdm_c1);
  common_free(tdm_u1);
  common_free(tdm_q1);
  return 0;
}


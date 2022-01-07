#include <mpi.h>
#include "common.h"
#include "parallel.h"


int parallel_get_size(const int num_total, const int mpisize, const int mpirank){
  /* ! number of grid points of the process ! 2 ! */
  int num_local = (num_total+mpirank)/mpisize;
  return num_local;
}

int parallel_get_offset(const int num_total, const int mpisize, const int mpirank){
  /* ! sum up the number of grid points to the process ! 5 ! */
  int offset = 0;
  for(int i=0; i<mpirank; i++){
    offset += parallel_get_size(num_total, mpisize, i);
  }
  return offset;
}

double parallel_get_wtime(const MPI_Op op){
  double time;
  time = MPI_Wtime();
  MPI_Allreduce(MPI_IN_PLACE, &time, 1, MPI_DOUBLE, op, MPI_COMM_WORLD);
  return time;
}


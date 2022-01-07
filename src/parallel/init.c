#include <stdlib.h>
#include <mpi.h>
#include "common.h"
#include "parallel.h"


static int init(parallel_t *parallel){
  int mpisize, mpirank;
  /* ! get number of process ! 1 ! */
  MPI_Comm_size(MPI_COMM_WORLD, &mpisize);
  parallel->mpisize = mpisize;
  /* ! get my process id ! 1 ! */
  MPI_Comm_rank(MPI_COMM_WORLD, &mpirank);
  parallel->mpirank = mpirank;
  /* ! assign neighbour rank ! 8 ! */
  parallel->ymrank = mpirank-1;
  parallel->yprank = mpirank+1;
  if(mpirank == 0){
    parallel->ymrank = mpisize-1;
  }
  if(mpirank == mpisize-1){
    parallel->yprank = 0;
  }
  /* ! random seed is set for reproducibility ! 1 ! */
  srand(mpirank);
  return 0;
}

parallel_t *parallel_init(void){
  /* ! allocated ! 1 ! */
  parallel_t *parallel = common_calloc(1, sizeof(parallel_t));
  /* ! initialised ! 1 ! */
  init(parallel);
  return parallel;
}


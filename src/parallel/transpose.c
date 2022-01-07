#include <mpi.h>
#include "common.h"
#include "parallel.h"


int parallel_transpose(const int g_isize, const int g_jsize, const size_t dtypesize, const MPI_Datatype mpi_dtype, const void *sendbuf, void *recvbuf){
  int mpisize, mpirank;
  MPI_Datatype *sendtypes = NULL;
  MPI_Datatype *recvtypes = NULL;
  int *sendcounts = NULL;
  int *recvcounts = NULL;
  int *sdispls = NULL;
  int *rdispls = NULL;
  MPI_Comm_size(MPI_COMM_WORLD, &mpisize);
  MPI_Comm_rank(MPI_COMM_WORLD, &mpirank);
  sendtypes  = common_calloc(mpisize, sizeof(MPI_Datatype));
  recvtypes  = common_calloc(mpisize, sizeof(MPI_Datatype));
  sendcounts = common_calloc(mpisize, sizeof(int)         );
  recvcounts = common_calloc(mpisize, sizeof(int)         );
  sdispls    = common_calloc(mpisize, sizeof(int)         );
  rdispls    = common_calloc(mpisize, sizeof(int)         );
  for(int n=0; n<mpisize; n++){
    int xalign_block_isize = parallel_get_size(g_isize, mpisize, n);
    int xalign_block_jsize = parallel_get_size(g_jsize, mpisize, mpirank);
    int yalign_block_isize = parallel_get_size(g_isize, mpisize, mpirank);
    int yalign_block_jsize = parallel_get_size(g_jsize, mpisize, n);
    MPI_Datatype tmpdtype;
    /* ! datatype to be sent: contiguous in y direction ! 8 ! */
    MPI_Type_create_hvector(
        /* int count             */ xalign_block_jsize,
        /* int blocklength       */ 1,
        /* MPI_Aint stride       */ dtypesize*g_isize,
        /* MPI_Datatype oldtype  */ mpi_dtype,
        /* MPI_Datatype *newtype */ &tmpdtype
    );
    MPI_Type_commit(&tmpdtype);
    /* ! datatype to be sent: the datatype previously defined is repeated in x direction ! 9 ! */
    MPI_Type_create_hvector(
        /* int count             */ xalign_block_isize,
        /* int blocklength       */ 1,
        /* MPI_Aint stride       */ dtypesize,
        /* MPI_Datatype oldtype  */ tmpdtype,
        /* MPI_Datatype *newtype */ &(sendtypes[n])
    );
    // the intermediate datatype is no longer used
    MPI_Type_free(&tmpdtype);
    /* ! datatype to be received: the data is already aligned in y direction ! 7 ! */
    MPI_Type_create_hvector(
        /* int count             */ yalign_block_isize,
        /* int blocklength       */ yalign_block_jsize,
        /* MPI_Aint stride       */ dtypesize*g_jsize,
        /* MPI_Datatype oldtype  */ mpi_dtype,
        /* MPI_Datatype *newtype */ &(recvtypes[n])
    );
    /* ! number of elements to be sent/received ! 2 ! */
    sendcounts[n] = 1;
    recvcounts[n] = 1;
    /* ! the offset of the pointers ! 2 ! */
    sdispls[n] = dtypesize*parallel_get_offset(g_isize, mpisize, n);
    rdispls[n] = dtypesize*parallel_get_offset(g_jsize, mpisize, n);
  }
  /* ! datatypes are created ! 4 ! */
  for(int n=0; n<mpisize; n++){
    MPI_Type_commit(&(sendtypes[n]));
    MPI_Type_commit(&(recvtypes[n]));
  }
  /* ! matrix is transposed ! 5 ! */
  MPI_Alltoallw(
      sendbuf, sendcounts, sdispls, sendtypes,
      recvbuf, recvcounts, rdispls, recvtypes,
      MPI_COMM_WORLD
  );
  /* ! finalised ! 10 ! */
  for(int n=0; n<mpisize; n++){
    MPI_Type_free(&(sendtypes[n]));
    MPI_Type_free(&(recvtypes[n]));
  }
  common_free(sendtypes);
  common_free(recvtypes);
  common_free(sendcounts);
  common_free(recvcounts);
  common_free(sdispls);
  common_free(rdispls);
  return 0;
}

/* for debug use of parallel matrix transpose */

#if defined(DEBUG_TEST)

#include <stdio.h>
#include <limits.h>
#include <assert.h>

#define MYTYPE int
#define MPI_MYTYPE MPI_INT

static int test1(const int itot, const int jtot){
  int mpisize, mpirank;
  MPI_Comm_size(MPI_COMM_WORLD, &mpisize);
  MPI_Comm_rank(MPI_COMM_WORLD, &mpirank);
  int jsize = parallel_get_size  (jtot, mpisize, mpirank);
  int joffs = parallel_get_offset(jtot, mpisize, mpirank);
  int isize = parallel_get_size  (itot, mpisize, mpirank);
  int ioffs = parallel_get_offset(itot, mpisize, mpirank);
  MYTYPE *qx = common_calloc(itot *jsize, sizeof(MYTYPE));
  MYTYPE *qy = common_calloc(isize* jtot, sizeof(MYTYPE));
  for(int j = 0; j < jsize; j++){
    for(int i = 0; i < itot; i++){
      qx[j*itot+i] = (j+joffs)*itot+i;
    }
  }
  parallel_transpose(itot, jtot, sizeof(MYTYPE), MPI_MYTYPE, qx, qy);
  for(int i = 0; i < isize; i++){
    for(int j = 0; j < jtot; j++){
      assert(qy[i*jtot+j] == j*itot+(i+ioffs));
    }
  }
  common_free(qx);
  common_free(qy);
  return 0;
}

#undef MYTYPE
#undef MPI_MYTYPE

#define MYTYPE double
#define MPI_MYTYPE MPI_DOUBLE

static int test2(const int itot, const int jtot){
  int mpisize, mpirank;
  MPI_Comm_size(MPI_COMM_WORLD, &mpisize);
  MPI_Comm_rank(MPI_COMM_WORLD, &mpirank);
  int jsize = parallel_get_size  (jtot, mpisize, mpirank);
  int joffs = parallel_get_offset(jtot, mpisize, mpirank);
  int isize = parallel_get_size  (itot, mpisize, mpirank);
  int ioffs = parallel_get_offset(itot, mpisize, mpirank);
  MYTYPE *qx = common_calloc(itot *jsize, sizeof(MYTYPE));
  MYTYPE *qy = common_calloc(isize* jtot, sizeof(MYTYPE));
  for(int j = 0; j < jsize; j++){
    for(int i = 0; i < itot; i++){
      qx[j*itot+i] = (j+joffs)*itot+i;
    }
  }
  parallel_transpose(itot, jtot, sizeof(MYTYPE), MPI_MYTYPE, qx, qy);
  for(int i = 0; i < isize; i++){
    for(int j = 0; j < jtot; j++){
      assert(qy[i*jtot+j] == j*itot+(i+ioffs));
    }
  }
  common_free(qx);
  common_free(qy);
  return 0;
}

#undef MYTYPE
#undef MPI_MYTYPE

int main(const int argc, const char *argv[]){
  MPI_Init(NULL, NULL);
  assert(argc == 3); // __FILE__, litot, ljtot
  const long litot = strtol(argv[1], NULL, 10);
  const long ljtot = strtol(argv[2], NULL, 10);
  assert(litot < INT_MAX);
  assert(ljtot < INT_MAX);
  assert(0 < litot);
  assert(0 < ljtot);
  const int itot = (int)litot;
  const int jtot = (int)ljtot;
  // int
  test1(itot, jtot);
  // double
  test2(itot, jtot);
  MPI_Finalize();
  return 0;
}

#endif // DEBUG_TEST


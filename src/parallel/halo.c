#include <mpi.h>
#include "common.h"
#include "parallel.h"


int parallel_update_halo_ym(const parallel_t *parallel, const int cnt, const MPI_Datatype dtype, const void *sendbuf, void *recvbuf){
  const int sendtag = 0;
  const int recvtag = 0;
  const int ymrank = parallel->ymrank;
  const int yprank = parallel->yprank;
  MPI_Sendrecv(sendbuf, cnt, dtype, yprank, sendtag, recvbuf, cnt, dtype, ymrank, recvtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
  return 0;
}

int parallel_update_halo_yp(const parallel_t *parallel, const int cnt, const MPI_Datatype dtype, const void *sendbuf, void *recvbuf){
  const int sendtag = 0;
  const int recvtag = 0;
  const int ymrank = parallel->ymrank;
  const int yprank = parallel->yprank;
  MPI_Sendrecv(sendbuf, cnt, dtype, ymrank, sendtag, recvbuf, cnt, dtype, yprank, recvtag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
  return 0;
}


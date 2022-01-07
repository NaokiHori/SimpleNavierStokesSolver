#if !defined(PARALLEL_H)
#define PARALLEL_H

#include <stddef.h>
#include <mpi.h>

#include "structure.h"

/* ! definition of a structure parallel_t_ ! 4 ! */
struct parallel_t_ {
  int mpisize, mpirank;
  int ymrank, yprank;
};

extern parallel_t *parallel_init(void);
extern int parallel_finalise(parallel_t *parallel);
extern int parallel_get_size(const int num, const int size, const int rank);
extern int parallel_get_offset(const int num, const int size, const int rank);
extern double parallel_get_wtime(const MPI_Op op);

/* parallel matrix transpose */
extern int parallel_transpose(const int g_isize, const int g_jsize, const size_t dtype, const MPI_Datatype mpi_dtype, const void *sendbuf, void *recvbuf);

/* parallel halo communication */
extern int parallel_update_halo_ym(const parallel_t *parallel, const int cnt, const MPI_Datatype dtype, const void *sendbuf, void *recvbuf);
extern int parallel_update_halo_yp(const parallel_t *parallel, const int cnt, const MPI_Datatype dtype, const void *sendbuf, void *recvbuf);

#endif // PARALLEL_H

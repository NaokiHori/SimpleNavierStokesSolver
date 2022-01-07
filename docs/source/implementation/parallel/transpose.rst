
.. _parallel_transpose:

##################################################################################################################
`parallel/transpose.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/parallel/transpose.c>`_
##################################################################################################################

A function to transpose two-dimensional matrix

******************
parallel_transpose
******************

==========
Definition
==========

.. code-block:: c

   int parallel_transpose(
       const int g_isize,
       const int g_jsize,
       const size_t dtypesize,
       const MPI_Datatype mpi_dtype,
       const void *sendbuf,
       void *recvbuf
   );

========= =========== =========================
Name      intent      description
========= =========== =========================
g_isize   in          number of points in :math:`x` direction
g_jsize   in          number of points in :math:`y` direction
dtypesize in          size of an element of the matrix
mpi_dtype in          datatype of the matrix
sendbuf   in          pointer to the matrix to be transposed
recvbuf   out         pointer to the transposed matrix
========= =========== =========================

===========
Description
===========

In the fluid solver, a matrix which is aligned in :math:`x` direction by default sometimes needs to be re-aligned to a :math:`y`-aligned one:

.. image:: image/transpose1.pdf
   :width: 800

in order to transpose the matrix (see :ref:`src/fluid/update_velocity.c <fluid_update_velocity>` and :ref:`src/fluid/compute_potential.c <fluid_compute_potential>`); This function takes on the role of this process.
Note that the red arrows denote the contiguous directions of the memory, i.e., the memories are contiguous in :math:`x` and :math:`y` directions before and after the transpose, respectively.

As an example to guide the discussion, we consider a matrix whose size in :math:`x` and :math:`y` directions are :math:`7` and :math:`11`, respectively, which is split in :math:`y` direction with :math:`3` processes by default:

.. image:: image/transpose2.pdf
   :width: 300

Note that the value of each element shows the row (:math:`x` location) and the column (:math:`y` location), i.e., :math:`\text{column} - \text{row}` for convenience.

Since the domain is split in :math:`y` direction originally, some information should be communicated in order to transpose the whole matrix, which can be achieved by using a function :c-lang:`MPI_Alltoall`:

.. image:: image/transpose3.pdf
   :width: 800

where values :math:`A_{ij}` are exchanged between process :math:`i` and :math:`j`.

In our case, however, the information to be communicated is not a single value but a block including multiple values which are not contiguous in memory.
To overcome this, for each block, we define an :c-lang:`MPI_Datatype` including all values and communicate them (as if the new datatype is a single value), which can be achieved by using an extended all-to-all function :c-lang:`MPI_Alltoallw`.

Different datatypes should be created for each communication since the block sizes are different in general.
For simplicity, we focus on the communication from process 0 (:c-lang:`mpirank = 0`) to process 1 (:c-lang:`mpirank = 1`), i.e., :math:`A_{01}` block.

First, we consider to create an intermediate datatype:

.. image:: image/transpose4.pdf
   :width: 300

where the values in the first column (:math:`0-2`, :math:`1-2`, and :math:`2-2`) are covered first.
The implementation can be found here:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: datatype to be sent: contiguous in y direction

where a new datatype :c-lang:`tmpdtype` is created as an intermediate type.
Note that the number of elements is :c-lang:`count = xalign_block_jsize`, only :c-lang:`blocklength = 1` column is considered for now, offset between two elements in the original array is :c-lang:`stride = dtypesize*g_isize` (the unit is byte), datatype is the given one :c-lang:`oldtype = mpi_dtype`.
Note that the memory ordering is swapped here, i.e., memory is contiguous in the red arrow direction originally, which is changed to the direction of the blue arrows.

This datatype is used to define a new datatype by repeating in :math:`x` direction:

.. image:: image/transpose5.pdf
   :width: 800

where the blue rectangle denotes the intermediate datatype.
The right one-dimensional container is a virtual buffer describing how the values are ordered and sent.
The implementation is found here:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: datatype to be sent: the datatype previously defined is repeated in x direction

Note that the number of elements is :c-lang:`count = xalign_block_isize`, only :c-lang:`blocklength = 1` component is considered, offset between two elements in the original array is :c-lang:`stride = dtypesize` (the unit is byte), datatype is the intermediate datatype :c-lang:`oldtype = tmpdtype`.

This data is sent to the other process (it can be the same process), which should be *unpacked* to assign to the appropriate memory locations.
To do so, a new datatype is created again:

.. image:: image/transpose6.pdf
   :width: 800

whose implementation can be found here:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: datatype to be received: the data is already aligned in y direction

Note that the number of elements is :c-lang:`count = yalign_block_isize`, :c-lang:`blocklength = yalign_block_jsize` components are assigned contiguously, offset between two blocks is :c-lang:`stride = dtypesize*g_jsize` (the unit is byte), and the datatype is the given one :c-lang:`oldtype = mpi_dtype`.
This created new type can be directly used.

Since the new datatypes is designed to contain all values inside the block, the number of elements to be sent and received is :c-lang:`1`:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: number of elements to be sent/received

Also the offset of the pointers of data to be transposed can be obtained as:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: the offset of the pointers

After the datatypes are committed:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: datatypes are created

The matrix is transposed:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: matrix is transposed

Finally the working arrays and created datatypes are deallocated:

.. myliteralinclude:: /../../src/parallel/transpose.c
   :language: c
   :tag: finalised

A working example can be found below.

.. code-block:: c

  #include <stdio.h>
  #include <stdlib.h>
  #include <mpi.h>


  #define ALLOCATE(ptr, size){                      \
    if(((ptr) = calloc(1, (size))) == NULL){        \
      printf("memory allocation error: %s\n", #ptr);\
      exit(EXIT_FAILURE);                           \
    }                                               \
  }

  #define DEALLOCATE(ptr){\
    free((ptr));          \
    (ptr) = NULL;         \
  }

  static int parallel_get_size(const int num_total, const int mpisize, const int mpirank){
    /* ! number of grid points of the process ! 2 ! */
    int num_local = (num_total+mpirank)/mpisize;
    return num_local;
  }

  static int parallel_get_offset(const int num_total, const int mpisize, const int mpirank){
    /* ! sum up the number of grid points to the process ! 5 ! */
    int offset = 0;
    for(int i=0; i<mpirank; i++){
      offset += parallel_get_size(num_total, mpisize, i);
    }
    return offset;
  }

  static int parallel_transpose(const int g_isize, const int g_jsize, const size_t dtypesize, const MPI_Datatype mpi_dtype, const void *sendbuf, void *recvbuf){
    int mpisize, mpirank;
    MPI_Datatype *sendtypes = NULL;
    MPI_Datatype *recvtypes = NULL;
    int *sendcounts = NULL;
    int *recvcounts = NULL;
    int *sdispls = NULL;
    int *rdispls = NULL;
    MPI_Comm_size(MPI_COMM_WORLD, &mpisize);
    MPI_Comm_rank(MPI_COMM_WORLD, &mpirank);
    ALLOCATE(sendtypes,  sizeof(MPI_Datatype)*mpisize);
    ALLOCATE(recvtypes,  sizeof(MPI_Datatype)*mpisize);
    ALLOCATE(sendcounts, sizeof(int)         *mpisize);
    ALLOCATE(recvcounts, sizeof(int)         *mpisize);
    ALLOCATE(sdispls,    sizeof(int)         *mpisize);
    ALLOCATE(rdispls,    sizeof(int)         *mpisize);
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
    /* ! matrix is transposed ! 11 ! */
    MPI_Alltoallw(
        sendbuf,
        sendcounts,
        sdispls,
        sendtypes,
        recvbuf,
        recvcounts,
        rdispls,
        recvtypes,
        MPI_COMM_WORLD
    );
    /* ! finalised ! 10 ! */
    for(int n=0; n<mpisize; n++){
      MPI_Type_free(&(sendtypes[n]));
      MPI_Type_free(&(recvtypes[n]));
    }
    DEALLOCATE(sendtypes);
    DEALLOCATE(recvtypes);
    DEALLOCATE(sendcounts);
    DEALLOCATE(recvcounts);
    DEALLOCATE(sdispls);
    DEALLOCATE(rdispls);
    return 0;
  }

  int main(void){
    int mpisize, mpirank;
    const int itot = 7;
    const int jtot = 11;
    MPI_Init(NULL, NULL);
    MPI_Comm_size(MPI_COMM_WORLD, &mpisize);
    MPI_Comm_rank(MPI_COMM_WORLD, &mpirank);
    const int isize = parallel_get_size(itot, mpisize, mpirank);
    const int jsize = parallel_get_size(jtot, mpisize, mpirank);
    int *x = NULL;
    int *y = NULL;
    ALLOCATE(x, sizeof(int)*itot*jsize);
    ALLOCATE(y, sizeof(int)*isize*jtot);
    for(int j=0; j<jsize; j++){
      const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
      for(int i=0; i<itot; i++){
        x[j*itot+i] = 100.*(j+joffset)+i;
      }
    }
    for(int n=0; n<mpisize; n++){
      if(n == mpirank){
        printf("rank %5d\n", n);
        for(int j=0; j<jsize; j++){
          for(int i=0; i<itot; i++){
            printf("%04d%c", x[j*itot+i], i == itot-1 ? '\n' : ' ');
          }
        }
      }
      MPI_Barrier(MPI_COMM_WORLD);
    }
    parallel_transpose(itot, jtot, sizeof(int), MPI_INT, x, y);
    for(int n=0; n<mpisize; n++){
      if(n == mpirank){
        printf("rank %5d\n", n);
        for(int i=0; i<isize; i++){
          for(int j=0; j<jtot; j++){
            printf("%04d%c", y[i*jtot+j], j == jtot-1 ? '\n' : ' ');
          }
        }
      }
      MPI_Barrier(MPI_COMM_WORLD);
    }
    DEALLOCATE(x);
    DEALLOCATE(y);
    MPI_Finalize();
    return 0;
  }


#########
parallel/
#########

Directory ``src/parallel`` contains source files which are relevant to MPI procedures.

.. toctree::
   :maxdepth: 1

   finalise
   halo
   init
   others
   transpose

**********
parallel_t
**********

A structure :c-lang:`parallel_t` is defined in `include/parallel.h <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/include/parallel.h>`_, which contains parameters which are relevant to the parallelisation:

.. myliteralinclude:: /../../include/parallel.h
   :language: c
   :tag: definition of a structure parallel_t_

The meanings of each member are as follows:

1. :c-lang:`mpisize`

   Number of total processors, which is given in ``exec.sh`` as e.g., :sh:`mpirun -n 64 ./a.out`

2. :c-lang:`mpirank`

   Process ID to identify each process (i.e., all processes have different numbers)

3. :c-lang:`ymrank` and :c-lang:`ymrank`

   :c-lang:`parallel->mpirank` of the neighbouring processes

Also see :ref:`src/parallel/init.c <parallel_init>` to see how they are initialised.


.. _parallel_others:

############################################################################################################
`parallel/others.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/parallel/others.c>`_
############################################################################################################

Auxiliary functions which are relevant to parallel treatments.

*****************
parallel_get_size
*****************

==========
Definition
==========

.. code-block:: c

   int parallel_get_size(
       const int num_total,
       const int mpisize,
       const int mpirank
   );

========= =========== =========================
Name      intent      description
========= =========== =========================
num_total in          number of total points
mpisize   in          number of MPI processes
mpirank   in          rank of the process which calls this function
num_local out(return) number of local points
========= =========== =========================

===========
Description
===========

As explained in the :ref:`spatial discretisation <spatial_discretisation>`, the domain (whose size is :c-lang:`jtot`) is split in :math:`y` direction; this function determines the local (each processor's) size of the domain (:c-lang:`jsize`) using the relation:

.. math::
   \text{jsize} = \left( \text{jtot} + \text{mpirank} \right) / \text{mpisize},

whose implementation can be found here:

.. myliteralinclude:: /../../src/parallel/others.c
   :language: c
   :tag: number of grid points of the process

Note that the division of an integer number truncates towards 0.
For instance, when the number of grid points in :math:`y` direction is 11 (:c-lang:`jtot` = :c-lang:`11`) and the number of processors :c-lang:`mpisize` is :c-lang:`3`, processor 0, 1, 2 (:c-lang:`mpirank` are :c-lang:`0`, :c-lang:`1`, and :c-lang:`2`) have :c-lang:`jsize` = :c-lang:`3`, :c-lang:`4`, and :c-lang:`4`, respectively:

.. image:: image/others1.pdf
   :width: 800

Of course the summation of all :c-lang:`jsize` among all processes is equal to :c-lang:`jtot` to cover the whole domain.

*******************
parallel_get_offset
*******************

==========
Definition
==========

.. code-block:: c

   int parallel_get_offset(
       const int num_total,
       const int mpisize,
       const int mpirank
   );

========= =========== =========================
Name      intent      description
========= =========== =========================
num_total in          number of total points
mpisize   in          number of MPI processes
mpirank   in          rank of the process which calls this function
offset    out(return) offset of the process
========= =========== =========================

===========
Description
===========

The function :c-lang:`parallel_get_size` returns the number of grid points in each process.
On the other hand, :c-lang:`parallel_get_offset` computes the *offset* by summing up the number of grid points in front of the process:

.. myliteralinclude:: /../../src/parallel/others.c
   :language: c
   :tag: sum up the number of grid points to the process

See the schematic below to understand the functions intuitively:

.. image:: image/others2.pdf
   :width: 500

Note that :c-lang:`offset` is :c-lang:`0` for :c-lang:`mpirank = 0`.

******************
parallel_get_wtime
******************

==========
Definition
==========

.. code-block:: c

   double parallel_get_wtime(
       const MPI_Op op
   );

===== =========== =========================
Name  intent      description
===== =========== =========================
op    in          MPI operator
wtime out(return) current wall time
===== =========== =========================

===========
Description
===========

The function :c-lang:`parallel_get_wtime` is a wrapper function of :c-lang:`MPI_Wtime` and returns the current wall time.
In order to synchronize the result among all processes (indeed :c-lang:`MPI_Wtime` can return different results), :c-lang:`MPI_Allreduce` is used with an operation :c-lang:`op` (e.g., :c-lang:`MPI_MAX` or :c-lang:`MPI_MIN` in most cases).


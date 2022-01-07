
.. _temperature_boundary_conditions:

############################################################################################################################################
`temperature/boundary_conditions.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/temperature/boundary_conditions.c>`_
############################################################################################################################################

Update boundary values (boundary condition, halo cells) of the temperature field.

**********************************
temperature_update_boundaries_temp
**********************************

==========
Definition
==========

.. code-block:: c

   int temperature_update_boundaries_temp(
       const param_t *param,
       const parallel_t *parallel,
       double *temp
   );

======== ====== ==================
Name     intent description
======== ====== ==================
param    in     general parameters
parallel in     MPI parameters
temp     out    temperature
======== ====== ==================

===========
Description
===========

Since the domain is wall-bounded in :math:`x` direction, boundary condition should be imposed on the `x` boundaries.
By default, Dirichlet boundary conditions are used:

.. myliteralinclude:: /../../src/temperature/boundary_conditions.c
   :language: c
   :tag: set boundary values of temp

Also halo cells are communicated here:

.. myliteralinclude:: /../../src/temperature/boundary_conditions.c
   :language: c
   :tag: update halo values of temp

where :c-lang:`parallel_update_halo_ym` is responsible for the communication with the lower process:

.. image:: image/boundary_conditions1.pdf
   :width: 800

while :c-lang:`parallel_update_halo_yp` is responsible for the communication with the upper process:

.. image:: image/boundary_conditions2.pdf
   :width: 800

Note that values only between :c-lang:`i=1` and :c-lang:`i=itot` (:c-lang:`itot` components) are communicated in each function, i.e., boundary values are not communicated, which is because their values are fixed and thus not necessary to be exchanged.

Also see :ref:`src/parallel/halo.c <parallel_halo>`.



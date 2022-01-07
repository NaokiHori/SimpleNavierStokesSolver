
.. _fluid_boundary_conditions:

################################################################################################################################
`fluid/boundary_conditions.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/boundary_conditions.c>`_
################################################################################################################################

Update boundary values (boundary condition, halo cells) of the velocity and pressure fields.

**************************
fluid_update_boundaries_ux
**************************

==========
Definition
==========

.. code-block:: c

   int fluid_update_boundaries_ux(
       const param_t *param,
       const parallel_t *parallel,
       double *ux
   );

======== ====== ====================
Name     intent description
======== ====== ====================
param    in     general parameters
parallel in     MPI parameters
ux       out    x direction velocity
======== ====== ====================

===========
Description
===========

Since the domain is wall-bounded in :math:`x` direction, impermeable condition is imposed on the `x` boundaries:

.. myliteralinclude:: /../../src/fluid/boundary_conditions.c
   :language: c
   :tag: set boundary values of ux

Also halo cells are communicated here:

.. myliteralinclude:: /../../src/fluid/boundary_conditions.c
   :language: c
   :tag: update halo values of ux

where :c-lang:`parallel_update_halo_ym` is responsible for the communication with the lower process:

.. image:: image/boundary_conditions1.pdf
   :width: 800

while :c-lang:`parallel_update_halo_yp` is responsible for the communication with the upper process:

.. image:: image/boundary_conditions2.pdf
   :width: 800

Note that values only between :c-lang:`i=2` and :c-lang:`i=itot-1` (:c-lang:`itot-1` components) are communicated in each function, i.e., boundary values are not communicated, which is because their values are fixed and thus not necessary to be exchanged.
Also see :ref:`src/parallel/halo.c <parallel_halo>`.

**************************
fluid_update_boundaries_uy
**************************

==========
Definition
==========

.. code-block:: c

   int fluid_update_boundaries_uy(
       const param_t *param,
       const parallel_t *parallel,
       double *uy
   );

======== ====== ====================
Name     intent description
======== ====== ====================
param    in     general parameters
parallel in     MPI parameters
uy       out    y direction velocity
======== ====== ====================

===========
Description
===========

Since the domain is wall-bounded in :math:`x` direction, no-slip condition is imposed on the `x` boundaries:

.. myliteralinclude:: /../../src/fluid/boundary_conditions.c
   :language: c
   :tag: set boundary values of uy

Note that :c-lang:`UY(0, j)` and :c-lang:`UY(itot+1, j)` are defined at the wall locations although they are defined at cell center in the bulk region (see :ref:`Spatial discretisation <spatial_discretisation>`).

Also halo cells are communicated here:

.. myliteralinclude:: /../../src/fluid/boundary_conditions.c
   :language: c
   :tag: update halo values of uy

where :c-lang:`parallel_update_halo_ym` is responsible for the communication with the lower process:

.. image:: image/boundary_conditions3.pdf
   :width: 800

while :c-lang:`parallel_update_halo_yp` is responsible for the communication with the upper process:

.. image:: image/boundary_conditions4.pdf
   :width: 800

Note that values only between :c-lang:`i=1` and :c-lang:`i=itot` (:c-lang:`itot` components) are communicated in each function, i.e., boundary values are not communicated, which is because their values are fixed and thus not necessary to be exchanged.
Also see :ref:`src/parallel/halo.c <parallel_halo>`.

*************************
fluid_update_boundaries_p
*************************

==========
Definition
==========

.. code-block:: c

   int fluid_update_boundaries_p(
       const param_t *param,
       const parallel_t *parallel,
       double *p
   );

======== ====== ==================
Name     intent description
======== ====== ==================
param    in     general parameters
parallel in     MPI parameters
p        out    pressure
======== ====== ==================

===========
Description
===========

Since the domain is wall-bounded in :math:`x` direction, Neumann condition is imposed on the `x` boundaries:

.. myliteralinclude:: /../../src/fluid/boundary_conditions.c
   :language: c
   :tag: set boundary values of p

Note that Neumann boundary condition is also used (implicitly assumed) in the Poisson solver (see :ref:`src/fluid/compute_potential.c <fluid_compute_potential>`).

Also halo cells are communicated here:

.. myliteralinclude:: /../../src/fluid/boundary_conditions.c
   :language: c
   :tag: update halo values of p

where :c-lang:`parallel_update_halo_ym` is responsible for the communication with the lower process:

.. image:: image/boundary_conditions5.pdf
   :width: 800

while :c-lang:`parallel_update_halo_yp` is responsible for the communication with the upper process:

.. image:: image/boundary_conditions6.pdf
   :width: 800

Note that values only between :c-lang:`i=1` and :c-lang:`i=itot` (:c-lang:`itot` components) are communicated in each function, i.e., boundary values are not communicated, which is because their values are fixed and thus not necessary to be exchanged.
Since boundary values are functions of the inner point in this case, the boundary values should be updated after the communications.

Also see :ref:`src/parallel/halo.c <parallel_halo>`.


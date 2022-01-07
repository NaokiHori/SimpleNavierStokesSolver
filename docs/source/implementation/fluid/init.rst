
.. _fluid_init:

##################################################################################################
`fluid/init.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/init.c>`_
##################################################################################################

Initialise a structure :c-lang:`fluid_t *fluid` and its members.

**********
fluid_init
**********

==========
Definition
==========

.. code-block:: c

   int fluid_init(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== =========================
Name     intent description
======== ====== =========================
param    in     general parameters
parallel in     MPI parameters
fluid    out    allocated and initialised
======== ====== =========================

===========
Description
===========

A :c-lang:`fluid` structure and its members are allocated:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: allocate structure and its members

and values are initialised when the simulation is started from the beginning, or values are loaded from a directory (:c-lang:`char param->dirname_restart`, see :ref:`param_t <param>`) to restart the run:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: initialise or load velocity and pressure

********
allocate
********

==========
Definition
==========

.. code-block:: c

   static int allocate(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t **fluid
   );

======== ====== ==================
Name     intent description
======== ====== ==================
param    in     general parameters
parallel in     MPI parameters
fluid    out    allocated
======== ====== ==================

===========
Description
===========

A pointer to a :c-lang:`fluid` structure is allocated:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: structure is allocated

as well as velocity, pressure, and scalar potential fields:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: velocity, pressure, scalar potential are allocated

Also arrays to keep the :ref:`right-hand-side of Runge-Kutta iterations <result_runge_kutta>`:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: Runge-Kutta source terms are allocated

are allocated.

************
init_or_load
************

==========
Definition
==========

.. code-block:: c

   static int init_or_load(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== ===================
Name     intent description
======== ====== ===================
param    in     general parameters
parallel in     MPI parameters
fluid    out    values are assigned
======== ====== ===================

===========
Description
===========

Velocity and pressure fields are initialised.

When we want to start the simulation from the beginning (i.e., :c-lang:`param->load_flow_field` is :c-lang:`false`), initial conditions are assigned here:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: ux is initialised

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: uy is initialised

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: p is initialised

Otherwise (i.e., :c-lang:`param->load_flow_field` is :c-lang:`true`), values are loaded from a restart file:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: ux is loaded

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: uy is loaded

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: p is loaded

where flow fields are loaded from *npy* files (see :ref:`src/fileio.c <fileio>` for details).

Note that flow fields excluding halo cells are set here, and these edge values are set subsequently:

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: update boundary and halo values of ux

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: update boundary and halo values of uy

.. myliteralinclude:: /../../src/fluid/init.c
   :language: c
   :tag: update boundary and halo values of p


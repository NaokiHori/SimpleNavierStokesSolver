
.. _temperature_init:

##############################################################################################################
`temperature/init.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/temperature/init.c>`_
##############################################################################################################

Initialise a structure :c-lang:`temperature_t *temperature` and its members.

****************
temperature_init
****************

==========
Definition
==========

.. code-block:: c

   int temperature_init(
       const param_t *param,
       const parallel_t *parallel,
       temperature_t *temperature
   );

=========== ====== =========================
Name        intent description
=========== ====== =========================
param       in     general parameters
parallel    in     MPI parameters
temperature out    allocated and initialised
=========== ====== =========================

===========
Description
===========

A :c-lang:`temperature` structure and its members are allocated:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: allocate structure and its members

and values are initialised when the simulation is started from the beginning, or values are loaded from a directory (:c-lang:`char param->dirname_restart`, see :ref:`param <param>`) to restart the run:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: initialise or load temperature

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
       temperature_t **temperature
   );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
temperature out    allocated
=========== ====== ==================

===========
Description
===========

A pointer to a :c-lang:`temperature` structure is allocated:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: structure is allocated

as well as temperature and buoyancy force fields:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: temperature and buoyancy force fields are allocated

Also arrays to keep the :ref:`right-hand-side of Runge-Kutta iterations <result_runge_kutta>`:

.. myliteralinclude:: /../../src/temperature/init.c
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
       temperature_t *temperature
   );

=========== ====== ===================
Name        intent description
=========== ====== ===================
param       in     general parameters
parallel    in     MPI parameters
temperature out    values are assigned
=========== ====== ===================

===========
Description
===========

Velocity and pressure fields are initialised.

When we want to start the simulation from the beginning (i.e., :c-lang:`param->load_flow_field` is :c-lang:`false`), initial conditions are assigned here:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: temp is initialised

Otherwise (i.e., :c-lang:`param->load_flow_field` is :c-lang:`true`), values are loaded from a restart file:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: temp is loaded

where the temperature field is loaded from a *npy* file (see :ref:`src/fileio.c <fileio>` for details).

Note that flow fields excluding halo cells and walls are set here, and these edge values are set subsequently:

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: update boundary and halo values of temp


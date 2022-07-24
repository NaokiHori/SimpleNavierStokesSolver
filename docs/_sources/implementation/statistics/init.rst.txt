
.. _statistics_init:

############################################################################################################
`statistics/init.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/statistics/init.c>`_
############################################################################################################

Initialise a structure :c-lang:`statistics_t *statistics` and its members.

***************
statistics_init
***************

==========
Definition
==========

.. code-block:: c

   int statistics_init(
       const param_t *param,
       const parallel_t *parallel,
       statistics_t *statistics
   );

========== ====== =========================
Name       intent description
========== ====== =========================
param      in     general parameters
parallel   in     MPI parameters
statistics out    allocated and initialised
========== ====== =========================

===========
Description
===========

A :c-lang:`statistics` structure and its members are allocated:

.. myliteralinclude:: /../../src/statistics/init.c
   :language: c
   :tag: allocate structure and its members

and values are initialised:

.. myliteralinclude:: /../../src/statistics/init.c
   :language: c
   :tag: initialise values

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
       statistics_t **statistics
   );

========== ====== ==================
Name       intent description
========== ====== ==================
param      in     general parameters
parallel   in     MPI parameters
statistics out    allocated
========== ====== ==================

===========
Description
===========

A pointer to a :c-lang:`statistics` structure is allocated:

.. myliteralinclude:: /../../src/statistics/init.c
   :language: c
   :tag: structure is allocated

as well as its members to store statistical values:

.. myliteralinclude:: /../../src/statistics/init.c
   :language: c
   :tag: arrays are allocated

****
init
****

==========
Definition
==========

.. code-block:: c

   static int init(
       const param_t *param,
       const parallel_t *parallel,
       statistics_t *statistics
   );

========== ====== ===================
Name       intent description
========== ====== ===================
param      in     general parameters
parallel   in     MPI parameters
statistics out    values are assigned
========== ====== ===================

===========
Description
===========

:c-lang:`0` are assigned to the members:

.. myliteralinclude:: /../../src/statistics/init.c
   :language: c
   :tag: assign 0

This is not necessary since :c-lang:`ALLOCATE` calls :c-lang:`calloc`, where :c-lang:`0x0000` is already assigned.
This function only exists to be consistent with other initialisers (e.g., :ref:`src/fluid/init.c <fluid_init>`).


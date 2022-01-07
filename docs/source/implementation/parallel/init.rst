
.. _parallel_init:

########################################################################################################
`parallel/init.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/parallel/init.c>`_
########################################################################################################

Functions to initialise the structure :c-lang:`parallel`.

*************
parallel_init
*************

==========
Definition
==========

.. code-block:: c

   int parallel_init(
       parallel_t **parallel
   );

======== ====== =========================
Name     intent description
======== ====== =========================
parallel out    allocated and initialised
======== ====== =========================

===========
Description
===========

A :c-lang:`parallel` structure is allocated:

.. myliteralinclude:: /../../src/parallel/init.c
   :language: c
   :tag: allocated

and values are assigned to the members:

.. myliteralinclude:: /../../src/parallel/init.c
   :language: c
   :tag: initialised

****
init
****

==========
Definition
==========

.. code-block:: c

   static int init(
       parallel_t *parallel
   );

======== ====== ===========
Name     intent description
======== ====== ===========
parallel out    initialised
======== ====== ===========

===========
Description
===========

First the number of process is checked and assigned to :c-lang:`mpisize`:

.. myliteralinclude:: /../../src/parallel/init.c
   :language: c
   :tag: get number of process

Also the process ID of itself is checked and assigned to :c-lang:`mpirank`:

.. myliteralinclude:: /../../src/parallel/init.c
   :language: c
   :tag: get my process id

Next, the neighbouring process IDs are assigned; the lower and upper process IDs are :c-lang:`mpirank-1` and :c-lang:`mpirank+1`, respectively.

.. myliteralinclude:: /../../src/parallel/init.c
   :language: c
   :tag: assign neighbour rank

The schematic below shows an example when :c-lang:`mpisize = 3`:

.. image:: image/init.pdf
   :width: 400

Note that the values should be modified for the bottom and top processes, as can be seen in the sketch.

Finally, random seed is set for reproducibility here.
By default, random numbers are only used to perturb the initial temperature field (in :ref:`src/temperature/init.c <temperature_init>`):

.. myliteralinclude:: /../../src/temperature/init.c
   :language: c
   :tag: temp is initialised

If we used the same seed for all processes, same perturbation is imposed and an artificial flow field can be generated; this is the reason why :c-lang:`mpirank` is used as the seed to create different perturbation in each domain.



.. _save:

######################################################################################
`save.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/save.c>`_
######################################################################################

``save.c`` contains functions to save whole flow fields which will be used to restart the run or for post-processings.

****
save
****

==========
Definition
==========

.. code-block:: c

  int save(
      param_t *param,
      const parallel_t *parallel,
      const fluid_t *fluid,
      const temperature_t *temperature
  );

=========== ====== ===================
Name        intent description
=========== ====== ===================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in     temperature field
=========== ====== ===================

===========
Description
===========

This function aims to dump variables which are essential to restart the run in the future.
In particular, :math:`x` and :math:`y` velocities, pressure :math:`p`, and temperature :math:`T` (if coupled) are saved to a directory as well as parameters.

Since the storage size is limited, it is impractical to save the flow fields for each time step.
This project does it in each :math:`\Delta t_{save}` time unit, which is contained by a variable :c-lang:`param->save.rate`.
Also the next timing to save the flow field is contained by :c-lang:`param->save.next`.

First of all, a directory is created, in which the data will be stored:

.. myliteralinclude:: /../../src/save.c
   :language: c
   :tag: create directory from main process

Note that this procedure should be called only by the main process to avoid conflict.

After the directory is created (or it already exists), the parameters such as domain size and physical parameters which are crucial for post-processings are saved first:

.. myliteralinclude:: /../../src/save.c
   :language: c
   :tag: save parameters

Again, this procedure should be called only by the main process to avoid conflict.

The flow fields are saved, which is a collective process which should be done by all processes:

.. myliteralinclude:: /../../src/save.c
   :language: c
   :tag: save flow fields


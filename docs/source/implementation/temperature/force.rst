
.. _temperature_force:

################################################################################################################
`temperature/force.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/temperature/force.c>`_
################################################################################################################

Compute thermal-driven buoyancy force acting on the :math:`x` momentum equation.

*************************
temperature_compute_force
*************************

==========
Definition
==========

.. code-block:: c

   int temperature_compute_force(
       const param_t *param,
       const parallel_t *parallel,
       temperature_t *temperature
   );

=========== ====== ======================================
Name        intent description
=========== ====== ======================================
param       in     general parameters
parallel    in     MPI parameters
temperature in/out temperature (in), buoyancy force (out)
=========== ====== ======================================

===========
Description
===========

As being discussed in :ref:`the governing equations <governing_equations>`, the buoyancy force under Boussinesq approximation leads :math:`T`.
Since :math:`T` is defined at cell centers, we need to interpolate them to the :math:`x` cell faces (where :math:`\ux` is located), where arithmetic average should be used.

.. note::

   One might be tempted to use values which are linearly interpolated or weighted by cell volume, which breaks the energy balance.
   See :ref:`the spatial discretisation <spatial_discretisation>` for details, in particular :ref:`Nusselt number relations <nusselt_number_relations>`.

The implementation can be found here

.. myliteralinclude:: /../../src/temperature/force.c
   :language: c
   :tag: buoyancy force acting only to wall-normal (x) direction

.. image:: image/force.pdf
   :width: 800


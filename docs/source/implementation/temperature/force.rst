
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

The buoyancy force in non-dimensional form under Boussinesq approximation :math:`f_x^b` can be written as :math:`f_x^b = T`, which is implemented as:

.. myliteralinclude:: /../../src/temperature/force.c
   :language: c
   :tag: buoyancy force acting only to wall-normal (x) direction

Note that the temperature is interpolated to the :math:`x` velocity positions:

.. image:: image/force1.pdf
   :width: 800

.. note::

   Here the temperatures are merely averaged to the in-between velocity location.
   One might be tempted to use values which are linearly interpolated or weighted by cell volume, **which breaks the energy balance**.
   See :ref:`the spatial discretisation <spatial_discretisation>` for details, in particular :ref:`Nusselt number relations <nusselt_number_relations>`.


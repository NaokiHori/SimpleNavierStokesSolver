
.. _param_estimate_cost:

####################################################################################################################
`param/estimate_cost.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/param/estimate_cost.c>`_
####################################################################################################################

Estimate computational costs (in wall time) for all explicit and implicit combinations of the diffusive treatments.

*******************
param_estimate_cost
*******************

==========
Definition
==========

.. code-block:: c

   int param_estimate_cost(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== ============================================================
Name     intent description
======== ====== ============================================================
param    in/out general parameters (in), estimated computational costs (out)
parallel in     MPI parameters
======== ====== ============================================================

===========
Description
===========

Sometimes implicit treatments of the diffusive terms are favorable to reduce the computational cost (by increasing the time step size :math:`\Delta t`).
This, however, imposes additional complexities and computational cost (communications among all MPI processes: the most expensive procedure in this project), which are usually non-trivial
In particular, communications among all processors (the most expensive process in this process) are essential, which can totally remove the time step advantage.
In order to determine whether the implicit treatments are advantageous, this function integrates the governing equations for a short time and quantifies the additional computational cost.


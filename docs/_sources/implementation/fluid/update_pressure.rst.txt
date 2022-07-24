
.. _fluid_update_pressure:

########################################################################################################################
`fluid/update_pressure.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/update_pressure.c>`_
########################################################################################################################

Update pressure :math:`p` using a scalar potential :math:`\psi`.

The methodology is discussed :ref:`here <smac_method>`.

*********************
fluid_update_pressure
*********************

==========
Definition
==========

.. code-block:: c

   int fluid_update_pressure(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== ========================================
Name     intent description
======== ====== ========================================
param    in     general parameters
parallel in     MPI parameters
fluid    in/out scalar potential (in), pressure (in/out)
======== ====== ========================================

===========
Description
===========

This function updates pressure field (from :math:`p^k` to :math:`p^{k+1}`) following a procedure of the :ref:`SMAC method <smac_method>`.

The pressure correction :math:`\psi`, which is obtained by :ref:`solving a Poisson equation <fluid_compute_potential>`, is added to the pressure:

.. math::
   p^{k+1} = p^k + \psi,

which is implemented as

.. myliteralinclude:: /../../src/fluid/update_pressure.c
   :language: c
   :tag: add correction

As discussed in :ref:`the temporal discretisation <smac_method>`, when the diffusive terms are treated implicitly, additional term should be taken into account, which is

.. math::
   \begin{aligned}
      & - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2 \psi}{\delta x^2}, \\
      & - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2 \psi}{\delta y^2}, \\
   \end{aligned}

for the implicit treatment in :math:`x` and :math:`y` directions, respectively.
Since Laplacian of :math:`\psi` at a cell center :math:`\left( i, j \right)` is discretised as

.. math::
  \frac{\delta^2 \psi}{\delta x_j \delta x_j}
  = \frac{\left. \frac{\delta \psi}{\delta x} \right|_{i+\frac{1}{2},j}-\left. \frac{\delta \psi}{\delta x} \right|_{i+\frac{1}{2},j}}{\Delta x_i}
  + \frac{\left. \frac{\delta \psi}{\delta y} \right|_{i,j+\frac{1}{2}}-\left. \frac{\delta \psi}{\delta y} \right|_{i,j+\frac{1}{2}}}{\Delta y},

.. image:: image/update_pressure1.pdf
   :width: 800

we have the following implementations:

.. myliteralinclude:: /../../src/fluid/update_pressure.c
   :language: c
   :tag: correction for implicit treatment in x

which is needed for the implicit treatments in :math:`x` direction, and

.. myliteralinclude:: /../../src/fluid/update_pressure.c
   :language: c
   :tag: correction for implicit treatment in y

which is for the implicit treatments in :math:`y` direction.

Finally the boundary values of the new pressure field are updated:

.. myliteralinclude:: /../../src/fluid/update_pressure.c
   :language: c
   :tag: boundary and halo values are updated


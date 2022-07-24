
.. _fluid_correct_velocity:

##########################################################################################################################
`fluid/correct_velocity.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/correct_velocity.c>`_
##########################################################################################################################

Correct non-solenoidal velocity :math:`u_i^*` to solenoidal (and new-step) one :math:`u_i^{n+1}` following :math:`\frac{u_i^{n+1} - u_i^*}{\gamma \Delta t} = -\frac{\delta \psi}{\delta x_i}`.

The methodology is discussed :ref:`here <smac_method>`.

**********************
fluid_correct_velocity
**********************

==========
Definition
==========

.. code-block:: c

   int fluid_correct_velocity(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== =====================================
Name     intent description
======== ====== =====================================
param    in     general parameters
parallel in     MPI parameters
fluid    in/out scalar potential (in), velocity (out)
======== ====== =====================================

===========
Description
===========

The tentative velocity field :math:`u_i^*` does not satisfy the (discrete) divergence-free condition, i.e.,

.. math::
   \frac{\delta u_x^*}{\delta x} + \frac{\delta u_y^*}{\delta y}
   = \frac{\left. u_x^* \right|_{i+\frac{1}{2},j} - \left. u_x^* \right|_{i-\frac{1}{2},j}}{\Delta x_i}
   + \frac{\left. u_y^* \right|_{i,j+\frac{1}{2}} - \left. u_y^* \right|_{i,j-\frac{1}{2}}}{\Delta y  }
   \ne 0,

which is modified by using the scalar potential :math:`\psi` :ref:`obtained by solving a Poisson equation <fluid_compute_potential>`.

In :math:`x` direction, we compute

.. math::
   \left. u_x^{n+1} \right|_{i+\frac{1}{2},j} = \left. u_x^* \right|_{i+\frac{1}{2},j} - \gamma \Delta t \frac{\left. \psi \right|_{i+1,j} - \left. \psi \right|_{i,j}}{\Delta x_{i+\frac{1}{2}}},

which is implemented as

.. myliteralinclude:: /../../src/fluid/correct_velocity.c
   :language: c
   :tag: correct ux

Also see the schematic below:

.. image:: image/correct_velocity1.pdf
   :width: 800

Note that :c-lang:`ux` at :c-lang:`i=1` and :c-lang:`i=itot+1` are not updated:

.. myliteralinclude:: /../../src/fluid/correct_velocity.c
   :language: c
   :tag: ux is computed from i=2 to itot

since the boundary values are fixed (impermeable).

In :math:`y` direction, we compute

.. math::
   \left. u_y^{n+1} \right|_{i,j+\frac{1}{2}} = \left. u_y^* \right|_{i,j+\frac{1}{2}} - \gamma \Delta t \frac{\left. \psi \right|_{i,j+1} - \left. \psi \right|_{i,j}}{\Delta y},

which is implemented as

.. myliteralinclude:: /../../src/fluid/correct_velocity.c
   :language: c
   :tag: correct uy

Also see the schematic below:

.. image:: image/correct_velocity2.pdf
   :width: 800

At last, the boundary and halo cells are updated as:

.. myliteralinclude:: /../../src/fluid/correct_velocity.c
   :language: c
   :tag: update boundary and halo values of ux

.. myliteralinclude:: /../../src/fluid/correct_velocity.c
   :language: c
   :tag: update boundary and halo values of uy

See :ref:`fluid/boudary_conditions.c <fluid_boundary_conditions>`.


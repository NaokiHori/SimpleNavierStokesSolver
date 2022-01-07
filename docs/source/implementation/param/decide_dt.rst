
.. include:: /references.txt

.. _param_decide_dt:

############################################################################################################
`param/decide_dt.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/param/decide_dt.c>`_
############################################################################################################

Decide time step size **dt** to be used to integrate the governing equations, as well as explicit/implicit treatments of the diffusive terms.

***************
param_decide_dt
***************

==========
Definition
==========

.. code-block:: c

   int param_decide_dt(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== ==============================================================
Name     intent description
======== ====== ==============================================================
param    in/out general parameters (in), time step size & implicit flags (out)
parallel in     MPI parameters
fluid    in     velocity
======== ====== ==============================================================

===========
Description
===========

Two restrictions for the time step size should be considered in this project.
One comes from the advective terms in the governing equations, where the information should not travel longer distance than the local grid size.
This constraint can be written as

.. math::
   \Delta t_{adv} < \min \left[ \min \left( \Delta x / u_x \right), \min \left( \Delta y / u_y \right) \right],

which should always be satisfied in this project:

.. myliteralinclude:: /../../src/param/decide_dt.c
   :language: c
   :tag: advective constraint, which will be used as dt

The other restriction is imposed by the diffusive terms.
Although the same story holds (information should travel shorter than the grid size), the diffusive time and length scales have the relation: :math:`\Delta t \sim \Delta x^2`, i.e., :math:`\Delta t` shrinks with a speed which is proportional to :math:`\Delta x^2`, which can be much severer (:math:`\Delta t_{dif} \ll \Delta t_{adv}`) and results in an extensive slow down.
In particular, this restriction can be written as

.. math::
   \begin{aligned}
      & \Delta t_{dif,x} < \frac{Re \left[ \min \left( \Delta x \right) \right]^2}{4}, \\
      & \Delta t_{dif,y} < \frac{Re \left( \Delta y \right)^2}{4},
   \end{aligned}

in each direction:

.. myliteralinclude:: /../../src/param/decide_dt.c
   :language: c
   :tag: diffusive constraints in each direction

Note that appropriate numbers (smaller than 1)

.. myliteralinclude:: /../../src/param/decide_dt.c
   :language: c
   :tag: safety factors for two constraints

are multiplied to these two :math:`\Delta t` values for safety.

Although the diffusive restrictions can be eliminated by treating them implicitly (see :ref:`temporal discretisation <temporal_discretisation>`), additional and non-trivial costs should be paid, which are :ref:`estimated a priori <param_estimate_cost>`.
Based on this information, an optimal combination in each direction is chosen:

.. myliteralinclude:: /../../src/param/decide_dt.c
   :language: c
   :tag: find optimal diffusive treatment

where a variable :c-lang:`param->expimp_wtimes` contains the costs of all possible diffusive treatments computed in :ref:`src/param/estimate_cost.c <param_estimate_cost>`.

This function is completed by assigning the decided time step size (advective restriction since diffusive ones are eliminated) to :c-lang:`param->dt`:

.. myliteralinclude:: /../../src/param/decide_dt.c
   :language: c
   :tag: time step size is assigned

.. note::

   Although implicit treatments can indeed eliminate the stability restriction, monotonicity (e.g., temperature is bounded between 0 and 1) is **not** guaranteed.
   Unfortunately, in order to keep the monotonicity, :math:`\Delta t \propto \Delta x^2` should be again satisfied with the Crank-Nicolson scheme (see e.g. |HORVATH2000|).
   Although this restriction disappears by adopting the Euler backward scheme (at the expense of the temporal accuracy), this fact is neglected in this project for now.


######
fluid/
######

Directory ``src/fluid`` contains source files which mainly handle the integration of the :ref:`governing equations <governing_equations>` by means of the :ref:`Simplified Marker And Cell (SMAC) method <smac_method>`.

.. toctree::
   :maxdepth: 1

   boundary_conditions
   compute_potential
   correct_velocity
   finalise
   init
   update_pressure
   update_velocity

*******
fluid_t
*******

A structure :c-lang:`fluid_t` is defined in `include/fluid.h <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/include/fluid.h>`_, which contains all two-dimensional arrays which are necessary to describe and integrate the flow field:

.. myliteralinclude:: /../../include/fluid.h
   :language: c
   :tag: definition of a structure fluid_t_

The meanings of each member are as follows:

1. :c-lang:`ux`

   Fluid velocity in :math:`x` direction (:math:`\ux`)

2. :c-lang:`uy`

   Fluid velocity in :math:`y` direction (:math:`\uy`)

3. :c-lang:`p`

   Reduced pressure (:math:`p`)

4. :c-lang:`psi`

   Scalar potential which projects non-solenoidal velocity field to a solenoidal one (:math:`\psi`)

5. :c-lang:`srcu[xy][abg]`

   Terms in the right-hand-side of momentum equations (source terms) in each direction (:math:`x` and :math:`y`)
   Suffices :c-lang:`a`, :c-lang:`b`, and :c-lang:`g` are used to distinguish each term and imply :math:`\alpha`, :math:`\beta`, and :math:`\gamma`, respectively.

Also see :ref:`this page <numerics>` for details, in particular how these terms are used in the code.


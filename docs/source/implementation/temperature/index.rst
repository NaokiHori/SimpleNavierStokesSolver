############
temperature/
############

Directory ``src/temperature`` contains source files which mainly handle the integration of the temperature field and the computation of the buoyancy force on the momentum equation.

.. toctree::
   :maxdepth: 1

   boundary_conditions
   finalise
   force
   init
   update

*************
temperature_t
*************

A structure :c-lang:`temperature_t` is defined in `include/temperature.h <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/include/temperature.h>`_, which contains parameters which are relevant to the scalar field :math:`T`:

.. myliteralinclude:: /../../include/temperature.h
   :language: c
   :tag: definition of a structure temperature_t_

The meanings of each member are as follows:

1. :c-lang:`temp`

   Temperature

2. :c-lang:`tempforcex`

   Buoyancy force in :math:`x` direction

3. :c-lang:`srctemp[abg]`

   Terms in the right-hand-side of the scalar equation (source terms)
   Suffices :c-lang:`a`, :c-lang:`b`:c-lang:`g` are used to distinguish each term and imply :math:`\alpha`, :math:`\beta`, and :math:`\gamma`, respectively.

Also see :ref:`here <temperature_integration>` for details, in particular how these terms are used in the code.


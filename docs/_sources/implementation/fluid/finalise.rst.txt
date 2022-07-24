
.. _fluid_finalise:

##########################################################################################################
`fluid/finalise.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/finalise.c>`_
##########################################################################################################

Deallocate memory of the structure :c-lang:`fluid`.

**************
fluid_finalise
**************

==========
Definition
==========

.. code-block:: c

   int fluid_finalise(
       fluid_t *fluid
   );

===== ====== ===========
Name  intent description
===== ====== ===========
fluid out    deallocated
===== ====== ===========

===========
Description
===========

All memories which are kept in the structure :c-lang:`fluid` during the whole run are freed.
The memory of the structure :c-lang:`fluid` itself is also freed here.



.. _param_finalise:

##########################################################################################################
`param/finalise.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/param/finalise.c>`_
##########################################################################################################

Deallocate memory of the structure :c-lang:`param`.

**************
param_finalise
**************

==========
Definition
==========

.. code-block:: c

   int param_finalise(
       param_t *param
   );

===== ====== ===========
Name  intent description
===== ====== ===========
param out    deallocated
===== ====== ===========

===========
Description
===========

All memories which are kept in the structure :c-lang:`param` during the whole run (coordinates) are freed.
The memory of the structure :c-lang:`param` itself is also freed here.


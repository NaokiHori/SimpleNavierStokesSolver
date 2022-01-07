
.. _temperature_finalise:

######################################################################################################################
`temperature/finalise.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/temperature/finalise.c>`_
######################################################################################################################

Deallocate memory of the structure :c-lang:`temperature`.

********************
temperature_finalise
********************

==========
Definition
==========

.. code-block:: c

   int temperature_finalise(
       temperature_t *temperature
   );

=========== ====== ===========
Name        intent description
=========== ====== ===========
temperature out    deallocated
=========== ====== ===========

===========
Description
===========

All memories which are kept in the structure :c-lang:`temperature` during the whole run are freed.
The memory of the structure :c-lang:`temperature` itself is also freed here.


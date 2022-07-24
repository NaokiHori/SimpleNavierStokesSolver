
.. _statistics_finalise:

####################################################################################################################
`statistics/finalise.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/statistics/finalise.c>`_
####################################################################################################################

Deallocate memory of the structure :c-lang:`statistics`.

*******************
statistics_finalise
*******************

==========
Definition
==========

.. code-block:: c

   int statistics_finalise(
       statistics_t *statistics
   );

========== ====== ===========
Name       intent description
========== ====== ===========
statistics out    deallocated
========== ====== ===========

===========
Description
===========

All memories which are kept in the structure :c-lang:`statistics` during the whole run are freed.
The memory of the structure :c-lang:`statistics` itself is also freed here.


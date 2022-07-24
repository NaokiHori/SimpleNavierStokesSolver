
.. _statistics_output:

################################################################################################################
`statistics/output.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/statistics/output.c>`_
################################################################################################################

Output members of a structure :c-lang:`statistics_t *statistics`, which contain collected statistics.

*****************
statistics_output
*****************

==========
Definition
==========

.. code-block:: c

   int statistics_collect(
       const param_t *param,
       const parallel_t *parallel,
       const statistics_t *statistics
   );

=========== ====== ====================
Name        intent description
=========== ====== ====================
param       in     general parameters
parallel    in     MPI parameters
statistics  out    collected statistics
=========== ====== ====================

===========
Description
===========

This function outputs the collected statistics.

.. seealso::

   See :ref:`src/save.c <save>` for the details since it does almost exactly the same thing.


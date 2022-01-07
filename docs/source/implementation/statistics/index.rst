
.. _statistics:

###########
statistics/
###########

Directory ``src/statistics`` contains source files which are used to collect temporally-averaged statistics and to output them.

.. toctree::
   :maxdepth: 1

   collect
   finalise
   init
   output

************
statistics_t
************

A structure :c-lang:`statistics_t` is defined in `include/statistics.h <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/include/statistics.h>`_, which contains data structures which are used to accumulate temporally-averaged quantities:

.. myliteralinclude:: /../../include/statistics.h
   :language: c
   :tag: definition of a structure statistics_t_

The meanings of each member are as follows:

1. :c-lang:`num`

   Number of statistics which have been collected

2. :c-lang:`ux1` and :c-lang:`ux2`

   Averaged :math:`x` velocity field and its squared quantity

3. :c-lang:`uy1` and :c-lang:`uy2`

   Averaged :math:`y` velocity field and its squared quantity

4. :c-lang:`temp1` and :c-lang:`temp2`

   Averaged temperature field and its squared quantity

See :ref:`src/statistics/collect.c <statistics_collect>` for details.

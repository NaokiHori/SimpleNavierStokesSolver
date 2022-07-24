
.. _statistics_collect:

##################################################################################################################
`statistics/collect.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/statistics/collect.c>`_
##################################################################################################################

Sum up field values to the members of :c-lang:`statistics_t *statistics` to collect temporally-averaged statistics.

******************
statistics_collect
******************

==========
Definition
==========

.. code-block:: c

   int statistics_collect(
       const param_t *param,
       const parallel_t *parallel,
       const fluid_t *fluid,
       const temperature_t *temperature,
       statistics_t *statistics
   );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in     temperature
statistics  out    values are summed
=========== ====== ==================

===========
Description
===========

:math:`\ave{q}{t}`, which is a temporally-averaged value of :math:`q`, is approximated as:

.. math::
   \ave{q}{t}
   = \frac{\int_{t} q dt}{\int_{t} dt}
   \approx \frac{\sum_{n=0}^{t_N-1} q_n}{N},

i.e., :math:`q` at different time (:math:`n` denotes *equidistant* simulation time step) should be summed up.

By default, these procedures are considered for :c-lang:`fluid->ux`, :c-lang:`fluid->uy`, and :c-lang:`temperature->temp`:

.. myliteralinclude:: /../../src/statistics/collect.c
   :language: c
   :tag: collect temporally-averaged quantities

See below for the detailed explanations of these functions.

Finally the number of samples :c-lang:`statistics->num` (which corresponds to the number of samples :math:`N`) is incremented:

.. myliteralinclude:: /../../src/statistics/collect.c
   :language: c
   :tag: number of samples is incremented

***************
collect_mean_ux
***************

==========
Definition
==========

.. code-block:: c

   static int collect_mean_ux(
       const param_t *param,
       const parallel_t *parallel,
       const fluid_t *fluid,
       statistics_t *statistics
   );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     :math:`x` velocity :math:`\ux`
statistics  out    :math:`\vat{\ave{\ux}{t}}{i, j}` and :math:`\vat{\ave{\ux^2}{t}}{i, j}`
=========== ====== ==================

===========
Description
===========

:math:`x` velocity and its squared quantity are summed up to :c-lang:`statistics->ux1` and :c-lang:`statistics->ux2` respectively:

.. myliteralinclude:: /../../src/statistics/collect.c
   :language: c
   :tag: ux and its square are added

***************
collect_mean_uy
***************

==========
Definition
==========

.. code-block:: c

   static int collect_mean_uy(
       const param_t *param,
       const parallel_t *parallel,
       const fluid_t *fluid,
       statistics_t *statistics
   );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     :math:`y` velocity :math:`\uy`
statistics  out    :math:`\vat{\ave{\uy}{t}}{i, j}` and :math:`\vat{\ave{\uy^2}{t}}{i, j}`
=========== ====== ==================

===========
Description
===========

:math:`y` velocity and its squared quantity are summed up to :c-lang:`statistics->uy1` and :c-lang:`statistics->uy2` respectively:

.. myliteralinclude:: /../../src/statistics/collect.c
   :language: c
   :tag: uy and its square are added

*****************
collect_mean_temp
*****************

==========
Definition
==========

.. code-block:: c

   static int collect_mean_temp(
       const param_t *param,
       const parallel_t *parallel,
       const temperature_t *temperature,
       statistics_t *statistics
   );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
temperature in     temperature :math:`T`
statistics  out    :math:`\vat{\ave{T}{t}}{i, j}` and :math:`\vat{\ave{T^2}{t}}{i, j}`
=========== ====== ==================

===========
Description
===========

Temperature and its squared quantity are summed up to :c-lang:`statistics->temp1` and :c-lang:`statistics->temp2` respectively:

.. myliteralinclude:: /../../src/statistics/collect.c
   :language: c
   :tag: temp and its square are added


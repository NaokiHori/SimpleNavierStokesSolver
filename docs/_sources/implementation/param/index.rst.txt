
.. _param:

######
param/
######

Directory ``src/param`` contains source files which treat general parameters widely used.

.. toctree::
   :maxdepth: 1

   decide_dt
   estimate_cost
   finalise
   init

*******
param_t
*******

A structure :c-lang:`param_t` is defined in `include/param.h <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/include/param.h>`_, which contains general parameters which are referred to by other functions:

.. myliteralinclude:: /../../include/param.h
   :language: c
   :tag: definition of a structure param_t_

The meanings of each member are as follows:

#. Initialisation: :c-lang:`load_flow_field`

   Whether flow fields (velocity, temperature, etc.) are loaded (:c-lang:`true`) or not (:c-lang:`false`).
   If not, they are initialised; otherwise loaded from a specified directory :c-lang:`param->dirname_restart`.

#. Temperature coupling

   * :c-lang:`with_temperature`

      Whether the temperature field is solved (:c-lang:`true`) or not (:c-lang:`false`) as well as the flow fields (velocity and pressure).

   * :c-lang:`with_thermal_forcing`

      Whether the buoyancy force is added (:c-lang:`true`) or not (:c-lang:`false`) to the momentum balance in :math:`x` direction (see :ref:`the governing equations <governing_equations>`).
      If not, the temperature is a passive scalar merely transported (advected and diffused) by the fluid motion.

#. Domain size and coordinates

   * :c-lang:`itot` and :c-lang:`jtot`

      Numbers of cell centers (where pressure and temperature are defined) in :math:`x` and :math:`y` directions, respectively.

   * :c-lang:`lx` and :c-lang:`ly`

      Physical domain sizes (lengths) in :math:`x` and :math:`y` directions, respectively.
      :c-lang:`lx` is fixed to 1 since the governing equations assume :math:`l_x \equiv 1` when being normalised (see :ref:`the governing equations <governing_equations>`).

   * :c-lang:`stretch`

      The amount of distortion of the grid in :math:`x` direction.
      Roughly, the smaller (minimum is 0) this number is, the more stretched the grid is and more points exist in the vicinity of the walls.
      See :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`.

   * :c-lang:`xf` and :c-lang:`xc`

      Coordinates in :math:`x` direction.
      :c-lang:`xf` and :c-lang:`xc` are used to define cell-face and cell-center locations, respectively.
      See :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`.

   * :c-lang:`dxf` and :c-lang:`dxc`

      Distance between neighbouring :c-lang:`param->xf` and :c-lang:`param->xc`, respectively.
      See :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`.

   * :c-lang:`dy`

      Grid size in :math:`y` direction.
      Since only uniform grid arrangements are allowed for now, a scalar value is sufficient.
      :c-lang:`yf` and :c-lang:`yc` are, however, defined since they are useful for post-processings.

#. Non-dimensional parameters

   * :c-lang:`Ra`

      Rayleigh number (see :ref:`the governing equations <governing_equations>`)

   * :c-lang:`Pr`

      Prandtl number (see :ref:`the governing equations <governing_equations>`)

#. Parameters relevant to temporal integration

   * :c-lang:`rkcoefs`

      Coefficients of Runge-Kutta scheme :math:`\alpha,\beta,\gamma` (see :ref:`Temporal discretisation <temporal_discretisation>`)

   * :c-lang:`time`

      Simulation time (not wall time)

   * :c-lang:`dt`

      Time step size

   * :c-lang:`step`

      Number of steps (how many iterations have been done up to now)

   * :c-lang:`implicitx`, :c-lang:`implicity`

      Whether the diffusive terms in each direction are treated implicitly (:c-lang:`1`) or not (:c-lang:`0`).
      See :ref:`the temporal discretisation <temporal_discretisation>` and :ref:`src/param/decide_dt.c <param_decide_dt>`.

   * :c-lang:`expimp_wtimes`

      Variable to store wall times which are needed to complete the whole procedures with explicit or implicit treatments of the diffusive terms.
      See :ref:`src/param/estimate_cost.c <param_estimate_cost>`.

#. Schedulers

   * :c-lang:`timemax`

      Maximum simulation time (in simulation time units).
      Simulation is terminated if :c-lang:`param->time` exceeds this parameter (see :ref:`src/main.c <main>`).

   * :c-lang:`wtimemax`

      Maximum simulation time (in wall time).
      Simulation is terminated if :c-lang:`param->wtime` exceeds this parameter (see :ref:`src/main.c <main>`).

   * :c-lang:`log`, :c-lang:`save`, :c-lang:`stat`

      Decide timings of logging, saving flow fields, and collecting statistics, respectively.
      Each member has three values:

      #. :c-lang:`rate`

         This process is repeated in each :c-lang:`rate` time units.
         This is needed since (generally) we do not want to dump flow fields (MB or GB in sizes) every time step.

      #. :c-lang:`after`

         This process is only executed after :c-lang:`after` time units.
         This is needed since (generally) we are only interested in flow statistics after the flow reaches the statistically-steady state.

      #. :c-lang:`next`

         This process will be executed at :c-lang:`next`.
         This is used as a timer to trigger the next event.

Although default values are assigned, these parameters can be specified as environmental variables and one can easily override them (see ``exec.sh``).
When being given, the parameters are loaded by :c-lang:`load_config` in :ref:`src/param/init.c <param_init>`.



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

1. Initialisation: :c-lang:`load_flow_field`

   Whether flow fields (velocity, temperature, etc.) are loaded (:c-lang:`true`) or not (:c-lang:`false`).
   If not, they are initialised; otherwise loaded from a restart file :c-lang:`FNAME_RESTART` defined in `include/param.h <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/include/param.h>`_.

2. Temperature coupling

   * :c-lang:`with_temperature`

      Whether the thermal fields (temperature, buoyancy force) are solved (:c-lang:`true`) or not (:c-lang:`false`) with the flow fields.

   * :c-lang:`with_thermal_forcing`

      Whether the buoyancy force is added (:c-lang:`true`) or not (:c-lang:`false`) to the momentum balance in :math:`x` direction (see :ref:`the governing equations <governing_equations>`).
      If not, the temperature is a passive scalar merely transported by the fluid motion.

3. Schedulers

   * :c-lang:`timemax`

      Maximum simulation time (in simulation time units).
      The run will be terminated if it reaches this number (see :ref:`src/main.c <main>`).

   * :c-lang:`wtimemax`

      Maximum simulation time (in wall time).
      The run will be terminated if it reaches this number (see :ref:`src/main.c <main>`).

   * :c-lang:`logtr`

      Log files are dumped per this time units (see :ref:`src/main.c <main>`).

   * :c-lang:`dumptr`

      Flow fields are dumped per this time units (see :ref:`src/main.c <main>`).

   * :c-lang:`stattr`

      Statistics are collected per this time units (see :ref:`src/main.c <main>`).

   * :c-lang:`stattafter`

      Statistics are collected after this time units (see :ref:`src/main.c <main>`).

   * :c-lang:`savetr`

      Flow fields and collected statistics are saved per this time units (see :ref:`src/main.c <main>`).

4. Domain size and coordinates

   * :c-lang:`itot` and :c-lang:`jtot`

      Numbers of cell centers (where pressure is defined) in :math:`x` and :math:`y` directions, respectively.

   * :c-lang:`lx` and :c-lang:`ly`

      Domain sizes in :math:`x` and :math:`y` directions, respectively.

      .. note::

         It is recommended to use :c-lang:`lx = 1` since the governing equations assume :math:`l_x \equiv 1` when being normalised (see :ref:`the governing equations <governing_equations>`).

   * :c-lang:`stretch`

      The amount of distortion of the grid in :math:`x` direction, from :c-lang:`0` (extremely stretched) to :c-lang:`itot` (uniform) (see :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`)

   * :c-lang:`xc` and :c-lang:`xf`

      Coordinates in :math:`x` direction.
      :c-lang:`xc` and :c-lang:`xf` are used to define cell-center and cell-face locations, respectively. (see :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`)

   * :c-lang:`dxc` and :c-lang:`dxf`

      Distance between neighbouring :c-lang:`param->xc` and :c-lang:`param->xf`, respectively (see :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`)

   * :c-lang:`dy`

      Grid size in :math:`y` direction (only uniform grid size is allowed for now)

5. Non-dimensional parameters

   * :c-lang:`Ra`

      Rayleigh number (see :ref:`the governing equations <governing_equations>`)

   * :c-lang:`Pr`

      Prandtl number (see :ref:`the governing equations <governing_equations>`)

6. Parameters relevant to temporal integration

   * :c-lang:`rk[abg]`

      Coefficients of Runge-Kutta scheme :math:`\alpha,\beta,\gamma` (see :ref:`Temporal discretisation <temporal_discretisation>`)

   * :c-lang:`step`

      Simulation time step

   * :c-lang:`implicitx`, :c-lang:`implicity`

      Whether the diffusive terms in each direction are treated implicitly (:c-lang:`1`) or not (:c-lang:`0`) (see :ref:`the temporal discretisation <temporal_discretisation>` and :ref:`src/param/decide_dt.c <param_decide_dt>`)

   * :c-lang:`time`

      Simulation time (not wall time)

   * :c-lang:`dt`

      Time step size

   * :c-lang:`expimp_wtimes`

      Variable to store wall times which are needed to complete the whole procedures with explicit or implicit treatments of the diffusive terms.
      See :ref:`src/param/estimate_cost.c <param_estimate_cost>`.

These parameters can be specified in ``exec.sh`` and are loaded by :c-lang:`load_config` in :ref:`src/param/init.c <param_init>`


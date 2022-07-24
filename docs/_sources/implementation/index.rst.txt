
.. _implementation:

##############
Implementation
##############

Various parameters in ``param_t`` can be specified as environmental variables, whose example can be seen in ``exec.sh``:

.. literalinclude:: /../../exec.sh
   :language: sh

(Forward) declarations of structures (:c-lang:`param_t`, :c-lang:`parallel_t`, :c-lang:`fluid_t`, :c-lang:`temperature_t`, and :c-lang:`statistics_t`) and all functions are included in `include <https://github.com/NaokiHori/SimpleNavierStokesSolver/tree/master/include>`_ directory.

.. code-block:: text

  include
  ├── analyses.h
  ├── arrays
  │  ├── fluid.h
  │  ├── param.h
  │  ├── statistics.h
  │  └── temperature.h
  ├── common.h
  ├── fileio.h
  ├── fluid.h
  ├── linalg.h
  ├── logging.h
  ├── parallel.h
  ├── param.h
  ├── save.h
  ├── simple_npyio.h
  ├── statistics.h
  ├── structure.h
  └── temperature.h

All functions are implemented under `src <https://github.com/NaokiHori/SimpleNavierStokesSolver/tree/master/src>`_ directory.

.. code-block:: text

  src
  ├── analyses.c
  ├── common.c
  ├── fileio.c
  ├── fluid
  │  ├── boundary_conditions.c
  │  ├── compute_potential.c
  │  ├── correct_velocity.c
  │  ├── finalise.c
  │  ├── init.c
  │  ├── update_pressure.c
  │  └── update_velocity.c
  ├── linalg.c
  ├── logging.c
  ├── main.c
  ├── parallel
  │  ├── finalise.c
  │  ├── halo.c
  │  ├── init.c
  │  ├── others.c
  │  └── transpose.c
  ├── param
  │  ├── decide_dt.c
  │  ├── estimate_cost.c
  │  ├── finalise.c
  │  └── init.c
  ├── save.c
  ├── simple_npyio.c
  ├── statistics
  │  ├── collect.c
  │  ├── finalise.c
  │  ├── init.c
  │  └── output.c
  └── temperature
     ├── boundary_conditions.c
     ├── finalise.c
     ├── force.c
     ├── init.c
     └── update.c

Documentation for each source file can be found here:

.. toctree::
   :maxdepth: 1

   analyses
   common
   fileio/main
   fluid/index
   linalg
   logging
   main
   parallel/index
   param/index
   save
   simple_npyio
   statistics/index
   temperature/index


###########################
Simple Navier-Stokes Solver
###########################

|License|_ |CI|_ |LastCommit|_ |GitHubStars|_

.. |License| image:: https://img.shields.io/github/license/NaokiHori/SimpleNavierStokesSolver
.. _License: https://opensource.org/licenses/MIT

.. |CI| image:: https://github.com/NaokiHori/SimpleNavierStokesSolver/actions/workflows/ci.yml/badge.svg
.. _CI: https://github.com/NaokiHori/SimpleNavierStokesSolver/actions/workflows/ci.yml

.. |LastCommit| image:: https://img.shields.io/github/last-commit/NaokiHori/SimpleNavierStokesSolver/main
.. _LastCommit: https://github.com/NaokiHori/SimpleNavierStokesSolver/commits/main

.. |GitHubStars| image:: https://img.shields.io/github/stars/NaokiHori/SimpleNavierStokesSolver?style=social
.. _GitHubStars: https://github.com/NaokiHori/SimpleNavierStokesSolver

|CBadge|_ |DockerBadge|_ |GitHubActionsBadge|_ |GitHubPagesBadge|_

.. |CBadge| image:: https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=C&logoColor=white
.. _CBadge: https://www.iso.org/standard/74528.html

.. |DockerBadge| image:: https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white
.. _DockerBadge: https://www.docker.com

.. |GitHubActionsBadge| image:: https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white
.. _GitHubActionsBadge: https://github.com/features/actions

.. |GitHubPagesBadge| image:: https://img.shields.io/badge/GitHub%20Pages-222222?style=for-the-badge&logo=GitHub%20Pages&logoColor=white
.. _GitHubPagesBadge: https://pages.github.com

.. image:: https://raw.githubusercontent.com/NaokiHori/SimpleNavierStokesSolver/gh-pages/docs/_images/snapshot.png

********
Overview
********

This library numerically solves the incompressible Navier-Stokes equations (coupled with a temperature field) in two-dimensional Cartesian domains using finite-difference methods.

The main purpose is to develop a library where `the implementations <https://naokihori.github.io/SimpleNavierStokesSolver/implementation/index.html>`_ and their background knowledges (`theories <https://naokihori.github.io/SimpleNavierStokesSolver/governing_equations/index.html>`_ and `numerical techniques <https://naokihori.github.io/SimpleNavierStokesSolver/numerical_method/index.html>`_) are closely linked via `a documentation <https://naokihori.github.io/SimpleNavierStokesSolver/index.html>`_, so that users can understand *how* and *why* things are treated.

********
Features
********

* Strong connection between `theories <https://naokihori.github.io/SimpleNavierStokesSolver/governing_equations/index.html>`_, `numerics <https://naokihori.github.io/SimpleNavierStokesSolver/numerical_method/index.html>`_, `implementations <https://naokihori.github.io/SimpleNavierStokesSolver/implementation/index.html>`_ and `examples <https://naokihori.github.io/SimpleNavierStokesSolver/examples/index.html>`_ via `a documentation <https://naokihori.github.io/SimpleNavierStokesSolver/index.html>`_
* `Automatic code validation <https://naokihori.github.io/SimpleNavierStokesSolver/examples/index.html>`_ thanks to `GitHub Actions <https://github.com/features/actions>`_ (`workflow <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/.github/workflows/ci.yml>`_)
* Perfect (up to round-off errors) mass and momentum balances
* `Perfect (up to round-off errors) Nusselt number agreements <https://naokihori.github.io/SimpleNavierStokesSolver/examples/case3/main.html>`_
* `Conservations of quadratic quantities (squared velocity and temperature) for inviscid fluids <https://naokihori.github.io/SimpleNavierStokesSolver/examples/case2/main.html>`_ and resulting extreme stability
* `MPI parallelisation <https://naokihori.github.io/SimpleNavierStokesSolver/numerical_method/spatial_discretisation/domain.html>`_
* `Efficient FFT-based direct Poisson solver <https://naokihori.github.io/SimpleNavierStokesSolver/implementation/fluid/compute_potential.html>`_
* Automatic optimisation of diffusive term treatments (explicit/implicit in time in both directions)

Please refer to `the documentation <https://naokihori.github.io/SimpleNavierStokesSolver/index.html>`_ for details.

**********
Dependency
**********

* `C compiler <https://gcc.gnu.org>`_
* `MPI <https://www.open-mpi.org>`_
* `FFTW3 <https://www.fftw.org>`_

Although not essential, these libraries are helpful:

* `Git <https://git-scm.com>`_
* `GNU Make <https://www.gnu.org/software/make/>`_
* `Python <https://www.python.org>`_ with `NumPy <https://numpy.org>`_ and `Matplotlib <https://matplotlib.org>`_

====================
Docker (recommended)
====================

Install `Git <https://git-scm.com>`_ beforehand to fetch this repository.

.. code-block:: console

   $ mkdir /path/to/your/working/directory
   $ cd    /path/to/your/working/directory
   $ git clone https://github.com/NaokiHori/SimpleNavierStokesSolver
   $ cd SimpleNavierStokesSolver
   $ docker build -t simplenavierstokessolver:latest .

======
Ubuntu
======

.. code-block:: console

   $ apt-get update
   $ apt-get install gcc libopenmpi-dev libfftw3-dev git make

============
Alpine Linux
============

.. code-block:: console

   $ apk -U upgrade
   $ apk add gcc musl-dev openmpi-dev fftw-dev git make

=====
MacOS
=====

`Command Line Tools for Xcode <https://developer.apple.com/download/all/?q=command%20line%20tools>`_ is necessary to compile C sources in addition to

.. code-block:: console

   $ brew install gcc open-mpi fftw git make

=======
Windows
=======

Use `Windows Subsystem for Linux <https://docs.microsoft.com/en-us/windows/wsl/>`_.

***********
Quick start
***********

#. Create working directory

   .. code-block:: console

      $ mkdir /path/to/your/working/directory
      $ cd    /path/to/your/working/directory

#. Fetch source

   .. code-block:: console

      $ git clone https://github.com/NaokiHori/SimpleNavierStokesSolver
      $ cd SimpleNavierStokesSolver

#. Build

   * Docker

      .. code-block:: console

         $ docker run -it --rm --cpuset-cpus="0-1" -u runner -v ${PWD}:/home/runner simplenavierstokessolver:latest
         $ make output
         $ make all

   * Others

      .. code-block:: console

         $ make output
         $ make all

#. Run with default configuration (see `the documentation <https://naokihori.github.io/SimpleNavierStokesSolver/introduction.html>`_ to modify parameters)

   .. code-block:: console

      $ mpirun -n 2 ./a.out

giving e.g.,

.. code-block:: text

   ------- parameters are loaded -------
     with_temperature: true (default)
     with_thermal_forcing: true (default)
     timemax: 1.000e+02 (default)
     wtimemax: 3.600e+03 (default)
     log_rate: 1.000e+00 (default)
     log_after: 0.000e+00 (default)
     save_rate: 1.000e+01 (default)
     save_after: 0.000e+00 (default)
     stat_rate: 1.000e-01 (default)
     stat_after: 5.000e+01 (default)
     itot: 16 (default)
     jtot: 32 (default)
     ly: 2.000e+00 (default)
     stretch: 3.000e+00 (default)
     Ra: 1.000e+04 (default)
     Pr: 2.000e+00 (default)
   -------------------------------------
   ------- Check optimal diffusive term treatment -------
   EXP(x)-EXP(y):    13495 iterations in 1.0e+00 [s]
   IMP(x)-EXP(y):     7920 iterations in 1.0e+00 [s]
   EXP(x)-IMP(y):     4526 iterations in 1.0e+00 [s]
   IMP(x)-IMP(y):     4236 iterations in 1.0e+00 [s]
   ------------------------------------------------------
   step       36, time     1.0, dt 2.85e-02 (x: EXP, y: EXP)
   step       71, time     2.0, dt 2.85e-02 (x: EXP, y: EXP)
   step      106, time     3.0, dt 2.85e-02 (x: EXP, y: EXP)
   step      141, time     4.0, dt 2.85e-02 (x: EXP, y: EXP)
   step      176, time     5.0, dt 2.85e-02 (x: EXP, y: EXP)
   ...
   step     3374, time    96.0, dt 2.85e-02 (x: EXP, y: EXP)
   step     3409, time    97.0, dt 2.85e-02 (x: EXP, y: EXP)
   step     3444, time    98.0, dt 2.85e-02 (x: EXP, y: EXP)
   step     3479, time    99.0, dt 2.85e-02 (x: EXP, y: EXP)
   step     3515, time   100.0, dt 2.85e-02 (x: EXP, y: EXP)
   elapsed: 10.76 [s]

You find log files, flow fields, and statistics are saved under ``output`` directory:

.. code-block:: text

   output
   ├── log
   │  ├── divergence.dat
   │  ├── energy.dat
   │  ├── momentum.dat
   │  ├── nusselt.dat
   │  └── progress.dat
   ├── save
   │  ├── step0000000352
   │  ├── step0000000703
   │  ├── step0000001055
   │  ├── step0000001406
   │  ├── step0000001758
   │  ├── step0000002109
   │  ├── step0000002460
   │  ├── step0000002812
   │  ├── step0000003163
   │  └── step0000003515
   └── stat
      └── step0000003515

Log files are written in ASCII format, while flow fields and statistical data are stored in `NPY format <https://numpy.org/doc/stable/reference/generated/numpy.lib.format.html>`_ using `SimpleNpyIO <https://github.com/NaokiHori/SimpleNpyIO>`_.
When Python with NumPy and Matplotlib is installed, the flow fields can be easily visualised.

****************
Acknowledgements
****************

The development of this CFD solver is largely motivated by `CaNS <https://github.com/p-costa/CaNS>`_ and `AFiD <https://stevensrjam.github.io/Website/afid.html>`_.

I would like to thank Dr. Pedro Costa and Dr. Marco Edoardo Rosti among others for fruitful discussions during my days at KTH Royal Institute of Technology in Stockholm and the University of Tokyo.


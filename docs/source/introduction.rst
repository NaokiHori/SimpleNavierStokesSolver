############
Introduction
############

********
Overview
********

There are mainly three reasons why I develop this library.

#. Connections between methods and implementations

   Although there are so many elegant libraries in the world, not all have documentations, and few are well-documented.
   In particular, sometimes there is a huge discrepancy between methods (equations) and implementations (code).
   I aim to find a way to reduce this gap in this project.

#. Well-validated

   Although validations of codes are usually shown in publications, it is not easy to see it is *really* working, and in the first place compilation of the code itself can be cumbersome.
   Trying to validate the code and publishing the results automatically whenever changes are made is another objective of this project.

#. Shedding light on minor but non-trivial things

   Although the background algorithm of this solver (integrating mass, momentum, and scalar fields) is fairly simple and famous, minor things are less focused and sometimes correct ways are counter-intuitive.
   Shedding light on these minor but non-trivial things, such as

   * discrete energy conservation

   * calculation of dissipation rates

   * Nusselt number agreements

   is the third focus of this project.

.. note::

   Although the program is parallelised using MPI, the efficiency of the code is not considered so much.
   For instance, memory allocations and deallocations are frequently called to shrink the scopes of the variables.
   Therefore it is less efficient and not recommended to perform any large-scale simulations.

************
Installation
************

============
Dependencies
============

* C compiler
* MPI
* FFTW3

=====
Usage
=====

I recommend to use `Docker <https://www.docker.com>`_ and `Git <https://git-scm.com>`_, so that users do not contaminate their local environments.

#. Prepare working place and visit

   .. code-block:: console

      $ mkdir /path/to/your/working/directory
      $ cd    /path/to/your/working/directory

#. Fetch sources etc.

   .. code-block:: console

      $ git clone https://github.com/NaokiHori/SimpleNavierStokesSolver
      $ cd SimpleNavierStokesSolver

#. Build Docker image and launch container

   .. code-block:: console

      $ docker build -t simplenavierstokessolver:latest .
      $ docker run -it --rm --cpuset-cpus="0-1" -u runner -v ${PWD}:/home/runner simplenavierstokessolver:latest

   .. note::

      Change "0-1" depending on your CPU resource

#. Prepare place for saving results and build solver

   .. code-block:: console

      $ make output
      $ make

#. Run

   .. code-block:: console

      $ mpirun -n 2 ./a.out

Parameters are given by default for introductory purpose, which can be changed by giving environmental variables.
For instance, specifying

.. code-block:: console

   $ ly=4. jtot=512 mpirun -n 2 ./a.out

changes the domain size in :math:`y` direction (original :c-lang:`ly=2.` and :c-lang:`jtot=256`, see :ref:`src/param/init.c <param_init>`).

Note that this is equivalent to prepare a script (e.g., ``exec.sh``):

.. code-block:: sh

   #!/bin/bash

   export ly=4.
   export jtot=64

   mpirun -n 2 ./a.out

and call it:

.. code-block:: console

   $ bash exec.sh

Please refer to `exec.sh <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/exec.sh>`_ and also check :ref:`param/ <param>` for all available options.


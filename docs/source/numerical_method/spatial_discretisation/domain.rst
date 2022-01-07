
.. _domain:

############
Domain setup
############

In this project, we employ the staggered grid arrangement, i.e., pressure (and temperature), :math:`x` velocity, and :math:`y` velocity are defined at different locations:

.. image:: image/staggered1.pdf
   :width: 800

where the left figure shows the locations and indices of the variables which are used in equations, while the variables in the right figure are used in the code.

In the current project, we assume that the domain is wall-bounded in :math:`x` direction, while periodic boundary conditions are imposed in :math:`y` direction.
Regarding the cell center (locations where the pressure is positioned), the number of grid points in :math:`x` and :math:`y` directions are :c-lang:`itot` and :c-lang:`jtot`, respectively.

In :math:`y` direction, the domain is split into :c-lang:`mpisize` (the number of processors) smaller domains using MPI, and each domain has :c-lang:`jsize` cell centers:

.. image:: image/domain.pdf
   :width: 800

Note that :c-lang:`jsize` can be different for each process.
For more details, see :c-lang:`parallel_get_size` in :ref:`src/parallel/others.c <parallel_others>`.

In addition, in order to evaluate the differentiations in :math:`y` direction close to the domain edges, additional cells (halo cells) are necessary to be appended in :math:`y` boundaries.

Thus, the locations of :c-lang:`UX(i, j)` are

.. image:: image/staggered2.pdf
   :width: 600

and the locations of :c-lang:`UY(i, j)` leads

.. image:: image/staggered3.pdf
   :width: 600

and the locations of :c-lang:`P(i, j)` (and :c-lang:`TEMP(i, j)`) can be drawn as

.. image:: image/staggered4.pdf
   :width: 600

The size of these two-dimensional arrays are

=========================== ================== ===================
Name                        :c-lang:`i` range  :c-lang:`j` range
=========================== ================== ===================
:c-lang:`UX`                :c-lang:`1:itot+1` :c-lang:`0:jsize+1`
:c-lang:`UY`                :c-lang:`0:itot+1` :c-lang:`0:jsize+1`
:c-lang:`P`, :c-lang:`TEMP` :c-lang:`0:itot+1` :c-lang:`0:jsize+1`
=========================== ================== ===================

Note that :c-lang:`UY(0, j)`, :c-lang:`UY(itot+1, j)` are shifted towards the near wall locations so that we can impose the velocity boundary conditions directly.
A similar treatment is considered for the pressure.

.. note::

   Another way is to position cells inside the walls, whose values are extrapolated (ghost cells).
   When computing the derivatives, however, the current implementation and the way to use ghost cells give identical results.

In :math:`y` direction, the grid spacing should be equidistant for now.
In :math:`x` direction, on the other hand, non-uniform grid arrangement can be adopted, which could be beneficial to resolve boundary layers on the walls by clustering grid points.
To identify the position of the computational nodes, it is necessary to use two variables which are in :c-lang:`param` structure, whose definitions are described below.

1. :c-lang:`param->xf`

   :c-lang:`XF(i)` is used to describe the position of the cell faces in :math:`x` direction (**f** comes from face), i.e., the locations where :math:`\ux` is defined:

   .. image:: image/grid1.pdf
      :width: 800

2. :c-lang:`param->xc`

   :c-lang:`XC(i)` is used to describe the position of the cell centers in :math:`x` direction (**c** comes from center), i.e., the locations where pressure, temperature, and :math:`\uy` are defined:

   .. image:: image/grid2.pdf
      :width: 800

Note that cell-face positions are included at the edges of the domain.

.. seealso::

   Coordiates are numerically defined by :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>`.


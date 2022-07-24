
.. _logging:

############################################################################################
`logging.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/logging.c>`_
############################################################################################

``logging.c`` contains functions which compute and output quantities to be monitored during the simulation.

*******
logging
*******

==========
Definition
==========

.. code-block:: c

  int logging(
      const param_t *param,
      const parallel_t *parallel,
      const fluid_t *fluid,
      const temperature_t *temperature
  );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in     temperature field
=========== ====== ==================

===========
Description
===========

This function is a main function of this file and calls other logging functions described below.

*************
show_progress
*************

==========
Definition
==========

.. code-block:: c

  static int show_progress(
      const char fname[],
      const param_t *param,
      const parallel_t *parallel
  );

=========== ====== ===================
Name        intent description
=========== ====== ===================
fname       in     name of output file
param       in     general parameters
parallel    in     MPI parameters
=========== ====== ===================

===========
Description
===========

Show the integration step :c-lang:`param->step`, simulation time :c-lang:`param->time` , current time step size :c-lang:`param->dt`, and the treatment of the diffusion terms :c-lang:`param->implicit` (explicit or implicit, see :ref:`here <result_runge_kutta>`):

.. myliteralinclude:: /../../src/logging.c
  :language: c
  :tag: show progress to standard output and file

Note that these information are displayed (if it is not redirected) and are output to the file :c-lang:`fname`.

****************
check_divergence
****************

==========
Definition
==========

.. code-block:: c

  static int check_divergence(
      const char fname[],
      const param_t *param,
      const parallel_t *parallel,
      const fluid_t *fluid
  );

=========== ====== ===================
Name        intent description
=========== ====== ===================
fname       in     name of output file
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
=========== ====== ===================

===========
Description
===========

This function computes the divergence of the velocity field and write the results to a file :c-lang:`fname`.

Local divergence of the velocity field

.. math::
   \dder{\ux}{x}
   +
   \dder{\uy}{y}
   =
   \frac{
      \vat{\ux}{\pip, \pjc}
      -
      \vat{\ux}{\pim, \pjc}
   }{\Delta x_{\pic}}
   +
   \frac{
      \vat{\uy}{\pic, \pjp}
      -
      \vat{\uy}{\pic, \pjm}
   }{\Delta y}

defined at cell center :math:`\left( \pic, \pjc \right)` is implemented as

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: compute local divergence

The maximum value of the local divergence :c-lang:`divmax` and the summation of them :c-lang:`divsum`, which should be comparable to machine epsilon, are checked

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: check local maximum divergence and global divergence

Finally, after collecting the information among all processes:

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: collect information among all processes

they are written to a file:

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: information are output, similar for other functions

.. note::

   The output should be done only by the master process (:c-lang:`mpirank` is 0).

**************
check_momentum
**************

==========
Definition
==========

.. code-block:: c

  static int check_momentum(
      const char fname[],
      const param_t *param,
      const parallel_t *parallel,
      const fluid_t *fluid
  );

=========== ====== ===================
Name        intent description
=========== ====== ===================
fname       in     name of output file
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
=========== ====== ===================

===========
Description
===========

This function computes the net momentum in each direction :math:`\int \ux dx dy` and :math:`\int \uy dx dy` and write them to a file :c-lang:`fname`.

The discrete forms lead

.. math::
   \sum_{i} \sum_{j}
   \vat{
      \left(
         \ux
         \Delta x
         \Delta y
      \right)
   }{\xic, \xjc}

and

.. math::
   \sum_{i} \sum_{j}
   \vat{
      \left(
         \uy
         \Delta x
         \Delta y
      \right)
   }{\yic, \yjc}.

Note that the summations are taken over all :math:`\ux` and :math:`\uy` components, respectively.

The implementations are

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: compute total x-momentum

and

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: compute total y-momentum

respectively.

They are written to a file after being collected among all processes (see :c-lang:`check_divergence` above).

************
check_energy
************

==========
Definition
==========

.. code-block:: c

  static int check_energy(
      const char fname[],
      const param_t *param,
      const parallel_t *parallel,
      const fluid_t *fluid,
      const temperature_t *temperature
  );

=========== ====== ===================
Name        intent description
=========== ====== ===================
fname       in     name of output file
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in     temperature
=========== ====== ===================

===========
Description
===========

This function computes the total discrete energies (quadratic quantities) :math:`k = \int \frac{1}{2} \ux^2 dx dy + \int \frac{1}{2} \uy^2 dx dy` and :math:`h = \int \frac{1}{2} T^2 dx dy`, whose results are written to a file :c-lang:`fname`.

Their discrete forms lead

.. math::
   \sum_{i} \sum_{j}
   \vat{
      \left(
         \frac{1}{2}
         \ux^2
         \Delta x
         \Delta y
      \right)
   }{\xic, \xjc},

.. math::
   \sum_{i} \sum_{j}
   \vat{
      \left(
         \frac{1}{2}
         \uy^2
         \Delta x
         \Delta y
      \right)
   }{\yic, \yjc},

and

.. math::
   \sum_{i} \sum_{j}
   \vat{
      \left(
         \frac{1}{2}
         T
         \Delta x
         \Delta y
      \right)
   }{\pic, \pjc},

which are implemented as

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: compute quadratic quantity in x direction

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: compute quadratic quantity in y direction

and

.. myliteralinclude:: /../../src/logging.c
   :language: c
   :tag: compute thermal energy

respectively.

They are written to a file after being collected among all processes (see :c-lang:`check_divergence` above).

.. _logging_check_nusselt:

*************
check_nusselt
*************

==========
Definition
==========

.. code-block:: c

  static int check_nusselt(
      const char fname[],
      const param_t *param,
      const parallel_t *parallel,
      const fluid_t *fluid,
      const temperature_t *temperature
  );

=========== ====== ===================
Name        intent description
=========== ====== ===================
fname       in     name of output file
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in     temperature
=========== ====== ===================

===========
Description
===========

This function computes the instantaneous Nusselt number (heat transfer enhancement by the advective effects) :math:`Nu \left( t \right)` based on various definitions and write them to a file :c-lang:`fname`.
We compute :math:`Nu` by four different ways.

.. seealso::

   The continuous and discrete relations are derived in :ref:`the governing equations <governing_equations>` and :ref:`the Nusselt number relations <nusselt_number_relations>`, respectively.

#. Heat flux (on the walls)

   .. math::
      Nu \left( t \right)
      =
      -\vat{\ave{\der{T}{x}}{y}}{\text{left  wall}}
      =
      -\vat{\ave{\der{T}{x}}{y}}{\text{right wall}},

   which are discretised as

   .. math::
      Nu
      & =
      -\frac{1}{l_y} \sum_{j} \vat{\left( \dder{T}{x} \Delta y \right)}{\text{left  wall}, \xjc} \\
      & =
      -\frac{1}{l_y} \sum_{j} \vat{\left( \dder{T}{x} \Delta y \right)}{\text{right wall}, \xjc}

   and implemented as

   .. myliteralinclude:: /../../src/logging.c
      :language: c
      :tag: heat flux on the walls

#. Energy injection

   .. math::
      Nu \left( t \right)
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\ux T}{x,y} + 1

   which is discretised as

   .. math::
      Nu
      =
      \frac{1}{l_x l_y}
      \sqrt{Pr} \sqrt{Ra}
      \sum_i \sum_j
      \vat{
         \left(
            \ux
            \dintrpa{T}{x}
            \Delta x
            \Delta y
         \right)
      }{\xic, \xjc}
      +
      1,

   which is implemented as

   .. myliteralinclude:: /../../src/logging.c
      :language: c
      :tag: energy injection

#. Kinetic energy dissipation

   .. math::
      Nu
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_k}{V,t} + 1

   which is discretised as

   .. math::
      Nu
      & =
      \frac{1}{l_x l_y}
      \sqrt{Pr} \sqrt{Ra}
      \sum_{i} \sum_{j} \vat{
         \left\{
            \frac{\sqrt{Pr}}{\sqrt{Ra}}
            \left(
               s_{xx} s_{xx}
               +
               s_{xy} s_{xy}
            \right)
            \Delta x
            \Delta y
         \right\}
      }{\xic, \xjc} \\
      & +
      \frac{1}{l_x l_y}
      \sqrt{Pr} \sqrt{Ra}
      \sum_{i} \sum_{j} \vat{
         \left\{
            \frac{\sqrt{Pr}}{\sqrt{Ra}}
            \left(
               s_{yx} s_{yx}
               +
               s_{yy} s_{yy}
            \right)
            \Delta x
            \Delta y
         \right\}
      }{\yic, \yjc} \\
      & +
      1,

   which is implemented as

   .. myliteralinclude:: /../../src/logging.c
      :language: c
      :tag: kinetic energy dissipation rate

   The discrete dissipation rate is computed in :ref:`src/analyses.c <analyses>`.

4. Thermal energy dissipation

   .. math::
      Nu
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_h}{x,y}

   which is discretised as

   .. math::
      Nu
      =
      \frac{1}{l_x l_y}
      \sqrt{Pr} \sqrt{Ra}
      \sum_{i} \sum_{j}
      \vat{
         \left\{
            \frac{1}{\sqrt{Pr} \sqrt{Ra}}
            \left(
               r_x r_x
               +
               r_y r_y
            \right)
            \Delta x
            \Delta y
         \right\}
      }{\pic, \pjc},

   which is implemented as

   .. myliteralinclude:: /../../src/logging.c
      :language: c
      :tag: thermal energy dissipation rate

   The dissipation rate is computed in :ref:`src/analyses.c <analyses>`.

Note that these four :math:`Nu` should return the same value in a statistical sense.

They are written to a file after being collected among all processes (see :c-lang:`check_divergence` above).


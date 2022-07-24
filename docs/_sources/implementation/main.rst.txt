
.. _main:

######################################################################################
`main.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/main.c>`_
######################################################################################

``main.c`` contains a main function which calls all other functions.

****
main
****

==========
Definition
==========

.. code-block:: c

   int main(void);

==== ====== ===========
Name intent description
==== ====== ===========
N/A  N/A    N/A
==== ====== ===========

===========
Description
===========

Here the flow of the program is described briefly as well as the corresponding part of the code.

#. Configuration

   Almost all parameters are set in `exec.sh <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/exec.sh>`_ before launched.
   For simplicity, they are defined as local environmental variables (i.e., :sh:`export XXX=value`) and loaded later.
   For more detail of each parameter loaded here, see :ref:`here <param>`.

#. Initialisation

   Main function in `src/main.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/tree/master/src/main.c>`_ is called among others.

   MPI is launched, and time when the execution is started is recorded:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: launch MPI, start timer

   Structures (e.g. :c-lang:`fluid_t *fluid`) and their members (e.g. :c-lang:`fluid->ux`) are allocated and initialised (initial values are assigned):

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: initialise structures

   Optimal diffusive term treatment (to minimise the overall computational load) is estimated:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: cost evaluations of diffusive term treatments

#. Main loop

   First of all, time step size **dt** (based on the diffusive term treatment determined above) is decided:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: decide time step size and diffusive term treatment

   All equations (mass, momentum, and internal energy balances) are integrated in time for one step:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: integrate mass, momentum, and internal energy balances in time

   .. note::

      See below for more details.

   Since the flow and temperature fields have been updated, time step (**step**) and time (**time**) should be incremented:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: step and time are incremented

#. Logging and output

   Values to be monitored during the simulation (e.g., divergence, which should be small enough) are computed and output regularly (each :c-lang:`param->log.rate` **simulation** time units):

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: output log

   .. note::

      This function is called when the current time :c-lang:`param->time` is larger than the scheduled time :c-lang:`param->log.next`.
      Once the logs are dumped, the schedule is updated to the next time, which is :c-lang:`param->log.rate` time units later.

      Similar schedule managements are done for :c-lang:`save` and :c-lang:`statistics`, which are called below.

   Flow fields are necessary for post-processings, visualisations, and restarting simulations; they are also dumped here regularly (each :c-lang:`param->save.rate` **simulation** time units):

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: save flow fields

   Temporally-averaged statistics are collected during the simulation (each :c-lang:`param->stat.rate` **simulation** time units).

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: collect statistics

   The program is terminated when the simulation reaches the maximum (free-fall) time units:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: terminate when the simulation is finished

   We also terminate the program when it has spent the maximum `wall time`:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: terminate when wall time limit is reached

#. Clean-up and finalisation

   Final flow fields (velocity, pressure, and temperature) and collected statistics are saved:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: save restart file and statistics at last

   Structures and their members are deallocated:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: finalise structures

   Finally MPI is finalised:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: finalise MPI

*********
integrate
*********

==========
Definition
==========

.. code-block:: c

   static int integrate(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid,
       temperature_t *temperature
   );

=========== ====== =============================================
Name        intent description
=========== ====== =============================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in/out pressure (in/out), velocity (in/out)
temperature in/out temperature (in/out), buoyancy force (in/out)
=========== ====== =============================================

===========
Description
===========

This function integrates the governing equation for one time step.

#. Update boundary values

   Boundary values (values on the walls in :math:`x` direction, values of halo cells in :math:`y` direction) of the velocities :c-lang:`fluid->ux`, :c-lang:`fluid->uy` and pressure :c-lang;`fluid->p` are assigned, which will be used to evaluate derivatives in the next steps:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: update boundary and halo values

#. Update temperature-related variables

   Based on the flow field (velocities), temperature field as well as buoyancy term are updated:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: update temperature and thermal forcing

#. Predict velocity

   Using the buoyancy force, :math:`x` and :math:`y` velocities are updated

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: update velocity by integrating momentum equation

   by integrating the momentum equation

   .. math::
      u_i^* = u_i^k + \left\{ \alpha^k \left( A_i^k + D_i^k \right) + \beta^k \left( A_i^{k-1} + D_i^{k-1} \right) + \gamma^k P_i^k \right\} \Delta t

   if the diffusive terms are treated explicitly, whereas

   .. math::
      \begin{aligned}
         & \delta u_i = \left\{ \alpha^k A_i^k + \beta^k A_i^{k-1} + \gamma^k \left( P_i^k + D_i^k \right) \right\} \Delta t, \\
         & u_i^* = u_i^k + \left( 1 - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2}{\delta x^2} \right)^{-1} \left( 1 - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta u_i,
      \end{aligned}

   if treated implicitly.
   See :ref:`Numerical method <numerics>` for more details (e.g., the meaning of the variables).

#. Compute scalar potential and correct velocity

   A scalar potential :math:`\psi` is computed by solving a Poisson equation

   .. math::
      \frac{\delta ^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\gamma^k \Delta t} \frac{\delta u_i^*}{\delta x_i}

   whose implementation is

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: compute scalar potential

   to correct the velocity field :math:`u_i^*`, so that the incompressibility constraint is satisfied:

   .. math::
      u_i^{k+1} = u_i^* - \gamma^k \Delta t \frac{\delta \psi}{\delta x_i}

   whose implementation is

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: correct velocity to be solenoidal

#. Update pressure

   Finally the pressure is updated following

   .. math::
      p^{k+1} = p^k + \psi

   if the diffusive terms are treated explicitly, while

   .. math::
      \frac{\delta p^{n+1}}{\delta x_i} = \frac{\delta p^n}{\delta x_i} + \frac{\delta \psi}{\delta x_i} - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2}{\delta x_j \delta x_j} \left( \frac{\delta \psi}{\delta x_i} \right)

   for implicit treatments:

   .. myliteralinclude:: /../../src/main.c
      :language: c
      :tag: update pressure

.. note::

   These procedures are repeated for three times (since we use *three* -step Runge-Kutta scheme) to update the fields (values at :math:`n` step is updated to ones at :math:`n+1` step).


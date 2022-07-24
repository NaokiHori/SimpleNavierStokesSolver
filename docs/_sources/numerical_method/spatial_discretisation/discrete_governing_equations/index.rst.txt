
.. _discrete_governing_equations:

.. include:: /references.txt

############################
Discrete governing equations
############################

************
Introduction
************

The :ref:`SMAC method <smac_method>` adopted in :ref:`the temporal discretisation <temporal_discretisation>` is a *de facto standard* to integrate the momentum balance in time while keeping the incompressibility constraint.
Spatial discretisations are, on the other hand, more flexible and scheme totally depends on the situation, on which property the user puts emphasis.
For instance, one can make schemes more accurate by adopting wider stencils properly.

In this project, we focus on the following two features:

* Simplicity, as the name of the project says

   We limit discussion to second-order-accurate central-difference schemes, where three points in one direction (itself and two neighbouring points) are used to evaluate differentiations.

* Keeping properties of the governing equations

   As reviewed in :ref:`the governing equations <governing_equations>`, there are several important features which the governing equations hold in the continuous domain.

   #. Advective terms do not alter the net amount of quantity (e.g., momentum, kinetic energy).

   #. Dissipative terms reduce the total amount of quantity

   #. :math:`K \equiv \int k dV` is conserved if the mass and momentum balances are satisfied (inviscid limit)

   #. :math:`H \equiv \int h dV` is conserved if the mass and thermal energy balances are satisfied (inviscid limit)

   #. Several ways to compute Nusselt number give an identical result (in a statistical sense).

   We try to mimic these properties after being discretised.

Based on these features, in this section, we aim to derive *discrete* governing equations :ref:`which are implemented in this project <implementation>`.

.. note::

   In short, the conclusive scheme is the so-called energy-conserving scheme.
   Usually, energy-conserving scheme is derived for governing equations in strong conservation forms.
   Namely, the equations are once mapped to a general coordinate system where grid sizes are uniform in the whole domain, in which the equations are discretised (e.g., |KAJISHIMA1999|).

   Although it is a consistent and powerful way, it tends to be fairly complicated, which can be found in the appendix.
   In this section, we try to deduce the same conclusion without using this projection, but simply by focusing on the conservation properties of mass, momentum, and energy.

*****************
Table of contents
*****************

This section is organised as follows.

.. toctree::
   :maxdepth: 1

   basic_operators
   mass_balance_and_pressure_equation
   momentum_balance_and_quadratic_quantity
   thermal_energy_balance_and_quadratic_quantity
   nusselt_number_relations
   inconsistent_results
   appendix_general_coordinate

**********
Conclusion
**********

The following equations keep the properties of the original governing equations and are implemented in the code.
See :ref:`basic operators <basic_operators>` for details of the used symbols.

Mass balance at :math:`\left( \pic, \pjc \right)`:

.. math::
   \dder{\ux}{x}
   +
   \dder{\uy}{y}
   =
   0,

which is satisfied in :ref:`src/fluid/correct_velocity.c <fluid_correct_velocity>`.

Momentum balance in :math:`x` direction at :math:`\left( \xic, \xjc \right)`:

.. math::
   \der{\ux}{t}
   +
   \dintrpv{
      \dintrpa{\ux}{x}
      \dder{\ux}{x}
   }{x}
   +
   \dintrpa{
      \dintrpv{\uy}{x}
      \dder{\ux}{y}
   }{y}
   =
   -\dder{p}{x}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{\ux}{x} \right)
      +
      \dder{}{y} \left( \dder{\ux}{y} \right)
   \right\}
   +
   \dintrpa{T}{x},

which is implemented in :ref:`src/fluid/update_velocity.c <fluid_update_velocity>`.

Momentum balance in :math:`y` direction at :math:`\left( \yic, \yjc \right)`:

.. math::
   \der{\uy}{t}
   +
   \dintrpv{
      \dintrpa{\ux}{y}
      \dder{\uy}{x}
   }{x}
   +
   \dintrpa{
      \dintrpa{\uy}{y}
      \dder{\uy}{y}
   }{y}
   =
   -\dder{p}{y}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{\uy}{x} \right)
      +
      \dder{}{y} \left( \dder{\uy}{y} \right)
   \right\},

which is implemented in :ref:`src/fluid/update_velocity.c <fluid_update_velocity>`.

Internal energy balance at :math:`\left( \pic, \pjc \right)`:

.. math::
   \der{T}{t}
   +
   \dintrpv{
      \ux
      \dder{T}{x}
   }{x}
   +
   \dintrpa{
      \uy
      \dder{T}{y}
   }{y}
   =
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{T}{x} \right)
      +
      \dder{}{y} \left( \dder{T}{y} \right)
   \right\},

which is implemented in :ref:`src/temperature/update.c <temperature_update>`.



.. _mass_balance_and_pressure_equation:

##################################
Mass balance and pressure equation
##################################

************
Introduction
************

In this part, we consider to discretise

.. math::
   \der{u_i}{x_i} = 0

at cell center :math:`\left( \pic, \pjc \right)`.

Also the discrete form of the pressure equation

.. math::
   \frac{\partial^2 \psi}{\partial x_i \partial x_i}
   =
   \frac{1}{\Delta t} \der{u_i^*}{x_i}

is derived.

*************************************
Discrete incompressibility constraint
*************************************

The incompressibility constraint at cell center :math:`\left( \pic, \pjc \right)` is discretised as

.. math::
   \dder{\ux}{x}
   +
   \dder{\uy}{y}
   =
   0.

.. details:: Derivations

   As being discussed in :ref:`the grid arrangement <domain>`, in this project, cell center (where pressure and temperature are located) lies in the middle of surrounding cell faces (where velocities are located), i.e.,

   .. math::
      \vat{x}{\pic}
      & =
      \frac{1}{2} \vat{x}{\pip}
      +
      \frac{1}{2} \vat{x}{\pim}, \\
      \vat{y}{\pjc}
      & =
      \frac{1}{2} \vat{y}{\pjp}
      +
      \frac{1}{2} \vat{y}{\pjm}.

   Since velocities are defined at cell face, it is natural to define the incompressibility constraint at cell center, i.e.,

   .. math::
      \der{u_i}{x_i} \left( x, y \right)
      \approx
      \vat{\dder{u_i}{x_i}}{\pic,\pjc}
      =
      \frac{\vat{\ux}{\pip} - \vat{\ux}{\pim}}{\vat{x}{\pip} - \vat{x}{\pim}}
      +
      \frac{\vat{\uy}{\pjp} - \vat{\uy}{\pjm}}{\vat{y}{\pjp} - \vat{y}{\pjm}}
      =
      0,

   so that it is isotropic with respect to each velocity component.
   In other words, this continuity is *only* valid at each cell center, which is different from continuous domain where all infinitesimal control volumes obey it.

**************************
Discrete pressure equation
**************************

Pressure equation at :math:`\left( \pic, \pjc \right)` should be discretised as

.. math::
   \dder{}{x} \left(
      \dder{\psi}{x}
   \right)
   +
   \dder{}{y} \left(
      \dder{\psi}{y}
   \right)
   =
   \frac{1}{\Delta t} \left(
      \dder{\ux^*}{x}
      +
      \dder{\uy^*}{y}
   \right).

.. details:: Derivations

   As being discussed in :ref:`the temporal discretisation <temporal_discretisation>`, the continuity is enforced by

   .. math::
      u_i^{n+1} = u_i^{*} - \der{\psi}{x_i} \Delta t,

   or written explicitly at each cell face:

   .. math::
      \vat{\ux^{n+1}}{\pip} &= \vat{\ux^*}{\pip} - \vat{\der{\psi}{x}}{\pip} \Delta t, \\
      \vat{\ux^{n+1}}{\pim} &= \vat{\ux^*}{\pim} - \vat{\der{\psi}{x}}{\pim} \Delta t, \\
      \vat{\uy^{n+1}}{\pjp} &= \vat{\uy^*}{\pjp} - \vat{\der{\psi}{y}}{\pjp} \Delta t, \\
      \vat{\uy^{n+1}}{\pjm} &= \vat{\uy^*}{\pjm} - \vat{\der{\psi}{y}}{\pjm} \Delta t,

   where :math:`\psi` is a scalar potential.
   Assigning this relation to the above discrete incompressibility constraint yields

   .. math::
      \frac{
          \vat{\der{\psi}{x}}{\pip}
        - \vat{\der{\psi}{x}}{\pim}
      }{
          \vat{x}{\pip}
        - \vat{x}{\pim}
      }
      +
      \frac{
          \vat{\der{\psi}{y}}{\pjp}
        - \vat{\der{\psi}{y}}{\pjm}
      }{
          \vat{y}{\pjp}
        - \vat{y}{\pjm}
      }
      =
      \frac{1}{\Delta t}
      \frac{\vat{\ux^*}{\pip} - \vat{\ux^*}{\pim}}{\vat{x}{\pip} - \vat{x}{\pim}}
      +
      \frac{\vat{\uy^*}{\pjp} - \vat{\uy^*}{\pjm}}{\vat{y}{\pjp} - \vat{y}{\pjm}},

   which is the discrete pressure equation

   .. math::
      \frac{\delta^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\Delta t} \dder{u_i^*}{x_i}.

   .. warning::

      When the grid sizes are non-uniform, the above discretisation is *different* from what can be derived using the naive Taylor series expansion of

      .. math::
         \frac{\partial^2 \psi}{\partial x_i \partial x_i}.

      In other words, **if one discretises the pressure equation naively using Taylor series, the mass balance is violated**.
      To avoid this, one needs to design the domain differently, which is out of focus in this project.


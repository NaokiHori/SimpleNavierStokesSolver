
.. _governing_equations:

###################
Governing equations
###################

*****************
Dimensional forms
*****************

In this project, we focus on the balance of these quantities (conservation laws):

   * mass (incompressibility constraint),
   * momentum (:math:`u_i`, per unit mass, omitted hereafter),
   * kinetic energy (:math:`k \equiv u_i u_i / 2`),
   * internal energy (temperature :math:`T`),
   * thermal analogue to the kinetic energy (:math:`h \equiv T^2 / 2`).

After being simplified, governing equations for these quantities lead

.. math::
   \left\{
      \begin{alignedat}{2}
         & \der{u_i}{x_i} = 0, \\
         & \der{u_i}{t} + u_j \der{u_i}{x_j} = -\der{p}{x_i} + \nu \frac{\partial^2 u_i}{\partial x_j \partial x_j} + f_i, \\
         & \der{k}{t} + u_i \der{k}{x_i} = -u_i \der{p}{x_i} + \nu \der{}{x_j} \left( u_i \der{u_i}{x_j} \right) - \nu \der{u_i}{x_j} \der{u_i}{x_j} + u_i f_i, \\
         & \der{T}{t} + u_i \der{T}{x_i} = \kappa \frac{\partial^2 T}{\partial x_i \partial x_i}, \\
         & \der{h}{t} + u_i \der{h}{x_i} = \kappa \der{}{x_i} \left( T \der{T}{x_i} \right) - \kappa \der{T}{x_i} \der{T}{x_i},
      \end{alignedat}
   \right.

where constant physical properties in time and space (e.g., density :math:`\rho`, kinematic viscosity :math:`\nu`, thermal diffusivity :math:`\kappa`) are assumed.

Derivations are as follows.

.. _mass:

.. details:: mass

   By assuming no generation nor loss, mass balance of a control volume :math:`V` (whose surface is :math:`\partial V` or :math:`S`, and its normal is given by :math:`n_i`) can be written as

   .. math::
      \der{}{t} \int_{V} \rho dV + \int_{\partial V} \rho u_i n_i dS = 0,

   indicating that the mass increase or decrease in time is balanced by the mass flux.
   Here :math:`\rho` and :math:`u_i` denote the density of the liquid and velocity, which are generally functions of space :math:`x_i` and time :math:`t`.
   Commutation between the temporal derivative and the integral gives

   .. math::
      \int_{V} \der{\rho}{t} dV + \int_{\partial V} \rho u_i n_i dS = 0.

   By applying Gauss theorem, we have

   .. math::
      \int_{V} \left( \der{\rho}{t} + \der{\rho u_i}{x_i} \right) dV = 0.

   Since this relation should be satisfied anywhere (arbitrary control volume), the integrand should be null, i.e.,

   .. math::
      \der{\rho}{t} + \der{\rho u_i}{x_i} = 0.

   In this project, we assume that the liquid is incompressible

   .. math::
      \frac{D \rho}{D t}
      \equiv
      \der{\rho}{t} + u_i \der{\rho}{x_i}
      =
      0,

   which further simplifies the above equation and results in the incompressibility constraint

   .. math::
      \der{u_i}{x_i} = 0.

.. _momentum:

.. details:: momentum

   Based on the same discussion as :ref:`the mass balance <mass>`, momentum balance can be written as

   .. math::
      \int_{V} \left( \der{\rho u_i}{t} + u_j \der{\rho u_i}{x_j} \right) dV
      =
      \int_{\partial V} \sigma_{ij} n_j dS
      +
      \int_{V} f_i dV,

   indicating that changes in the momentum are caused by the 1. advection, 2. force working on the surface (both normal and tangential to the surface), and 3. body force.

   Again, thanks to the divergence theorem, we have

   .. math::
      \der{\rho u_i}{t} + u_j \der{\rho u_i}{x_j}
      =
      \der{\sigma_{ij}}{x_j}
      +
      f_i.

   In particular, :math:`\sigma_{ij}` is the Cauchy stress tensor given as (assuming incompressible liquid)

   .. math::
      \sigma_{ij} = - p \delta_{ij} + 2 \mu e_{ij},

   where :math:`p` is the reduced pressure and :math:`e_{ij}` is the strain-rate tensor (assuming isotropic Newtonian liquid)

   .. math::
      e_{ij} = \frac{1}{2} \left( \der{u_i}{x_j} + \der{u_j}{x_i} \right).

   Based on this closure relation, we obtain the balance of momentum as

   .. math::
      \der{\rho u_i}{t} + u_j \der{\rho u_i}{x_j}
      =
      -
      \der{p}{x_i}
      +
      \der{}{x_j} \left( 2 \mu e_{ij} \right)
      +
      f_i.

   Finally, by assuming the density and viscosity are constant, we have

   .. math::
      \der{u_i}{t}
      + u_j \der{u_i}{x_j}
      = -\der{p}{x_i}
      + \nu \frac{\partial^2 u_i}{\partial x_j \partial x_j}
      + f_i,

   where :math:`\nu \equiv \mu / \rho`.

   .. seealso::
      * `Navier-Stokes equations <https://en.wikipedia.org/wiki/Navier–Stokes_equations>`_
      * `Newtonian fluid <https://en.wikipedia.org/wiki/Newtonian_fluid>`_

.. details:: kinetic energy

   As discussed in the derivation of :ref:`the momentum balance <momentum>`, we have the following relation

   .. math::
      \der{u_i}{t}
      + u_j \der{u_i}{x_j}
      = -\der{p}{x_i}
      + \nu \frac{\partial^2 u_i}{\partial x_j \partial x_j}
      + f_i.

   We consider to multiply the momentum balance by :math:`u_i`, i.e., calculating the inner product of each term with :math:`u_i`.
   By adopting the product rule, it is readily apparent that we have

   .. math::
      \der{k}{t}
      + u_i \der{k}{x_i}
      = -u_i \der{p}{x_i}
      + \nu \der{}{x_j} \left( u_i \der{u_i}{x_j} \right)
      - \nu \der{u_i}{x_j} \der{u_i}{x_j}
      + u_i f_i,

   where :math:`k \equiv \frac{1}{2} u_i u_i` is the kinetic energy per unit mass.

   .. note::

      The second term in the right-hand-side can be written as

      .. math::
         \nu \frac{\partial^2 k}{\partial x_i \partial x_i}

      by further using the product rule.
      However, we stop in the first formulation for later convenience.

.. details:: internal energy (temperature) and thermal analogue to the kinetic energy

   By following the identical procedure as :ref:`the momentum balance <momentum>` (substituting :math:`u_i` with :math:`T`), we can derive the balance of the internal energy (or temperature):

   .. math::
      \der{T}{t}
      + u_i \der{T}{x_i}
      = \kappa \frac{\partial^2 T}{\partial x_i \partial x_i}.

   Also, by multiplying this equation by :math:`T`, we obtain

   .. math::
      \der{h}{t}
      + u_i \der{h}{x_i}
      = \kappa \der{}{x_i} \left( T \der{T}{x_i} \right)
      - \kappa \der{T}{x_i} \der{T}{x_i},

   where :math:`h \equiv \frac{1}{2} T^2` is analogous to the kinetic energy per unit mass :math:`k`.

   .. note::

      The second term in the right-hand-side can be written as

      .. math::
         \kappa \frac{\partial^2 h}{\partial x_i \partial x_i}

      by further using the product rule.
      However, we stop in the first formulation for later convenience.

*********************
Non-dimensional forms
*********************

We focus on `Rayleigh-Bénard convections <https://en.wikipedia.org/wiki/Rayleigh–Bénard_convection>`_ in this project, which is an excellent model problem to shed light on the conservation properties.
By assuming `Boussinesq approximation <https://en.wikipedia.org/wiki/Boussinesq_approximation_(buoyancy)>`_ to make the above equations non-dimensional, we obtain a set of equations which are considered in this project:

.. math::
   \left\{
      \begin{alignedat}{2}
         & \der{u_i}{x_i} = 0, \\
         & \der{u_i}{t} + u_j \der{u_i}{x_j} = -\der{p}{x_i} + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{\partial^2 u_i}{\partial x_j \partial x_j} + T \delta_{ix}, \\
         & \der{k}{t} + u_i \der{k}{x_i} = -u_i \der{p}{x_i} + \frac{\sqrt{Pr}}{\sqrt{Ra}} \der{}{x_j} \left( u_i \der{u_i}{x_j} \right) - \frac{\sqrt{Pr}}{\sqrt{Ra}} \der{u_i}{x_j} \der{u_i}{x_j} + u_i T \delta_{ix}, \\
         & \der{T}{t} + u_i \der{T}{x_i} = \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\partial^2 T}{\partial x_i \partial x_i}, \\
         & \der{h}{t} + u_i \der{h}{x_i} = \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{}{x_i} \left( T \der{T}{x_i} \right)
                                         - \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{T}{x_i} \der{T}{x_i}
      \end{alignedat}
   \right.

where Rayleigh number :math:`Ra` and Prandtl number :math:`Pr` are non-dimensional parameters which are given by

.. math::
   \begin{aligned}
     Ra & = \frac{\beta g {l_x}^3 \left( \Delta T \right)}{\nu \kappa}, \\
     Pr & = \frac{\nu}{\kappa}.
   \end{aligned}

Here :math:`\beta`, :math:`g`, :math:`l_x`, and :math:`\left( \Delta T \right) = T_{H} - T_{L}` are thermal expansion coefficient :math:`\left[ K^{-1} \right]`, gravitational acceleration :math:`\left[ L T^{-2} \right]`, distance between the walls :math:`\left[ L \right]`, and temperature difference :math:`\left[ K \right]`, respectively.
Also see the schematic below for convenience.

.. image:: image/schematic.pdf
   :width: 400

.. note::
   Here are several additional things to be noted.

   #. Without loss of generality, we can fix :math:`\beta`, :math:`g`, :math:`l_x`, and :math:`\left( \Delta T \right)` to unity, which is assumed in this project.
   #. Characteristic velocity :math:`U \left[ L T^{-1} \right]` is defined by using the other parameters :math:`U = \sqrt{\beta g l_x \left( \Delta T \right)} \left( = 1 \right)`, namely free-fall velocity.
   #. In this project, :math:`x` direction is the wall-normal direction, while other directions :math:`y` and :math:`z` are used to denote homogeneous directions where periodic boundary conditions (:math:`\vat{q}{y = 0} \equiv \vat{q}{y = l_y}`) are imposed.
   #. Walls are fixed in space and time. Although it is trivial to let them move in homogeneous directions from a numerical point of view, discussions regarding the energy balance assume fixed walls for the time being.

One of the most important features of Rayleigh-Bénard convections is its perfect energy balances and resulting theoretical relations with respect to the Nusselt number :math:`Nu`, which measures how much the heat transfer is enhanced by the convection.
Here are four typical relations:

#. Heat flux

   .. math::
      Nu
      =
      -
      \ave{
         \vat{
            \der{T}{x}
         }{x = 0}
      }{y,z,t}
      =
      -
      \ave{
         \vat{
            \der{T}{x}
         }{x = l_x}
      }{y,z,t},

   where :math:`\left\langle q_0 \right\rangle_{q_1}` indicates the average of a quantity :math:`q_0` with respect to :math:`q_1`

   .. math::
      \ave{q_0}{q_1} \equiv \frac{1}{q_1^{\max} - q_1^{\min}} \int_{q_1^{\min}}^{q_0^{\max}} q_0 \, dq_1.

   Note that this relation is the definition of the Nusselt number and only holds on the walls (at :math:`x = 0` and :math:`l_x`), but it can be extended to the bulk region:

   .. math::
      Nu = Nu \left( x \right)
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\ux T}{y,z,t} - \ave{\der{T}{x}}{y,z,t}.

   .. details:: Derivation

      Averaging the equation of internal energy (temperature :math:`T`) in homogeneous directions (:math:`y,z`) and in time gives

      .. math::
         \begin{aligned}
            \ave{\der{T}{t}}{y,z,t}
            & +
            \ave{\der{u_i T}{x_i}}{y,z,t} \\
            & =
            \frac{1}{\sqrt{Pr} \sqrt{Ra}} \ave{\frac{\partial^2 T}{\partial x_i \partial x_i}}{y,z,t},
         \end{aligned}

      where a conversion from the convective form to the divergence form

      .. math::
         u_i \der{q}{x_i} + q \der{u_i}{x_i} = \der{q u_i}{x_i}

      is adopted with the aid of the incompressiblity constraint.

      The temporal evolution drops since we are interested in statistically-steady state.
      The advective and diffusive terms in homogeneous directions (e.g., :math:`\partial u_y T / \partial y` or :math:`\partial^2 T / \partial y^2`) also vanish because of the periodic boundary conditions.
      Thus we have

      .. math::
         \ave{\der{u_x T}{x}}{y,z,t} = \frac{1}{\sqrt{Pr} \sqrt{Ra}} \ave{\frac{\partial^2 T}{\partial x^2}}{y,z,t}.

      By further integrating this equation in the wall-normal direction (interval is :math:`\left[ 0, x \right]`), we obtain

      .. math::
         \sqrt{Pr} \sqrt{Ra} \left[ \ave{u_x T}{y,z,t} \right]_{x = 0}^{x = x}
         =
         \left[ \ave{\der{T}{x}}{y,z,t} \right]_{x = 0}^{x = x}.

      We notice

      #. :math:`-\vat{\ave{u_x T}{y,z,t}}{x = 0} = 0` since :math:`\vat{u_x}{x = 0} \equiv 0` (walls are impermeable)

      #. :math:`-\vat{\ave{\der{T}{x}}{y,z,t}}{x = 0} = Nu` because of the definition

      and thus

      .. math::
         \forall x \in \left[ 0, l_x \right], \,\,
         Nu
         =
         \sqrt{Pr} \sqrt{Ra} \ave{u_x T}{y,z,t}
         -
         \ave{\der{T}{x}}{y,z,t}.

#. Energy injection

   .. math::
      Nu
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\ux T}{x,y,z,t} + 1.

   .. details:: Derivation

      By further averaging the relation of the heat flux in the wall-normal direction (or equivalently averaging the equation of the temperature in the whole domain), we have

      .. math::
         \begin{aligned}
            \frac{1}{l_x} \int_{x=0}^{x=l_x} Nu dx
            & =
            \frac{1}{l_x} \int_{x=0}^{x=l_x} \left[ \sqrt{Pr} \sqrt{Ra} \ave{u_x T}{y,z,t} - \ave{\der{T}{x}}{y,z,t} \right] dx \\
            & =
            \sqrt{Pr} \sqrt{Ra} \ave{\ux T}{x,y,z,t}
            -
            \frac{1}{l_x} \vat{\ave{T}{y,z,t}}{x=l_x}
            +
            \frac{1}{l_x} \vat{\ave{T}{y,z,t}}{x=  0}.
         \end{aligned}

      The left-hand-side is :math:`Nu` since :math:`Nu` is a constant.
      The second and third terms in the right-hand-side are :math:`-T_{L}` and :math:`T_{H}` respectively because of the boudnary conditions.
      Since :math:`T_{H} - T_{L} \equiv 1`, we finally have

      .. math::
         Nu
         =
         \sqrt{Pr} \sqrt{Ra} \ave{\ux T}{x,y,z,t} + 1.

#. Kinetic energy dissipation

   .. math::
      Nu
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_k}{V,t} + 1,

   where

   .. math::
      \ave{\epsilon_k}{V,t}
      =
      \ave{\epsilon_k}{x,y,z,t}
      =
      \frac{\sqrt{Pr}}{\sqrt{Ra}} \ave{\der{u_i}{x_j} \der{u_i}{x_j}}{x,y,z,t}

   is the volume-averaged kinematic dissipation rate.

   .. details:: Derivation

      By averaging the equation of the kinetic energy balance :math:`k` in time and space, we have

      .. math::
         \begin{aligned}
            \frac{1}{l_x} \left[ \ave{u_x \left( k + p \right)}{y,z,t} \right]_{x=0}^{x=l_x}
            & =
            \frac{\sqrt{Pr}}{\sqrt{Ra}} \left[ \ave{u_i \der{u_i}{x}}{y,z,t} \right]_{x=0}^{x=l_x} \\
            & -
            \frac{\sqrt{Pr}}{\sqrt{Ra}} \ave{\der{u_i}{x_j} \der{u_i}{x_j}}{x,y,z,t} \\
            & +
            \ave{u_x T}{x,y,z,t},
         \end{aligned}

      where terms including derivatives in homogeneous directions have already been eliminated using the periodicities.
      The left-hand-side vanishes because of the impermeable condition on the walls :math:`\vat{u_x}{x=0} = \vat{u_x}{x=l_x} \equiv 0`.
      Written explicitly, the first term in the right-hand-side is

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \left[ \ave{u_x \der{u_x}{x} + u_y \der{u_y}{x} + u_z \der{u_z}{x}}{y,z,t} \right]_{x=0}^{x=l_x}.

      The first term is always null since the walls are impermeable.
      Regarding the other terms, they also take null **as long as the walls are at rest**; otherwise they represents (generally) the energy injection by the driving force.
      The physical interpretation of this term is the transfer by diffusion, i.e., viscous stress transports the kinetic energy from the walls to the fluid (nothing else but the drag force) since they can be written as

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \left[ \ave{\der{k}{x}}{y,z,t} \right]_{x=0}^{x=l_x}.

      Since we assume the walls are fixed also in the homogeneous directions for now, they all vanish and we have

      .. math::
         \ave{u_x T}{x,y,z,t}
         =
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \ave{\der{u_i}{x_j} \der{u_i}{x_j}}{x,y,z,t}
         \equiv
         \ave{\epsilon_k}{x,y,z,t},

      indicating that the energy injection by the buoyancy is compensated for by the dissipation of the energy.
      By comparing with the relation of energy injection

      .. math::
         Nu
         =
         \sqrt{Pr} \sqrt{Ra} \ave{\ux T}{x,y,z,t} + 1,

      we immediately notice

      .. math::
         Nu
         =
         \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_k}{x,y,z,t} + 1.

#. Thermal energy dissipation

   .. math::
      Nu
      =
      \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_h}{V,t}.

   where

   .. math::
      \ave{\epsilon_h}{V,t}
      =
      \ave{\epsilon_h}{x,y,z,t}
      =
      \frac{1}{\sqrt{Pr} \sqrt{Ra}} \ave{\der{T}{x_i} \der{T}{x_i}}{x,y,z,t}

   is the volume-averaged thermal dissipation rate.

   .. details:: Derivation

      By averaging the equation of :math:`h = \frac{1}{2} T^2` in time and space, we have

      .. math::
         \frac{1}{l_x} \left[ \ave{u_x h}{y,z,t} \right]_{x=0}^{x=l_x}
         =
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left[ \ave{T \der{T}{x}}{y,z,t} \right]_{x=0}^{x=l_x}
         -
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \ave{\der{T}{x_i} \der{T}{x_i}}{x,y,z,t},

      The left-hand-side vanishes because of the impermeable condition on the walls :math:`\vat{u_x}{x=0} = \vat{u_x}{x=l_x} \equiv 0`.
      Mote explicit representation of the first term in the right-hand-side leads

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left[ \ave{T \der{T}{x}}{y,z,t} \right]_{x=0}^{x=l_x}.

      Although things inside brackets look non-linear, we can take out :math:`T` being constants on the walls thanks to the boundary conditions, i.e.,

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left(
              T_L \vat{\ave{\der{T}{x}}{y,z,t}}{x=l_x}
            - T_H \vat{\ave{\der{T}{x}}{y,z,t}}{x=  0}
         \right),

      which is, because of the definition of :math:`Nu`

      .. math::
         Nu
         =
         -\vat{\ave{\der{T}{x}}{y,z,t}}{x =   0}
         =
         -\vat{\ave{\der{T}{x}}{y,z,t}}{x = l_x},

      we deduce

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left( -T_L Nu + T_H Nu \right)
         =
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} Nu.

      It is readily apprent that we finally have

      .. math::
         \frac{1}{\sqrt{Pr}\sqrt{Ra}} Nu
         =
         \frac{1}{\sqrt{Pr}\sqrt{Ra}} \ave{\der{T}{x_i} \der{T}{x_i}}{x,y,z,t}
         \equiv
         \ave{\epsilon_h}{x,y,z,t}

      or

      .. math::
         Nu
         =
         \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_h}{x,y,z,t}.

.. note::

   Although pre-factors of the dissipation rates seem to be weird, they remain as they are considering their dimensional counterparts, e.g., *dimensional* kinematic dissipation rate:

   .. math::
      \ave{\epsilon_k}{x,y,z,t} = \nu \ave{\der{u_i}{x_j} \der{u_i}{x_j}}.

.. seealso::

   From a numerical point of view, it is non-trivial to satisfy these relations even after being discretised, which is extensively discussed in :ref:`the numerical method <numerics>`.


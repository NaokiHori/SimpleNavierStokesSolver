
.. _nusselt_number_relations:

########################
Nusselt number relations
########################

************
Introduction
************

In this part, we consider the discrete the counterpart of four Nusselt number relations which are derived in :ref:`the governing equations <governing_equations>`.

***********
Derivations
***********

.. note::

   #. Averaging in :math:`t`

      The following relations assume statistically-steady state, i.e., they hold after being averaged in time :math:`\ave{q}{t}`, which are dropped for notational convenience.

   #. Averaging in :math:`y`

   Averaging a quantity :math:`q` in :math:`y` direction is discretised (approximated) as

      .. math::
         \frac{1}{l_y} \sum_{j} q_j \Delta y.

      When :math:`q` is in a conservative form in :math:`y` direction (:math:`q \equiv \dder{q^{\prime}}{y}`), we have

      .. math::
         \frac{1}{l_y} \sum_{j} \dder{q^{\prime}}{y} \Delta y
         =
         0

      because of the periodicity in :math:`y` direction.

#. Heat flux

   .. math::
      Nu
      =
      \frac{1}{l_y}
      \sqrt{Pr} \sqrt{Ra}
      \sum_{j} \vat{
         \left(
            \ux
            \dintrpa{T}{x}
            \Delta y
         \right)
      }{\xic, \xjc}
      -
      \frac{1}{l_y}
      \sum_{j} \vat{
         \left(
            \dder{T}{x}
            \Delta y
         \right)
      }{\xic, \xjc},

   or on the walls

   .. math::
      Nu
      & =
      -\frac{1}{l_y} \sum_{j} \vat{\left( \dder{T}{x} \Delta y \right)}{\text{left  wall}, \xjc} \\
      & =
      -\frac{1}{l_y} \sum_{j} \vat{\left( \dder{T}{x} \Delta y \right)}{\text{right wall}, \xjc}.

   .. details:: Derivations

      We consider the discrete equation of the internal energy derived in :ref:`the thermal balance and quadratic quantity <thermal_energy_balance>`

      .. math::
         \der{T}{t}
         +
         \dder{
            \ux
            \dintrpa{T}{x}
         }{x}
         +
         \dder{
            \uy
            \dintrpa{T}{y}
         }{y}
         =
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
            \dder{}{x} \left( \dder{T}{x} \right)
            +
            \dder{}{y} \left( \dder{T}{y} \right)
         \right\},

      which is valid for all cell centers :math:`\left( \pic, \pjc \right)`.

      By averaging in :math:`y`, we have

      .. math::
         \frac{1}{l_y}
         \sum_{\pjc}
         \vat{
            \left[
               \left\{
                  \dder{
                     \ux
                     \dintrpa{T}{x}
                  }{x}
                  -
                  \frac{1}{\sqrt{Pr} \sqrt{Ra}}
                  \dder{}{x} \left( \dder{T}{x} \right)
               \right\}
               \Delta y
            \right]
         }{\pic, \pjc}
         =
         0,

      which is valid for all cell center in :math:`x` direction :math:`\left( \pic \right)`.

      Note that we drop the temporal derivative since we are interested in the statistically-averaged state, while we eliminate :math:`y` derivatives because of the periodicity.

      Now, we integrate this equation in :math:`x` direcion, from the left-most cell center (:math:`i^{\prime} = 1`) to a specific center (:math:`i^{\prime} = i`), i.e.,

      .. math::
         \frac{1}{l_y}
         \sum_{i^{\prime} = 1}^{\pic}
         \sum_{\pjc}
         \vat{
            \left[
               \left\{
                  \dder{
                     \ux
                     \dintrpa{T}{x}
                  }{x}
                  -
                  \frac{1}{\sqrt{Pr} \sqrt{Ra}}
                  \dder{}{x} \left( \dder{T}{x} \right)
               \right\}
               \Delta x_{i^{\prime}}
               \Delta y
            \right]
         }{i^{\prime}, \pjc}
         =
         0.

      Since all terms are in conservative forms with respect to :math:`x`, they are determined by the edge values:

      .. math::
         \sum_{i^{\prime} = 1}^{\pic}
         \vat{
            \left(
               \dder{q}{x}
               \Delta x
            \right)
         }{i^{\prime}}
         =
         \vat{q}{\xic}
         -
         \vat{q}{\text{left wall}},

      giving

      .. math::
         &
         \frac{1}{l_y}
         \sum_{\pjc}
         \vat{
            \left\{
               \left(
                  \ux
                  \dintrpa{T}{x}
                  -
                  \frac{1}{\sqrt{Pr} \sqrt{Ra}}
                  \dder{T}{x}
               \right)
               \Delta y
            \right\}
         }{\text{left wall}, \xjc} \\
         = &
         \frac{1}{l_y}
         \sum_{\pjc}
         \vat{
            \left\{
               \left(
                  \ux
                  \dintrpa{T}{x}
                  -
                  \frac{1}{\sqrt{Pr} \sqrt{Ra}}
                  \dder{T}{x}
               \right)
               \Delta y
            \right\}
         }{\xic, \xjc},

      or equivalently

      .. math::
         &
         -\frac{1}{l_y}
         \sum_{\pjc}
         \vat{
            \left(
               \dder{T}{x}
               \Delta y
            \right)
         }{\text{left wall}, \xjc} \\
         = &
         \frac{1}{l_y}
         \sum_{\pjc}
         \vat{
            \left\{
               \left(
                  \sqrt{Pr} \sqrt{Ra}
                  \ux
                  \dintrpa{T}{x}
                  -
                  \dder{T}{x}
               \right)
               \Delta y
            \right\}
         }{\xic, \xjc},

      where the impermeability of the wall (:math:`\ux \equiv 0`) is used to eliminate the advective term on the wall.

      Since the left-hand-side is *definition* of the discrete heat flux, we obtain

      .. math::
         Nu
         =
         \frac{1}{l_y}
         \sqrt{Pr} \sqrt{Ra}
         \sum_{j} \vat{
            \left(
               \ux
               \dintrpa{T}{x}
               \Delta y
            \right)
         }{\xic, \xjc}
         -
         \frac{1}{l_y}
         \sum_{j} \vat{
            \left(
               \dder{T}{x}
               \Delta y
            \right)
         }{\xic, \xjc},

      where the right-hand-side is valid for all :math:`x` cell faces.

      .. note::

         This relation is **only** valid where :math:`\ux` are defined; in other words, this :math:`Nu` constancy is not guaranteed for other locations such as cell centers.

#. Energy injection

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
      1.

   .. details:: Derivations

      We consider to further average the equation of the heat flux throughout the bulk (from the left to the right walls):

      .. math::
         \frac{1}{l_x}
         \sum_i
         \vat{
            \left(
               Nu
               \Delta x
            \right)
         }{\xic}
         & =
         \frac{1}{l_x l_y}
         \sqrt{Pr} \sqrt{Ra}
         \sum_{i} \sum_{j} \vat{
            \left(
               \ux
               \dintrpa{T}{x}
               \Delta x
               \Delta y
            \right)
         }{\xic, \xjc} \\
         & -
         \frac{1}{l_x l_y}
         \sum_{i} \sum_{j} \vat{
            \left(
               \dder{T}{x}
               \Delta x
               \Delta y
            \right)
         }{\xic, \xjc},

      The left-hand-side yields :math:`Nu` since it is readily apparent that

      .. math::
         \frac{1}{l_x} \sum_{i} \vat{\Delta x}{\xic} = 1,

      and the integrand :math:`Nu` is a constant value.

      The diffusive term in the right-hand-side leads

      .. math::
         -\frac{1}{l_x l_y}
         \sum_{j} \vat{
            \left(
               \vat{T}{\text{right wall}}
               \Delta y
               -
               \vat{T}{\text{left wall}}
               \Delta y
            \right)
         }{\xjc}
         =
         \frac{\Delta T}{l_x}
         \frac{1}{l_y}
         \sum_{j} \vat{\Delta y}{j}
         \equiv
         1,

      because of the configurations (see :ref:`the governing equations <governing_equations>`).

      Thus we obtain

      .. math::
         Nu
         =
         \frac{1}{l_x l_y}
         \sqrt{Pr} \sqrt{Ra}
         \sum_{i} \sum_{j} \vat{
            \left(
               \ux
               \dintrpa{T}{x}
               \Delta x
               \Delta y
            \right)
         }{\xic, \xjc}
         +
         1.

#. Kinetic energy dissipation

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

   where :math:`s_{ij} s_{ij}` are the discrete form of :math:`\der{u_i}{x_j} \der{u_i}{x_j}` (see :ref:`the momentum balance and quadratic quantity <momentum_balance>`).

   Also the explicit form of the forcing term in the momentum equation :math:`\ux \dintrpu{T}{x}` is concluded to be :math:`\ux \dintrpa{T}{x}`.

   .. details:: Derivations

      As being discussed in :ref:`the momentum balance and quadratic quantity <momentum_balance>`, we have

      .. math::
         &
         \sum_{i} \sum_{j}
         \vat{
            \left[
               \left\{
                  -
                  \frac{\sqrt{Pr}}{\sqrt{Ra}} \left(
                     s_{xx} s_{xx}
                     +
                     s_{xy} s_{xy}
                  \right)
                  +
                  \ux \dintrpu{T}{x}
               \right\}
               \Delta x \Delta y
            \right]
         }{\xic, \xjc} \\
         + &
         \sum_{i} \sum_{j}
         \vat{
            \left[
               \left\{
                  -
                  \frac{\sqrt{Pr}}{\sqrt{Ra}} \left(
                     s_{yx} s_{yx}
                     +
                     s_{yy} s_{yy}
                  \right)
               \right\}
               \Delta x \Delta y
            \right]
         }{\yic, \yjc}

      regarding the balance of the kinetic energy.

      Notice that the physical interpretation of this equation is that the energy injection by the buoyancy force (volume integral of :math:`\ux \dintrpu{T}{x}`) is balanced by the dissipation of kinetic energy (:math:`s_{ij} s_{ij}`).
      We aim to mimic this relation in our discrete system.

      As shown above, from the equation of thermal energy, the *local* energy injection is given as :math:`\ux \dintrpa{T}{x}`, which should be identical to the forcing term in the momentum equation :math:`\ux \dintrpu{T}{x}`, concluding that **the interpolation of temperature in the forcing term should be** :math:`\dintrpa{T}{x}`.

      Since we have

      .. math::
         \sum_{i} \sum_{j}
         \vat{
            \left(
               \ux
               \dintrpa{T}{x}
               \Delta x \Delta y
            \right)
         }{\xic, \xjc}
         & =
         \sum_{i} \sum_{j}
         \vat{
            \left[
               \left\{
                  \frac{\sqrt{Pr}}{\sqrt{Ra}} \left(
                     s_{xx} s_{xx}
                     +
                     s_{xy} s_{xy}
                  \right)
               \right\}
               \Delta x \Delta y
            \right]
         }{\xic, \xjc} \\
         & +
         \sum_{i} \sum_{j}
         \vat{
            \left[
               \left\{
                  \frac{\sqrt{Pr}}{\sqrt{Ra}} \left(
                     s_{yx} s_{yx}
                     +
                     s_{yy} s_{yy}
                  \right)
               \right\}
               \Delta x \Delta y
            \right]
         }{\yic, \yjc},

      we replace the volume integral in the Nusselt relation of the energy injection by the kinetic energy dissipation, giving

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
         1.

#. Thermal energy dissipation

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

   where :math:`r_i r_i` are the discrete form of :math:`\der{T}{x_i} \der{T}{x_i}` (see :ref:`the thermal energy balance and quadratic quantity <thermal_energy_balance>`).

   .. details:: Derivations

      As being discussed in :ref:`the thermal energy balance and quadratic quantity <thermal_energy_balance>`, we have

      .. math::
         &
         \frac{1}{l_y}
         \sum_{j}
         \vat{
            \left\{
               \frac{1}{\sqrt{Pr} \sqrt{Ra}}
               \left[ T \dder{T}{x} \right]_{\text{left wall}}^{\text{right wall}}
               \Delta y
            \right\}
         }{\pjc} \\
         & =
         \frac{1}{l_x l_y}
         \sum_{i} \sum_{j}
         \vat{
            \left\{
               \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left(
                  r_x r_x
                  +
                  r_y r_y
               \right)
               \Delta x
               \Delta y
            \right\}
         }{\pic, \pjc}

      regarding the balance of :math:`h`.
      The left-hand-side leads

      .. math::
         &
         \frac{1}{l_y}
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \sum_{j}
         \vat{
            \left\{
               \left(
                  \vat{T}{\text{right wall}}
                  \vat{\dder{T}{x}}{\text{right wall}}
                  -
                  \vat{T}{\text{left wall}}
                  \vat{\dder{T}{x}}{\text{left wall}}
               \right)
               \Delta y
            \right\}
         }{\pjc} \\
         = &
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \vat{T}{\text{right wall}}
         \frac{1}{l_y}
         \sum_{j}
         \vat{
            \left\{
               \left(
                  \vat{\dder{T}{x}}{\text{right wall}}
               \right)
               \Delta y
            \right\}
         }{\pjc} \\
         - &
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \vat{T}{\text{left wall}}
         \frac{1}{l_y}
         \sum_{j}
         \vat{
            \left\{
               \left(
                  \vat{\dder{T}{x}}{\text{left wall}}
               \right)
               \Delta y
            \right\}
         }{\pjc} \\
         = &
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \left(
            -T_{\text{right wall}}
            +T_{\text{left  wall}}
         \right)
         Nu
         =
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         Nu

      using the relation of the heat flux, and thus we obtain

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
         }{\pic, \pjc}.

.. seealso::

   These relations are used to monitor the simulations, which are implemented in :ref:`check_nusselt in src/logging.c <logging_check_nusselt>`.


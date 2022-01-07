
.. include:: /references.txt

.. _smac_method:

###################################################
Integrating mass and momentum balances: SMAC method
###################################################

********************************
First-order accurate SMAC method
********************************

When we aim to integrate :ref:`the mass and momentum balances <governing_equations>` in time, we might notice two non-trivial problems:

#. How to enforce the continuity while integrating the momentum equation?
#. How to couple the pressure, which seems to be independent of time?

An elegant idea to solve these problems at once is the Simplified Marker And Cell (SMAC) method (|AMSDEN1970|).
This method naively integrates the momentum equation to update the velocity in the first step, which is followed by a correction step in which the updated velocity is modified so that the incompressibility is satisfied.

By introducing an intermediate velocity :math:`u_i^*`, we can write this idea as

.. math::
   \text{prediction step :} \,\,
   & \frac{u_i^*-u_i^n}{\Delta t}
   =
   -\dder{u_j^n u_i^n}{x_j}
   -\frac{\delta p^n}{\delta x_i}
   +\frac{1}{Re} \frac{\delta^2 u_i^n}{\delta x_j \delta x_j}, \\
   \text{correction step :} \,\,
   & \frac{u_i^{n+1}-u_i^*}{\Delta t}
   =
   -\dder{\psi}{x_i},

where :math:`\psi` is an unknown scalar potential, and :math:`Re` is the Reynolds number satisfying :math:`1/Re = \sqrt{Pr/Ra}`.
Hereafter we use the notations :math:`\left\{ \cdot \right\}^n` and :math:`\left\{ \cdot \right\}^{n+1}` to represent that the quantity :math:`\left\{ \cdot \right\}` is before and after being updated, respectively.
Note that notations :math:`\delta / \delta x_i` are used, which indicate the discrete spatial derivatives (namely differentiations, see :ref:`spatial discretisation <spatial_discretisation>`).

We would like to impose the incompressibility constraint on the new velocity :math:`u_i^{n+1}`, i.e., we request

.. math::
   \dder{u_i^{n+1}}{x_i} = 0.

Thus, by taking the divergence of the correction step, we find

.. math::
   \frac{\delta^2 \psi}{\delta x_i \delta x_i}
   =
   \frac{1}{\Delta t} \dder{u_i^*}{x_i}.

Also, by adding the prediction and correction steps, we have

.. math::
   \frac{u_i^{n+1}-u_i^n}{\Delta t}
   =
   -\dder{u_j^n u_i^n}{x_j}
   -\frac{\delta \left( p^n + \psi \right)}{\delta x_i}
   +\frac{1}{Re} \frac{\delta^2 u_i^n}{\delta x_j \delta x_j}.

By adopting the Euler-implicit scheme to evolve the pressure gradient term, we have

.. math::
   \frac{u_i^{n+1} - u_i^n}{\Delta t}
   =
   -\frac{\delta u_j^n u_i^n}{\delta x_j}
   -\frac{\delta p^{n+1}}{\delta x_i}
   +\frac{1}{Re} \frac{\delta^2 u_i^n}{\delta x_j \delta x_j},

and we notice :math:`\psi = p^{n+1} - p^n`.

In summary, a scheme to integrate the momentum equation under the incompressibility constraint leads

.. math::
   & \frac{u_i^*     - u_i^n}{\Delta t} = -\frac{\delta u_j^n u_i^n}{\delta x_j} - \frac{\delta p^n}{\delta x_i} + \frac{1}{Re} \frac{\delta^2 u_i^n}{\delta x_j \delta x_j}, \\
   & \frac{\delta^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\Delta t} \frac{\delta u_i^*}{\delta x_i}, \\
   & \frac{u_i^{n+1} - u_i^*}{\Delta t} = -\frac{\delta \psi}{\delta x_i}, \\
   & p^{n+1} = p^n + \psi,

where the pressure is a scalar potential which imposes the incompressibility constraint, rather than a quantity which has a physical meaning (|KAJISHIMA1999|).

.. note::

   :math:`\Delta t` should be so small that **no** information which is treated explicitly propagates longer distance than the local grid size.
   Since we assume the fluid to be incompressible, the propagation speed of the pressure wave is infinity, enforcing :math:`\Delta t = 0`.
   In order to avoid this problem, it is essential to treat the pressure implicitly.

*********************************
Second-order accurate SMAC method
*********************************

Finally, we consider to improve the original SMAC method.
When the diffusive terms are treated explicitly, the extension is straightforward (shown at the end of this section).
When they are treated implicitly, we need to slightly modify the definition of the scalar potential :math:`\psi`.
First, we consider to apply the Crank-Nicolson scheme to the diffusive term, while the Euler explicit and implicit schemes are used to the advective and pressure-gradient terms respectively for convenience:

.. math::
   \frac{u_i^{n+1} - u_i^n}{\Delta t}
   =
   -\frac{\delta p^{n+1}}{\delta x_i}
   -\frac{\delta u_i^n u_j^n}{\delta x_j}
   +\frac{1}{2 Re} \left( \frac{\delta^2 u_i^{n+1}}{\delta x_j \delta x_j}
   +\frac{\delta^2 u_i^n}{\delta x_j \delta x_j} \right).

Following the idea of the SMAC method, we split this equation as

.. math::
   \frac{u_i^* - u_i^n}{\Delta t} &= - \frac{\delta p^n}{\delta x_i} - \frac{\delta u_i^n u_j^n}{\delta x_j} + \frac{1}{2 Re} \left( \frac{\delta^2 u_i^*}{\delta x_j \delta x_j} + \frac{\delta^2 u_i^n}{\delta x_j \delta x_j} \right), \\
   \frac{u_i^{n+1} - u_i^*}{\Delta t} &= - \frac{\delta \psi}{\delta x_i}.

Note that the intermediate velocity :math:`u_i^*` is used instead at the prediction level since :math:`u_i^{n+1}` is unknown for now.
Eliminating :math:`u_i^*` leads

.. math::
   \frac{u_i^{n+1} - u_i^n}{\Delta t}
   &= - \frac{\delta p^n}{\delta x_i} - \frac{\delta \psi}{\delta x_i} - \frac{\delta u_i^n u_j^n}{\delta x_j} \\
   &+ \frac{1}{2 Re} \left\{ \frac{\delta^2 u_i^{n+1}}{\delta x_j \delta x_j} + \frac{\delta^2 u_i^n}{\delta x_j \delta x_j} + \Delta t \frac{\delta^2}{\delta x_j \delta x_j} \left( \frac{\delta \psi}{\delta x_i} \right) \right\},

and thus we find the relation of the pressure and the scalar potential as

.. math::
   \frac{\delta p^{n+1}}{\delta x_i}
   =\frac{\delta p^n}{\delta x_i}
   +\frac{\delta \psi}{\delta x_i}
   -\frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x_j \delta x_j} \left( \frac{\delta \psi}{\delta x_i} \right).

When we adopt the central differences for spatial discretisations, the Laplace operator :math:`\delta^2 / \delta x_j \delta x_j` and the divergence operator :math:`\delta / \delta x_i` are commutable, and we can simplify the relation as

.. math::
   p^{n+1} = p^n + \psi - \frac{\Delta t}{2 Re} \frac{\delta^2 \psi}{\delta x_j \delta x_j}.

Thus we conclude

.. math::
   \frac{u_i^* - u_i^n}{\Delta t} &= - \frac{\delta p^n}{\delta x_i} - \frac{\delta u_i^n u_j^n}{\delta x_j} + \frac{1}{2 Re} \left( \frac{\delta^2 u_i^*}{\delta x_j \delta x_j} + \frac{\delta^2 u_i^n}{\delta x_j \delta x_j} \right), \\
   \frac{\delta^2 \psi}{\delta x_i \delta x_i} &= \frac{1}{\Delta t} \frac{\delta u_i^*}{\delta x_i}, \\
   p^{n+1} &= p^n + \psi - \frac{\Delta t}{2 Re} \frac{\delta^2 \psi}{\delta x_j \delta x_j}, \\
   \frac{u_i^{n+1} - u_i^*}{\Delta t} &= - \frac{\delta \psi}{\delta x_i}.

As the prediction step, we need to solve Helmholtz equations:

.. math::
   \left( 1 - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x_j \delta x_j} \right) u_i^*
   =
   -\frac{\delta p^n}{\delta x_i} \Delta t
   -\frac{\delta u_i^n u_j^n}{\delta x_j} \Delta t
   +\left( 1 + \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x_j \delta x_j} \right) u_i^n,

which can be done using FFT-based Helmholtz solver (see :ref:`src/fluid_compute_potential.c <fluid_compute_potential>`, where a Poisson equation is solved using a similar procedure).

This equation, however, can be further simplified as follows.
First, we re-write the equation in the so-called delta form:

.. math::
   \left( 1 - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x_j \delta x_j} \right) \left( u_i^* - u_i^n \right)
   =
   -\frac{\delta p^n}{\delta x_i} \Delta t
   -\frac{\delta u_i^n u_j^n}{\delta x_j} \Delta t
   +\frac{\Delta t}{Re} \frac{\delta^2}{\delta x_j \delta x_j} u_i^n,

where the left-hand-side can be approximated as

.. math::
   \left( 1 - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x_j \delta x_j} \right) \left( u_i^* - u_i^n \right)
   & = \left( 1 - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x \delta x} - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta y \delta y} \right) \left( u_i^* - u_i^n \right) \\
   & \approx \left( 1 - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta x \delta x} \right) \left( 1 - \frac{\Delta t}{2 Re} \frac{\delta^2}{\delta y \delta y} \right) \left( u_i^* - u_i^n \right),

whose error is

.. math::
   \left( \frac{\Delta t^2}{4 Re^2} \right) \frac{\delta^2}{\delta x \delta x} \frac{\delta^2}{\delta y \delta y} \left( u_i^* - u_i^n \right)
   = \mathcal{O} \left( \Delta t^3 \right)

assuming :math:`u_i^* - u_i^n = \mathcal{O} \left( \Delta t \right)`.
Note that this approximation (so-called factorisation) is only valid when the delta form is adopted.

Now we find we can convert the original Helmholtz equation to a linear system, which can be solved by `the tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_.

.. _result_runge_kutta:

In summary, when the diffusive terms are treated explicitly,

.. math::
   &\text{do}\,\,\,\, k = 0, 2 \\
   &\,\,\,\,u_i^* = u_i^k + \left\{ \alpha^k \left( A_i^k + D_i^k \right) + \beta^k \left( A_i^{k-1} + D_i^{k-1} \right) + \gamma^k P_i^k \right\} \Delta t, \\
   &\,\,\,\,\frac{\delta ^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\gamma^k \Delta t} \frac{\delta u_i^*}{\delta x_i}, \\
   &\,\,\,\,u_i^{k+1} = u_i^* - \gamma^k \Delta t \frac{\delta \psi}{\delta x_i}, \\
   &\,\,\,\,p^{k+1} = p^k + \psi, \\
   &\text{enddo}

When the diffusive terms are treated implicitly,

.. math::
   &\text{do}\,\,\,\, k = 0, 2 \\
   &\,\,\,\,\delta u_i = \left\{ \alpha^k A_i^k + \beta^k A_i^{k-1} + \gamma^k \left( P_i^k + D_i^k \right) \right\} \Delta t, \\
   &\,\,\,\,u_i^* = u_i^k + \left( 1 - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2}{\delta y^2} \right)^{-1} \left( 1 - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta u_i, \\
   &\,\,\,\,\frac{\delta^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\gamma^k \Delta t} \frac{\delta u_i^*}{\delta x_i}, \\
   &\,\,\,\,u_i^{k+1} = u_i^* - \gamma^k \Delta t \frac{\delta \psi}{\delta x_i}, \\
   &\,\,\,\,p^{n+1} = p^n + \psi - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2 \psi}{\delta x_j \delta x_j}, \\
   &\text{enddo}

Sometimes only one direction is treated implicitly whilst the other direction adopts an explicit treatment (see :ref:`param/estimate_cost.c <param_estimate_cost>` and :ref:`param/decide_dt.c <param_decide_dt>`).
For instance, when only :math:`x` direction is treated implicitly, we have

.. math::
   &\text{do}\,\,\,\, k = 0, 2 \\
   &\,\,\,\,\delta u_i = \left\{ \alpha^k \left( A_i^k + \frac{1}{Re} \frac{\delta^2 u_i^k}{\delta y^2} \right) + \beta^k \left( A_i^{k-1} + \frac{1}{Re} \frac{\delta^2 u_i^{k-1}}{\delta y^2} \right) + \gamma^k \left( P_i^k + \frac{1}{Re} \frac{\delta^2 u_i^k}{\delta x^2} \right) \right\} \Delta t, \\
   &\,\,\,\,u_i^* = u_i^k + \left( 1 - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta u_i, \\
   &\,\,\,\,\frac{\delta^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\gamma^k \Delta t} \frac{\delta u_i^*}{\delta x_i}, \\
   &\,\,\,\,u_i^{k+1} = u_i^* - \gamma^k \Delta t \frac{\delta \psi}{\delta x_i}, \\
   &\,\,\,\,p^{n+1} = p^n + \psi - \frac{\gamma^k \Delta t}{2 Re} \frac{\delta^2 \psi}{\delta x^2}, \\
   &\text{enddo}

where

.. math::
   A_i^k \equiv -\frac{\delta u_j^k u_i^k}{\delta x_j},

(A: advection),

.. math::
   D_i^k \equiv \frac{1}{Re} \frac{\delta^2 u_i^k}{\delta x_j \delta x_j},

(D: diffusion), and

.. math::
   P_i^k \equiv -\frac{\delta p^k}{\delta x_i},

(P: pressure).
Note that the accuracy of the pressure-gradient term is first-order in time.


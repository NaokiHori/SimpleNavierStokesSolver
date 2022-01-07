
.. _temperature_integration:

####################################
Integrating internal energy equation
####################################

The governing equation (advection-diffusion equation) of a scalar quantity :math:`T` (e.g., temperature) in non-dimensional form leads

.. math::
   \frac{\partial T}{\partial t} + \frac{\partial u_j T}{\partial x_j} = \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\partial^2 T}{\partial x_j \partial x_j}.

Since there are no additional constraints, predictor-corrector-like treatments are not necessary to integrate this equation in time, and thus a simple Runge-Kutta method is adopted:

.. math::
  \begin{aligned}
    &\text{do}\,\,\,\, k = 0, 2 \\
    &\,\,\,\,\delta T = \left\{ \alpha^k \left( A^k + D^k \right) + \beta^k \left( A^{k-1} + D^{k-1} \right) \right\} \Delta t, \\
    &\,\,\,\,T^{k+1} = T^k + \delta T, \\
    &\text{enddo}
  \end{aligned}

when the diffusive terms are treated explicitly, while

.. math::
  \begin{aligned}
    &\text{do}\,\,\,\, k = 0, 2 \\
    &\,\,\,\,\delta T = \left\{ \alpha^k A^k + \beta^k A^{k-1} + \gamma^k D^k \right\} \Delta t, \\
    &\,\,\,\,T^{k+1} = T^k + \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta T, \\
    &\text{enddo}
  \end{aligned}

when the diffusive terms are treated implicitly.

Sometimes only one direction is treated implicitly whilst the other direction adopts an explicit treatment (see :ref:`param/estimate_cost.c <param_estimate_cost>` and :ref:`param/decide_dt.c <param_decide_dt>`).
For instance, when only :math:`x` direction is treated implicitly, we have

.. math::
  \begin{aligned}
    &\text{do}\,\,\,\, k = 0, 2 \\
    &\,\,\,\,\delta T = \left\{ \alpha^k \left( A^k + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\delta^2 T^k}{\delta y^2} \right) + \beta^k \left( A^{k-1} + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\delta^2 T^{k-1}}{\delta y^2} \right) + \gamma^k \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\delta^2 T^{k-1}}{\delta x^2} \right\} \Delta t, \\
    &\,\,\,\,T^{k+1} = T^k + \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta T. \\
    &\text{enddo}
  \end{aligned}

The capital variables are defined as follows:

.. math::
    A^k \equiv -\frac{\delta u_j^k T^k}{\delta x_j},

(A: advection), and

.. math::
    D^k \equiv \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\delta^2 T^k}{\delta x_j \delta x_j},

(D: diffusion).


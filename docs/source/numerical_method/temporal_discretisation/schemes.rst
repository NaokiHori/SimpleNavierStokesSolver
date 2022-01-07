
.. _schemes:

.. include:: /references.txt

##########################################
Appendix: Schemes for temporal integration
##########################################

We consider an ordinary differential equation

.. math::
  \frac{d f}{d t} = g,

whose Taylor-series expansion around :math:`f^n` is

.. math::
  f^{n+1} =
   f^n
   + \frac{df^n}{dt} \Delta t
   + \frac{1}{2} \frac{d^2f^n}{dt^2} \left( \Delta t \right)^2
   + \frac{1}{6} \frac{d^3f^n}{dt^3} \left( \Delta t \right)^3
   + \mathcal{O} \left( \Delta t^4 \right),

and thus

.. math::
  \frac{f^{n+1} - f^n}{\Delta t} =
   \frac{df^n}{dt}
   + \frac{1}{2} \frac{d^2f^n}{dt^2} \Delta t
   + \frac{1}{6} \frac{d^3f^n}{dt^3} \left( \Delta t \right)^2
   + \mathcal{O} \left( \Delta t^3 \right).

*********************
Euler explicit scheme
*********************

The simplest scheme would be the first-order Euler explicit scheme

.. math::
  \frac{f^{n+1} - f^n}{\Delta t} = \frac{df^n}{dt} = g^n,

whose deviation from the Taylor series is

.. math::
   \frac{1}{2} \frac{d^2f^n}{dt^2} \Delta t
   = \mathcal{O} \left( \Delta t \right),

i.e., first-order accuracy in time.
By expanding :math:`f` around :math:`t + \Delta t`, we notice that the Euler implicit scheme also has first-order accuracy in time.

***************************
Explicit Runge-Kutta scheme
***************************

In order to increase the stability and accuracy, we adopt an explicit three-step Runge-Kutta scheme:

.. math::
  \begin{aligned}
    &\text{do}\,\,\,\, k = 0, 2 \\
    &\,\,\,\,\frac{f^{k+1} - f^k}{\Delta t} = \alpha^k g^k + \beta^k g^{k-1}, \\
    &\text{enddo}
  \end{aligned}

where :math:`\left( \alpha^0, \alpha^1, \alpha^2 \right) = \left( 32/60, 25/60, 45/60 \right)` and :math:`\left( \beta^0, \beta^1, \beta^2 \right) = \left( 0, -17/60, -25/60 \right)` (e.g., |VERZICCO1996|).
Note that :math:`f^{k=0}` and :math:`f^{k=3}` correspond to :math:`f^n` and :math:`f^{n+1}`, respectively.

Since we have

.. math::
  f^{k+1} = f^k + \alpha^k g^k \Delta t + \beta^k g^{k-1} \Delta t,

the relation

.. math::
  g^{k+1} = \frac{df^{k+1}}{dt} = \frac{df^k}{dt} + \alpha^k \frac{d^2f^k}{dt^2} \Delta t + \beta^k \frac{d^2f^{k-1}}{dt^2} \Delta t

holds.

By using this relation repeatedly, we have

.. math::
  \begin{aligned}
    f^1 &= f^n + \alpha^0 g^n \Delta t \\
        &= f^n + \alpha^0 \frac{df^n}{dt} \Delta t, \\
    g^1 &= \frac{df^n}{dt} + \alpha^0 \frac{d^2f^n}{dt^2} \Delta t, \\
    f^2 &= f^1 + \alpha^1 g^1 \Delta t + \beta^1 g^0 \Delta t \\
        &= f^n + \alpha^0 \frac{df^n}{dt} \Delta t + \alpha^1 \left( \frac{df^n}{dt} + \alpha^0 \frac{d^2f^n}{dt^2} \Delta t \right) \Delta t + \beta^1 \frac{df^n}{dt} \Delta t, \\
        &= f^n + \left( \alpha^0 + \alpha^1 + \beta^1 \right) \frac{df^n}{dt} \Delta t + \alpha^0 \alpha^1 \frac{d^2f^n}{dt^2} \Delta t^2, \\
    g^2 &= \frac{df^n}{dt} + \left( \alpha^0 + \alpha^1 + \beta^1 \right) \frac{d^2f^n}{dt^2} \Delta t + \alpha^0 \alpha^1 \frac{d^3f^n}{dt^3} \Delta t^2, \\
    f^3 &= f^{n+1} \\
        &= f^2 + \alpha^2 g^2 \Delta t + \beta^2 g^1 \Delta t \\
        &= f^n + \left( \alpha^0 + \alpha^1 + \beta^1 \right) \frac{df^n}{dt} \Delta t + \alpha^0 \alpha^1 \frac{d^2f^n}{dt^2} \Delta t^2 \\
        &+ \alpha^2 \left( \frac{df^n}{dt} + \left( \alpha^0 + \alpha^1 + \beta^1 \right) \frac{d^2f^n}{dt^2} \Delta t + \alpha^0 \alpha^1 \frac{d^3f^n}{dt^3} \Delta t^2 \right) \Delta t \\
        &+ \beta^2 \left( \frac{df^n}{dt} + \alpha^0 \frac{d^2f^n}{dt^2} \Delta t \right) \Delta t, \\
        &= f^n + \left( \alpha^0 + \alpha^1 + \beta^1 + \alpha^2 + \beta^2 \right) \frac{df^n}{dt} \Delta t \\
        &+ \left( \alpha^0 \alpha^1 + \alpha^0 \alpha^2 + \alpha^1 \alpha^2 + \alpha^2 \beta^1 + \alpha^0 \beta^2 \right) \frac{d^2f^n}{dt^2} \Delta t^2 \\
        &+ \mathcal{O} \left( \Delta t^3 \right) \\
        &= f^n + \frac{df^n}{dt} \Delta t + \frac{1}{2} \frac{d^2f^n}{dt^2} \Delta t^2 + \mathcal{O} \left( \Delta t^3 \right),
  \end{aligned}

i.e.,

.. math::
   \frac{f^{n+1} - f^n}{\Delta t} = \frac{df^n}{dt} + \frac{1}{2} \frac{d^2f^n}{dt^2} \Delta t + \mathcal{O} \left( \Delta t^2 \right),

and thus we find that this scheme has second-order accuracy in time.
Note that the superscripts :math:`\alpha` and :math:`\beta` are not the exponents but sub-steps of the Runge-Kutta iterations.

*********************
Crank-Nicolson scheme
*********************

Sometimes implicit treatment is desired to stabilise the integration, where Crank-Nicolson scheme:

.. math::
  \frac{f^{n+1} - f^n}{\Delta t} = \frac{1}{2} \left( g^{n+1} + g^n \right)

is the most famous choice.

By using the relation

.. math::
  g^{n+1} = \frac{df^{n+1}}{dt} = \frac{df^n}{dt} + \frac{d^2f^n}{dt^2} \Delta t + \frac{1}{2} \frac{d^3f^n}{dt^3} \Delta t^2 + \mathcal{O} \left( \Delta t^3 \right),

we have

.. math::
  \begin{aligned}
    f^{n+1}
    &= f^n + \frac{1}{2} \left( \frac{df^n}{dt} + \frac{d^2f^n}{dt^2} \Delta t + \frac{1}{2} \frac{d^3f^n}{dt^3} \Delta t^2 + \frac{df^n}{dt} \right) \Delta t \\
    &= f^n + \frac{df^n}{dt} \Delta t + \frac{1}{2} \frac{d^2f^n}{dt^2} \Delta t^2 + \mathcal{O} \left( \Delta t^3 \right),
  \end{aligned}

which indicates that Crank-Nicolson scheme also has second-order accuracy in time.

********************************
Semi-implicit Runge-Kutta scheme
********************************

Runge-Kutta and Crank-Nicolson schemes can be mixed, which leads

.. math::
  \begin{aligned}
    &\text{do}\,\,\,\, k = 0, 2 \\
    &\,\,\,\,\frac{f^{k+1} - f^k}{\Delta t} = \frac{\gamma^k}{2} \left( g^{k+1} + g^k \right), \\
    &\text{enddo}
  \end{aligned}

where :math:`\gamma^k = \alpha^k + \beta^k`, i.e., :math:`\left( \gamma^0, \gamma^1, \gamma^2 \right) = \left( 32/60, 8/60, 20/60 \right)`.
By summing up all three equations, we have

.. math::
  \frac{f^{n+1} - f^n}{\Delta t} = \frac{\gamma^0 + \gamma^1 + \gamma^2}{2} \left( g^{n+1} + g^n \right).

Since :math:`\sum_k \gamma^k = 1`, we notice that this equation recovers the original Crank-Nicolson scheme and thus has second-order accuracy in time again.


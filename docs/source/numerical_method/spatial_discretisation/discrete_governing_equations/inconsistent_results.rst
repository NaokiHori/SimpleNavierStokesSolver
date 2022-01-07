
.. _inconsistent_results:

.. include:: /references.txt

####################
Inconsistent results
####################

In the previous parts, we extensively derive schemes for

#. the advective terms to conserve discrete momenta and quadratic quantities,

#. the diffusive terms to dissipate the transported quantities properly.

One might be tempted to know whether these rigorous formulations are really necessary.
In this part, we aim to answer this question by quantifying the effects through some examples.

*******************************************************
1. Treatment of advective terms - linear interpolations
*******************************************************

==========
Conclusion
==========

Advective terms inject artificial energy, which breaks physics and tends to destabilise the solver.
The error never shrinks even when we make :math:`\Delta t` smaller.

=======
Example
=======

.. details:: Details

   When we interpolate a quantity from the neighbouring two points, linear interpolations generally give the most *accurate* results according the Taylor series expansion.

   Here, instead of thee energy conserving schemes, we adopt the following discrete governing equations:

   .. math::
      \der{\ux}{t}
      +
      \dder{
         \dintrpa{\ux}{x}
         \dintrpa{\ux}{x}
      }{x}
      +
      \dder{
         \color{red}{\dintrpv{\uy}{x}}
         \dintrpa{\ux}{y}
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
      \color{red}{\dintrpa{T}{x}},

   .. math::
      \der{\uy}{t}
      +
      \dder{
         \dintrpa{\ux}{y}
         \color{red}{\dintrpa{\uy}{x}}
      }{x}
      +
      \dder{
         \dintrpa{\uy}{y}
         \dintrpa{\uy}{y}
      }{y}
      =
      -\dder{p}{y}
      +
      \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
         \dder{}{x} \left( \dder{\uy}{x} \right)
         +
         \dder{}{y} \left( \dder{\uy}{y} \right)
      \right\},

   .. math::
      \der{T}{t}
      +
      \dder{
         \ux
         \color{red}{\dintrpa{T}{x}}
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

   where the reddish terms are replaced by linear interpolations since they are all affected by non-uniform grid spacings.

   Here is the main part of the configuration.

   .. code-block:: sh

      #!/bin/bash

      export with_temperature=true
      export with_thermal_forcing=false
      export lx=1.0e+0
      export ly=2.0e+0
      export itot=32
      export jtot=64
      export stretch=3
      export Ra=1.0e+100
      export Pr=1.0e+0

   Note that the velocity and temperature fields are randomly disturbed initially (by modifying :ref:`src/fluid/init.c <fluid_init>` and :ref:`src/temperature/init.c <temperature_init>`).
   Also the time step size is fixed to :math:`\Delta t = 10^{-2}`.

   We monitor the changes in the volume-integrated quadratic quantities :math:`K` and :math:`H` for two types of schemes:

   .. image:: images/adv_energy.pdf
      :width: 800

   One might be tempted to investigate the effects of the time step size :math:`\Delta t`.
   To check the dependence, we vary :math:`\Delta t` to see the convergence of the errors

   .. math::
      \epsilon_{k} \equiv \left| \frac{K_{t = 10}- K_0}{K_0} \right|, \\
      \epsilon_{h} \equiv \left| \frac{H_{t = 10}- H_0}{H_0} \right|.

   The results are shown here

   .. image:: images/adv_convergence.pdf
      :width: 800

   We notice that the energy-conserving scheme shows third-order convergence, which is consistent with the previous reports (see e.g. |MORINISHI1998|, |HAM2002| and |COPPOLA2019|; in short, the decrease is because of the temporal integration, not of the spatial treatments).
   It should be noted that the total energies are always reduced when the energy-conserving scheme is adopted, which is a favourable feature from a stability point of view.

   With linear interpolations, on the other hand, the errors never shrink; namely, **using smaller time steps, which is a common way to stabilise, does not help at all**.
   In addition, the total energies are generally increased when linear interpolations are used and may lead to numerical instabilities.

   In normal cases with finite :math:`Re`, the results are not affected so much because of the viscous dissipation, which generally works to stabilise the flow fields.
   For highly turbulent wall-bounded flows with largely stretched grid, however, using an energy-consistent scheme could be useful to obtain a reliable and stable solutions.

***********************************
2. Computations of dissipation rate
***********************************

==========
Conclusion
==========

Intuitive ways to compute dissipation rates are compared with consistent ways derived previously.
They tend to underestimate the dissipation, and as a result perfect Nusselt number agreements are broken.

=======
Example
=======

.. details:: Details

   We consider an intuitive way to compute

   .. math::
      \der{u_i}{x_j} \der{u_i}{x_j}
      = \left( \der{\ux}{x} \right)^2
      + \left( \der{\ux}{y} \right)^2
      + \left( \der{\uy}{x} \right)^2
      + \left( \der{\uy}{y} \right)^2,

   which is necessary to compute the kinetic dissipation eate :math:`\epsilon_{k}`.

   A straightforward way to compute :math:`\der{\ux}{y}` at the cell center might be

   .. math::
     \vat{\frac{\delta u_x}{\delta y}}{i,j}
     =
     \frac{1}{2} \left(
         \frac{\vat{\ux}{\pim,\pjpp} - \vat{\ux}{\pim,\pjmm}}{2 \Delta y}
       + \frac{\vat{\ux}{\pip,\pjpp} - \vat{\ux}{\pip,\pjmm}}{2 \Delta y}
     \right).

   Similarly, the discretisation of :math:`\der{T}{y}`, which is essential to compute the thermal dissipation rate

   .. math::
      \der{T}{x_i} \der{T}{x_i}
      = \left( \der{T}{x} \right)^2
      + \left( \der{T}{y} \right)^2,

   could be given as

   .. math::
      \vat{\frac{\delta T}{\delta y}}{i,j}
      =
      \frac{
         \vat{T}{\pic,\pjpp}
       - \vat{T}{\pic,\pjmm}
      }{2 \Delta y}.

   We compare this inconsistent discretisations with the consistent ones derived previously.
   The main part of configuration is as follows.

   .. code-block:: sh

      #!/bin/bash

      export timemax=2.e+3
      export log_rate=1.e-1
      export ly=2.
      export itot=128
      export jtot=256
      export stretch=3
      export Ra=1.e8
      export Pr=1.e0

   Our interest is :math:`Nu_{\epsilon_{k}}` and :math:`Nu_{\epsilon_{h}}`, which are the Nusselt numbers computed based on the kinetic and thermal dissipation rates, respectively.
   The resolution :sh:`itot` and :sh:`jtot` are varied to see the effects.

   .. image:: images/dif_convergence.pdf
      :width: 800

   Note that :math:`Nu` are shown after being normalised by :math:`Nu_{wall}`, and thus they should be unity.

   We find that the ratios indeed give almost unity when we evaluate the dissipation rates with consistent ways, which is irrespective to the resolution.
   Note that, although :math:`Nu` is a function of the spatial resolution (of course), the *agreements* of different :math:`Nu` are always satisfied irrespective to the resolution.

   When inconsistent schemes are adopted, on the other hand, :math:`Nu_{\epsilon_{k}}` and :math:`Nu_{\epsilon_{h}}` do not agree with :math:`Nu_{wall}`.
   Generally they give lower values, i.e.., underestimating the actual Nusselt number.
   Obviously the Nusselt balances derived in :ref:`the Nusselt number relations <nusselt_number_relations>` are broken.


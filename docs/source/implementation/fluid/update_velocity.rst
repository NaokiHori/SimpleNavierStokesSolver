
.. _fluid_update_velocity:

.. include:: /references.txt

########################################################################################################################
`fluid/update_velocity.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/update_velocity.c>`_
########################################################################################################################

Update velocity from :math:`u_i^k` to :math:`u_i^*`, which does not necessarily satisfy divergence-free condition.

See :ref:`the temporal discretisation <temporal_discretisation>` and :ref:`the spatial discretisation <spatial_discretisation>` for details.

*********************
fluid_update_velocity
*********************

==========
Definition
==========

.. code-block:: c

   int fluid_update_velocity(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid,
       const temperature_t *temperature
   );

=========== ====== ================================
Name        intent description
=========== ====== ================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in/out pressure (in), velocity (in/out)
temperature in     thermal forcing term
=========== ====== ================================

===========
Description
===========

Now we try to update the velocity field of the previous Runge-Kutta step :math:`k`: :math:`u_i^k` to tentative values :math:`u_i^*` using :ref:`the SMAC method <smac_method>`.

Source terms in the right-hand-side (:math:`A_i^k`, :math:`D_i^k`, and :math:`P_i^k`) are computed in two directions :math:`x` and :math:`y`:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: source terms of Runge-Kutta scheme are updated

which are followed by

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: velocities are updated

where the velocities are updated.

For more information about these 4 functions, see below.

**************
compute_src_ux
**************

==========
Definition
==========

.. code-block:: c

   static int compute_src_ux(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid,
       const temperature_t *temperature
   );

=========== ====== ==============================================
Name        intent description
=========== ====== ==============================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in/out pressure, velocity (in), source terms (in/out)
temperature in     thermal forcing term
=========== ====== ==============================================

===========
Description
===========

Compute source terms of the Runge-Kutta integration (:math:`A_x^k`, :math:`D_x^k`, :math:`P_x^k`) of the momentum equation in :math:`x` direction.

First of all, :c-lang:`srcuxa` (the last character **a** implies :math:`\alpha`), which contains the information of the previous Runge-Kutta step, is copied to :c-lang:`srcuxb` (the last character **b** implies :math:`\beta`), so that new values can be assigned to :c-lang:`srcuxa`:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: previous k-step source term of ux is copied

Then, all source terms are evaluated at each location where :c-lang:`ux` is defined.

.. note::

   The spatial discretisations and their derivations are extensively discussed in the section :ref:`"momentum balance and quadratic quantity" <momentum_balance>`.

   Hereafter, superscript :math:`k`, which denotes Runge-Kutta step and should be on all :math:`\ux` and :math:`\uy`, are dropped for notational simplicity.

1. Advective terms (:c-lang:`adv1`, :c-lang:`adv2`)

   .. math::
      -
      \dder{
         \dintrpa{\ux}{x}
         \dintrpa{\ux}{x}
      }{x}
      -
      \dder{
         \dintrpv{\uy}{x}
         \dintrpa{\ux}{y}
      }{y}

   1. :c-lang:`adv1`: Advection of :math:`\ux` by :math:`\ux`

      .. math::
         -
         \frac{
            \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
            \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
            -
            \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
            \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
         }{\Delta x_{\xic}}

      .. details:: Details

         :math:`\ux` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{\ux}{x}}{\xim, \xjc} & & =
                    \frac{1}{2} \vat{\ux}{\ximm, \xjc } & &
                  + \frac{1}{2} \vat{\ux}{\xic , \xjc }, \\
               & \vat{\dintrpa{\ux}{x}}{\xip, \xjc} & & =
                    \frac{1}{2} \vat{\ux}{\xic , \xjc } & &
                  + \frac{1}{2} \vat{\ux}{\xipp, \xjc }. \\
            \end{alignedat}

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: x-momentum is transported by ux

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity1.pdf
            :width: 800

   2. :c-lang:`adv2`: Advection of :math:`\ux` by :math:`\uy`

      .. math::
         -
         \frac{
            \vat{\dintrpv{\uy}{x}}{\xic, \yjp}
            \vat{\dintrpa{\ux}{y}}{\xic, \yjp}
            -
            \vat{\dintrpv{\uy}{x}}{\xic, \yjm}
            \vat{\dintrpa{\ux}{y}}{\xic, \yjm}
         }{\Delta y}

      .. details:: Details

         :math:`\ux` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{\ux}{y}}{\xic, \xjm} & & =
                    \frac{1}{2} \vat{\ux}{\xic, \xjmm} & &
                  + \frac{1}{2} \vat{\ux}{\xic, \xjc }, \\
               & \vat{\dintrpa{\ux}{y}}{\xic, \xjp} & & =
                    \frac{1}{2} \vat{\ux}{\xic, \xjc } & &
                  + \frac{1}{2} \vat{\ux}{\xic, \xjpp}, \\
            \end{alignedat}

         while :math:`\uy` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpv{\uy}{x}}{\xic, \xjm} & & =
                    \vat{C}{\xim} \vat{\uy}{\xim, \xjm} & &
                  + \vat{C}{\xip} \vat{\uy}{\xip, \xjm}, \\
               & \vat{\dintrpv{\uy}{x}}{\xic, \xjp} & & =
                    \vat{C}{\xim} \vat{\uy}{\xim, \xjp} & &
                  + \vat{C}{\xip} \vat{\uy}{\xip, \xjp}, \\
            \end{alignedat}

         where coefficients are

         .. math::
            \vat{C}{\xim}
            & =
            \frac{\Delta x_{\xim}}{2 \Delta x_{\xic}}, \\
            \vat{C}{\xip}
            & =
            \frac{\Delta x_{\xip}}{2 \Delta x_{\xic}}.

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: x-momentum is transported by uy

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity2.pdf
            :width: 800

2. Diffusive terms (:c-lang:`dif1`, :c-lang:`dif2`)

   .. math::
      \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
         \dder{}{x} \left( \dder{\ux}{x} \right)
         +
         \dder{}{y} \left( \dder{\ux}{y} \right)
      \right\}

   1. :c-lang:`dif1`: Diffusion of :math:`\ux` in :math:`x` direction

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\dder{\ux}{x}}{\xip, \xjc}
            -
            \vat{\dder{\ux}{x}}{\xim, \xjc}
         }{\Delta x_{\xic}}

      .. details:: Details

         The differentiations lead

         .. math::
            \vat{\dder{\ux}{x}}{\xip, \xjc}
            =
            \frac{
               \vat{\ux}{\xipp, \xjc}
               -
               \vat{\ux}{\xic,  \xjc}
            }{\Delta x_{\xip}}, \\
            \vat{\dder{\ux}{x}}{\xim, \xjc}
            =
            \frac{
               \vat{\ux}{\xic,  \xjc}
               -
               \vat{\ux}{\ximm, \xjc}
            }{\Delta x_{\xim}}.

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: x-momentum is diffused in x

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity1.pdf
            :width: 800

   2. :c-lang:`dif2`: Diffusion of :math:`\ux` in :math:`y` direction

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\dder{\ux}{y}}{\xic, \xjp}
            -
            \vat{\dder{\ux}{y}}{\xic, \xjm}
         }{\Delta y}

      .. details:: Details

         The differentiations lead

         .. math::
            \vat{\dder{\ux}{y}}{\xic, \xjp}
            =
            \frac{
               \vat{\ux}{\xic, \xjpp}
               -
               \vat{\ux}{\xic, \xjc }
            }{\Delta y}, \\
            \vat{\dder{\ux}{y}}{\xic, \xjm}
            =
            \frac{
               \vat{\ux}{\xic, \xjc }
               -
               \vat{\ux}{\xic, \xjmm}
            }{\Delta y}.

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: x-momentum is diffused in y

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity3.pdf
            :width: 800

3. Pressure-gradient term (:c-lang:`pre`)

   .. math::
      -\dder{p}{x}

   .. details:: Details

      The implementation leads

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: pressure gradient in x

      :ref:`The domain setup <domain>` is described here again for convenience.

      .. image:: image/update_velocity4.pdf
          :width: 800

4. Buoyancy term (:c-lang:`tmp`)

   .. math::
      \dintrpa{T}{x}

   .. details:: Details

      .. seealso::

         It is computed in :ref:`src/temperature/force.c <temperature_force>`.

      The implementation leads

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: buoyancy force

After all source terms are evaluated, they are assigned to the corresponding variable.

Terms which are treated explicitly are summed up to :c-lang:`srcuxa`:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: summation of ux explicit terms

Advective terms (:c-lang:`adv1`, :c-lang:`adv2`) and buoyancy term (:c-lang:`tmp`) are involved since they are always treated explicitly.

Diffusive terms are summed up here when treated explicitly (:c-lang:`implicitx` or :c-lang:`implicity` is :math:`0`), while are neglected here when treated implicitly (:c-lang:`implicitx` or :c-lang:`implicity` is :math:`1`).

Instead, they are summed up to :c-lang:`srcuxg` when treated implicitly:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: summation of ux implicit terms

Pressure gradient term (:c-lang:`pre`) is always treated implicitly.

.. note::

   The inner loop (with respect to :c-lang:`i`, :math:`x` locations) does not contain :c-lang:`i=1` and :c-lang:`i=itot+1`, which are on the boundaries and thus whose values are known a priori as boundary conditions.
   In particular, :c-lang:`UX(1, j) = UX(itot+1, j) = 0` since this project assumes impermeable walls.

**************
compute_src_uy
**************

==========
Definition
==========

.. code-block:: c

   static int compute_src_uy(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

=========== ====== ==============================================
Name        intent description
=========== ====== ==============================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in/out pressure, velocity (in), source terms (in/out)
=========== ====== ==============================================

===========
Description
===========

Compute source terms of the Runge-Kutta integration (:math:`A_y^k`, :math:`D_y^k`, :math:`P_y^k`) of the momentum equation in :math:`y` direction.

First of all, :c-lang:`srcuya` (the last character **a** implies :math:`\alpha`), which contains the information of the previous Runge-Kutta step, is copied to :c-lang:`srcuyb` (the last character **b** implies :math:`\beta`), so that new values can be assigned to :c-lang:`srcuya`:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: previous k-step source term of uy is copied

Then, all source terms are evaluated at each location where :c-lang:`uy` is defined.

.. note::

   The spatial discretisations and their derivations are extensively discussed in the section :ref:`"momentum balance and quadratic quantity" <momentum_balance>`.

   Hereafter, superscript :math:`k`, which denotes Runge-Kutta step and should be on all :math:`\ux` and :math:`\uy`, are dropped for notational simplicity.

1. Advective terms (:c-lang:`adv1`, :c-lang:`adv2`)

   .. math::
      -
      \dder{
         \dintrpa{\ux}{y}
         \dintrpa{\uy}{x}
      }{x}
      -
      \dder{
         \dintrpa{\uy}{y}
         \dintrpa{\uy}{y}
      }{y}

   1. :c-lang:`adv1`: Advection of :math:`\uy` by :math:`\ux`

      .. math::
         -
         \frac{
            \vat{\dintrpa{\ux}{y}}{\yip, \yjc}
            \vat{\dintrpa{\uy}{x}}{\yip, \yjc}
            -
            \vat{\dintrpa{\ux}{y}}{\yim, \yjc}
            \vat{\dintrpa{\uy}{x}}{\yim, \yjc}
         }{\Delta x_{\yic}}

      .. details:: Details

         :math:`\ux` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{\ux}{y}}{\yim, \yjc} & & =
                    \frac{1}{2} \vat{\ux}{\yim, \yjm} & &
                  + \frac{1}{2} \vat{\ux}{\yim, \yjp}, \\
               & \vat{\dintrpa{\ux}{y}}{\yip, \yjc} & & =
                    \frac{1}{2} \vat{\ux}{\yip, \yjm} & &
                  + \frac{1}{2} \vat{\ux}{\yip, \yjp}, \\
            \end{alignedat}

         while :math:`\uy` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{\uy}{x}}{\yim, \yjc} & & =
                    \frac{1}{2} \vat{\uy}{\yimm, \yjc} & &
                  + \frac{1}{2} \vat{\uy}{\yic,  \yjc}, \\
               & \vat{\dintrpa{\uy}{x}}{\yip, \yjc} & & =
                    \frac{1}{2} \vat{\uy}{\yic,  \yjc} & &
                  + \frac{1}{2} \vat{\uy}{\yipp, \yjc}. \\
            \end{alignedat}

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: y-momentum is transported by ux

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity5.pdf
           :width: 800

         .. note::

            Recall that the boundary values of :math:`\uy` are defined on the walls.
            Strictly speaking, we should use these boundary values directly instead of the interpolated values.

            Since impermeable walls (:math:`\ux \equiv 0`) are assumed, however, they give null eventually and thus we use the same notation for simplicity here.

   2. :c-lang:`adv2`: Advection of :math:`\uy` by :math:`\uy`

      .. math::
         -
         \frac{
            \vat{\dintrpa{\uy}{y}}{\yic, \yjp}
            \vat{\dintrpa{\uy}{y}}{\yic, \yjp}
            -
            \vat{\dintrpa{\uy}{y}}{\yic, \yjm}
            \vat{\dintrpa{\uy}{y}}{\yic, \yjm}
         }{\Delta y}

      .. details:: Details

         :math:`\uy` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{\uy}{x}}{\yic, \yjm} & & =
                    \frac{1}{2} \vat{\uy}{\yic, \yjmm} & &
                  + \frac{1}{2} \vat{\uy}{\yic, \yjc }, \\
               & \vat{\dintrpa{\uy}{x}}{\yic, \yjc} & & =
                    \frac{1}{2} \vat{\uy}{\yic, \yjc } & &
                  + \frac{1}{2} \vat{\uy}{\yic, \yjpp}. \\
            \end{alignedat}

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: y-momentum is transported by uy

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity6.pdf
            :width: 400

2. Diffusive terms (:c-lang:`dif1`, :c-lang:`dif2`)

   .. math::
      \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
         \dder{}{x} \left( \dder{\uy}{x} \right)
         +
         \dder{}{y} \left( \dder{\uy}{y} \right)
      \right\}

   1. :c-lang:`dif1`: Diffusion of :math:`\uy` in :math:`x` direction

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\dder{\uy}{x}}{\yip, \yjc}
            -
            \vat{\dder{\uy}{x}}{\yim, \yjc}
         }{\Delta x_{\yic}}

      .. details:: Details

         The differentiations lead

         .. math::
            \vat{\dder{\uy}{x}}{\yip, \yjc}
            =
            \frac{
               \vat{\uy}{\yipp, \yjc}
               -
               \vat{\uy}{\yic,  \yjc}
            }{\Delta x_{\yip}}, \\
            \vat{\dder{\uy}{x}}{\yim, \yjc}
            =
            \frac{
               \vat{\uy}{\yic,  \yjc}
               -
               \vat{\uy}{\yimm, \yjc}
            }{\Delta x_{\yim}}.

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: y-momentum is diffused in x

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity7.pdf
           :width: 800

         .. note::

            :c-lang:`DXC` already includes the boundary corrections (see :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>` and :ref:`spatial discretisation <spatial_discretisation>`).

   2. :c-lang:`dif2`: Diffusion of :math:`\uy` in :math:`y` direction

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\dder{\uy}{y}}{\yic, \yjp}
            -
            \vat{\dder{\uy}{y}}{\yic, \yjm}
         }{\Delta y}

      .. details:: Details

         The differentiations lead

         .. math::
            \vat{\dder{\uy}{y}}{\yic, \yjp}
            =
            \frac{
               \vat{\uy}{\yic, \yjpp}
               -
               \vat{\uy}{\yic, \yjc }
            }{\Delta y}, \\
            \vat{\dder{\uy}{y}}{\yic, \yjm}
            =
            \frac{
               \vat{\uy}{\yic, \yjc }
               -
               \vat{\uy}{\yic, \yjmm}
            }{\Delta y}.

         The implementation leads

         .. myliteralinclude:: /../../src/fluid/update_velocity.c
            :language: c
            :tag: y-momentum is diffused in y

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update_velocity6.pdf
            :width: 400

3. Pressure-gradient term (:c-lang:`pre`)

   .. math::
      -\dder{p}{y}

   .. details:: Details

      The implementation leads

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: pressure gradient in y

      :ref:`The domain setup <domain>` is described here again for convenience.

      .. image:: image/update_velocity8.pdf
        :width: 400

After all source terms are evaluated, they are assigned to the corresponding variable.

Terms which are treated explicitly are summed up to :c-lang:`srcuya`:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: summation of uy explicit terms

Advective terms (:c-lang:`adv1`, :c-lang:`adv2`) are involved since they are always treated explicitly.

Diffusive terms are summed up here when treated explicitly (:c-lang:`implicitx` or :c-lang:`implicity` is :math:`0`), while are neglected here when treated implicitly (:c-lang:`implicitx` or :c-lang:`implicity` is :math:`1`).

Instead, they are summed up to :c-lang:`srcuyg` when treated implicitly:

.. myliteralinclude:: /../../src/fluid/update_velocity.c
   :language: c
   :tag: summation of uy implicit terms

Pressure gradient term (:c-lang:`pre`) is always treated implicitly.

*********
update_ux
*********

==========
Definition
==========

.. code-block:: c

   static int update_ux(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

=========== ====== ===========================================
Name        intent description
=========== ====== ===========================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in/out source terms (in), :math:`x` velocity (out)
=========== ====== ===========================================

===========
Description
===========

New but non-solenoidal velocity in :math:`x` direction :math:`\ux^*` is obtained by using the source terms computed in :c-lang:`compute_src_ux`.

First of all, the velocity increment in :math:`x` direction :math:`\delta \ux \equiv \ux^* - \ux^k` is computed:

.. math::
   \delta \ux = \left(
        \alpha^k \mathcal{A}_x
      + \beta^k  \mathcal{B}_x
      + \gamma^k \mathcal{G}_x
   \right) \Delta t,

where :math:`\mathcal{A}_x`, :math:`\mathcal{B}_x`, and :math:`\mathcal{G}_x` are source terms which are already computed in :c-lang:`compute_src_ux` and correspond to :c-lang:`srcuxa`, :c-lang:`srcuxb`, and :c-lang:`srcuxg`, respectively.

As discussed in :ref:`the temporal discretisation <smac_method>`, the update process differs for different diffusive treatments.
When all diffusive terms are treated explicitly in time, we simply have

.. math::
   \ux^* = \ux^k + \delta \ux.

When the diffusive terms are partially treated implicitly (e.g., only :math:`x` direction), we have

.. math::
   \ux^* = \ux^k + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta \ux,

where linear systems in :math:`x` direction need to be solved.

When all diffusive terms are treated implicitly, we have

.. math::
   \ux^* = \ux^k + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta \ux,

where linear systems in each direction should be solved.

Based on these relations, the updating procedure is as follows.

1. Compute :math:`\delta \ux`

   .. details:: Details

      The velocity increment in :math:`x` direction :math:`\delta \ux` is computed and assigned to a variable :c-lang:`qx`:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: compute increments of ux

2. Solve linear systems in :math:`x` direction (**only when** the diffusive term in :math:`x` direction is treated implicitly)

   .. details:: Details

      We consider

      .. math::
         \delta \ux^{\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta \ux

      or in other words

      .. math::
         \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right) \delta \ux^{\prime}
         = \delta \ux^{\prime} - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2 \left( \delta \ux^{\prime} \right)}{\delta x^2}
         = \delta \ux.

      Hereafter, for notational simplicity,

         * instead of :math:`\delta \ux^{\prime}` and :math:`\delta \ux`, :math:`q^{\prime}` and :math:`q` are used,

         * :math:`j` is dropped since the following discussion holds for each :math:`\xjc`.

      The second-order derivative of :math:`q^{\prime}` in :math:`x` direction should be discretised with the same discrete operator used to compute the diffusive term, i.e.,

      .. math::
         \vat{\frac{\delta^2 q^{\prime}}{\delta x^2}}{\xic}
         = c_{\ximm} \vat{q^{\prime}}{\ximm}
         + c_{\xic } \vat{q^{\prime}}{\xic }
         + c_{\xipp} \vat{q^{\prime}}{\xipp},

      where

      .. math::
         \begin{aligned}
            c_{\ximm} & = \frac{1}{\Delta x_{\xic} \Delta x_{\xim}}, \\
            c_{\xipp} & = \frac{1}{\Delta x_{\xic} \Delta x_{\xip}}, \\
            c_{\xic } & = -c_{\ximm}-c_{\xipp}.
         \end{aligned}

      .. image:: image/update_velocity9.pdf
         :width: 800

      Thus, the equation of :math:`q^{\prime}` can be discretised as

      .. math::
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\ximm}         \vat{q^{\prime}}{\ximm}
         + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\xic } \right) \vat{q^{\prime}}{\xic }
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\xipp}         \vat{q^{\prime}}{\xipp} \\
         = \vat{q}{\xic}.

      For simplicity, we write this as

      .. math::
           l_{\ximm} \vat{q^{\prime}}{\ximm}
         + c_{\xic } \vat{q^{\prime}}{\xic }
         + u_{\xipp} \vat{q^{\prime}}{\xipp}
         = \vat{q}{\xic},

      which is implemented as:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: set diagonal components of ux linear system in x direction

      Recall the difference of the notations; :math:`\xic` corresponds to :c-lang:`i`, i.e., the left bound is :math:`i = \frac{1}{2}` and :c-lang:`i = 1`, whereas the right bound is :math:`i = \text{itot}+\frac{1}{2}` and :c-lang:`i = itot+1`.

      This can be written as a linear system (whose size is :c-lang:`itot+1`):

      .. math::
         \newcommand\ia{\frac{1}{2}}
         \newcommand\ib{\frac{3}{2}}
         \newcommand\ic{\frac{5}{2}}
         \newcommand\id{i-\frac{1}{2}}
         \newcommand\ie{i+\frac{1}{2}}
         \newcommand\if{i+\frac{3}{2}}
         \newcommand\ig{\text{itot}-\frac{3}{2}}
         \newcommand\ih{\text{itot}-\frac{1}{2}}
         \newcommand\ii{\text{itot}+\frac{1}{2}}
         \begin{bmatrix}
            1       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            l_{\ib} & c_{\ib} & u_{\ib} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            0       & l_{\ic} & c_{\ic} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & c_{\id} & u_{\id} & 0       & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & l_{\ie} & c_{\ie} & u_{\ie} & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & 0       & l_{\if} & c_{\if} & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & c_{\ig} & u_{\ig} & 0       \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & l_{\ih} & c_{\ih} & u_{\ih} \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 1
         \end{bmatrix}
         \begin{bmatrix}
            \vat{q^{\prime}}{\ia} \\
            \vat{q^{\prime}}{\ib} \\
            \vat{q^{\prime}}{\ic} \\
            \vdots                                   \\
            \vat{q^{\prime}}{\id} \\
            \vat{q^{\prime}}{\ie} \\
            \vat{q^{\prime}}{\if} \\
            \vdots                                   \\
            \vat{q^{\prime}}{\ig} \\
            \vat{q^{\prime}}{\ih} \\
            \vat{q^{\prime}}{\ii}
         \end{bmatrix}
         =
         \begin{bmatrix}
            \vat{q}{\ia} \\
            \vat{q}{\ib} \\
            \vat{q}{\ic} \\
            \vdots                          \\
            \vat{q}{\id} \\
            \vat{q}{\ie} \\
            \vat{q}{\if} \\
            \vdots                          \\
            \vat{q}{\ig} \\
            \vat{q}{\ih} \\
            \vat{q}{\ii}
         \end{bmatrix},

      where the first matrix in the left-hand-side is the tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_.
      See :ref:`src/linalg.c <linalg>` for details.

      Note that the matrix is already diagonalised at the edges, i.e., we already have solutions

      .. math::
         \newcommand\ia{\frac{1}{2}}
         \newcommand\ii{\text{itot}+\frac{1}{2}}
         \vat{\delta \ux^{\prime}}{\ia} &= \vat{\delta \ux}{\ia} = 0, \\
         \vat{\delta \ux^{\prime}}{\ii} &= \vat{\delta \ux}{\ii} = 0,

      since the walls are assumed to be impermeable and thus the boundary condition does not change in time.
      Although these two rows can be removed to obtain an equivalent linear system (whose size is :c-lang:`itot-1`), here we include them for simplicity.

      Finally the linear system is solved

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: solve linear system of ux in x direction

3. Solve linear systems in :math:`y` direction (**only when** the diffusive term in :math:`y` direction is treated implicitly)

   .. details:: Details

      We consider

      .. math::
         \delta \ux^{\prime\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta \ux^{\prime}.

      To do so, all :math:`y` values at each :math:`x` location should be contained by one processor.
      By default, this is not the case since the domain is split in :math:`y` direction.
      Thus the matrix must be transposed beforehand, which is achieved by

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: transpose x-aligned ux matrix to y-aligned matrix

      Also see the schematic below for an intuitive understanding, where a domain whose sizes are :c-lang:`itot=7` (thus size of :c-lang:`qx` in :math:`x` direction is :c-lang:`8`) and :c-lang:`jtot=11` is drawn:

      .. image:: image/update_velocity10.pdf
         :width: 800

      Here :c-lang:`qx` (left figure) is transposed to :c-lang:`qy` (right figure) and the alignment is modified to :math:`y` direction (note that memory is contiguous in :math:`y` direction after being transposed, which was contiguous in :math:`x` direction before).

      We consider

      .. math::
         \delta \ux^{\prime\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta \ux^{\prime}

      or in other words

      .. math::
         \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right) \delta \ux^{\prime\prime}
         = \delta \ux^{\prime\prime} - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2 \left( \delta \ux^{\prime\prime} \right)}{\delta y^2}
         = \delta \ux^{\prime}.

      Hereafter, for notational simplicity,

         * instead of :math:`\delta \ux^{\prime\prime}` and :math:`\delta \ux^{\prime}`, :math:`q^{\prime\prime}` and :math:`q^{\prime}` are used,

         * :math:`i` is dropped since the following discussion holds for each :math:`\xic`.

      The second-order derivative of :math:`q^{\prime\prime}` in :math:`y` direction should be discretised with the same discrete operator used to compute the diffusive term, i.e.,

      .. math::
         \vat{\frac{\delta^2 q^{\prime\prime}}{\delta y^2}}{\xjc}
         = c_{\xjmm} \vat{q^{\prime\prime}}{\xjmm}
         + c_{\xjc } \vat{q^{\prime\prime}}{\xjc }
         + c_{\xjpp} \vat{q^{\prime\prime}}{\xjpp},

      where

      .. math::
         \begin{aligned}
            c_{\xjmm} & = \frac{1}{\Delta y^2}, \\
            c_{\xjpp} & = \frac{1}{\Delta y^2}, \\
            c_{\xjc } & = -c_{\xjmm}-c_{\xjpp}.
         \end{aligned}

      .. image:: image/update_velocity11.pdf
         :width: 800

      Thus, the equation of :math:`q^{\prime\prime}` can be discretised as

      .. math::
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\xjmm}         \vat{q^{\prime\prime}}{\xjmm}
         + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\xjc } \right) \vat{q^{\prime\prime}}{\xjc }
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\xjpp}         \vat{q^{\prime\prime}}{\xjpp}
         = \vat{q^{\prime}}{\xjc}.

      For simplicity, we write this as

      .. math::
           l_{\xjmm} \vat{q^{\prime\prime}}{\xjmm}
         + c_{\xjc } \vat{q^{\prime\prime}}{\xjc }
         + u_{\xjpp} \vat{q^{\prime\prime}}{\xjpp}
         = \vat{q^{\prime}}{\xjc},

      which is implemented as:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: set diagonal components of ux linear system in y direction

      This can be written as a linear system (whose size is :c-lang:`jtot`)

      .. math::
         \newcommand\ia{1}
         \newcommand\ib{2}
         \newcommand\ic{3}
         \newcommand\id{j-1}
         \newcommand\ie{j  }
         \newcommand\if{j+1}
         \newcommand\ig{\text{jtot}-2}
         \newcommand\ih{\text{jtot}-1}
         \newcommand\ii{\text{jtot}  }
         \begin{bmatrix}
            c_{\ia} & u_{\ia} & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & l_{ia}  \\
            l_{\ib} & c_{\ib} & u_{\ib} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            0       & l_{\ic} & c_{\ic} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & c_{\id} & u_{\id} & 0       & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & l_{\ie} & c_{\ie} & u_{\ie} & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & 0       & l_{\if} & c_{\if} & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & c_{\ig} & u_{\ig} & 0       \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & l_{\ih} & c_{\ih} & u_{\ih} \\
            u_{\ii} & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{\ii} & c_{\ii}
         \end{bmatrix}
         \begin{bmatrix}
            \vat{q^{\prime\prime}}{\ia} \\
            \vat{q^{\prime\prime}}{\ib} \\
            \vat{q^{\prime\prime}}{\ic} \\
            \vdots                      \\
            \vat{q^{\prime\prime}}{\id} \\
            \vat{q^{\prime\prime}}{\ie} \\
            \vat{q^{\prime\prime}}{\if} \\
            \vdots                      \\
            \vat{q^{\prime\prime}}{\ig} \\
            \vat{q^{\prime\prime}}{\ih} \\
            \vat{q^{\prime\prime}}{\ii}
         \end{bmatrix}
         =
         \begin{bmatrix}
           \vat{q^{\prime}}{\ia} \\
           \vat{q^{\prime}}{\ib} \\
           \vat{q^{\prime}}{\ic} \\
           \vdots                \\
           \vat{q^{\prime}}{\id} \\
           \vat{q^{\prime}}{\ie} \\
           \vat{q^{\prime}}{\if} \\
           \vdots                \\
           \vat{q^{\prime}}{\ig} \\
           \vat{q^{\prime}}{\ih} \\
           \vat{q^{\prime}}{\ii}
         \end{bmatrix},

      where the first matrix in the left-hand-side is the modified (i.e., periodic boundary) tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_ with `Sherman–Morrison formula <https://en.wikipedia.org/wiki/Sherman–Morrison_formula>`_.
      See :ref:`src/linalg.c <linalg>` for details.

      Finally, the linear system is solved

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: solve linear system of ux in y direction

      After all linear systems are solved, the :math:`y`-aligned memory alignment is modified to the original :math:`x`-aligned one by transposing the matrix again:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: transpose y-aligned ux matrix to x-aligned matrix

4. Update :math:`\ux^k` to :math:`\ux^*`

   .. details:: Details

      Now the increment is ready, which is added to the velocity in :math:`x` direction :c-lang:`ux`:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: update ux

*********
update_uy
*********

==========
Definition
==========

.. code-block:: c

   static int update_uy(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

=========== ====== ===========================================
Name        intent description
=========== ====== ===========================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in/out source terms (in), :math:`y` velocity (out)
=========== ====== ===========================================

===========
Description
===========

New but non-solenoidal velocity in :math:`y` direction :math:`\uy^*` is obtained by using the source terms computed in :c-lang:`compute_src_uy`.

First of all, the velocity increment in :math:`y` direction :math:`\delta \uy \equiv \uy^* - \uy^k` is computed:

.. math::
   \delta \uy = \left(
        \alpha^k \mathcal{A}_y
      + \beta^k  \mathcal{B}_y
      + \gamma^k \mathcal{G}_y
   \right) \Delta t,

where :math:`\mathcal{A}_y`, :math:`\mathcal{B}_y`, and :math:`\mathcal{G}_y` are source terms which are already computed in :c-lang:`compute_src_uy` and correspond to :c-lang:`srcuya`, :c-lang:`srcuyb`, and :c-lang:`srcuyg`, respectively.

As discussed in :ref:`the temporal discretisation <smac_method>`, the update process differs for different diffusive treatments.
When all diffusive terms are treated explicitly in time, we simply have

.. math::
   \uy^* = \uy^k + \delta \uy.

When the diffusive terms are partially treated implicitly (e.g., only :math:`x` direction), we have

.. math::
   \uy^* = \uy^k + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta \uy,

where linear systems in :math:`x` direction needs to be solved.

When all diffusive terms are treated implicitly, we have

.. math::
   \uy^* = \uy^k + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta \uy,

where linear systems in each direction should be solved.

Based on these relations, the updating procedure is as follows.

1. Compute :math:`\delta \uy`

   .. details:: Details

      The velocity increment in :math:`y` direction :math:`\delta \uy` is computed and assigned to a variable :c-lang:`qx`:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: compute increments of uy

2. Solve linear systems in :math:`x` direction (**only when** the diffusive term in :math:`x` direction is treated implicitly)

   .. details:: Details

      We consider

      .. math::
        \delta \uy^{\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta \uy

      or in other words

      .. math::
        \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right) \delta \uy^{\prime}
         = \delta \uy^{\prime} - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2 \left( \delta \uy^{\prime} \right)}{\delta x^2}
         = \delta \uy.

      Hereafter, for notational simplicity,

         * instead of :math:`\delta \uy^{\prime}` and :math:`\delta \uy`, :math:`q^{\prime}` and :math:`q` are used,

         * :math:`j` is dropped since the following discussion holds for each :math:`\yjc`.

      The second-order derivative of :math:`q^{\prime}` in :math:`x` direction should be discretised with the same discrete operator used to compute the diffusive term, i.e.,

      .. math::
         \vat{\frac{\delta^2 q}{\delta x^2}}{\yic}
         = c_{\yimm} \vat{q}{\yimm}
         + c_{\yic } \vat{q}{\yic }
         + c_{\yipp} \vat{q}{\yipp},

      where

      .. math::
         c_{\yimm} & = \frac{1}{\Delta x_{\yic} \Delta x_{\yim}}, \\
         c_{\yipp} & = \frac{1}{\Delta x_{\yic} \Delta x_{\yip}}, \\
         c_{\yic } & = -c_{\yimm}-c_{\yipp},

      .. image:: image/update_velocity12.pdf
         :width: 800

      Based on this, the equation of :math:`\uy^{\prime}` can be discretised as

      .. math::
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\yimm}         \vat{q^{\prime}}{\yimm}
         + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\yic } \right) \vat{q^{\prime}}{\yic }
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\yipp}         \vat{q^{\prime}}{\yipp}
         = \vat{q}{\yic},

      For simplicity, we write this as

      .. math::
           l_{\yimm} \vat{q^{\prime}}{\yimm}
         + c_{\yic } \vat{q^{\prime}}{\yic }
         + u_{\yipp} \vat{q^{\prime}}{\yipp}
         = \vat{q}{\yic},

      which is implemented as:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: set diagonal components of uy linear system in x direction

      This can be written as a linear system (whose size is :c-lang:`itot`)

      .. math::
         \newcommand\ia{1}
         \newcommand\ib{2}
         \newcommand\ic{3}
         \newcommand\id{i-1}
         \newcommand\ie{i  }
         \newcommand\if{i+1}
         \newcommand\ig{\text{itot}-2}
         \newcommand\ih{\text{itot}-1}
         \newcommand\ii{\text{itot}  }
         \begin{bmatrix}
            c_{\ia} & u_{\ia} & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            l_{\ib} & c_{\ib} & u_{\ib} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            0       & l_{\ic} & c_{\ic} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & c_{\id} & u_{\id} & 0       & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & l_{\ie} & c_{\ie} & u_{\ie} & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & 0       & l_{\if} & c_{\if} & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & c_{\ig} & u_{\ig} & 0       \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & l_{\ih} & c_{\ih} & u_{\ih} \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{\ii} & c_{\ii}
         \end{bmatrix}
         \begin{bmatrix}
            \vat{q^{\prime}}{\ia} \\
            \vat{q^{\prime}}{\ib} \\
            \vat{q^{\prime}}{\ic} \\
            \vdots                \\
            \vat{q^{\prime}}{\id} \\
            \vat{q^{\prime}}{\ie} \\
            \vat{q^{\prime}}{\if} \\
            \vdots                \\
            \vat{q^{\prime}}{\ig} \\
            \vat{q^{\prime}}{\ih} \\
            \vat{q^{\prime}}{\ii}
         \end{bmatrix}
         =
         \begin{bmatrix}
            \vat{q}{\ia} \\
            \vat{q}{\ib} \\
            \vat{q}{\ic} \\
            \vdots       \\
            \vat{q}{\id} \\
            \vat{q}{\ie} \\
            \vat{q}{\if} \\
            \vdots       \\
            \vat{q}{\ig} \\
            \vat{q}{\ih} \\
            \vat{q}{\ii}
         \end{bmatrix},

      where the first matrix in the left-hand-side is the tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_.
      See :ref:`src/linalg.c <linalg>` for details.

      Finally the linear system is solved

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: solve linear system of uy in x direction

3. Solve linear systems in :math:`y` direction (**only when** the diffusive term in :math:`y` direction is treated implicitly)

   .. details:: Details

      We consider

      .. math::
         \delta \uy^{\prime\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta \uy^{\prime}.

      To do so, all :math:`y` values at each :math:`x` location should be contained by one processor.
      This is not the case since the domain is split in :math:`y` direction by default.
      Thus the matrix must be transposed beforehand, which is achieved by

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: transpose x-aligned uy matrix to y-aligned matrix

      Also see the schematic below for an intuitive understanding, where a domain whose sizes are :c-lang:`itot=7` (thus size of :c-lang:`qx` in :math:`x` direction is :c-lang:`8`) and :c-lang:`jtot=11` is drawn:

      .. image:: image/update_velocity13.pdf
         :width: 800

      Here :c-lang:`qx` (left figure) is transposed to :c-lang:`qy` (right figure) and the alignment is modified to :math:`y` direction (note that memory is contiguous in :math:`y` direction after being transposed, which was contiguous in :math:`x` direction before).

      We consider

      .. math::
         \delta \uy^{\prime\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta \uy^{\prime}

      or in other words

      .. math::
         \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right) \delta \uy^{\prime\prime}
         = \delta \uy^{\prime\prime} - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} \frac{\delta^2 \left( \delta \uy^{\prime\prime} \right)}{\delta y^2}
         = \delta \uy^{\prime}.

      Hereafter, for notational simplicity,

         * instead of :math:`\delta \uy^{\prime\prime}` and :math:`\delta \uy^{\prime}`, :math:`q^{\prime\prime}` and :math:`q^{\prime}` are used,

         * :math:`i` is dropped since the following discussion holds for each :math:`\yic`.

      The second-order derivative of :math:`q^{\prime\prime}` in :math:`y` direction should be discretised with the same discrete operator used to compute the diffusive term, i.e.,

      .. math::
         \vat{\frac{\delta^2 q}{\delta y^2}}{\yjc}
         = c_{\yjmm} \vat{q}{\yjmm}
         + c_{\yjc } \vat{q}{\yjc }
         + c_{\yjpp} \vat{q}{\yjpp},

      where

      .. math::
         \begin{aligned}
            c_{\yjmm} & = \frac{1}{\Delta y^2}, \\
            c_{\yjpp} & = \frac{1}{\Delta y^2}, \\
            c_{\yjc } & = -c_{\yjmm}-c_{\yjpp},
         \end{aligned}

      .. image:: image/update_velocity14.pdf
         :width: 400

      Thus, the equation of :math:`q^{\prime\prime}` can be discretised as

      .. math::
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\yjmm}         \vat{q^{\prime\prime}}{\yjmm}
         + \left( 1 - \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\yjc } \right) \vat{q^{\prime\prime}}{\yjc }
         -            \frac{\gamma^k \Delta t \sqrt{Pr}}{2 \sqrt{Ra}} c_{\yjpp}         \vat{q^{\prime\prime}}{\yjpp}
         = \vat{q^{\prime}}{\yjc}.

      For simplicity, we write this as

      .. math::
           l_{\yjmm} \vat{q^{\prime\prime}}{\yjmm}
         + c_{\yjc } \vat{q^{\prime\prime}}{\yjc }
         + u_{\yjpp} \vat{q^{\prime\prime}}{\yjpp}
         = \vat{q^{\prime}}{\yjc},

      which is implemented as:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: set diagonal components of uy linear system in y direction

      This can be written as a linear system (whose size is :c-lang:`jtot`)

      .. math::
         \newcommand\ia{\frac{1}{2}}
         \newcommand\ib{\frac{3}{2}}
         \newcommand\ic{\frac{5}{2}}
         \newcommand\id{j-\frac{1}{2}}
         \newcommand\ie{j+\frac{1}{2}}
         \newcommand\if{j+\frac{3}{2}}
         \newcommand\ig{\text{jtot}-\frac{3}{2}}
         \newcommand\ih{\text{jtot}-\frac{1}{2}}
         \newcommand\ii{\text{jtot}+\frac{1}{2}}
         \begin{bmatrix}
            c_{\ia} & u_{\ia} & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & l_{ia}  \\
            l_{\ib} & c_{\ib} & u_{\ib} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            0       & l_{\ic} & c_{\ic} & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & c_{\id} & u_{\id} & 0       & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & l_{\ie} & c_{\ie} & u_{\ie} & \cdots & 0       & 0       & 0       \\
            0       & 0       & 0       & \cdots & 0       & l_{\if} & c_{\if} & \cdots & 0       & 0       & 0       \\
            \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & c_{\ig} & u_{\ig} & 0       \\
            0       & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & l_{\ih} & c_{\ih} & u_{\ih} \\
            u_{\ii} & 0       & 0       & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{\ii} & c_{\ii}
         \end{bmatrix}
         \begin{bmatrix}
            \vat{q^{\prime\prime}}{\ia} \\
            \vat{q^{\prime\prime}}{\ib} \\
            \vat{q^{\prime\prime}}{\ic} \\
            \vdots                      \\
            \vat{q^{\prime\prime}}{\id} \\
            \vat{q^{\prime\prime}}{\ie} \\
            \vat{q^{\prime\prime}}{\if} \\
            \vdots                      \\
            \vat{q^{\prime\prime}}{\ig} \\
            \vat{q^{\prime\prime}}{\ih} \\
            \vat{q^{\prime\prime}}{\ii}
         \end{bmatrix}
         =
         \begin{bmatrix}
            \vat{q^{\prime}}{\ia} \\
            \vat{q^{\prime}}{\ib} \\
            \vat{q^{\prime}}{\ic} \\
            \vdots                \\
            \vat{q^{\prime}}{\id} \\
            \vat{q^{\prime}}{\ie} \\
            \vat{q^{\prime}}{\if} \\
            \vdots                \\
            \vat{q^{\prime}}{\ig} \\
            \vat{q^{\prime}}{\ih} \\
            \vat{q^{\prime}}{\ii}
         \end{bmatrix},

      where the first matrix in the left-hand-side is the modified (i.e., periodic boundary) tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_ with `Sherman–Morrison formula <https://en.wikipedia.org/wiki/Sherman–Morrison_formula>`_.
      See :ref:`src/linalg.c <linalg>` for details.

      Finally, the linear system is solved

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: solve linear system of uy in y direction

      After all linear systems are solved, the :math:`y`-aligned memory alignment is modified to the original :math:`x`-aligned one by transposing the matrix again:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: transpose y-aligned uy matrix to x-aligned matrix

4. Update :math:`\uy^k` to :math:`\uy^*`

   .. details:: Details

      Now the increment is ready, which is added to the velocity in :math:`y` direction :c-lang:`uy`:

      .. myliteralinclude:: /../../src/fluid/update_velocity.c
         :language: c
         :tag: update uy


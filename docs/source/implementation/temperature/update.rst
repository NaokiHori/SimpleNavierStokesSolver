
.. _temperature_update:

##################################################################################################################
`temperature/update.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/temperature/update.c>`_
##################################################################################################################

Update temperature from :math:`T^k` to :math:`T^{k+1}`.

See :ref:`the temporal discretisation <temporal_discretisation>` and :ref:`the spatial discretisation <spatial_discretisation>` for details.

***********************
temperature_update_temp
***********************

==========
Definition
==========

.. code-block:: c

   int temperature_update_temp(
       const param_t *param,
       const parallel_t *parallel,
       const fluid_t *fluid,
       temperature_t *temperature
   );

=========== ====== ==================
Name        intent description
=========== ====== ==================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in/out temperature
=========== ====== ==================

===========
Description
===========

Now we try to update the temperature field of the previous Runge-Kutta step :math:`T^k` to the new step :math:`T^{k+1}`, whose method is presented in :ref:`the temporal discretisation <temperature_integration>`.

Source terms in the right-hand-side (:math:`A^k` and :math:`D^k`) are computed:

.. myliteralinclude:: /../../src/temperature/update.c
   :language: c
   :tag: source terms of Runge-Kutta scheme are updated

which is followed by

.. myliteralinclude:: /../../src/temperature/update.c
   :language: c
   :tag: temperature field is updated

where the temperature field is updated.

For more information about these 2 functions, see below.

***********
compute_src
***********

==========
Definition
==========

.. code-block:: c

   static int compute_src(
       const param_t *param,
       const parallel_t *parallel,
       const fluid_t *fluid,
       temperature_t *temperature
   );

=========== ====== =======================================
Name        intent description
=========== ====== =======================================
param       in     general parameters
parallel    in     MPI parameters
fluid       in     velocity
temperature in/out temperature (in), source terms (in/out)
=========== ====== =======================================

===========
Description
===========

Compute source terms of the Runge-Kutta integration (:math:`A^k` and :math:`D^k`, see the equations above) of the internal energy equation.

First of all, :c-lang:`srctempa` (the last character **a** implies :math:`\alpha`), which contains the information of the previous Runge-Kutta step, is copied to :c-lang:`srctempb` (the last character **b** implies :math:`\beta`), so that new values can be assigned to :c-lang:`srctempa`:

.. myliteralinclude:: /../../src/temperature/update.c
   :language: c
   :tag: previous k-step source term of temp is copied

Then, all source terms are evaluated at each location where :c-lang:`T` is defined.

.. note::

   The spatial discretisations and their derivations are extensively discussed in the section :ref:`"thermal energy balance and quadratic quantity" <thermal_energy_balance>`.

   Hereafter, superscript :math:`k`, which denotes Runge-Kutta step and should be on all :math:`\ux` and :math:`T`, are dropped for notational simplicity.

1. Advective terms (:c-lang:`adv1`, :c-lang:`adv2`)

   .. math::
      - \dder{\ux \dintrpa{T}{x}}{x}
      - \dder{\uy \dintrpa{T}{y}}{y}

   1. :c-lang:`adv1`: Advection of :math:`T` by :math:`\ux`

      .. math::
         - \frac{
            \vat{\ux}{\pip, \pjc}
            \vat{\dintrpa{T}{x}}{\pip, \pjc}
            -
            \vat{\ux}{\pim, \pjc}
            \vat{\dintrpa{T}{x}}{\pim, \pjc}
         }{\Delta x_{\pic}}

      .. details:: Details

         :math:`\ux` can be used directly since they are defined at these locations, while :math:`T` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{T}{x}}{\pim,\pjc} & & = \frac{1}{2} \vat{T}{\pimm,\pjc } & & + \frac{1}{2} \vat{T}{\pic ,\pjc }, \\
               & \vat{\dintrpa{T}{x}}{\pip,\pjc} & & = \frac{1}{2} \vat{T}{\pic ,\pjc } & & + \frac{1}{2} \vat{T}{\pipp,\pjc }.
            \end{alignedat}

         The implementation leads

         .. myliteralinclude:: /../../src/temperature/update.c
            :language: c
            :tag: T is transported by ux

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update1.pdf
            :width: 800

         .. note::

            Recall that the boundary values of the temperature are defined on the walls.
            Strictly speaking, we should use these boundary values (:c-lang:`TEMP(0,j)` for :math:`\vat{T}{\frac{1}{2},j}`, :c-lang:`TEMP(itot+1,j)` for :math:`\vat{T}{\text{itot}+\frac{1}{2},j}`) directly instead of the interpolated values.

            Since impermeable walls :math:`\ux \equiv 0` are assumed, however, they give null eventually and thus we use the same notation for simplicity here.

   2. :c-lang:`adv2`: Advection of :math:`T` by :math:`\uy`

      .. math::
         - \frac{
            \vat{\uy}{\pic, \pjp}
            \vat{\dintrpa{T}{y}}{\pic, \pjp}
            -
            \vat{\uy}{\pic, \pjm}
            \vat{\dintrpa{T}{y}}{\pic, \pjm}
         }{\Delta y}

      .. details:: Details

         :math:`\uy` can be used directly since they are defined at these locations, while :math:`T` is interpolated as

         .. math::
            \begin{alignedat}{3}
               & \vat{\dintrpa{T}{y}}{\pic,\pjm} & & = \frac{1}{2} \vat{T}{\pic,\pjmm} & & + \frac{1}{2} \vat{T}{\pic,\pjc }, \\
               & \vat{\dintrpa{T}{y}}{\pic,\pjp} & & = \frac{1}{2} \vat{T}{\pic,\pjc } & & + \frac{1}{2} \vat{T}{\pic,\pjpp}.
            \end{alignedat}

         The implementation leads

         .. myliteralinclude:: /../../src/temperature/update.c
            :language: c
            :tag: T is transported by uy

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update2.pdf
            :width: 800

2. Diffusive terms (:c-lang:`dif1`, :c-lang:`dif2`)

   .. math::
      \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
         \dder{}{x} \left( \dder{T}{x} \right)
         +
         \dder{}{y} \left( \dder{T}{y} \right)
      \right\}

   1. :c-lang:`dif1`: Diffusion of :math:`T` in :math:`x` direction

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
              \vat{\dder{T}{x}}{\pip, \pjc}
            - \vat{\dder{T}{x}}{\pim, \pjc}
         }{\Delta x_{\pic}}

      .. details:: Details

         The differentiations lead

         .. math::
            \vat{\dder{T}{x}}{\pip, \pjc}
            & =
            \frac{
               \vat{T}{\pipp, \pjc}
               -
               \vat{T}{\pic,  \pjc}
            }{\Delta x_{\pip}}, \\
            \vat{\dder{T}{x}}{\pim, \pjc}
            & =
            \frac{
               \vat{T}{\pic,  \pjc}
               -
               \vat{T}{\pimm, \pjc}
            }{\Delta x_{\pim}}.

         The implementation leads

         .. myliteralinclude:: /../../src/temperature/update.c
            :language: c
            :tag: T is diffused in x

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update3.pdf
            :width: 800

         .. note::

            :c-lang:`DXC` already includes the boundary corrections (see :c-lang:`set_coordinate` in :ref:`src/param/init.c <param_init>` and :ref:`spatial discretisation <spatial_discretisation>`).

   2. :c-lang:`dif2`: Diffusion of :math:`T` in :math:`y` direction

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
              \vat{\dder{T}{y}}{\pic, \pjp}
            - \vat{\dder{T}{y}}{\pic, \pjm}
         }{\Delta y}

      .. details:: Details

         The differentiations lead

         .. math::
            \vat{\dder{T}{y}}{\pic, \pjp}
            & =
            \frac{
               \vat{T}{\pic, \pjpp}
               -
               \vat{T}{\pic, \pjc }
            }{\Delta y}, \\
            \vat{\dder{T}{y}}{\pic, \pjm}
            & =
            \frac{
               \vat{T}{\pic, \pjc }
               -
               \vat{T}{\pic, \pjmm}
            }{\Delta y}.

         The implementation leads

         .. myliteralinclude:: /../../src/temperature/update.c
            :language: c
            :tag: T is diffused in y

         :ref:`The domain setup <domain>` is described here again for convenience.

         .. image:: image/update4.pdf
            :width: 800

After all source terms are evaluated, they are assigned to the corresponding variable.

Terms which are treated explicitly are summed up to :c-lang:`srctempa`:

.. myliteralinclude:: /../../src/temperature/update.c
   :language: c
   :tag: summation of explicit terms

Advective terms (:c-lang:`adv1`, :c-lang:`adv2`) are involved here since they are always treated explicitly.

Diffusive terms are summed up here when treated explicitly (:c-lang:`implicitx` or :c-lang:`implicity` is :math:`0`), while are neglected here when treated implicitly (:c-lang:`implicitx` or :c-lang:`implicity` is :math:`1`).
Instead, they are summed up to :c-lang:`srctempg` when treated implicitly:

.. myliteralinclude:: /../../src/temperature/update.c
   :language: c
   :tag: summation of implicit terms

***********
update_temp
***********

==========
Definition
==========

.. code-block:: c

   static int update_temp(
       const param_t *param,
       const parallel_t *parallel,
       temperature_t *temperature
   );

=========== ====== ====================================
Name        intent description
=========== ====== ====================================
param       in     general parameters
parallel    in     MPI parameters
temperature in/out source terms (in), temperature (out)
=========== ====== ====================================

===========
Description
===========

New temperature :math:`T^{k+1}` is obtained by using the source terms computed in :c-lang:`compute_src`.

First of all, the increment of temperature :math:`\delta T \equiv T^{k+1} - T^{k}` is computed:

.. math::
   \delta T = \left(
        \alpha^k \mathcal{A}
      + \beta^k  \mathcal{B}
      + \gamma^k \mathcal{G}
   \right) \Delta t,

where :math:`\mathcal{A}`, :math:`\mathcal{B}`, and :math:`\mathcal{G}` are source terms which are already computed in :c-lang:`compute_src` and correspond to :c-lang:`srctempa`, :c-lang:`srctempb`, and :c-lang:`srctempg`, respectively.

As discussed in :ref:`the temporal discretisation <temperature_integration>`, the update process differs for different diffusive treatments.
When all diffusive terms are treated explicitly in time, we simply have

.. math::
   T^{k+1} = T^k + \delta T.

When the diffusive terms are partially treated implicitly (e.g., only :math:`x` direction), we have

.. math::
   T^{k+1} = T^k + \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta T,

where linear systems in :math:`x` direction needs to be solved before being added to :math:`T^k`.

When all diffusive terms are treated implicitly, we have

.. math::
   T^{k+1} = T^k + \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta T,

where linear systems in each direction should be solved before being added to :math:`T^k`.

Based on these relations, the updating procedure is as follows.

1. Compute :math:`\delta T`

   .. details:: Details

      The temperature increment :math:`\delta T` is computed and assigned to a variable :c-lang:`qx`:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: compute increment of T

2. Solve linear systems in :math:`x` direction (**only when** the diffusive term in :math:`x` direction is treated implicitly)

   .. details:: Details

      We consider

      .. math::
         \delta T^{\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right)^{-1} \delta T

      or in other words

      .. math::
         \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta x^2} \right) \delta T^{\prime}
         = \delta T^{\prime} - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2 \left( \delta T^{\prime} \right)}{\delta x^2}
         = \delta T.

      The second-order derivative of :math:`\delta T^{\prime}` in :math:`x` direction should be discretised with the same discrete operator used to compute the diffusive term, i.e.,

      .. math::
         \vat{\frac{\delta^2 \left( \delta T^{\prime} \right)}{\delta x^2}}{\pic, \pjc}
         = c_{\pimm} \vat{\left( \delta T^{\prime} \right)}{\pimm, \pjc}
         + c_{\pic } \vat{\left( \delta T^{\prime} \right)}{\pic , \pjc}
         + c_{\pipp} \vat{\left( \delta T^{\prime} \right)}{\pipp, \pjc},

      where

      .. math::
         c_{\pimm} & = \frac{1}{\Delta x_{\pic} \Delta x_{\pim}}, \\
         c_{\pipp} & = \frac{1}{\Delta x_{\pic} \Delta x_{\pip}}, \\
         c_{\pic } & = -c_{\pimm}-c_{\pipp}.

      .. image:: image/update5.pdf
         :width: 800

      Thus, the equation of :math:`\delta T^{\prime}` can be discretised as

      .. math::
         -            \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} c_{\pimm}         \vat{\left( \delta T^{\prime} \right)}{\pimm, \pjc}
         + \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} c_{\pic } \right) \vat{\left( \delta T^{\prime} \right)}{\pic , \pjc}
         -            \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} c_{\pipp}         \vat{\left( \delta T^{\prime} \right)}{\pipp, \pjc}
         = \vat{\delta T}{\pic, \pjc}.

      For simplicity, we write this as

      .. math::
           l_{\pic, \pjc} \vat{\delta T^{\prime}}{\pimm, \pjc}
         + c_{\pic, \pjc} \vat{\delta T^{\prime}}{\pic , \pjc}
         + u_{\pic, \pjc} \vat{\delta T^{\prime}}{\pipp, \pjc}
         = \vat{\delta T}{\pic, \pjc},

      which is implemented as:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: set diagonal components of the linear system in x direction

      This can be written as a linear system (whose size is :c-lang:`itot`) for each :math:`j` (:math:`j` is omitted for simplicity):

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
            \vat{\delta T^{\prime}}{\ia} \\
            \vat{\delta T^{\prime}}{\ib} \\
            \vat{\delta T^{\prime}}{\ic} \\
            \vdots                       \\
            \vat{\delta T^{\prime}}{\id} \\
            \vat{\delta T^{\prime}}{\ie} \\
            \vat{\delta T^{\prime}}{\if} \\
            \vdots                       \\
            \vat{\delta T^{\prime}}{\ig} \\
            \vat{\delta T^{\prime}}{\ih} \\
            \vat{\delta T^{\prime}}{\ii}
         \end{bmatrix}
         =
         \begin{bmatrix}
            \vat{\delta T}{\ia} \\
            \vat{\delta T}{\ib} \\
            \vat{\delta T}{\ic} \\
            \vdots              \\
            \vat{\delta T}{\id} \\
            \vat{\delta T}{\ie} \\
            \vat{\delta T}{\if} \\
            \vdots              \\
            \vat{\delta T}{\ig} \\
            \vat{\delta T}{\ih} \\
            \vat{\delta T}{\ii}
         \end{bmatrix},

      where the first matrix in the left-hand-side is the tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_.
      See :ref:`src/linalg.c <linalg>` for details.

      Since the coefficients are assigned, the linear system is ready to be solved:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: solve linear system in x direction

3. Solve linear systems in :math:`y` direction (**only when** the diffusive term in :math:`y` direction is treated implicitly)

   .. details:: Details

      We consider

      .. math::
         \delta T^{\prime\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta T^{\prime}.

      To do so, all :math:`y` values at each :math:`x` location should be contained by one processor.
      This is not the case since the domain is split in :math:`y` direction by default.
      Thus the matrix must be transposed beforehand, which is achieved as:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: transpose x-aligned matrix to y-aligned matrix

      Also see the schematic below for an intuitive understanding, where a domain whose sizes are :c-lang:`itot=7` and :c-lang:`jtot=11` is drawn:

      .. image:: image/update6.pdf
        :width: 800

      Here :c-lang:`qx` (left figure) is transposed to :c-lang:`qy` (right figure) and the alignment is modified to :math:`y` direction (note that memory is contiguous in :math:`y` direction after being transposed, which was contiguous in :math:`x` direction before).

      We consider

      .. math::
         \delta T^{\prime\prime} \equiv \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right)^{-1} \delta T^{\prime}

      or in other words

      .. math::
         \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2}{\delta y^2} \right) \delta T^{\prime\prime}
         = \delta T^{\prime\prime} - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} \frac{\delta^2 \left( \delta T^{\prime\prime} \right)}{\delta y^2}
         = \delta T^{\prime}.

      The second-order derivative of :math:`\delta T^{\prime\prime}` in :math:`y` direction should be discretised with the same discrete operator used to compute the diffusive term, i.e.,

      .. math::
         \vat{\frac{\delta^2 \left( \delta T^{\prime\prime} \right)}{\delta y^2}}{\pic, \pjc}
         = c_{\pjmm} \vat{\left( \delta T^{\prime\prime} \right)}{\pic, \pjmm}
         + c_{\pjc } \vat{\left( \delta T^{\prime\prime} \right)}{\pic, \pjc }
         + c_{\pjpp} \vat{\left( \delta T^{\prime\prime} \right)}{\pic, \pjpp},

      where

      .. math::
         c_{\pjmm} & = \frac{1}{\Delta y^2}, \\
         c_{\pjpp} & = \frac{1}{\Delta y^2}, \\
         c_{\pjc } & = -c_{\pjmm}-c_{\pjpp},

      .. image:: image/update7.pdf
         :width: 800

      Based on this, the equation of :math:`T^{\prime\prime}` can be discretised as

      .. math::
         -            \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} c_{\pjmm}         \vat{\delta T^{\prime\prime}}{\pic, \pjmm}
         + \left( 1 - \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} c_{\pjc } \right) \vat{\delta T^{\prime\prime}}{\pic, \pjc }
         -            \frac{\gamma^k \Delta t}{2 \sqrt{Pr} \sqrt{Ra}} c_{\pjpp}         \vat{\delta T^{\prime\prime}}{\pic, \pjpp}
         = \vat{\delta T^{\prime}}{\pic, \pjc},

      For simplicity, we write this as

      .. math::
           l_{\pic, \pjc} \vat{\delta T^{\prime\prime}}{\pic, \pjmm}
         + c_{\pic, \pjc} \vat{\delta T^{\prime\prime}}{\pic, \pjc }
         + u_{\pic, \pjc} \vat{\delta T^{\prime\prime}}{\pic, \pjpp}
         = \vat{\delta T^{\prime}}{\pic, \pjc},

      which is implemented as:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: set diagonal components of the linear system in y direction

      This can be written as a linear system (whose size is :c-lang:`jtot`) for each :math:`i` (:math:`i` is omitted for simplicity):

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
            \vat{\delta T^{\prime\prime}}{\ia} \\
            \vat{\delta T^{\prime\prime}}{\ib} \\
            \vat{\delta T^{\prime\prime}}{\ic} \\
            \vdots                             \\
            \vat{\delta T^{\prime\prime}}{\id} \\
            \vat{\delta T^{\prime\prime}}{\ie} \\
            \vat{\delta T^{\prime\prime}}{\if} \\
            \vdots                             \\
            \vat{\delta T^{\prime\prime}}{\ig} \\
            \vat{\delta T^{\prime\prime}}{\ih} \\
            \vat{\delta T^{\prime\prime}}{\ii}
         \end{bmatrix}
         =
         \begin{bmatrix}
            \vat{\delta T^{\prime}}{\ia} \\
            \vat{\delta T^{\prime}}{\ib} \\
            \vat{\delta T^{\prime}}{\ic} \\
            \vdots                       \\
            \vat{\delta T^{\prime}}{\id} \\
            \vat{\delta T^{\prime}}{\ie} \\
            \vat{\delta T^{\prime}}{\if} \\
            \vdots                       \\
            \vat{\delta T^{\prime}}{\ig} \\
            \vat{\delta T^{\prime}}{\ih} \\
            \vat{\delta T^{\prime}}{\ii}
         \end{bmatrix},

      where the first matrix in the left-hand-side is the modified (i.e., periodic boundary) tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_ with `Sherman–Morrison formula <https://en.wikipedia.org/wiki/Sherman–Morrison_formula>`_.
      See :ref:`src/linalg.c <linalg>` for details.

      Since the coefficients are assigned, the linear system is ready to be solved:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: solve linear system in y direction

      After all linear systems are solved, the :math:`y`-aligned memory alignment is modified to the original :math:`x`-aligned one by transposing the matrix again:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: transpose y-aligned matrix to x-aligned matrix

      .. note::
         Because of the two matrix transposes, MPI communications among all processors (the most expensive procedure in the code) are essential.
         In order to avoid unnecessary performance degenerations, the cost is evaluated in a function :ref:`param_estimate_cost <param_estimate_cost>`, where an optimal diffusive treatment is decided.

4. Update :math:`T^k` to :math:`T^{k+1}`

   .. details:: Details

      Now the increment is ready, which is added to the temperature :c-lang:`temp`:

      .. myliteralinclude:: /../../src/temperature/update.c
         :language: c
         :tag: update temperature


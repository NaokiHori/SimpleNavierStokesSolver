
.. _analyses:

##############################################################################################
`analyses.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/analyses.c>`_
##############################################################################################

Functions used to compute dissipation rates are included.

************************************
analyses_compute_kinetic_dissipation
************************************

==========
Definition
==========

.. code-block:: c

   double analyses_compute_kinetic_dissipation_x(
       const param_t *param,
       const fluid_t *fluid,
       const int i,
       const int j
   );

   double analyses_compute_kinetic_dissipation_y(
       const param_t *param,
       const fluid_t *fluid,
       const int i,
       const int j
   );

======== ====== ========================
Name     intent description
======== ====== ========================
param    in     general parameters
fluid    in     velocity
i, j     in     indices
data     out    kinetic dissipation rate
======== ====== ========================

===========
Description
===========

As being discussed in :ref:`the governing equations <governing_equations>`, instantaneous and local kinetic dissipation (in non-dimensional form) :math:`\epsilon_{k}` is given as

.. math::
   \epsilon_{k}
   =
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \der{u_i}{x_j} \der{u_i}{x_j}.

As being derived in :ref:`the discrete momentum balance and quadratic quantity <momentum_balance>`, the discrete form of :math:`\der{u_i}{x_j} \der{u_i}{x_j}`:

.. math::
   s_{xx} s_{xx}
   +
   s_{xy} s_{xy}
   +
   s_{yx} s_{yx}
   +
   s_{yy} s_{yy}

is twofold,

.. math::
   s_{xj} s_{xj}
   & =
   s_{xx} s_{xx}
   +
   s_{xy} s_{xy} \\
   & =
   \frac{1}{2}
   \frac{1}{\Delta x_{\xic}}
   \vat{
      \diffe{\ux}{x}
   }{\xip, \xjc}
   \vat{
      \dder{\ux}{x}
   }{\xip, \xjc}
   +
   \frac{1}{2}
   \frac{1}{\Delta x_{\xic}}
   \vat{
      \diffe{\ux}{x}
   }{\xim, \xjc}
   \vat{
      \dder{\ux}{x}
   }{\xim, \xjc} \\
   & +
   \frac{1}{2}
   \frac{1}{\Delta y}
   \vat{
      \diffe{\ux}{y}
   }{\xic, \xjp}
   \vat{
      \dder{\ux}{y}
   }{\xic, \xjp}
   +
   \frac{1}{2}
   \frac{1}{\Delta y}
   \vat{
      \diffe{\ux}{y}
   }{\xic, \xjm}
   \vat{
      \dder{\ux}{y}
   }{\xic, \xjm}

at :math:`\left( \xic, \xjc \right)`, and

.. math::
   s_{yj} s_{yj}
   & =
   s_{yx} s_{yx}
   +
   s_{yy} s_{yy} \\
   & =
   \vat{C}{\yip}
   \frac{1}{\Delta x_{\yic}}
   \vat{
      \diffe{\uy}{x}
   }{\yip, \yjc}
   \vat{
      \dder{\uy}{x}
   }{\yip, \yjc}
   +
   \vat{C}{\yim}
   \frac{1}{\Delta x_{\yic}}
   \vat{
      \diffe{\uy}{x}
   }{\yim, \yjc}
   \vat{
      \dder{\uy}{x}
   }{\yim, \yjc} \\
   & +
   \frac{1}{2}
   \frac{1}{\Delta y}
   \vat{
      \diffe{\uy}{y}
   }{\yic, \yjp}
   \vat{
      \dder{\uy}{y}
   }{\yic, \yjp}
   +
   \frac{1}{2}
   \frac{1}{\Delta y}
   \vat{
      \diffe{\uy}{y}
   }{\yic, \yjm}
   \vat{
      \dder{\uy}{y}
   }{\yic, \yjm}

at :math:`\left( \xic, \xjc \right)`, where :math:`\vat{C}{\pip}, \vat{C}{\pim}` are coefficients

.. math::
   &
   \vat{C}{\pip}
   =
   \begin{cases}
      \pip \text{is right wall} & 1 \\
      \text{otherwise}          & \frac{1}{2}
   \end{cases}, \\
   &
   \vat{C}{\pim}
   =
   \begin{cases}
      \pim \text{is left wall} & 1 \\
      \text{otherwise}         & \frac{1}{2}
   \end{cases}.

Contributions of :math:`\ux` and :math:`\uy` should be computed at different locations, which are taken care of by :c-lang:`analyses_compute_kinetic_dissipation_x`:

.. myliteralinclude:: /../../src/analyses.c
   :language: c
   :tag: kinetic dissipation rate (x-momentum contribution)

and :c-lang:`analyses_compute_kinetic_dissipation_y`:

.. myliteralinclude:: /../../src/analyses.c
   :language: c
   :tag: kinetic dissipation rate (y-momentum contribution)

respectively.

.. note::

   What we compute here is the integrand of

   .. math::
      \int \epsilon_k dV
      \approx
      \sum \color{red}{\epsilon_k} \Delta x \Delta y.

   Thus, in order to obtain volume-integrated value, we need to multiply the result by the cell size :math:`\Delta x \Delta y`.

************************************
analyses_compute_thermal_dissipation
************************************

==========
Definition
==========

.. code-block:: c

   int analyses_compute_thermal_dissipation(
       const param_t *param,
       const parallel_t *parallel,
       const fluid_t *fluid,
       double *data
   );

=========== ====== ========================
Name        intent description
=========== ====== ========================
param       in     general parameters
parallel    in     MPI parameters
temperature in     temperature
data        out    thermal dissipation rate
=========== ====== ========================

===========
Description
===========

As being discussed in :ref:`the governing equations <governing_equations>`, instantaneous and local thermal dissipation (in non-dimensional form) :math:`\epsilon_{h}` is given as

.. math::
   \epsilon_{h}
   =
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{T}{x_i} \der{T}{x_i}.

As being derived in :ref:`the thermal energy balance and quadratic quantity <thermal_energy_balance>`, the discrete form of :math:`\der{T}{x_i} \der{T}{x_i}`:

.. math::
   r_x r_x
   +
   r_y r_y

leads

.. math::
   &
   \vat{C}{\pip}
   \frac{1}{\Delta x_{\pic}}
   \vat{
      \diffe{T}{x}
   }{\pip, \pjc}
   \vat{
      \dder{T}{x}
   }{\pip, \pjc}
   +
   \vat{C}{\pim}
   \frac{1}{\Delta x_{\pic}}
   \vat{
      \diffe{T}{x}
   }{\pim, \pjc}
   \vat{
      \dder{T}{x}
   }{\pim, \pjc} \\
   + &
   \frac{1}{2}
   \frac{1}{\Delta y}
   \vat{
      \diffe{T}{y}
   }{\pic, \pjp}
   \vat{
      \dder{T}{y}
   }{\pic, \pjp}
   +
   \frac{1}{2}
   \frac{1}{\Delta y}
   \vat{
      \diffe{T}{y}
   }{\pic, \pjm}
   \vat{
      \dder{T}{y}
   }{\pic, \pjm},

where :math:`\vat{C}{\pip}, \vat{C}{\pim}` are coefficients

.. math::
   &
   \vat{C}{\pip}
   =
   \begin{cases}
      \pip \text{is right wall} & 1 \\
      \text{otherwise}          & \frac{1}{2}
   \end{cases}, \\
   &
   \vat{C}{\pim}
   =
   \begin{cases}
      \pim \text{is left wall} & 1 \\
      \text{otherwise}         & \frac{1}{2}
   \end{cases}.

The implementation leads

.. myliteralinclude:: /../../src/analyses.c
   :language: c
   :tag: thermal dissipation rate

.. note::

   What we compute here is the integrand of

   .. math::
      \int \epsilon_h dV
      \approx
      \sum \color{red}{\epsilon_h} \Delta x \Delta y.

   Thus, in order to obtain volume-integrated value, we need to multiply the result by the cell size :math:`\Delta x \Delta y`.


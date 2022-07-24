
.. _appendix_strong_conservation:

.. include:: /references.txt

################################################################
Appendix: General coordinate system and energy-conserving scheme
################################################################

.. note::

   Energy-conserving schemes are derived :ref:`here <discrete_governing_equations>`.
   In this appendix, we bring the same conclusion using the other way.

************
Introduction
************

Because of the staggered grid arrangement where velocities and pressure are defined at different positions, variables are not necessarily defined where we need, when we need to interpolate them.

When all variables are positioned equidistantly (uniform grid), interpolations of two quantities to the middle point is given by a simple arithmetic average and no ambiguity exist there, e.g.,

.. math::
   \vat{\dintrpa{q}{x}}{\pic, \pjc}
   =
   \frac{1}{2} \vat{q}{\pip, \pjc}
   +
   \frac{1}{2} \vat{q}{\pim, \pjc}.,

where :math:`\dintrpa{q}{x}` indicates the arithmetic average in :math:`x` direction using the surrounding two quantities.

When the grid is stretched (non-uniform grid), an intuitive way might be to use linear interpolations, which sometimes brings undesirable outcomes.
One of the most important properties which is influenced by that could be the conservation of the quadratic quantities :math:`k` and :math:`h`.

As discussed in :ref:`the governing equations <governing_equations>`, in the continuous level, the kinetic energy conservation is implicitly fulfilled in the inviscid limit as long as the mass and momentum balances are satisfied.
This relation, however, is easily destroyed when the equations are discretised without using appropriate interpolations (e.g., |MORINISHI1998|, |KAJISHIMA1999|, |HAM2002|).
As a result, the numerical solver continuously injects (or ejects) artificial energy through the advective terms, which can affect the stability of the solver and distort the physics behind.

In order to obtain a scheme which is mass-, momentum-, and energy-consistent, we investigate the continuous governing equations again.
The central idea is as follows.

.. note::
   Let's consider to transform the original governing equations to a new coordinate system.
   Since this is a pure mathematical operation, no error is involved.
   The new coordinate system is designed so that all discrete points are uniformly located, in which arithmetic averages can be used for *all* interpolations without ambiguity.

This appendix is twofold.

#. Derivation of the governing equations in a new coordinate system :math:`\xi_i`, so-called strong conservation form.

#. Discretisation of equations described in the new coordinate system.

************************
Strong conservation form
************************

.. details:: Derivations

   We consider to project the mass conservation, momentum balance, and the equation of the internal energy to a new coordinate system.

   For convenience, we take the incompressibility constraint

   .. math::
      \frac{\partial u_i}{\partial x_i}
      =
      \frac{\partial \ux}{\partial x}
      +
      \frac{\partial \uy}{\partial y}
      =
      0

   as an example.

   As a first step, we try to replace derivatives :math:`\partial / \partial x_i` with :math:`\partial / \partial \xi^i` as

   .. math::
      \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
      = \frac{\partial  \xi}{\partial x} \frac{\partial \ux}{\partial  \xi}
      + \frac{\partial \eta}{\partial x} \frac{\partial \ux}{\partial \eta}
      + \frac{\partial  \xi}{\partial y} \frac{\partial \uy}{\partial  \xi}
      + \frac{\partial \eta}{\partial y} \frac{\partial \uy}{\partial \eta}.

   Since this is not in a conservative form, we would like to make this conservative, i.e. :math:`\partial / \partial \xi^j \left( \cdots \right)`.

   The relation between the old and new coordinate systems is

   .. math::
      \begin{aligned}
        \begin{pmatrix}
          \frac{\partial}{\partial x} \\
          \frac{\partial}{\partial y}
        \end{pmatrix}
        =
        \begin{pmatrix}
          \frac{\partial \xi}{\partial x} & \frac{\partial \eta}{\partial x} \\
          \frac{\partial \xi}{\partial y} & \frac{\partial \eta}{\partial y}
        \end{pmatrix}
        \begin{pmatrix}
          \frac{\partial}{\partial  \xi} \\
          \frac{\partial}{\partial \eta}
        \end{pmatrix}
      \end{aligned}

   or

   .. math::
      \begin{aligned}
        \begin{pmatrix}
          \frac{\partial}{\partial  \xi} \\
          \frac{\partial}{\partial \eta}
        \end{pmatrix}
        =
        \begin{pmatrix}
          \frac{\partial x}{\partial  \xi} & \frac{\partial y}{\partial  \xi} \\
          \frac{\partial x}{\partial \eta} & \frac{\partial y}{\partial \eta}
        \end{pmatrix}
        \begin{pmatrix}
          \frac{\partial}{\partial x} \\
          \frac{\partial}{\partial y}
        \end{pmatrix}.
      \end{aligned}

   Since the second equation can be written as

   .. math::
      \begin{aligned}
        \begin{pmatrix}
          \frac{\partial}{\partial x} \\
          \frac{\partial}{\partial y}
        \end{pmatrix}
        =
        \frac{1}{\frac{\partial x}{\partial  \xi} \frac{\partial y}{\partial \eta} - \frac{\partial y}{\partial  \xi} \frac{\partial x}{\partial \eta}}
        \begin{pmatrix}
           \frac{\partial y}{\partial \eta} & -\frac{\partial x}{\partial \eta} \\
          -\frac{\partial y}{\partial  \xi} &  \frac{\partial x}{\partial  \xi}
        \end{pmatrix}
        \begin{pmatrix}
          \frac{\partial}{\partial  \xi} \\
          \frac{\partial}{\partial \eta}
        \end{pmatrix},
      \end{aligned}

   by comparing two relations, we find

   .. math::
      \newcommand{ \xx}{\frac{\partial    x}{\partial  \xi}}
      \newcommand{ \xy}{\frac{\partial    x}{\partial \eta}}
      \newcommand{ \yx}{\frac{\partial    y}{\partial  \xi}}
      \newcommand{ \yy}{\frac{\partial    y}{\partial \eta}}
      \newcommand{\xxi}{\frac{\partial  \xi}{\partial    x}}
      \newcommand{\xyi}{\frac{\partial \eta}{\partial    x}}
      \newcommand{\yxi}{\frac{\partial  \xi}{\partial    y}}
      \newcommand{\yyi}{\frac{\partial \eta}{\partial    y}}

   .. math::
        \frac{1}{\xx \yy - \xy \yx}
        \begin{pmatrix}
           \yy & -\xy \\
          -\yx &  \xx
        \end{pmatrix}
        =
        \begin{pmatrix}
          \xxi & \yxi \\
          \xyi & \yyi
        \end{pmatrix},

   where the denominator :math:`J \equiv \xx \yy - \xy \yx` is the determinant of the Jacobian matrix.

   As a result, the incompressibility constraint leads

   .. math::
      \begin{aligned}
        \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
        &= \xxi \frac{\partial \ux}{\partial  \xi}
         + \xyi \frac{\partial \ux}{\partial \eta}
         + \yxi \frac{\partial \uy}{\partial  \xi}
         + \yyi \frac{\partial \uy}{\partial \eta} \\
        &= \frac{1}{J} \yy \frac{\partial \ux}{\partial  \xi}
         - \frac{1}{J} \yx \frac{\partial \ux}{\partial \eta}
         - \frac{1}{J} \xy \frac{\partial \uy}{\partial  \xi}
         + \frac{1}{J} \xx \frac{\partial \uy}{\partial \eta}
       \end{aligned}

   Next, we consider to update the velocity, i.e., trying to write down the equation using the contravariant component :math:`U^i`.
   By assigning the relation

   .. math::
      \begin{pmatrix}
        \ux \\
        \uy
      \end{pmatrix}
      \equiv
      \begin{pmatrix}
        \frac{\partial x}{\partial t} \\
        \frac{\partial y}{\partial t}
      \end{pmatrix}
      =
      \begin{pmatrix}
        \xx & \xy \\
        \yx & \yy
      \end{pmatrix}
      \begin{pmatrix}
        \frac{\partial  \xi}{\partial t} \\
        \frac{\partial \eta}{\partial t}
      \end{pmatrix}
      =
      \begin{pmatrix}
        \xx & \xy \\
        \yx & \yy
      \end{pmatrix}
      \begin{pmatrix}
        U^x \\
        U^y
      \end{pmatrix}

   to the incompressibility constraint, we have

   .. math::
      \begin{aligned}
        &+ \frac{1}{J} \yy \frac{\partial}{\partial  \xi} \left( \xx U^x + \xy U^y \right) \\
        &- \frac{1}{J} \yx \frac{\partial}{\partial \eta} \left( \xx U^x + \xy U^y \right) \\
        &- \frac{1}{J} \xy \frac{\partial}{\partial  \xi} \left( \yx U^x + \yy U^y \right) \\
        &+ \frac{1}{J} \xx \frac{\partial}{\partial \eta} \left( \yx U^x + \yy U^y \right)
      \end{aligned}.

   Terms including :math:`U` are

   .. math::
      \begin{aligned}
        &+ \frac{1}{J} \yy \frac{\partial}{\partial  \xi} \left( \xx U^x \right) \\
        &- \frac{1}{J} \yx \frac{\partial}{\partial \eta} \left( \xx U^x \right) \\
        &- \frac{1}{J} \xy \frac{\partial}{\partial  \xi} \left( \yx U^x \right) \\
        &+ \frac{1}{J} \xx \frac{\partial}{\partial \eta} \left( \yx U^x \right)
      \end{aligned}
      =
      \begin{aligned}
        &+ \frac{U^x}{J} \yy \frac{\partial}{\partial  \xi} \left( \xx \right) + \frac{1}{J} \yy \frac{\partial U^x}{\partial  \xi} \xx \\
        &- \frac{U^x}{J} \yx \frac{\partial}{\partial \eta} \left( \xx \right) - \frac{1}{J} \yx \frac{\partial U^x}{\partial \eta} \xx \\
        &- \frac{U^x}{J} \xy \frac{\partial}{\partial  \xi} \left( \yx \right) - \frac{1}{J} \xy \frac{\partial U^x}{\partial  \xi} \yx \\
        &+ \frac{U^x}{J} \xx \frac{\partial}{\partial \eta} \left( \yx \right) + \frac{1}{J} \xx \frac{\partial U^x}{\partial \eta} \yx
      \end{aligned}
      \equiv
      \begin{aligned}
        &\left( 1-1 \right) + \left( 1-2 \right) \\
        &\left( 2-1 \right) + \left( 2-2 \right) \\
        &\left( 3-1 \right) + \left( 3-2 \right) \\
        &\left( 4-1 \right) + \left( 4-2 \right)
      \end{aligned},

   .. math::
      \left( 1-2 \right) + \left( 3-2 \right) =
      + \frac{1}{J} \yy \frac{\partial U^x}{\partial  \xi} \xx
      - \frac{1}{J} \xy \frac{\partial U^x}{\partial  \xi} \yx
      = \frac{1}{J} \left( \xx \yy - \xy \yx \right) \frac{\partial U^x}{\partial \xi}
      = \frac{1}{J} J \frac{\partial U^x}{\partial \xi},

   .. math::
      \left( 2-2 \right) + \left( 4-2 \right) =
      - \frac{1}{J} \yx \frac{\partial U^x}{\partial \eta} \xx
      + \frac{1}{J} \xx \frac{\partial U^x}{\partial \eta} \yx
      = 0,

   .. math::
      \begin{aligned}
        & \left( 1-1 \right) + \left( 2-1 \right) + \left( 3-1 \right) + \left( 4-1 \right)  \\
        & =
        + \frac{U^x}{J} \yy \frac{\partial}{\partial  \xi} \left( \xx \right)
        - \frac{U^x}{J} \yx \frac{\partial}{\partial \eta} \left( \xx \right)
        - \frac{U^x}{J} \xy \frac{\partial}{\partial  \xi} \left( \yx \right)
        + \frac{U^x}{J} \xx \frac{\partial}{\partial \eta} \left( \yx \right) \\
        & =
        + \frac{U^x}{J} \yy \frac{\partial}{\partial  \xi} \left( \xx \right)
        - \frac{U^x}{J} \yx \frac{\partial}{\partial  \xi} \left( \xy \right)
        - \frac{U^x}{J} \xy \frac{\partial}{\partial  \xi} \left( \yx \right)
        + \frac{U^x}{J} \xx \frac{\partial}{\partial  \xi} \left( \yy \right) \\
        & =
        \frac{U^x}{J} \left[
          + \xx \frac{\partial}{\partial  \xi} \left( \yy \right)
          + \yy \frac{\partial}{\partial  \xi} \left( \xx \right)
          - \xy \frac{\partial}{\partial  \xi} \left( \yx \right)
          - \yx \frac{\partial}{\partial  \xi} \left( \xy \right)
        \right] \\
        & =
        \frac{U^x}{J} \left[
          + \frac{\partial}{\partial  \xi} \left(
            \xx \yy
          \right)
          - \frac{\partial}{\partial  \xi} \left(
            \xy \yx
          \right)
        \right] \\
        & =
        \frac{U^x}{J} \frac{\partial}{\partial \xi} \left( \xx \yy - \xy \yx \right)
        = \frac{U^x}{J} \frac{\partial J}{\partial \xi},
      \end{aligned}

   and as a result

   .. math::
      \frac{1}{J} \frac{\partial}{\partial \xi} \left( J U^x \right).

   Similarly we notice the terms involving :math:`U^y` yields

   .. math::
      \frac{1}{J} \frac{\partial}{\partial \eta} \left( J U^y \right).

   Thus we have

   .. math::
      \frac{\partial u_i}{\partial x_i}
      =
      \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
      =
      \frac{1}{J} \frac{\partial}{\partial \xi^i} \left( J U^i \right)
      =
      0.

   Since

   .. math::
      \begin{pmatrix}
        U^x \\
        U^y
      \end{pmatrix}
      =
      \frac{1}{J}
      \begin{pmatrix}
         \yy & -\xy \\
        -\yx &  \xx
      \end{pmatrix}
      \begin{pmatrix}
        \ux \\
        \uy
      \end{pmatrix}
      =
      \begin{pmatrix}
        \xxi & \yxi \\
        \xyi & \yyi
      \end{pmatrix}
      \begin{pmatrix}
        \ux \\
        \uy
      \end{pmatrix}

   or

   .. math::
      U^j = \frac{\partial \xi^j}{\partial x_i} u_i,

   we finally obtain

   .. math::
      \frac{\partial u_i}{\partial x_i}
      =
      \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
      =
      \frac{1}{J} \frac{\partial}{\partial \xi^j} \left( J \frac{\partial \xi^j}{\partial x_i} u_i \right)
      =
      0,

   which is the conservative form of the incompressibility constraint in the new coordinate system (strong conservation form).

   By comparing the second term with the third one, we notice

   .. math::
      \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
      =
      \frac{1}{J} \left\{ \frac{\partial}{\partial \xi^j} \left( J \frac{\partial \xi^j}{\partial x_i} \right) \right\} u_i
      + \frac{1}{J} J \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
      =
      \frac{1}{J} \left\{ \frac{\partial}{\partial \xi^j} \left( J \frac{\partial \xi^j}{\partial x_i} \right) \right\} u_i
      + \frac{\partial \xi^j}{\partial x_i} \frac{\partial u_i}{\partial \xi^j}
      =
      0,

   and thus we find an important identity

   .. math::
      \frac{1}{J} \left\{ \frac{\partial}{\partial \xi^j} \left( J \frac{\partial \xi^j}{\partial x_i} \right) \right\} u_i = 0.

   By following the same procedure as above, we notice that this relation even holds for general tensors (not limited to first-order tensors), which can be used to derive the strong conservation forms of the momentum and internal energy balances.

   .. note::
      Since the current projection keeps the original orthogonal relations, the Jacobian matrix is a diagonal matrix.
      Thus, :math:`\der{\xi^j}{x_i}` can be reduced to :math:`\der{\xi^i}{x_i}`.

******************************
Continuous governing equations
******************************

Non-dimensional governing equations shown in :ref:`the governing equations <governing_equations>` are described as

.. math::
   \left\{
      \begin{alignedat}{2}
         & \frac{1}{J} \der{}{\xi^i} \left( J \der{\xi^i}{x_i} u_i \right) = 0, \\
         & \der{u_i}{t}
         + \frac{1}{J} \der{}{\xi^j} \left\{ \left( J \der{\xi^j}{x_j} u_j \right) u_i \right\}
         =
         - \frac{1}{J} \der{}{\xi^i} \left( J \der{\xi^i}{x_i} p \right)
         + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} \der{u_i}{\xi^j} \right)
         + T \delta_{ix}, \\
         & \der{k}{t}
         + \frac{1}{J} \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) \left( k + p \right) \right\}
         =
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} u_i \der{u_i}{\xi^j} \right)
         - \frac{\sqrt{Pr}}{\sqrt{Ra}} \mst{i}{i} \der{u_i}{\xi^j} \der{u_i}{\xi^j}
         + u_i T \delta_{ix}, \\
         & \der{T}{t}
         + \frac{1}{J} \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) T \right\}
         = \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J} \der{}{\xi^i} \left( \mst{i}{i} \der{T}{\xi^i} \right), \\
         & \der{h}{t}
         + \frac{1}{J} \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) h \right\}
         =
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J} \der{}{\xi^i} \left( \mst{i}{i} T \der{T}{\xi^i} \right)
         - \frac{1}{\sqrt{Pr} \sqrt{Ra}} \mst{i}{i} \der{T}{\xi^j} \der{T}{\xi^j}
      \end{alignedat}
   \right.

in strong conservation forms.
Note that :math:`\mst{i}{j} = J \der{\xi^i}{x_k} \der{\xi^j}{x_k}` is the mesh skewness tensor.

****************************
Discrete governing equations
****************************

The above continuous governing equations are directly discretised based on the following notes.
For simplicity equations which are not treated numerically are omitted.

.. note::

   * Since the new cooridnate system is designed to satisfy :math:`\Delta \xi \equiv \Delta \eta \equiv 1`, interpolations and differentiations are given as arithmetic averages and subtractions of two neighbouring points, respectively.

   * Jacobian and scaling factors should be interpolated as well as variables.

   * Mesh skewness tensors lead

      .. math::
         \mst{x}{x} = \frac{\Delta y}{\Delta x},
         \mst{y}{y} = \frac{\Delta x}{\Delta y}.

The incompressibility constraint evaluated at :math:`\left( \pic, \pjc \right)`:

.. math::
   \frac{
       \vat{\ux}{\pip,\pjc}
     - \vat{\ux}{\pim,\pjc}
   }{\Delta x_{\pic}}
   + \frac{
       \vat{\uy}{\pic,\pjp}
     - \vat{\uy}{\pic,\pjm}
   }{\Delta y_{\pjc}}
   = 0.

The equation of momentum balance in :math:`x` direction evaluated at :math:`\left( \xic, \xjc \right)`:

.. math::
   \begin{aligned}
     \der{\vat{\ux}{\xic,\xjc}}{t}
     =
     & - \frac{
         \vat{\intrp{\Delta y \ux}{\gx}}{\xip,\xjc} \vat{\intrp{\ux}{\gx}}{\xip,\xjc}
       - \vat{\intrp{\Delta y \ux}{\gx}}{\xim,\xjc} \vat{\intrp{\ux}{\gx}}{\xim,\xjc}
     }{\Delta x_{\xic} \Delta y_{\xjc}} \\
     & - \frac{
         \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjp} \vat{\intrp{\ux}{\gy}}{\xic,\xjp}
       - \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjm} \vat{\intrp{\ux}{\gy}}{\xic,\xjm}
     }{\Delta x_{\xic} \Delta y_{\xjc}} \\
     & -\frac{
         \vat{\Delta y p}{\xip,\xjc}
       - \vat{\Delta y p}{\xim,\xjc}
     }{\Delta x_{\xic} \Delta y_{\xjc}} \\
     & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
         \vat{\frac{\Delta y}{\Delta x} \diffe{\ux}{\gx}}{\xip,\xjc}
       - \vat{\frac{\Delta y}{\Delta x} \diffe{\ux}{\gx}}{\xim,\xjc}
     }{\Delta x_{\xic} \Delta y_{\xjc}} \\
     & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
         \vat{\frac{\Delta x}{\Delta y} \diffe{\ux}{\gy}}{\xic,\xjp}
       - \vat{\frac{\Delta x}{\Delta y} \diffe{\ux}{\gy}}{\xic,\xjm}
     }{\Delta x_{\xic} \Delta y_{\xjc}} \\
     & + \vat{\intrp{T}{\gx}}{\xic,\xjc}.
   \end{aligned}

The equation of momentum balance in :math:`y` direction evaluated at :math:`\left( \yic, \yjc \right)`:

.. math::
   \begin{aligned}
     \der{\vat{\uy}{\yic,\yjc}}{t}
     =
     & - \frac{
         \vat{\intrp{\Delta y \ux}{\gy}}{\yip,\yjc} \vat{\intrp{\uy}{\gx}}{\yip,\yjc}
       - \vat{\intrp{\Delta y \ux}{\gy}}{\yim,\yjc} \vat{\intrp{\uy}{\gx}}{\yim,\yjc}
     }{\Delta x_{\yic} \Delta y_{\yjc}} \\
     & - \frac{
         \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjp} \vat{\intrp{\uy}{\gy}}{\yic,\yjp}
       - \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjm} \vat{\intrp{\uy}{\gy}}{\yic,\yjm}
     }{\Delta x_{\yic} \Delta y_{\yjc}} \\
     & -\frac{
         \vat{\Delta x p}{\yic,\yjp}
       - \vat{\Delta x p}{\yic,\yjm}
     }{\Delta x_{\yic} \Delta y_{\yjc}} \\
     & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
         \vat{\frac{\Delta y}{\Delta x} \diffe{\uy}{\gx}}{\yip,\yjc}
       - \vat{\frac{\Delta y}{\Delta x} \diffe{\uy}{\gx}}{\yim,\yjc}
     }{\Delta x_{\yic} \Delta y_{\yjc}} \\
     & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
         \vat{\frac{\Delta x}{\Delta y} \diffe{\uy}{\gy}}{\yic,\yjp}
       - \vat{\frac{\Delta x}{\Delta y} \diffe{\uy}{\gy}}{\yic,\yjm}
     }{\Delta x_{\yic} \Delta y_{\yjc}}.
   \end{aligned}

The equation of internal energy evaluated at :math:`\left( \pic, \pjc \right)`:

.. math::
   \begin{aligned}
     \der{\vat{T}{\pic,\pjc}}{t}
     =
     & - \frac{
         \vat{\Delta y \ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
       - \vat{\Delta y \ux}{\pim,\pjc} \vat{\intrp{T}{\gx}}{\pim,\pjc}
     }{\Delta x_{\pic} \Delta y_{\pjc}} \\
     & - \frac{
         \vat{\Delta x \uy}{\pic,\pjp} \vat{\intrp{T}{\gy}}{\pic,\pjp}
       - \vat{\Delta x \uy}{\pic,\pjm} \vat{\intrp{T}{\gy}}{\pic,\pjm}
     }{\Delta x_{\pic} \Delta y_{\pjc}} \\
     & + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
         \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
       - \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pim,\pjc}
     }{\Delta x_{\pic} \Delta y_{\pjc}} \\
     & + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
         \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjp}
       - \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjm}
     }{\Delta x_{\pic} \Delta y_{\pjc}}.
   \end{aligned}

************************
Nusselt number relations
************************

================
Continuous level
================

.. details:: Details

   By multiplying the momentum balance with :math:`u_i` (i.e., taking the inner product), we have

   .. math::
      \begin{aligned}
         u_i \der{u_i}{t} &
         + u_i \frac{1}{J} \der{}{\xi^j} \left\{ \left( J \der{\xi^j}{x_j} u_j \right) u_i \right\}
         + u_i \frac{1}{J} \der{}{\xi^i} \left( J \der{\xi^i}{x_i} p \right) \\ &
         - u_i \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} \der{u_i}{\xi^j} \right)
         - u_i f_i
         = 0.
      \end{aligned}

   Each term can be written differently:

   1. Temporal derivative

      .. math::
         u_i \der{u_i}{t} = \der{}{t} \left( u_i u_i \right) - \der{u_i}{t} u_i

      and thus

      .. math::
         u_i \der{u_i}{t} = \der{k}{t},

      where :math:`k \equiv \frac{1}{2} u_i u_i`.

   2. Advection

      .. math::
         \frac{1}{J} \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) k \right\}.

   3. Pressure gradient

      .. math::
           \frac{1}{J} \der{}{\xi^i} \left( J \der{\xi^i}{x_i} u_i p \right)
         - p \frac{1}{J} \der{}{\xi^i} \left( J \der{\xi^i}{x_i} u_i \right),

      where the second term vanishes because of the incompressibility constraint.

   4. Viscosity

      .. math::
         - \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} u_i \der{u_i}{\xi^j} \right)
         + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \mst{j}{j} \der{u_i}{\xi^j} \der{u_i}{\xi^j}.

   5. Body force

      This term remains as it is.

   In summary, we have the equation of the kinetic energy balance as

   .. math::
      \begin{aligned}
         \der{k}{t} &
         + \frac{1}{J} \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) k \right\}
         + \frac{1}{J} \der{}{\xi^i} \left( J \der{\xi^i}{x_i} u_i p \right) \\ &
         - \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} u_i \der{u_i}{\xi^j} \right)
         + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \mst{j}{j} \der{u_i}{\xi^j} \der{u_i}{\xi^j}
         - u_i f_i
         = 0.
      \end{aligned}

   Similarly, by multiplying the equation of the internal energy by :math:`T`, we obtain

   .. math::
      \begin{aligned}
         \der{h}{t} &
         + \frac{1}{J} \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) h \right\}
         - \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} T \der{T}{\xi^j} \right) \\ &
         + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J} \mst{j}{j} \der{T}{\xi^j} \der{T}{\xi^j}
         = 0,
      \end{aligned}

   where :math:`h \equiv \frac{1}{2} T^2`.

   Now we discuss the evolution of the total energies.
   The total kinetic energy inside the domain :math:`K` is

   .. math::
      \int k dx dy

   in the original coordinate system, while

   .. math::
      \int k J d\gx d\gy

   in the transformed coordinate system.

   The governing equation with respect to :math:`K` can be obtained by integrating the equation of :math:`k` inside the domain:

   .. math::
      \der{K}{t} &
      + \int \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) k \right\} d\gx d\gy
      + \int \der{}{\xi^i} \left( J \der{\xi^i}{x_i} u_i p \right) d\gx d\gy \\ &
      - \int \frac{\sqrt{Pr}}{\sqrt{Ra}} \der{}{\xi^j} \left( \mst{j}{j} u_i \der{u_i}{\xi^j} \right) d\gx d\gy
      + \int \frac{\sqrt{Pr}}{\sqrt{Ra}} \mst{j}{j} \der{u_i}{\xi^j} \der{u_i}{\xi^j} d\gx d\gy \\ &
      - \int J u_i f_i d\gx d\gy
      = 0.

   Regarding the second, third, and fourth terms, the integrated values are determined solely by the boundary fluxes because of the divergence theorem.
   In Rayleigh-Bénard systems we consider in this project, periodic boundary conditions or impermeable and no-slip walls (:math:`u_i = 0`) are assumed, when all these terms vanish.
   Thus we have

   .. math::
      \der{K}{t}
      + \int \frac{\sqrt{Pr}}{\sqrt{Ra}} \mst{j}{j} \der{u_i}{\xi^j} \der{u_i}{\xi^j} d\gx d\gy
      - \int J u_i f_i d\gx d\gy
      = 0.

   When the system reaches the statistically-steady state :math:`\ave{\partial K / \partial t}{t} = 0`, we notice that the energy injection by the body force is exactly balanced by the viscous dissipation.

   An analogous relation can be derived for :math:`H = \int h dx dy = \int h J d\gx d\gy`:

   .. math::
      \der{H}{t} &
      + \int \der{}{\xi^i} \left\{ \left( J \der{\xi^i}{x_i} u_i \right) h \right\} d\gx d\gy \\ &
      - \int \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{}{\xi^j} \left( \mst{j}{j} T \der{T}{\xi^j} \right) d\gx d\gy
      + \int \frac{1}{\sqrt{Pr} \sqrt{Ra}} \mst{j}{j} \der{T}{\xi^j} \der{T}{\xi^j} d\gx d\gy
      = 0.

   The second term vanishes because of the divergence theorem again.
   Regarding the third term, it remains here since the thermal energy is continuously injected by the conduction (:math:`\partial T / \partial y`) through the walls.
   This injection is exactly dissipated by the last term in a statistical sense.

==============
Discrete level
==============

.. details:: Details

   .. note::
      We assume that :math:`x` direction is the wall-normal direction, while :math:`y` direction is the homogeneous direction.
      In the implementation, uniform grid spacings are assumed in :math:`y` direction (:math:`\Delta y_j \equiv \Delta y`).
      For generality, however, we here take into account the grid size variations also in :math:`y` direction.

   The discretised governing equations in strong conservation forms are as follows.

   Incompressibility constraint at cell center :math:`\left( i, j \right)`:

   .. math::
        \frac{\vat{\ux}{\pip,\pjc}-\vat{\ux}{\pim,\pjc}}{\Delta x_{\pic}}
      + \frac{\vat{\uy}{\pic,\pjp}-\vat{\uy}{\pic,\pjm}}{\Delta y_{\pjc}}
      = 0.

   Momentum balance in :math:`x` direction at cell face :math:`\left( \xic, \xjc \right)` (:math:`\ux` are defined):

   .. math::
      \begin{aligned}
        \der{\vat{\ux}{\xic,\xjc}}{t}
        =
        & - \frac{
            \vat{\intrp{\Delta y \ux}{\gx}}{\xip,\xjc} \vat{\intrp{\ux}{\gx}}{\xip,\xjc}
          - \vat{\intrp{\Delta y \ux}{\gx}}{\xim,\xjc} \vat{\intrp{\ux}{\gx}}{\xim,\xjc}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & - \frac{
            \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjp} \vat{\intrp{\ux}{\gy}}{\xic,\xjp}
          - \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjm} \vat{\intrp{\ux}{\gy}}{\xic,\xjm}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & -\frac{
            \vat{\Delta y p}{\xip,\xjc}
          - \vat{\Delta y p}{\xim,\xjc}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta y}{\Delta x} \diffe{\ux}{\gx}}{\xip,\xjc}
          - \vat{\frac{\Delta y}{\Delta x} \diffe{\ux}{\gx}}{\xim,\xjc}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta x}{\Delta y} \diffe{\ux}{\gy}}{\xic,\xjp}
          - \vat{\frac{\Delta x}{\Delta y} \diffe{\ux}{\gy}}{\xic,\xjm}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & + \vat{\intrp{T}{\gx}}{\xic,\xjc}.
      \end{aligned}

   Momentum balance in :math:`y` direction at cell face :math:`\left( \yic, \yjc \right)` (:math:`\uy` are defined):

   .. math::
      \begin{aligned}
        \der{\vat{\uy}{\yic,\yjc}}{t}
        =
        & - \frac{
            \vat{\intrp{\Delta y \ux}{\gy}}{\yip,\yjc} \vat{\intrp{\uy}{\gx}}{\yip,\yjc}
          - \vat{\intrp{\Delta y \ux}{\gy}}{\yim,\yjc} \vat{\intrp{\uy}{\gx}}{\yim,\yjc}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & - \frac{
            \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjp} \vat{\intrp{\uy}{\gy}}{\yic,\yjp}
          - \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjm} \vat{\intrp{\uy}{\gy}}{\yic,\yjm}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & -\frac{
            \vat{\Delta x p}{\yic,\yjp}
          - \vat{\Delta x p}{\yic,\yjm}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta y}{\Delta x} \diffe{\uy}{\gx}}{\yip,\yjc}
          - \vat{\frac{\Delta y}{\Delta x} \diffe{\uy}{\gx}}{\yim,\yjc}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta x}{\Delta y} \diffe{\uy}{\gy}}{\yic,\yjp}
          - \vat{\frac{\Delta x}{\Delta y} \diffe{\uy}{\gy}}{\yic,\yjm}
        }{\Delta x_{\yic} \Delta y_{\yjc}}.
      \end{aligned}

   Equation of internal energy balance at cell center :math:`\left( \pic, \pjc \right)` (:math:`p,T` are defined):

   .. math::
      \begin{aligned}
        \der{\vat{T}{\pic,\pjc}}{t}
        =
        & - \frac{
            \vat{\Delta y \ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
          - \vat{\Delta y \ux}{\pim,\pjc} \vat{\intrp{T}{\gx}}{\pim,\pjc}
        }{\Delta x_{\pic} \Delta y_{\pjc}} \\
        & - \frac{
            \vat{\Delta x \uy}{\pic,\pjp} \vat{\intrp{T}{\gy}}{\pic,\pjp}
          - \vat{\Delta x \uy}{\pic,\pjm} \vat{\intrp{T}{\gy}}{\pic,\pjm}
        }{\Delta x_{\pic} \Delta y_{\pjc}} \\
        & + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
            \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
          - \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pim,\pjc}
        }{\Delta x_{\pic} \Delta y_{\pjc}} \\
        & + \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
            \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjp}
          - \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjm}
        }{\Delta x_{\pic} \Delta y_{\pjc}}.
      \end{aligned}

   Based on these equations, we consider the energy balances *after being discretised*.

   We consider to multiply the momentum balance equation in :math:`x` direction by :math:`\vat{\ux}{\xic,\xjc}`, yielding

   .. math::
      \begin{aligned}
        \vat{\ux}{\xic,\xjc} \der{\vat{\ux}{\xic,\xjc}}{t}
        =
        & - \vat{\ux}{\xic,\xjc} \frac{
            \vat{\intrp{\Delta y \ux}{\gx}}{\xip,\xjc} \vat{\intrp{\ux}{\gx}}{\xip,\xjc}
          - \vat{\intrp{\Delta y \ux}{\gx}}{\xim,\xjc} \vat{\intrp{\ux}{\gx}}{\xim,\xjc}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & - \vat{\ux}{\xic,\xjc} \frac{
            \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjp} \vat{\intrp{\ux}{\gy}}{\xic,\xjp}
          - \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjm} \vat{\intrp{\ux}{\gy}}{\xic,\xjm}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & - \vat{\ux}{\xic,\xjc} \frac{
            \vat{\Delta y p}{\xip,\xjc}
          - \vat{\Delta y p}{\xim,\xjc}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & + \vat{\ux}{\xic,\xjc} \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta y}{\Delta x} \diffe{\ux}{\gx}}{\xip,\xjc}
          - \vat{\frac{\Delta y}{\Delta x} \diffe{\ux}{\gx}}{\xim,\xjc}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & + \vat{u}{\xic,\xjc} \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta x}{\Delta y} \diffe{\ux}{\gy}}{\xic,\xjp}
          - \vat{\frac{\Delta x}{\Delta y} \diffe{\ux}{\gy}}{\xic,\xjm}
        }{\Delta x_{\xic} \Delta y_{\xjc}} \\
        & + \vat{\ux}{\xic,\xjc} \vat{\intrp{T}{\gx}}{\xic,\xjc}.
      \end{aligned}

   Similarly, the momentum balance in :math:`y` direction is multiplied by :math:`\vat{\uy}{\yic,\yjc}`:

   .. math::
      \begin{aligned}
        \vat{\uy}{\yic,\yjc} \der{\vat{\uy}{\yic,\yjc}}{t}
        =
        & - \vat{\uy}{\yic,\yjc} \frac{
            \vat{\intrp{\Delta y \ux}{\gy}}{\yip,\yjc} \vat{\intrp{\uy}{\gx}}{\yip,\yjc}
          - \vat{\intrp{\Delta y \ux}{\gy}}{\yim,\yjc} \vat{\intrp{\uy}{\gx}}{\yim,\yjc}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & - \vat{\uy}{\yic,\yjc} \frac{
            \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjp} \vat{\intrp{\uy}{\gy}}{\yic,\yjp}
          - \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjm} \vat{\intrp{\uy}{\gy}}{\yic,\yjm}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & - \vat{\uy}{\yic,\yjc} \frac{
            \vat{\Delta x p}{\yic,\yjp}
          - \vat{\Delta x p}{\yic,\yjm}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & + \vat{\uy}{\yic,\yjc} \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta y}{\Delta x} \diffe{\uy}{\gx}}{\yip,\yjc}
          - \vat{\frac{\Delta y}{\Delta x} \diffe{\uy}{\gx}}{\yim,\yjc}
        }{\Delta x_{\yic} \Delta y_{\yjc}} \\
        & + \vat{\uy}{\yic,\yjc} \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{
            \vat{\frac{\Delta x}{\Delta y} \diffe{\uy}{\gy}}{\yic,\yjp}
          - \vat{\frac{\Delta x}{\Delta y} \diffe{\uy}{\gy}}{\yic,\yjm}
        }{\Delta x_{\yic} \Delta y_{\yjc}}.
      \end{aligned}

   The left-hand-side terms give the change of :math:`1/2 \ux^2` and :math:`1/2 \uy^2` in time, which are obviously relevant to the discrete kinetic energy.

   Also the equation of the squared temperature leads

   .. math::
      \begin{aligned}
        \vat{T}{\pic,\pjc} \der{\vat{T}{\pic,\pjc}}{t}
        =
        & - \vat{T}{\pic,\pjc} \frac{
            \vat{\Delta y \ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
          - \vat{\Delta y \ux}{\pim,\pjc} \vat{\intrp{T}{\gx}}{\pim,\pjc}
        }{\Delta x_{\pic} \Delta y_{\pjc}} \\
        & - \vat{T}{\pic,\pjc} \frac{
            \vat{\Delta x \uy}{\pic,\pjp} \vat{\intrp{T}{\gy}}{\pic,\pjp}
          - \vat{\Delta x \uy}{\pic,\pjm} \vat{\intrp{T}{\gy}}{\pic,\pjm}
        }{\Delta x_{\pic} \Delta y_{\pjc}} \\
        & + \vat{T}{\pic,\pjc} \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
            \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
          - \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pim,\pjc}
        }{\Delta x_{\pic} \Delta y_{\pjc}} \\
        & + \vat{T}{\pic,\pjc} \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
            \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjp}
          - \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjm}
        }{\Delta x_{\pic} \Delta y_{\pjc}}.
      \end{aligned}

   * Discrete energy conservation (inviscid limit)

      First we consider the case without viscosity (:math:`Ra / Pr \rightarrow \infty`) and buoyancy, when the kinetic energy should be conserved physically since there are no sources nor sinks.
      Even after being discretised, this property should be kept.
      In this part, we derive this; namely, the advective and pressure gradient terms do nothing for the energy increase/decrease.

      Since velocity components are located at different positions, kinetic energy cannot be defined uniquely.
      Here, we compute the squared velocities (:math:`\ux^2` and :math:`\uy^2`) separately at positions where they are defined.

      In :math:`x` direction, the advection terms at :math:`\left( \xic, \xjc \right)` lead

      .. math::
         \begin{aligned}
            & - \frac{
                \vat{\intrp{\Delta y \ux}{\gx}}{\xip,\xjc} \frac{\vat{\ux}{\xipp,\xjc } \vat{\ux}{\xic ,\xjc }}{2}
              - \vat{\intrp{\Delta y \ux}{\gx}}{\xim,\xjc} \frac{\vat{\ux}{\xic ,\xjc } \vat{\ux}{\ximm,\xjc }}{2}
            }{\Delta x_{\xic} \Delta y_{\xjc}} \\
            & - \frac{
                \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjp} \frac{\vat{\ux}{\xic ,\xjpp} \vat{\ux}{\xic ,\xjc }}{2}
              - \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjm} \frac{\vat{\ux}{\xic ,\xjc } \vat{\ux}{\xic ,\xjmm}}{2}
            }{\Delta x_{\xic} \Delta y_{\xjc}} \\
            & - \frac{\vat{\ux^2}{\xic,\xjc}}{2} \frac{
                 \vat{\intrp{\Delta y \ux}{\gx}}{\xip,\xjc}
               - \vat{\intrp{\Delta y \ux}{\gx}}{\xim,\xjc}
               + \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjp}
               - \vat{\intrp{\Delta x \uy}{\gx}}{\xic,\xjm}
            }{\Delta x_{\xic} \Delta y_{\xjc}} \\
            & = \\
            & -\frac{1}{J_{\xic,\xjc}} \left\{ \diffe{}{\gx} \left(
               \intrp{\Delta y \ux}{\gx} \frac{{\widehat{\ux^2}}^{\gx}}{2}
            \right) \right\}_{\xic,\xjc}
            - \frac{1}{J_{\xic,\xjc}} \left\{ \diffe{}{\gy} \left(
               \intrp{\Delta x \uy}{\gx} \frac{{\widehat{\ux^2}}^{\gy}}{2}
            \right) \right\}_{\xic,\xjc} \\
            & - \frac{\vat{u^2}{\xic,\xjc}}{2} \frac{1}{J_{\xic,\xjc}} \left\{
               \frac{J_{\xim,\xjc}}{2} \left(
                 \frac{
                     \vat{\ux}{\xic, \xjc}
                   - \vat{\ux}{\ximm,\xjc}
                 }{\Delta x_{\xim}}
                 + \frac{
                     \vat{\uy}{\xim,\xjp}
                   - \vat{\uy}{\xim,\xjm}
                 }{\Delta y_{\xjc}}
               \right)
               + \frac{J_{\xip,\xjc}}{2} \left(
                 \frac{
                     \vat{\ux}{\xipp,\xjc}
                   - \vat{\ux}{\xic, \xjc}
                 }{\Delta x_{\xip}}
                 + \frac{
                     \vat{\uy}{\xip,\xjp}
                   - \vat{\uy}{\xip,\xjm}
                 }{\Delta y_{\xjc}}
               \right)
            \right\},
         \end{aligned}

      while in :math:`y` direction at :math:`\left( \yic, \yjc \right)`, we have

      .. math::
         \begin{aligned}
            & - \frac{
                \vat{\intrp{\Delta y \ux}{\gy}}{\yip,\yjc} \frac{\vat{\uy}{\yipp,\yjc } \vat{\uy}{\yic, \yjc }}{2}
              - \vat{\intrp{\Delta y \ux}{\gy}}{\yim,\yjc} \frac{\vat{\uy}{\yic ,\yjc } \vat{\uy}{\yimm,\yjc }}{2}
            }{\Delta x_{\yic} \Delta y_{\yjc}} \\
            & - \frac{
                \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjp} \frac{\vat{\uy}{\yic ,\yjpp} \vat{\uy}{\yic ,\yjc }}{2}
              - \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjm} \frac{\vat{\uy}{\yic ,\yjc } \vat{\uy}{\yic ,\yjmm}}{2}
            }{\Delta x_{\yic} \Delta y_{\yjc}} \\
            & - \frac{\vat{v^2}{\yic,\yjc}}{2} \frac{
                 \vat{\intrp{\Delta y \ux}{\gy}}{\yip,\yjc}
               - \vat{\intrp{\Delta y \ux}{\gy}}{\yim,\yjc}
               + \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjp}
               - \vat{\intrp{\Delta x \uy}{\gy}}{\yic,\yjm}
            }{\Delta x_{\yic} \Delta y_{\yjc}} \\
            & = \\
            & -\frac{1}{J_{\yic,\yjc}} \left\{ \diffe{}{\gx} \left(
               \intrp{\Delta y \ux}{\gx} \frac{{\widehat{\uy^2}}^{\gx}}{2}
            \right) \right\}_{\yic,\yjc}
            - \frac{1}{J_{\yic,\yjc}} \left\{ \diffe{}{\gy} \left(
               \intrp{\Delta x \uy}{\gx} \frac{{\widehat{\uy^2}}^{\gy}}{2}
            \right) \right\}_{\yic,\yjc} \\
            & - \frac{\vat{\uy^2}{\yic,\yjc}}{2} \frac{1}{J_{\yic,\yjc}} \left\{
               \frac{J_{\yic,\yjm}}{2} \left(
                 \frac{
                     \vat{\ux}{\yim,\yjm}
                   - \vat{\ux}{\yip,\yjm}
                 }{\Delta x_{\yic}}
                 + \frac{
                     \vat{\uy}{\yic,\yjmm}
                   - \vat{\uy}{\yic,\yjc }
                 }{\Delta y_{\yjm}}
               \right)
               + \frac{J_{\yic,\yjp}}{2} \left(
                 \frac{
                     \vat{\ux}{\yim,\yjp}
                   - \vat{\ux}{\yip,\yjp}
                 }{\Delta x_{\yic}}
                 + \frac{
                     \vat{\uy}{\yic,\yjpp}
                   - \vat{\uy}{\yic,\yjc }
                 }{\Delta y_{\yjp}}
               \right)
            \right\}.
         \end{aligned}

      Note that the last terms are the volumetric averages of incompressibility constraints, giving null.

      Here new symbols are introduced (quadratic quantities, which are the pseudo kinetic energies):

      .. math::
         \begin{aligned}
           & \vat{\widehat{\ux^2}^{\gx}}{\xip,\xjc} \equiv \vat{\ux}{\xic,\xjc} \vat{\ux}{\xipp,\xjc }, \\
           & \vat{\widehat{\ux^2}^{\gy}}{\xic,\xjp} \equiv \vat{\ux}{\xic,\xjc} \vat{\ux}{\xic ,\xjpp},
         \end{aligned}

      in :math:`x` direction, while

      .. math::
         \begin{aligned}
           & \vat{\widehat{\uy^2}^{\gx}}{\yip,\yjc} \equiv \vat{\uy}{\yic,\yjc} \vat{v}{\yipp,\yjc }, \\
           & \vat{\widehat{\uy^2}^{\gy}}{\yic,\yjp} \equiv \vat{\uy}{\yic,\yjc} \vat{v}{\yic ,\yjpp},
         \end{aligned}

      in :math:`y` direction.

      The pressure gradient terms remain as they are, and the other terms are null now since we consider the inviscid limit :math:`Ra / Pr \rightarrow \infty` and the buoyancy forcing is decoupled.

      Now we integrate and sum up these two equations in the whole domain (surface integral).
      The surface integral of a quantity :math:`q`

      .. math::
         \int q dx dy = \int q J d\gx d\gy

      is discretised as

      .. math::
         \sum q_{i,j} \Delta x_i \Delta y_j = \sum q_{i,j} J_{i,j} \Delta \gx_i \Delta \gy_j = \sum q_{i,j} J_{i,j} \,\,\, \left( \because \Delta \gx_i \equiv \Delta \gy_j \equiv 1 \right).

      Thus :math:`\der{K}{t}`, which is the evolution of the **total** (global) discrete kinetic energy :math:`K`, is given as the sum of

      .. math::
         \sum_{\forall \ux \text{positions}, \left( \xic, \xjc \right)} \der{}{t} \left( \frac{1}{2} J \ux^2 \right)_{\xic,\xjc}
         \equiv
         \sum_{\forall \ux \text{positions}, \left( \xic, \xjc \right)}
         \left[
            \begin{aligned}
               & - \left\{ \diffe{}{\gx} \left(
                  \intrp{\Delta y \ux}{\gx} \frac{{\widehat{\ux^2}}^{\gx}}{2}
               \right) \right\}_{\xic,\xjc} \\
               & - \left\{ \diffe{}{\gy} \left(
                  \intrp{\Delta x \uy}{\gx} \frac{{\widehat{\ux^2}}^{\gy}}{2}
               \right) \right\}_{\xic,\xjc} \\
               & - \vat{\ux}{\xic,\xjc} \Delta y_{\xjc} \left(
                   \vat{p}{\xip,\xjc}
                 - \vat{p}{\xim,\xjc}
               \right) \\
            \end{aligned}
         \right]

      and

      .. math::
         \sum_{\forall \uy \text{positions}, \left( \yic, \yjc \right)} \der{}{t} \left( \frac{1}{2} J \uy^2 \right)_{\yic,\yjc}
         \equiv
         \sum_{\forall \uy \text{positions}, \left( \yic, \yjc \right)}
         \left[
            \begin{aligned}
               & - \left\{ \diffe{}{\gx} \left(
                  \intrp{\Delta y \ux}{\gx} \frac{{\widehat{\uy^2}}^{\gx}}{2}
               \right) \right\}_{\yic,\yjc} \\
               & - \left\{ \diffe{}{\gy} \left(
                  \intrp{\Delta x \uy}{\gx} \frac{{\widehat{\uy^2}}^{\gy}}{2}
               \right) \right\}_{\yic,\yjc} \\
               & - \vat{\uy}{\yic,\yjc} \Delta x_{\yic} \left(
                   \vat{p}{\yic,\yjp}
                 - \vat{p}{\yic,\yjm}
               \right) \\
            \end{aligned}
         \right].

      In each summation, the first two terms vanish because of their conservative forms, i.e., the values cancel out to each other for neighbouring cells and we have periodic boundaries and impermeable walls (:math:`u_i = 0`) at the edges.

      Regarding the pressure gradient terms, they can be re-ordered as

      .. math::
           \sum_{\forall p \text{positions}, \left( \pic, \pjc \right)} \vat{p}{\pic,\pjc} \Delta y_j \left( \vat{\ux}{\pip,\pjc} - \vat{\ux}{\pim,\pjc} \right)
         + \sum_{\forall p \text{positions}, \left( \pic, \pjc \right)} \vat{p}{\pic,\pjc} \Delta x_i \left( \vat{\uy}{\pic,\pjp} - \vat{\uy}{\pic,\pjm} \right),

      which is

      .. math::
         \sum_{\forall p \text{positions}, \left( \pic, \pjc \right)} \vat{p J}{\pic,\pjc} \left(
             \frac{\vat{\ux}{\pip,\pjc} - \vat{\ux}{\pim,\pjc}}{\Delta x_i}
           + \frac{\vat{\uy}{\pic,\pjp} - \vat{\uy}{\pic,\pjm}}{\Delta y_j}
         \right),

      and thus null because of the incompressibility constraint.

      Similarly, the advection terms of the internal energy equation leads

      .. math::
         \begin{aligned}
            & - \frac{
                \vat{\left( \Delta y \ux \right)}{\pip,\pjc} \frac{\vat{T}{\pic ,\pjc } \vat{T}{\pipp,\pjc }}{2}
              - \vat{\left( \Delta y \ux \right)}{\pim,\pjc} \frac{\vat{T}{\pimm,\pjc } \vat{T}{\pic ,\pjc }}{2}
            }{\Delta x_{\pic} \Delta y_{\pjc}} \\
            & - \frac{
                \vat{\left( \Delta x \uy \right)}{\pic,\pjp} \frac{\vat{T}{\pic ,\pjc } \vat{T}{\pic ,\pjpp}}{2}
              - \vat{\left( \Delta x \uy \right)}{\pic,\pjm} \frac{\vat{T}{\pic ,\pjmm} \vat{T}{\pic ,\pjc }}{2}
            }{\Delta x_{\pic} \Delta y_{\pjc}} \\
            & - \frac{\vat{T^2}{\pic,\pjc}}{2} \left(
               \frac{
                   \vat{\Delta y \ux}{\pip,\pjc}
                 - \vat{\Delta y \ux}{\pim,\pjc}
               }{\Delta x_{\pic} \Delta y_{\pjc}}
               + \frac{
                   \vat{\Delta x \uy}{\pic,\pjp}
                 - \vat{\Delta x \uy}{\pic,\pjm}
               }{\Delta x_{\pic} \Delta y_{\pjc}}
            \right) \\
            & = \\
            & - \frac{1}{J_{\pic,\pjc}} \left\{ \diffe{}{\gx} \left( \Delta y \ux \frac{\widehat{T^2}^{\gx}}{2} \right) \right\}_{\pic,\pjc}
              - \frac{1}{J_{\pic,\pjc}} \left\{ \diffe{}{\gy} \left( \Delta x \uy \frac{\widehat{T^2}^{\gy}}{2} \right) \right\}_{\pic,\pjc} \\
            & - \frac{\vat{T^2}{\pic,\pjc}}{2} \left(
               \frac{
                   \vat{\ux}{\pip,\pjc}
                 - \vat{\ux}{\pim,\pjc}
               }{\Delta x_{\pic}}
               + \frac{
                   \vat{\uy}{\pic,\pjp}
                 - \vat{\uy}{\pic,\pjm}
               }{\Delta y_{\pjc}}
            \right),
         \end{aligned}

      where the last term is null because of the incompressibility constraint.
      The first two terms are in conservative forms and thus do not contribute to the change in the total :math:`T^2`.
      Note that similar quadratic quantities are defined:

      .. math::
         \begin{aligned}
           \vat{\widehat{T^2}^{\gx}}{\pip,\pjc} = \vat{T}{\pic,\pjc} \vat{T}{\pipp,\pjc}, \\
           \vat{\widehat{T^2}^{\gy}}{\pic,\pjp} = \vat{T}{\pic,\pjc} \vat{T}{\pic,\pjpp}.
         \end{aligned}

      In conclusion, we notice that the current advective and pressure gradient schemes do not contribute to the changes in the total energies (:math:`K` and :math:`H`), i.e., the current discretisations are indeed energy-conserving.

   * Viscous dissipation and its discretisation

      Regarding the terms contributing to the momentum diffusion, through the analyses in the continuous level, we already found that this term can be decomposed into two terms, 1. transportation and 2. dissipation of the kinetic energy; the latter is an important factor when computing the kinetic energy dissipation rate (and Nusselt number).
      In order to obtain a consistent discretisation, we follow the same procedure here, i.e., in the continuous level, the viscous dissipation arising from the momentum equation in :math:`x` direction is given as

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \mst{j}{j} \der{\ux}{\xi^j} \der{\ux}{\xi^j}
         = \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} \ux \der{\ux}{\xi^j} \right)
         - \ux \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} \der{\ux}{\xi^j} \right).

      This relation is directly discretised:

      .. math::
         \begin{aligned}
             &   \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left\{
                 \vat{\left( \mst{x}{x} \intrp{\ux}{\gx} \right) \diffe{\ux}{\gx}}{\xip,\xjc}
               - \vat{\left( \mst{x}{x} \intrp{\ux}{\gx} \right) \diffe{\ux}{\gx}}{\xim,\xjc}
             \right\}
               + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left\{
                 \vat{\left( \mst{y}{y} \intrp{\ux}{\gy} \right) \diffe{\ux}{\gy}}{\xic,\xjp}
               - \vat{\left( \mst{y}{y} \intrp{\ux}{\gy} \right) \diffe{\ux}{\gy}}{\xic,\xjm}
             \right\} \\
             & - \vat{\ux}{\xic,\xjc} \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left\{
                 \vat{\left( \mst{x}{x} \diffe{\ux}{\gx} \right)}{\xip,\xjc}
               - \vat{\left( \mst{x}{x} \diffe{\ux}{\gx} \right)}{\xim,\xjc}
             \right\}
               - \vat{\ux}{\xic,\xjc} \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left\{
                 \vat{\left( \mst{y}{y} \diffe{\ux}{\gy} \right)}{\xic,\xjp}
               - \vat{\left( \mst{y}{y} \diffe{\ux}{\gy} \right)}{\xic,\xjm}
             \right\} \\
             =
             & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left( \vat{\intrp{\ux}{\gx}}{\xip,\xjc} - \vat{\ux}{\xic,\xjc} \right) \vat{\left( \mst{x}{x} \diffe{\ux}{\gx} \right)}{\xip,\xjc}
               - \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left( \vat{\intrp{\ux}{\gx}}{\xim,\xjc} - \vat{\ux}{\xic,\xjc} \right) \vat{\left( \mst{x}{x} \diffe{\ux}{\gx} \right)}{\xim,\xjc} \\
             & + \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left( \vat{\intrp{\ux}{\gy}}{\xic,\xjp} - \vat{\ux}{\xic,\xjc} \right) \vat{\left( \mst{y}{y} \diffe{\ux}{\gy} \right)}{\xic,\xjp}
               - \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left( \vat{\intrp{\ux}{\gy}}{\xic,\xjm} - \vat{\ux}{\xic,\xjc} \right) \vat{\left( \mst{y}{y} \diffe{\ux}{\gy} \right)}{\xic,\xjm}.
         \end{aligned}

      Since we have

      .. math::
         \begin{aligned}
           & \vat{\intrp{\ux}{\gx}}{\xip,\xjc} - \vat{\ux}{\xic,\xjc}
             = \frac{\vat{\ux}{\xipp,\xjc} + \vat{\ux}{\xic ,\xjc}}{2} - \vat{\ux}{\xic,\xjc}
             = + \frac{\vat{\ux}{\xipp,\xjc} - \vat{\ux}{\xic ,\xjc}}{2}
             = + \frac{1}{2} \vat{\diffe{\ux}{\gx}}{\xip,\xjc} \\
           & \vat{\intrp{\ux}{\gx}}{\xim,\xjc} - \vat{\ux}{\xic,\xjc}
             = \frac{\vat{\ux}{\xic ,\xjc} + \vat{\ux}{\ximm,\xjc}}{2} - \vat{\ux}{\xic,\xjc}
             = - \frac{\vat{\ux}{\xic ,\xjc} - \vat{\ux}{\ximm,\xjc}}{2}
             = - \frac{1}{2} \vat{\diffe{\ux}{\gx}}{\xim,\xjc} \\
           & \vat{\intrp{\ux}{\gy}}{\xic,\xjp} - \vat{\ux}{\xic,\xjc}
             = \frac{\vat{\ux}{\xic,\xjpp} + \vat{\ux}{\xic,\xjc }}{2} - \vat{\ux}{\xic,\xjc}
             = + \frac{\vat{\ux}{\xic,\xjpp} - \vat{\ux}{\xic,\xjc }}{2}
             = + \frac{1}{2} \vat{\diffe{\ux}{\gy}}{\xic,\xjp} \\
           & \vat{\intrp{\ux}{\gy}}{\xic,\xjm} - \vat{\ux}{\xic,\xjc}
             = \frac{\vat{\ux}{\xic,\xjc } + \vat{\ux}{\xic,\xjmm}}{2} - \vat{\ux}{\xic,\xjc}
             = - \frac{\vat{\ux}{\xic,\xjc } - \vat{\ux}{\xic,\xjmm}}{2}
             = - \frac{1}{2} \vat{\diffe{\ux}{\gy}}{\xic,\xjm}
         \end{aligned}

      in the bulk, we finally notice that the viscous dissipation arising from the momentum equation in :math:`x` direction leads

      .. math::
         \begin{aligned}
            & \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left[
               \frac{
                   \vat{\left\{ \mst{x}{x} \left( \diffe{\ux}{\gx} \right)^2 \right\}}{\xip,\xjc}
                 + \vat{\left\{ \mst{x}{x} \left( \diffe{\ux}{\gx} \right)^2 \right\}}{\xim,\xjc}
               }{2}
               + \frac{
                   \vat{\left\{ \mst{y}{y} \left( \diffe{\ux}{\gy} \right)^2 \right\}}{\xic,\xjp}
                 + \vat{\left\{ \mst{y}{y} \left( \diffe{\ux}{\gy} \right)^2 \right\}}{\xic,\xjm}
               }{2}
            \right] \\
            =
            & \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\xic,\xjc}} \left\{
                 \frac{1}{2} J_{\xip,\xjc} \left( \vat{\frac{\diffe{\ux}{\gx}}{\Delta x}}{\xip,\xjc} \right)^2
               + \frac{1}{2} J_{\xim,\xjc} \left( \vat{\frac{\diffe{\ux}{\gx}}{\Delta x}}{\xim,\xjc} \right)^2
               + \frac{1}{2} J_{\xic,\xjp} \left( \vat{\frac{\diffe{\ux}{\gy}}{\Delta y}}{\xic,\xjp} \right)^2
               + \frac{1}{2} J_{\xic,\xjm} \left( \vat{\frac{\diffe{\ux}{\gy}}{\Delta y}}{\xic,\xjm} \right)^2
            \right\}
         \end{aligned}

      at :math:`\left( \xic, \xjc \right).`

      Following a similar manner, by using the relation

      .. math::
         \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \mst{j}{j} \der{\uy}{\xi^j} \der{\uy}{\xi^j}
         = \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} \uy \der{\uy}{\xi^j} \right)
         - \uy \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J} \der{}{\xi^j} \left( \mst{j}{j} \der{\uy}{\xi^j} \right),

      we can derive the viscous dissipation coming from the momentum equation in :math:`y` direction as

      .. math::
         \begin{aligned}
            & \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\yic,\yjc}} \left[
               \frac{
                   \vat{\left\{ \mst{x}{x} \left( \diffe{\uy}{\gx} \right)^2 \right\}}{\yip,\yjc}
                 + \vat{\left\{ \mst{x}{x} \left( \diffe{\uy}{\gx} \right)^2 \right\}}{\yim,\yjc}
               }{2}
               + \frac{
                   \vat{\left\{ \mst{y}{y} \left( \diffe{\uy}{\gy} \right)^2 \right\}}{\yic,\yjp}
                 + \vat{\left\{ \mst{y}{y} \left( \diffe{\uy}{\gy} \right)^2 \right\}}{\yic,\yjm}
               }{2}
            \right] \\
            =
            & \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{1}{J_{\yic,\yjc}} \left\{
                 \frac{1}{2} J_{\yip,\yjc} \left( \vat{\frac{\diffe{\uy}{\gx}}{\Delta x}}{\yip,\yjc} \right)^2
               + \frac{1}{2} J_{\yim,\yjc} \left( \vat{\frac{\diffe{\uy}{\gx}}{\Delta x}}{\yim,\yjc} \right)^2
               + \frac{1}{2} J_{\yic,\yjp} \left( \vat{\frac{\diffe{\uy}{\gy}}{\Delta y}}{\yic,\yjp} \right)^2
               + \frac{1}{2} J_{\yic,\yjm} \left( \vat{\frac{\diffe{\uy}{\gy}}{\Delta y}}{\yic,\yjm} \right)^2
            \right\}
         \end{aligned}

      at :math:`\left( \yic, \yjc \right).`

      .. note::
         For :math:`y` velocities, in the vicinity of the walls, the coefficient :math:`1/2` should be corrected to unity since :math:`\uy` is defined exactly on the walls.
         See :ref:`src/logging.c <logging>` for details.

      Similar analyses can be made for :math:`T^2`.
      The local thermal energy dissipation :math:`\dfrac{1}{J} \mst{i}{i} \der{T}{\gx^i} \der{T}{\gx^i}` in the continuous level is given as

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J} \der{}{\gx^i} \left( \mst{i}{i} T \der{T}{\gx^i} \right)
         -
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J} T \der{}{\xi^i} \left( \mst{i}{i} \der{T}{\gx^i} \right).

      The first conservative term is discretised as

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \left\{
             \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\pip,\pjc}
           - \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\pim,\pjc}
         \right\}
         +
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \left\{
             \vat{\left( \mst{y}{y} T \diffe{T}{\gy} \right)}{\pic,\pjp}
           - \vat{\left( \mst{y}{y} T \diffe{T}{\gy} \right)}{\pic,\pjm}
         \right\},

      while the other term leads

      .. math::
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \vat{T}{\pic,\pjc} \left\{
             \vat{\left( \mst{x}{x} \diffe{T}{\gx} \right)}{\pip,\pjc}
           - \vat{\left( \mst{x}{x} \diffe{T}{\gx} \right)}{\pim,\pjc}
         \right\}
         +
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \vat{T}{\pic,\pjc} \left\{
             \vat{\left( \mst{y}{y} \diffe{T}{\gy} \right)}{\pic,\pjp}
           - \vat{\left( \mst{y}{y} \diffe{T}{\gy} \right)}{\pic,\pjm}
         \right\}.

      Since

      .. math::
         \begin{aligned}
           & + \vat{\left( \intrp{T}{\gx} \diffe{T}{\gx} \right)}{\pip,\pjc} - \vat{T}{\pic,\pjc} \vat{\diffe{T}{\gx}}{\pip,\pjc} = \left( + \vat{\intrp{T}{\gx}}{\pip,\pjc} - \vat{T}{\pic,\pjc} \right) \vat{\diffe{T}{\gx}}{\pip,\pjc} = \frac{1}{2} \vat{\left( \diffe{T}{\gx} \right)^2}{\pip,\pjc}, \\
           & - \vat{\left( \intrp{T}{\gx} \diffe{T}{\gx} \right)}{\pim,\pjc} + \vat{T}{\pic,\pjc} \vat{\diffe{T}{\gx}}{\pim,\pjc} = \left( - \vat{\intrp{T}{\gx}}{\pim,\pjc} + \vat{T}{\pic,\pjc} \right) \vat{\diffe{T}{\gx}}{\pim,\pjc} = \frac{1}{2} \vat{\left( \diffe{T}{\gx} \right)^2}{\pim,\pjc}, \\
           & + \vat{\left( \intrp{T}{\gy} \diffe{T}{\gy} \right)}{\pic,\pjp} - \vat{T}{\pic,\pjc} \vat{\diffe{T}{\gy}}{\pic,\pjp} = \left( + \vat{\intrp{T}{\gy}}{\pic,\pjp} - \vat{T}{\pic,\pjc} \right) \vat{\diffe{T}{\gy}}{\pic,\pjp} = \frac{1}{2} \vat{\left( \diffe{T}{\gy} \right)^2}{\pic,\pjp}, \\
           & - \vat{\left( \intrp{T}{\gy} \diffe{T}{\gy} \right)}{\pic,\pjm} + \vat{T}{\pic,\pjc} \vat{\diffe{T}{\gy}}{\pic,\pjm} = \left( - \vat{\intrp{T}{\gy}}{\pic,\pjm} + \vat{T}{\pic,\pjc} \right) \vat{\diffe{T}{\gy}}{\pic,\pjm} = \frac{1}{2} \vat{\left( \diffe{T}{\gy} \right)^2}{\pic,\pjm},
         \end{aligned}

      the difference of these two terms is

      .. math::
         \begin{aligned}
            & \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \left[
               \frac{
                   \vat{\left\{ \mst{x}{x} \left( \diffe{T}{\gx} \right)^2 \right\}}{\pip,\pjc}
                 + \vat{\left\{ \mst{x}{x} \left( \diffe{T}{\gx} \right)^2 \right\}}{\pim,\pjc}
               }{2}
               +
               \frac{
                   \vat{\left\{ \mst{y}{y} \left( \diffe{T}{\gy} \right)^2 \right\}}{\pic,\pjp}
                 + \vat{\left\{ \mst{y}{y} \left( \diffe{T}{\gy} \right)^2 \right\}}{\pic,\pjm}
               }{2}
            \right] \\
            =
            & \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \left\{
                 \frac{1}{2} J_{\pip,\pjc} \left( \vat{\frac{\diffe{T}{\gx}}{\Delta x}}{\pip,\pjc} \right)^2
               + \frac{1}{2} J_{\pim,\pjc} \left( \vat{\frac{\diffe{T}{\gx}}{\Delta x}}{\pim,\pjc} \right)^2
               + \frac{1}{2} J_{\pic,\pjp} \left( \vat{\frac{\diffe{T}{\gy}}{\Delta y}}{\pic,\pjp} \right)^2
               + \frac{1}{2} J_{\pic,\pjm} \left( \vat{\frac{\diffe{T}{\gy}}{\Delta y}}{\pic,\pjm} \right)^2
            \right\},
         \end{aligned}

      which is the local thermal energy dissipation rate.

      .. note::
         In the vicinity of the walls, the coefficient :math:`1/2` should be corrected to unity since :math:`T` is defined exactly on the walls.

************************
Nusselt number relations
************************

.. details:: Details

   Nusselt number, which is the non-dimensional number telling the heat transfer enhancement (:math:`Nu = 1` when no flow exists), is defined as the thermal conduction at the walls:

   .. math::
      Nu
      \equiv
      - \ave{\vat{\der{T}{x}}{\text{wall}}}{y,t}
      =
      - \ave{\frac{\int \vat{\der{T}{x}}{\text{wall}} dy}{\int dy}}{t}
      =
      - \ave{\frac{\int \der{\gx}{x} \vat{\der{T}{\gx}}{\text{wall}} \der{y}{\gy} d\gy}{\int \der{y}{\gy} d\gy}}{t}.

   After being discretised, we have

   .. math::
      - \ave{\frac{\sum_j \frac{1}{\Delta x_{\text{wall}}} \vat{\diffe{T}{\gx}}{\text{wall}} \Delta y_j }{\sum_j \Delta y_j}}{t}
      =
      - \frac{1}{l_y} \ave{\sum_j \frac{1}{\Delta x_{\text{wall}}} \vat{\diffe{T}{\gx}}{\text{wall}} \Delta y_j}{t},

   where :math:`l_y` is the domain size in :math:`y` direction.

   In this part, we find three additional relations which hold in Rayleigh-Bénard systems.

   1. Heat flux

      .. details:: Details

         We consider to average the equation of the internal energy balance:

         .. math::
            \begin{aligned}
              \der{\vat{T}{\pic,\pjc}}{t}
              & + \frac{
                  \vat{\Delta y \ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
                - \vat{\Delta y \ux}{\pim,\pjc} \vat{\intrp{T}{\gx}}{\pim,\pjc}
              }{\Delta x_{\pic} \Delta y_{\pjc}} \\
              & + \frac{
                  \vat{\Delta x \uy}{\pic,\pjp} \vat{\intrp{T}{\gy}}{\pic,\pjp}
                - \vat{\Delta x \uy}{\pic,\pjm} \vat{\intrp{T}{\gy}}{\pic,\pjm}
              }{\Delta x_{\pic} \Delta y_{\pjc}} \\
              & - \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
                  \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
                - \vat{\frac{\Delta y}{\Delta x} \diffe{T}{\gx}}{\pim,\pjc}
              }{\Delta x_{\pic} \Delta y_{\pjc}} \\
              & - \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{
                  \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjp}
                - \vat{\frac{\Delta x}{\Delta y} \diffe{T}{\gy}}{\pic,\pjm}
              }{\Delta x_{\pic} \Delta y_{\pjc}} = 0
            \end{aligned}

         in :math:`y` direction and in time.

         In the physical domain :math:`\left( x, y \right)`, integrating a quantity :math:`q` in :math:`y` direction is written as

         .. math::
            \int q dy,

         which is

         .. math::
            \int q \der{y}{\gy} d\gy

         in the computational domain :math:`\left( \gx, \gy \right)`.
         When being discretised, it is

         .. math::
            \sum_j q_j \Delta y_j.

         Based on this relation, we consider to average the equation of the internal energy balance.

         The first term vanishes since we are interested in the statistically-steady state.

         The third and fifth terms lead

         .. math::
            \sum_j \left(
                \vat{\uy}{\pic,\pjp} \vat{\intrp{T}{\gy}}{\pic,\pjp}
              - \vat{\uy}{\pic,\pjm} \vat{\intrp{T}{\gy}}{\pic,\pjm}
            \right)

         and

         .. math::
            \sum_j - \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left(
                \vat{\frac{1}{\Delta y} \diffe{T}{\gy}}{\pic,\pjp}
              - \vat{\frac{1}{\Delta y} \diffe{T}{\gy}}{\pic,\pjm}
            \right),

         which are null because of the periodicity in :math:`y` direction.

         Thus we have

         .. math::
            \begin{aligned}
               & \frac{1}{l_y} \sum_{\pjc} \frac{\Delta y_{\pjc}}{\Delta x_{\pic}} \left\{
                  \left(
                      \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
                    - \vat{\ux}{\pim,\pjc} \vat{\intrp{T}{\gx}}{\pim,\pjc}
                  \right)
               \right\} \\
               & = \frac{1}{l_y} \sum_{\pjc} \frac{\Delta y_{\pjc}}{\Delta x_{\pic}} \left\{
                  \frac{1}{\sqrt{Pr} \sqrt{Ra}}
                  \left(
                      \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
                    - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pim,\pjc}
                  \right)
               \right\}.
            \end{aligned}

         Now we integrate this relation in :math:`x` direction (:math:`\int q dx \approx \sum_i q_i \Delta x_i`) to a specific position :math:`i = i`, yielding

         .. math::
            \begin{aligned}
               & \frac{1}{l_y} \sum_{\pic = 1}^{I} \sum_{\pjc} \Delta y_{\pjc} \left\{
                  \sqrt{Pr} \sqrt{Ra} \left(
                      \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
                    - \vat{\ux}{\pim,\pjc} \vat{\intrp{T}{\gx}}{\pim,\pjc}
                  \right)
                  - \left(
                      \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
                    - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pim,\pjc}
                  \right)
               \right\} \\
               & =
               \frac{1}{l_y} \sum_{\pjc} \Delta y_{\pjc} \left\{
                  \sqrt{Pr} \sqrt{Ra} \left(
                      \vat{\ux}{\pip        ,\pjc} \vat{\intrp{T}{\gx}}{\pip        ,\pjc}
                    - \vat{\ux}{\frac{1}{2},\pjc} \vat{\intrp{T}{\gx}}{\frac{1}{2},\pjc}
                  \right)
                  - \left(
                      \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pip        ,\pjc}
                    - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\frac{1}{2},\pjc}
                  \right)
               \right\} = 0,
            \end{aligned}

         i.e.,

         .. math::
            \begin{aligned}
               \frac{1}{l_y} \sum_{\pjc} \Delta y_{\pjc} \left(
                  \sqrt{Pr} \sqrt{Ra} \, \vat{u}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
                  - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
               \right)
               =
               \frac{1}{l_y} \sum_{\pjc} \Delta y_{\pjc} \left(
                 \sqrt{Pr} \sqrt{Ra} \, \vat{u}{\frac{1}{2},\pjc} \vat{\intrp{T}{\gx}}{\frac{1}{2},\pjc}
                  - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\frac{1}{2},\pjc}
               \right).
            \end{aligned}

         Note that this relation holds for all :math:`i`.

         The left-hand-side denotes the value at a specific wall-normal location (:math:`x` cell faces where :math:`u_x` are defined), while the right-hand-side describes the value on the left wall.
         Since we assume the walls are impermeable, the first term (temperature advection) vanishes and thus we finally notice

         .. math::
            \begin{aligned}
               Nu
               & =
               \frac{1}{l_y} \sum_{\pjc} \Delta y_{\pjc} \left(
                  - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\text{wall},\pjc}
               \right) \\
               & =
               \frac{1}{l_y} \sum_{\pjc} \Delta y_{\pjc} \left(
                  \sqrt{Pr} \sqrt{Ra} \, \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
                  - \vat{\frac{1}{\Delta x} \diffe{T}{\gx}}{\pip,\pjc}
               \right) \\
               & =
               const,
            \end{aligned}

         which is the **Nusselt number based on the local heat flux**.

         .. note::
            In the continuous level, this Nusselt constancy in the wall-normal direction holds for all :math:`x` locations.
            After being discretised, on the other hand, this relation is satisfied only where :math:`u_x` is defined.

   2. Energy injection by buoyancy

      .. details:: Details

         We further consider to average the above equation in :math:`x` direction, from the left to the right walls, yielding

         .. math::
            \begin{aligned}
               Nu &= \frac{1}{l_x l_y} \sum_{\pic} \sum_{\pjc} \left(
                  \Delta x_{\pip} \Delta y_{\pjc} \sqrt{Pr} \sqrt{Ra} \, \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
               \right) \\
               & - \frac{1}{l_x l_y} \sum_{\pjc} \left(
                    \Delta y_{\pjc} \vat{T}{\text{right wall},\pjc}
                  - \Delta y_{\pjc} \vat{T}{\text{left  wall},\pjc}
               \right).
            \end{aligned}

         Because of the normalisations, :math:`l_x` and :math:`\vat{T}{\text{left  wall},\pjc} - \vat{T}{\text{right wall},\pjc}` are unity.
         Thus we have

         .. math::
            Nu = \frac{1}{l_x l_y} \sum_{\pic} \sum_{\pjc} \left(
               \Delta x_{\pip} \Delta y_{\pjc} \sqrt{Pr} \sqrt{Ra} \, \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
            \right)
            + 1,

         or equivalently

         .. math::
            Nu = \frac{1}{l_x l_y} \sum_{\forall \ux \text{positions}, \left( \pip, \pjc \right)} \left(
               \sqrt{Pr} \sqrt{Ra} \, J_{\pip,\pjc} \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
            \right)
            + 1,

         which is the **Nusselt number based on the energy injection by buoyancy force**.

   3. Kinetic energy dissipation

      .. details:: Details

         Next, we move on to the kinetic energy equation to find the other relation.
         As discussed above, we have the equation of the total kinetic energy :math:`\der{K}{t}`, which is increased by the energy injection by the buoyancy force:

         .. math::
            \sum_{\forall \ux \text{positions}, \left( \pip, \pjc \right)} J_{\pip,\pjc} \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc},

         while reduced by the viscous dissipation coming from the momentum equation in :math:`x` direction:

         .. math::
            \sum_{\forall \ux \text{positions}, \left( \xic, \xjc \right)} \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
                 \frac{1}{2} J_{\xip,\xjc} \left( \vat{\frac{\diffe{\ux}{\gx}}{\Delta x}}{\xip,\xjc} \right)^2
               + \frac{1}{2} J_{\xim,\xjc} \left( \vat{\frac{\diffe{\ux}{\gx}}{\Delta x}}{\xim,\xjc} \right)^2
               + \frac{1}{2} J_{\xic,\xjp} \left( \vat{\frac{\diffe{\ux}{\gy}}{\Delta y}}{\xic,\xjp} \right)^2
               + \frac{1}{2} J_{\xic,\xjm} \left( \vat{\frac{\diffe{\ux}{\gy}}{\Delta y}}{\xic,\xjm} \right)^2
            \right\}

         and the one in :math:`y` direction:

         .. math::
            \sum_{\forall \uy \text{positions}, \left( \yic, \yjc \right)} \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
                 \frac{1}{2} J_{\yip,\yjc} \left( \vat{\frac{\diffe{\uy}{\gx}}{\Delta x}}{\yip,\yjc} \right)^2
               + \frac{1}{2} J_{\yim,\yjc} \left( \vat{\frac{\diffe{\uy}{\gx}}{\Delta x}}{\yim,\yjc} \right)^2
               + \frac{1}{2} J_{\yic,\yjp} \left( \vat{\frac{\diffe{\uy}{\gy}}{\Delta y}}{\yic,\yjp} \right)^2
               + \frac{1}{2} J_{\yic,\yjm} \left( \vat{\frac{\diffe{\uy}{\gy}}{\Delta y}}{\yic,\yjm} \right)^2
            \right\}.

         Again, we consider to average this equation in the whole domain and in time.

         The evolution of :math:`K` vanishes as usual since we are interested in the statistically-steady state.
         The buoyancy forcing leads

         .. math::
            \frac{1}{l_x l_y} \sum_{\forall \ux \text{positions}, \left( \pip, \pjc \right)} J_{\pip,\pjc} \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}.

         The total viscous dissipation is given as the sum of

         .. math::
            \frac{1}{l_x l_y} \sum_{\forall \ux \text{positions}, \left( \xic, \xjc \right)} \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
                 \frac{1}{2} J_{\xip,\xjc} \left( \vat{\frac{\diffe{\ux}{\gx}}{\Delta x}}{\xip,\xjc} \right)^2
               + \frac{1}{2} J_{\xim,\xjc} \left( \vat{\frac{\diffe{\ux}{\gx}}{\Delta x}}{\xim,\xjc} \right)^2
               + \frac{1}{2} J_{\xic,\xjp} \left( \vat{\frac{\diffe{\ux}{\gy}}{\Delta y}}{\xic,\xjp} \right)^2
               + \frac{1}{2} J_{\xic,\xjm} \left( \vat{\frac{\diffe{\ux}{\gy}}{\Delta y}}{\xic,\xjm} \right)^2
            \right\}

         and

         .. math::
            \frac{1}{l_x l_y} \sum_{\forall \uy \text{positions}, \left( \yic, \yjc \right)} \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
                 \frac{1}{2} J_{\yip,\yjc} \left( \vat{\frac{\diffe{\uy}{\gx}}{\Delta x}}{\yip,\yjc} \right)^2
               + \frac{1}{2} J_{\yim,\yjc} \left( \vat{\frac{\diffe{\uy}{\gx}}{\Delta x}}{\yim,\yjc} \right)^2
               + \frac{1}{2} J_{\yic,\yjp} \left( \vat{\frac{\diffe{\uy}{\gy}}{\Delta y}}{\yic,\yjp} \right)^2
               + \frac{1}{2} J_{\yic,\yjm} \left( \vat{\frac{\diffe{\uy}{\gy}}{\Delta y}}{\yic,\yjm} \right)^2
            \right\}.

         Note that this summation is nothing else but the (discretised) kinetic dissipation rate :math:`\ave{\epsilon_k}{x,y,t}`, i.e., :math:`\left\langle s_{ij} s_{ij} \right\rangle_{S,t}` in the continuous level.

         Finally we find

         .. math::
            \frac{1}{l_x l_y} \sum_{\forall \ux \text{positions}, \left( \pip, \pjc \right)} J_{\pip,\pjc} \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
            =
            \ave{\epsilon_k}{x,y,t},

         and, by using the relation we obtained in the previous Nusselt definition:

         .. math::
            Nu = \frac{1}{l_x l_y} \sum_{\forall \ux \text{positions}, \left( \pip, \pjc \right)} \left(
               \sqrt{Pr} \sqrt{Ra} \, J_{\pip,\pjc} \vat{\ux}{\pip,\pjc} \vat{\intrp{T}{\gx}}{\pip,\pjc}
            \right)
            + 1,

         we obtain

         .. math::
            Nu = \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_k}{x,y,t} + 1,

         which is the **Nusselt number based on the kinetic energy dissipation rate**.

   4. Thermal energy dissipation

      .. details:: Details

         Again we focus on the thermal energy equation; in particular we consider the equation of the **total** thermal energy :math:`\der{H}{t}`.
         As discussed above, this quantity is increased by the thermal conduction on the walls:

         .. math::
            \begin{aligned}
               & \int \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{}{\xi^j} \left( \mst{j}{j} T \der{T}{\xi^j} \right) d\gx d\gy \\
               \approx
               & \sum_i \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
                   \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\pip,\pjc}
                 - \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\pim,\pjc}
                 + \vat{\left( \mst{y}{y} T \diffe{T}{\gy} \right)}{\pic,\pjp}
                 - \vat{\left( \mst{y}{y} T \diffe{T}{\gy} \right)}{\pic,\pjm}
               \right\} \\
               =
               & \sum_i \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
                   \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\pip,\pjc}
                 - \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\pim,\pjc}
               \right\} \\
               =
               & \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
                   \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\text{right wall},\pjc}
                 - \vat{\left( \mst{x}{x} T \diffe{T}{\gx} \right)}{\text{left  wall},\pjc}
               \right\}, \\
               =
               & - \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \vat{\left( \frac{\Delta y_j}{\Delta x_{\text{left wall}}} \diffe{T}{\gx} \right)}{\text{left wall},\pjc},
            \end{aligned}

         where :math:`T_{\text{left wall}} \equiv 1` and :math:`T_{\text{right wall}} \equiv 0` are used.

         On the other hand, :math:`H` is reduced by the dissipation:

         .. math::
            \begin{aligned}
               & \int \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{}{\xi^j} \left( \mst{j}{j} T \der{T}{\xi^j} \right) d\gx d\gy \\
               \approx
               & \sum_i \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{1}{J_{\pic,\pjc}} \left\{
                    \frac{1}{2} J_{\pip,\pjc} \left( \vat{\frac{\diffe{T}{\gx}}{\Delta x}}{\pip,\pjc} \right)^2
                  + \frac{1}{2} J_{\pim,\pjc} \left( \vat{\frac{\diffe{T}{\gx}}{\Delta x}}{\pim,\pjc} \right)^2
                  + \frac{1}{2} J_{\pic,\pjp} \left( \vat{\frac{\diffe{T}{\gy}}{\Delta y}}{\pic,\pjp} \right)^2
                  + \frac{1}{2} J_{\pic,\pjm} \left( \vat{\frac{\diffe{T}{\gy}}{\Delta y}}{\pic,\pjm} \right)^2
               \right\}.
            \end{aligned}

         Again, we average this equation in the whole domain and in time.

         The evolution of :math:`H` vanishes as usual since we are interested in the statistically-steady state.

         The thermal conduction leads

         .. math::
            - \frac{1}{l_x l_y} \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \vat{\left( \frac{\Delta y_j}{\Delta x_{\text{left wall}}} \diffe{T}{\gx} \right)}{\text{left wall},\pjc} = Nu \,\, \left( \because l_x \equiv 1 \right),

         while the dissipation leads

         .. math::
            \frac{1}{l_x l_y} \sum_i \sum_j \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
                 \frac{1}{2} J_{\pip,\pjc} \left( \vat{\frac{\diffe{T}{\gx}}{\Delta x}}{\pip,\pjc} \right)^2
               + \frac{1}{2} J_{\pim,\pjc} \left( \vat{\frac{\diffe{T}{\gx}}{\Delta x}}{\pim,\pjc} \right)^2
               + \frac{1}{2} J_{\pic,\pjp} \left( \vat{\frac{\diffe{T}{\gy}}{\Delta y}}{\pic,\pjp} \right)^2
               + \frac{1}{2} J_{\pic,\pjm} \left( \vat{\frac{\diffe{T}{\gy}}{\Delta y}}{\pic,\pjm} \right)^2
            \right\},

         which is the thermal dissipation rate :math:`\ave{\epsilon_h}{x,y,t} = \ave{\der{T}{x_i} \der{T}{x_i}}{S,t}` in the continuous level.

         Thus we notice

         .. math::
            Nu = \sqrt{Pr} \sqrt{Ra} \ave{\epsilon_h}{x,y,t},

         which is the **Nusselt number based on the thermal energy dissipation rate**.


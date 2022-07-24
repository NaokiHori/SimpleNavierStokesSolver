
.. _basic_operators:

###############
Basic operators
###############

Differentiations and interpolations are defined.

**************************************
Conservative form and differentiations
**************************************

First of all, we define the *conservative form* in both continuous and discrete domains.
In the continuous domain, we call terms *conservative* when written as

.. math::
   \der{q}{x_i},

since the net increase and decrease of :math:`q` (can be tensors of any order) is purely determined by the boundary values of :math:`q`.

.. details:: Derivation

   For simplicity, we consider one-dimensional space where the both edges are bounded or periodic.
   When being written as

   .. math::
      \der{q}{x},

   the volume integral of this term leads

   .. math::
      \int_{\text{left}}^{\text{right}} \der{q}{x} dx
      =
      \vat{q}{\text{right}} - \vat{q}{\text{left}}.

   We notice that the total amount of :math:`q` is *conserved* as long as :math:`q` at the boundaries (flux) are null (:math:`\vat{q}{\text{right}} = \vat{q}{\text{left}} \equiv 0`) or the periodic conditions are imposed, i.e. :math:`\vat{q}{\text{right}} \equiv \vat{q}{\text{left}}`).

To mimic this relation in the discrete space, the discrete first-order derivatives should be given as

.. math::
   \vat{\dder{q}{x}}{\pic}
   =
   \frac{\vat{q}{\pip} - \vat{q}{\pim}}{\vat{x}{\pip} - \vat{x}{\pim}}, \\

at cell centers, while

.. math::
   \vat{\dder{q}{x}}{\pip}
   =
   \frac{\vat{q}{\pipp} - \vat{q}{\pic}}{\vat{x}{\pipp} - \vat{x}{\pic}}.

at cell faces, respectively.

.. note::

   Hereafter :math:`\der{q}{x}` (\\partial) and :math:`\dder{q}{x}` (\\delta) are used to indicate derivatives in the continuous and discrete domains, respectively.

.. details:: Derivation

   One-dimensional domain is considered in the derivations below for simplicity, whose extension to multi-dimensional domains is straightforward.

   #. Derivatives at cell center, quantities at cell face

      We consider quantity :math:`q`, whose derivative is defined at each cell center, i.e.,

      .. math::
         \vat{\dder{q}{x}}{\pic}.

      The integral of this derivative in the whole domain leads

      .. math::
         \int \der{q}{x} dx
         \approx
         \sum_{i} \vat{
            \left(
               \dder{q}{x} \Delta x
            \right)
         }{\pic}.

      Since :math:`\vat{\Delta x}{\pic}` denotes the size of the cell at each cell center, it is clear that we have

      .. math::
         \vat{\Delta x}{\pic} = \vat{x}{\pip} - \vat{x}{\pim}.

      Now we would like to *mimic* the relation in the continuous domain, i.e., this volume integral should be merely determined by the boundary values.
      To satisfy this requirement, the denominator of the gradient :math:`\delta x` at each cell center should be cancelled out by the size of the cell :math:`\vat{\Delta x}{\pic}`, giving

      .. math::
         \vat{\delta x}{\pic} = \vat{x}{\pip} - \vat{x}{\pim}.

      Also, it is natural to use the same scheme for the numerator :math:`\delta q` since they have the same form, i.e.,

      .. math::
         \vat{\delta q}{\pic} = \vat{q}{\pip} - \vat{q}{\pim}.

      Thus, we can conclude that the derivative at cell center should be given as

      .. math::
         \vat{\dder{q}{x}}{\pic}
         =
         \frac{\vat{q}{\pip} - \vat{q}{\pim}}{\vat{x}{\pip} - \vat{x}{\pim}},

      so that

      .. math::
         \int \der{q}{x} dx
         & \approx
         \sum \frac{\vat{q}{\pip} - \vat{q}{\pim}}{\vat{x}{\pip} - \vat{x}{\pim}} \left( \vat{x}{\pip} - \vat{x}{\pim} \right) \\
         & =
         \sum \vat{q}{\pip} - \vat{q}{\pim} \\
         & =
         \vat{q}{\text{(right cell face)}} - \vat{q}{\text{(left cell face)}}.

      This is totally analogous to the continuous counterpart shown above.

   #. Derivatives at cell face, quantities at cell center

      We can derive a consistent discretisation of the derivative at cell face as

      .. math::
         \vat{\dder{q}{x}}{\xic}
         =
         \frac{\vat{q}{\xip} - \vat{q}{\xim}}{\vat{x}{\xip} - \vat{x}{\xim}}.

      Special care should be taken for the boudnary treatment since :math:`q` is defined at cell center and boundary values (cell faces) are missing.
      One convenient way is to define boundary values explicitly; in addition to the cell center values, additional grid points are introduced exactly on the boundaries.
      This method is adopted in this project for values defined at cell center (see :ref:`the domain setup <domain>`).

      Another way is to define *ghost cells* outside the domain.
      They are the fictitious grids to impose proper boundary conditions, whose values are extrapolated from the bulk.

   .. warning::
      Sometimes the above discrete derivative is represented as

      .. math::
         \frac{\vat{q}{\pipp} - \vat{q}{\pimm}}{\vat{x}{\pipp} - \vat{x}{\pimm}}.

      With this formulation, the approximation of the volume integral should be modified correspondingly, i.e.

      .. math::
         \int q dx
         \approx
         \sum q \left( \vat{x}{\pipp} - \vat{x}{\pimm} \right).

      One can see that this cannot be conservative in general, since some :math:`q` values inside bulk cannot be eliminated.
      Thus, in the following discussion, we try to avoid this formulation.

*************************
Discrete volume integrals
*************************

In this part we define the approximation of the volume integral

.. math::
   \int q dx dy.

Because of the staggered grid arrangement, we need the following three different definitions.

#. Volume integral at :math:`\left( \xic, \xjc \right)`

   .. math::
      \sum_{i} \sum_{j} \vat{
         \left(
            q
            \Delta x
            \Delta y
         \right)
      }{\xic, \xjc},

   which is used to integrate a quantity defined at :math:`x` cell face.

#. Volume integral at :math:`\left( \yic, \yjc \right)`

   .. math::
      \sum_{i} \sum_{j} \vat{
         \left(
            q
            \Delta x
            \Delta y
         \right)
      }{\yic, \yjc},

   which is used to integrate a quantity defined at :math:`y` cell face.

#. Volume integral at :math:`\left( \pic, \pjc \right)`

   .. math::
      \sum_{i} \sum_{j} \vat{
         \left(
            q
            \Delta x
            \Delta y
         \right)
      }{\pic, \pjc},

   which is used to integrate a quantity defined at cell center.

**************
Interpolations
**************

Because of :ref:`the staggered grid arrangement <domain>`, most variables are not defined at the locations we want, when interpolations defined here are necessary.

Three different symbols are used in this project, whose superscripts indicate the direction to which being interpolated.

#. Arithmetic averages :math:`\dintrpa{q}{x}` and :math:`\dintrpa{q}{y}`

   .. math::
      \begin{cases}
         x \, \text{direction}
         &
         \begin{cases}
            \text{center-to-face}
            &
            2 \vat{\dintrpv{q}{x}}{\xic}
            \equiv
            \vat{q}{\xim}
            +
            \vat{q}{\xip}, \\
            \text{face-to-center}
            &
            2 \vat{\dintrpv{q}{x}}{\pic}
            \equiv
            \vat{q}{\pim}
            +
            \vat{q}{\pip}
         \end{cases} \\
         y \, \text{direction}
         &
         \begin{cases}
            \text{center-to-face}
            &
            2 \vat{\dintrpv{q}{y}}{\yjc}
            \equiv
            \vat{q}{\yjm}
            +
            \vat{q}{\yjp}, \\
            \text{face-to-center}
            &
            2 \vat{\dintrpv{q}{y}}{\pjc}
            \equiv
            \vat{q}{\pjm}
            +
            \vat{q}{\pjp}
         \end{cases}
      \end{cases}

#. Averages weighted by the cell sizes :math:`\dintrpv{q}{x}` and :math:`\dintrpv{q}{y}`

   .. math::
      \begin{cases}
         x \, \text{direction}
         &
         \begin{cases}
            \text{center-to-face}
            &
            2 \Delta x_{\xic} \vat{\dintrpv{q}{x}}{\xic}
            \equiv
            \Delta x_{\xim} \vat{q}{\xim}
            +
            \Delta x_{\xip} \vat{q}{\xip}, \\
            \text{face-to-center}
            &
            2 \Delta x_{\pic} \vat{\dintrpv{q}{x}}{\pic}
            \equiv
            \Delta x_{\pim} \vat{q}{\pim}
            +
            \Delta x_{\pip} \vat{q}{\pip}
         \end{cases} \\
         y \, \text{direction}
         &
         \begin{cases}
            \text{center-to-face}
            &
            2 \Delta y \vat{\dintrpv{q}{y}}{\yjc}
            \equiv
            \Delta y \vat{q}{\yjm}
            +
            \Delta y \vat{q}{\yjp}, \\
            \text{face-to-center}
            &
            2 \Delta y \vat{\dintrpv{q}{y}}{\pjc}
            \equiv
            \Delta y \vat{q}{\pjm}
            +
            \Delta y \vat{q}{\pjp}
         \end{cases}
      \end{cases}

   Note that :math:`\dintrpv{q}{y}` is identical to :math:`\dintrpa{q}{y}` since only uniform grid spacings are allowed in :math:`y` direction.

#. Placeholders :math:`\dintrpu{q}{x}` and :math:`\dintrpu{q}{y}`

   They do not have explicit formulations, i.e, we do not know anything except it is interpolated in the specified direction.
   They are used as placeholders, which must be replaced by the other interpolation symbol defined above to conclude.


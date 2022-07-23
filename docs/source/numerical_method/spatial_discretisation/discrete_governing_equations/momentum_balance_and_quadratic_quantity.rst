
.. _momentum_balance:

#######################################
Momentum balance and quadratic quantity
#######################################

************
Introduction
************

In this part, we consider to discretise

.. math::
   \der{\ux}{t}
   +
   u_j \der{\ux}{x_j}
   =
   -\der{p}{x}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{\partial^2 \ux}{\partial x_j \partial x_j}
   +
   T

at :math:`x` cell faces :math:`\left( \xic, \xjc \right)`, and

.. math::
   \der{\uy}{t}
   +
   u_j \der{\uy}{x_j}
   =
   -\der{p}{y}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \frac{\partial^2 \uy}{\partial x_j \partial x_j}

at :math:`y` cell faces :math:`\left( \yic, \yjc \right)`.

Also a relevant (dependent) kinetic energy balance

.. math::
   \der{k}{t}
   +
   u_i \der{k}{x_i}
   =
   -u_i \der{p}{x_i}
   + \frac{\sqrt{Pr}}{\sqrt{Ra}} \der{}{x_j} \left( u_i \der{u_i}{x_j} \right)
   - \frac{\sqrt{Pr}}{\sqrt{Ra}} \der{u_i}{x_j} \der{u_i}{x_j}
   + u_i T \delta_{ix}

is considered.
Note that this can be obtained by taking the inner product of the velocity :math:`u_i` and the momentum balance, whose derivation in the continuous domain can be found in :ref:`the governing equations <governing_equations>`.

**********
Conclusion
**********

The following discrete equations are directly implemented in the code.

Momentum balance in :math:`x` direction at :math:`\left( \xic, \xjc \right)`:

.. math::
   \der{\ux}{t}
   +
   \dintrpv{
      \dintrpa{\ux}{x}
      \dder{\ux}{x}
   }{x}
   +
   \dintrpa{
      \dintrpv{\uy}{x}
      \dder{\ux}{y}
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
   \dintrpu{T}{x}.

Momentum balance in :math:`y` direction at :math:`\left( \yic, \yjc \right)`:

.. math::
   \der{\uy}{t}
   +
   \dintrpv{
      \dintrpa{\ux}{y}
      \dder{\uy}{x}
   }{x}
   +
   \dintrpa{
      \dintrpa{\uy}{y}
      \dder{\uy}{y}
   }{y}
   =
   -\dder{p}{y}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{\uy}{x} \right)
      +
      \dder{}{y} \left( \dder{\uy}{y} \right)
   \right\}.

Their implementations can be found in :ref:`src/fluid/update_velocity.c <fluid_update_velocity>`.

.. note::

   #. Discrete thermal forcing term

      We cannot define the forcing term in :math:`x` direction :math:`\dintrpu{T}{x}` here (recall that *widehat* symbol is a placeholder).
      In order to decide the correct interpolation, we need to consider the equation of the internal energy and Nusselt number relations.

   #. Discrete kinetic energy

      In the continuous space, local kinetic energy :math:`k = k \left( t, x, y \right)` is clearly given as the sum of :math:`\frac{1}{2} \ux^2 \left( t, x, y \right)` and :math:`\frac{1}{2} \uy^2 \left( t, x, y \right)`.
      After being discretised, however, the *definition* of kinetic energy itself is ambiguous since :math:`\ux` and :math:`\uy` are defined at different locations.

      In this project, we consider these two contributions separately:

      .. math::
         \der{}{t} \vat{
            \left( \frac{1}{2} \ux^2 \right)
         }{\xic, \xjc} + \cdots,

      and

      .. math::
         \der{}{t} \vat{
            \left( \frac{1}{2} \uy^2 \right)
         }{\yic, \yjc} + \cdots,

      which can be obtained by multiplying the momentum balances by :math:`\ux` and :math:`\uy`, respectively.

      We regard the total discrete kinetic energy :math:`K = K \left( t \right)` as the sum of the volume integrals of these two equations:

      .. math::
         \der{K}{t}
         =
         \sum_{i} \sum_{j} \der{}{t} \vat{
            \left(
               \frac{1}{2} \ux^2
               \Delta x \Delta y
            \right)
         }{\xic, \xjc}
         +
         \sum_{i} \sum_{j} \der{}{t} \vat{
            \left(
               \frac{1}{2} \uy^2
               \Delta x \Delta y
            \right)
         }{\yic, \yjc},

      which will be investigated in this section.

*********************************
Derivations - local conservations
*********************************

In this part, we focus on the *local* property of equations, e.g., how each term is discretised to make it :ref:`conservative <basic_operators>`.
This is necessary to discuss the *global* properties (after being integrated in the volume), which will be discussed later.

'''''''''''''''
Advective terms
'''''''''''''''

Mathematically speaking (in the continuous domain), advective terms should not alter the total amount of the transported quantity.
Here, they should be designed so that not only the net momentum but the total kinetic energy (quadratic quantity) are conserved.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Divergence form of advective terms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We find the discrete form of the advection of :math:`\ux` and :math:`\uy` are given as

.. math::
   \dder{
      \dintrpa{\ux}{x}
      \dintrpa{\ux}{x}
   }{x}
   +
   \dder{
      \dintrpu{\uy}{x}
      \dintrpa{\ux}{y}
   }{y}

at :math:`\left( \xic, \xjc \right)` and

.. math::
   \dder{
      \dintrpa{\ux}{y}
      \dintrpu{\uy}{x}
   }{x}
   +
   \dder{
      \dintrpa{\uy}{y}
      \dintrpa{\uy}{y}
   }{y}

at :math:`\left( \yic, \yjc \right)`, respectively.
Note that interpolations :math:`\dintrpu{\uy}{x}` and :math:`\dintrpu{\ux}{y}` are undefined.

.. details:: Derivations

   We first focus on the advective terms in the momentum balance

   .. math::
      u_j \der{u_i}{x_j},

   which is called as the *gradient form*.
   Obviously this is not in :ref:`a conservative form <mass_balance_and_pressure_equation>` since this is not written as :math:`\partial / \partial x_i`.
   In order to visually understand that this term really conserves momentum, we use

   .. math::
      u_j \der{u_i}{x_j}
      +
      u_i \der{u_j}{x_j}
      =
      \der{u_j u_i}{x_j}.

   Note that the second term in the left-hand-side is the incompressibility constraint weighted by :math:`u_i`.
   Thus, when the incompressibility constraint is satisfied, the advective term can be written in a conservative form, which is named as the *divergence form*.

   Since they are inherently momentum-conservative, we discretise this form instead of the gradient form, giving

   .. math::
      \dder{
         \dintrpu{\ux}{x}
         \dintrpu{\ux}{x}
      }{x}
      +
      \dder{
         \dintrpu{\uy}{x}
         \dintrpu{\ux}{y}
      }{y}

   at :math:`\left( \xic, \xjc \right)` and

   .. math::
      \dder{
         \dintrpu{\ux}{y}
         \dintrpu{\uy}{x}
      }{x}
      +
      \dder{
         \dintrpu{\uy}{y}
         \dintrpu{\uy}{y}
      }{y}

   at :math:`\left( \yic, \yjc \right)`.
   It is readily apparent that they are discretely-conservative.

   .. note::

      There are two possibilities to write :math:`\ux \ux`.

      #. :math:`\dintrpu{\left( \ux \right)^2}{x}`, interpolated after squared.

      #. :math:`\left( \dintrpu{\ux}{x} \right)^2 = \dintrpu{\ux}{x} \dintrpu{\ux}{x}`, squared after interpolated.

      We take the second option since it is consistent with the other direction :math:`\dintrpu{\uy}{x} \dintrpu{\ux}{y}`.

   Placeholders :math:`\dintrpu{q}{x}` and :math:`\dintrpu{q}{y}` can be partially replaced by arithmetic averages :math:`\dintrpa{q}{x}` and :math:`\dintrpa{q}{y}` since cell center locates in the middle of the surrounding two cell faces in this project (see :ref:`the domain setup <domain>`).
   This partially reveals the advective terms

   .. math::
      \dder{
         \dintrpa{\ux}{x}
         \dintrpa{\ux}{x}
      }{x}
      +
      \dder{
         \dintrpu{\uy}{x}
         \dintrpa{\ux}{y}
      }{y}

   at :math:`\left( \xic, \xjc \right)` and

   .. math::
      \dder{
         \dintrpa{\ux}{y}
         \dintrpu{\uy}{x}
      }{x}
      +
      \dder{
         \dintrpa{\uy}{y}
         \dintrpa{\uy}{y}
      }{y}

   at :math:`\left( \yic, \yjc \right)`.

   As can be seen, two unknown interpolations are remained, which will be resolved by investigating the conservation property of the discrete kinetic energy (quadratic quantities) in the next section.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2. Advection of quadratic quantities
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We find the discrete form of the advection of :math:`\ux` and :math:`\uy` are given as

.. math::
   \dder{
      \dintrpa{\ux}{x}
      \dintrpa{\ux}{x}
   }{x}
   +
   \dder{
      \dintrpv{\uy}{x}
      \dintrpa{\ux}{y}
   }{y}

at :math:`\left( \xic, \xjc \right)` and

.. math::
   \dder{
      \dintrpa{\ux}{y}
      \dintrpa{\uy}{x}
   }{x}
   +
   \dder{
      \dintrpa{\uy}{y}
      \dintrpa{\uy}{y}
   }{y}

at :math:`\left( \yic, \yjc \right)`, respectively.
Note that interpolations :math:`\dintrpv{\uy}{x}` and :math:`\dintrpa{\ux}{y}`, which were undefined, are concluded.

.. details:: Derivations

   In the continuous domain, the advection of kinetic energy is obtained by taking the inner product of the velocity and the momentum advection.
   Here we consider the counterpart in the discrete domain.

   In :math:`x` direction, at :math:`\left( \xic, \xjc \right)` where :math:`\ux` is defined, we have

   .. math::
      \ux \left(
         \dder{
            \dintrpa{\ux}{x}
            \dintrpa{\ux}{x}
         }{x}
         +
         \dder{
            \dintrpu{\uy}{x}
            \dintrpa{\ux}{y}
         }{y}
      \right).

   The first term leads

   .. math::
      & \vat{\ux}{\xic, \xjc}
      \frac{
         \vat{
            \dintrpa{\ux}{x}
         }{\xip, \xjc}
         \frac{
            \vat{\ux}{\xipp, \xjc}
            +
            \vat{\ux}{\xic , \xjc}
         }{2}
         -
         \vat{
            \dintrpa{\ux}{x}
         }{\xim, \xjc}
         \frac{
            \vat{\ux}{\xic , \xjc}
            +
            \vat{\ux}{\ximm, \xjc}
         }{2}
      }{\Delta x_{\xic}} \\
      & =
      \frac{
         \vat{
            \dintrpa{\ux}{x}
         }{\xip, \xjc}
         \frac{
            \vat{\ux}{\xipp, \xjc}
            \vat{\ux}{\xic,  \xjc}
         }{2}
         -
         \vat{
            \dintrpa{\ux}{x}
         }{\xim, \xjc}
         \frac{
            \vat{\ux}{\xic,  \xjc}
            \vat{\ux}{\ximm, \xjc}
         }{2}
      }{\Delta x_{\xic}}
      +
      \frac{
         \vat{\ux^2}{\xic, \xjc}
      }{2}
      \frac{
         \vat{
            \dintrpa{\ux}{x}
         }{\xip, \xjc}
         -
         \vat{
            \dintrpa{\ux}{x}
         }{\xim, \xjc}
      }{\Delta x_{\xic}} \\
      & = \dder{
         \dintrpa{\ux}{x}
         q_{xx}
      }{x}
      +
      \frac{
         \vat{\ux^2}{\xic, \xjc}
      }{2}
      \frac{
         \vat{
            \dintrpa{\ux}{x}
         }{\xip, \xjc}
         -
         \vat{
            \dintrpa{\ux}{x}
         }{\xim, \xjc}
      }{\Delta x_{\xic}},

   while the second term leads

   .. math::
      & \vat{\ux}{\xic, \xjc}
      \frac{
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjp}
         \frac{
            \vat{\ux}{\xic, \xjpp}
            +
            \vat{\ux}{\xic, \xjc }
         }{2}
         -
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjm}
         \frac{
            \vat{\ux}{\xic, \xjc }
            +
            \vat{\ux}{\xic, \xjmm}
         }{2}
      }{\Delta y} \\
      & =
      \frac{
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjp}
         \frac{
            \vat{\uy}{\xic, \xjpp}
            \vat{\uy}{\xic, \xjc }
         }{2}
         -
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjm}
         \frac{
            \vat{\uy}{\xic, \xjc }
            \vat{\uy}{\xic, \xjmm}
         }{2}
      }{\Delta y}
      +
      \frac{
         \vat{\ux^2}{\xic, \xjc}
      }{2}
      \frac{
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjp}
         -
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjm}
      }{\Delta y} \\
      & =
      \dder{
         \dintrpu{\uy}{x}
         q_{xy}
      }{y}
      +
      \frac{
         \vat{\ux^2}{\xic, \xjc}
      }{2}
      \frac{
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjp}
         -
         \vat{
            \dintrpu{\uy}{x}
         }{\xic, \xjm}
      }{\Delta y},

   where :math:`q_{xx}` and :math:`q_{xy}` are quadratic quantities defined as

   .. math::
      \vat{q_{xx}}{\xip, \xjc}
      & \equiv
      \frac{1}{2}
      \vat{\ux}{\xipp, \xjc}
      \vat{\ux}{\xic,  \xjc}, \\
      \vat{q_{xy}}{\xic, \xjp}
      & \equiv
      \frac{1}{2}
      \vat{\ux}{\xic, \xjpp}
      \vat{\ux}{\xic, \xjc }.

   We request the volume integral of the summation of these two terms is conserved.
   The first terms are in conservative forms and thus they satisfy the requirement.
   The residual leads

   .. math::
      \frac{
         \vat{\ux^2}{\xic, \xjc}
      }{2}
      \left(
         \frac{
            \vat{
               \dintrpa{\ux}{x}
            }{\xip, \xjc}
            -
            \vat{
               \dintrpa{\ux}{x}
            }{\xim, \xjc}
         }{\Delta x_{\xic}}
         +
         \frac{
            \vat{
               \dintrpu{\uy}{x}
            }{\xic, \xjp}
            -
            \vat{
               \dintrpu{\uy}{x}
            }{\xic, \xjm}
         }{\Delta y}
      \right),

   which should vanish.

   The first term inside parenthesis can be written as

   .. math::
      \frac{\Delta x_{\xip}}{2 \Delta x_{\xic}} \vat{\dder{\ux}{x}}{\xip, \xjc}
      +
      \frac{\Delta x_{\xim}}{2 \Delta x_{\xic}} \vat{\dder{\ux}{x}}{\xim, \xjc}.

   Although the explicit forms of :math:`\vat{\dintrpu{\uy}{x}}{\xic, \xjp}` and :math:`\vat{\dintrpu{\uy}{x}}{\xic, \xjm}` are unknown, they should be written as linear combinations:

   .. math::
      \vat{\dintrpu{\uy}{x}}{\xic, \cdots}
      =
      \vat{C}{\xip} \vat{\uy}{\xip, \cdots}
      +
      \vat{C}{\xim} \vat{\uy}{\xim, \cdots}.

   By using this relation, the second term inside parenthesis can be written as

   .. math::
      \vat{C}{\xip} \vat{\dder{\uy}{y}}{\xip, \xjc}
      +
      \vat{C}{\xim} \vat{\dder{\uy}{y}}{\xim, \xjc}.

   Thus, we notice

   .. math::
      \vat{C}{\xip}
      & =
      \frac{\Delta x_{\xip}}{2 \Delta x_{\xic}}, \\
      \vat{C}{\xim}
      & =
      \frac{\Delta x_{\xim}}{2 \Delta x_{\xic}},

   with which the term inside the parenthesis vanishes thanks to the incompressibility constraint.

   Similarly, in :math:`y` direction at :math:`\left( \yic, \yjc \right)` where :math:`\uy` is defined, we have

   .. math::
      \uy \left(
         \dder{
            \dintrpa{\ux}{y}
            \dintrpu{\uy}{x}
         }{x}
         +
         \dder{
            \dintrpa{\uy}{y}
            \dintrpa{\uy}{y}
         }{y}
      \right).

   The second term is simply

   .. math::
      \dder{\dintrpa{\uy}{y} q_{yy}}{y}
      +
      \frac{
         \vat{\uy^2}{\yic, \yjc}
      }{2}
      \frac{1}{2} \left(
         \vat{\dder{\uy}{y}}{\yic, \yjp}
         -
         \vat{\dder{\uy}{y}}{\yic, \yjm}
      \right),

   where :math:`q_{yy}` is the quadratic quantity defined as

   .. math::
      \vat{q_{yy}}{\yic, \yjp}
      \equiv
      \frac{1}{2}
      \vat{\uy}{\yic, \yjpp}
      \vat{\uy}{\yic, \yjc }.

   Regarding the first term, we let the coefficients of unknown interpolations as

   .. math::
      \vat{
         \dintrpu{\uy}{x}
      }{\yim, \yjc}
      & \equiv
      \vat{c^-}{\yimm} \vat{\uy}{\yimm}
      +
      \vat{c^-}{\yic } \vat{\uy}{\yic }, \\
      \vat{
         \dintrpu{\uy}{x}
      }{\yip, \yjc}
      & \equiv
      \vat{c^+}{\yic } \vat{\uy}{\yic }
      +
      \vat{c^+}{\yipp} \vat{\uy}{\yipp},

   giving

   .. math::
      \color{blue}{\vat{\uy}{\yic, \yjc}}
      \frac{
         \vat{
            \dintrpa{\ux}{y}
         }{\yip, \yjc}
         \left(
            \color{blue}{
            \vat{c^+}{\yipp} \vat{\uy}{\yipp, \yjc}
            }
            +
            \vat{c^+}{\yic } \vat{\uy}{\yic , \yjc}
         \right)
         -
         \vat{
            \dintrpa{\ux}{y}
         }{\yim, \yjc}
         \left(
            \vat{c^-}{\yic } \vat{\uy}{\yic , \yjc}
            +
            \color{blue}{
            \vat{c^-}{\yimm} \vat{\uy}{\yimm, \yjc}
            }
         \right)
      }{\Delta x_{\yic}}.

   We notice two constraints to determine coefficients.

   #. Quadratic quantity

      We use terms coloured in blue to define quadratic quantity, which request the coefficients :math:`\vat{c^+}{\yipp}` and :math:`\vat{c^-}{\yimm}` to be :math:`1/2`, so that

      .. math::
         \vat{q_{yx}}{\yip, \yjc}
         \equiv
         \frac{1}{2}
         \vat{\uy}{\yipp, \yjc}
         \vat{\uy}{\yic,  \yjc}

      can be defined and we are able to write the bluish terms in a conservative form

      .. math::
         \dder{
            \dintrpa{\ux}{y}
            q_{yx}
         }{x}.

   #. Residual

      The remained term yields

      .. math::
         \vat{\uy^2}{\yic, \yjc}
         \frac{
            \vat{c^+}{\yic}
            \vat{
               \dintrpa{\ux}{y}
            }{\yip, \yjc}
            -
            \vat{c^-}{\yic}
            \vat{
               \dintrpa{\ux}{y}
            }{\yim, \yjc}
         }{\Delta x_{\yic}}.

      In order to make them canceled out with the other residual, we notice the coefficients must be :math:`1/2` again.

   Thus, we notice that arithmetic averages :math:`\dintrpa{q}{x}` should be used for the unknown interpolations existing in the :math:`y` momentum advection.

   Finally, we can conclude the explicit forms of the advective terms in divergence form as

   .. math::
      \der{
         \ux
         \ux
      }{x}
      +
      \der{
         \uy
         \ux
      }{y}
      & =
      \color{red}{
         \dder{
            \dintrpa{\ux}{x}
            \dintrpa{\ux}{x}
         }{x}
         +
         \dder{
            \dintrpv{\uy}{x}
            \dintrpa{\ux}{y}
         }{y}
      }, \\
      \der{
         \ux
         \uy
      }{x}
      +
      \der{
         \uy
         \uy
      }{y}
      & =
      \color{red}{
         \dder{
            \dintrpa{\ux}{y}
            \dintrpa{\uy}{x}
         }{x}
         +
         \dder{
            \dintrpa{\uy}{y}
            \dintrpa{\uy}{y}
         }{y}
      }.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3. Gradient form of advective terms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Finally we find that the advective terms can be written as

.. math::
   \dintrpv{
      \dintrpa{\ux}{x}
      \dder{\ux}{x}
   }{x}
   +
   \dintrpa{
      \dintrpv{\uy}{x}
      \dder{\ux}{y}
   }{y}

at :math:`\left( \xic, \xjc \right)` and

.. math::
   \dintrpv{
      \dintrpa{\ux}{y}
      \dder{\uy}{x}
   }{x}
   +
   \dintrpa{
      \dintrpa{\uy}{y}
      \dder{\uy}{y}
   }{y}

at :math:`\left( \yic, \yjc \right)` in each direction.

.. details:: Derivations

   #. Advection of :math:`\ux`

      The gradient form

      .. math::
         \ux \dder{\ux}{x}
         +
         \uy \dder{\ux}{y}

      is defined at :math:`x` cell face :math:`\left( \xic, \xjc \right)` and  is written as

      .. math::
         \dder{\ux \ux}{x}
         +
         \dder{\uy \ux}{y}
         -
         \ux \left(
            \dder{\ux}{x}
            +
            \dder{\uy}{y}
         \right)

      i.e.,

      .. math::
         \left( \text{divergence form} \right) - \ux \left( \text{incompressibility constraint} \right).

      Since the incompressibility constraint is defined at cell center, we need to interpolate them to the cell face in-between:

      .. math::
         \vat{
            \dder{u_i}{x_i}
         }{\xic, \xjc}
         =
         \vat{
            \dintrpu{
               \dder{u_i}{x_i}
            }{x}
         }{\xic, \xjc}.

      .. note::

         The pre-factor :math:`\vat{\ux}{\xic,\xjc}` in front of the incompressibility constraint is controversial since there are mainly two possibilities:

         #. Use local value at :math:`\left( \xic, \xjc \right)`

            .. math::
               \vat{
                  \left(
                     \ux
                     \dintrpu{
                        \dder{u_i}{x_i}
                     }{x}
                  \right)
               }{\xic, \xjc}

         #. Interpolate as well as the incompressibility constraint

            .. math::
               \vat{
                  \dintrpu{
                     \left(
                        \dintrpa{\ux}{x}
                        \dder{u_i}{x_i}
                     \right)
                  }{x}
               }{\xic, \xjc}

         To answer this question, we focus on the :math:`y` component :math:`\uy \der{\ux}{y}`.
         As shown in the divergence form, three :math:`\ux` are involved: :math:`\vat{\ux}{\xic,\xjp}`, :math:`\vat{\ux}{\xic,\xjc}`, and :math:`\vat{\ux}{\xic,\xjm}`, which are on the same :math:`x` cell face.
         If we adopt the second option, two additional :math:`\ux` components located at different :math:`x` cell faces are involved.
         This is obviously inconsistent, because the divergence and gradient forms, which are essentially identical, contain different :math:`\ux` information.

         Thus we should adopt the first option.

      In order to go further, we let

      .. math::
         \vat{\dintrpu{q}{x}}{\xic}
         =
         \vat{C}{\xip} \vat{q}{\xip}
         +
         \vat{C}{\xim} \vat{q}{\xim}.

      Since they are linear operation, interpolations and differentiations should be interchangeable, i.e.,

      .. math::
         \dintrpu{
            \dder{\ux}{x}
         }{x}
         =
         \dder{
            \dintrpu{\ux}{x}
         }{x},
         \dintrpu{
            \dder{\uy}{y}
         }{x}
         =
         \dder{
            \dintrpu{\uy}{x}
         }{y}.

      .. note::
         We replace :math:`\dintrpu{q}{x}` by :math:`\dintrpa{q}{x}` since the interpolation is shifted to cell centers.

      The second relation is obvious since operations in :math:`x` and :math:`y` directions are independent.

      In order to satisfy the first relation, :math:`\vat{C}{\xip}` and :math:`\vat{C}{\xim}` should be properly determined.
      The interpolation of differentiations leads

      .. math::
         \vat{
            \dintrpu{
               \dder{\ux}{x}
            }{x}
         }{\xic, \xjc}
         & =
         \vat{C}{\xip} \vat{\dder{\ux}{x}}{\xip, \xjc}
         +
         \vat{C}{\xim} \vat{\dder{\ux}{x}}{\xim, \xjc} \\
         & =
         \vat{C}{\xip} \frac{
            \vat{\ux}{\xipp, \xjc}
            -
            \vat{\ux}{\xic,  \xjc}
         }{\Delta x_{\xip}}
         +
         \vat{C}{\xim} \frac{
            \vat{\ux}{\xic,  \xjc}
            -
            \vat{\ux}{\ximm, \xjc}
         }{\Delta x_{\xim}},

      while the differentiation of interpolations leads

      .. math::
         \vat{
            \dder{
               \dintrpu{\ux}{x}
            }{x}
         }{\xic, \xjc}
         & =
         \frac{
            \vat{\dintrpu{\ux}{x}}{\xip, \xjc}
            -
            \vat{\dintrpu{\ux}{x}}{\xim, \xjc}
         }{\Delta x_{\xic}} \\
         & =
         \frac{
            \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
            -
            \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
         }{\Delta x_{\xic}} \\
         & =
         \frac{
            \frac{
               \vat{\ux}{\xipp, \xjc}
               +
               \vat{\ux}{\xic,  \xjc}
            }{2}
            -
            \frac{
               \vat{\ux}{\xic,  \xjc}
               +
               \vat{\ux}{\ximm, \xjc}
            }{2}
         }{\Delta x_{\xic}}.

      By comparing these two equations, we notice

      .. math::
         \vat{C}{\xip}
         & =
         \frac{\Delta x_{\xip}}{2 \Delta x_{\xic}}, \\
         \vat{C}{\xim}
         & =
         \frac{\Delta x_{\xim}}{2 \Delta x_{\xic}},

      which is nothing else but :math:`\dintrpv{q}{x}`.

      Thus the gradient form leads,

      .. math::
         \ux \dder{\ux}{x}
         & =
         \dder{\ux \ux}{x}
         -
         \ux \dder{\ux}{x} \\
         & =
         \dder{
            \dintrpa{\ux}{x}
            \dintrpa{\ux}{x}
         }{x}
         -
         \ux \dintrpv{
            \dder{\ux}{x}
         }{x} \\
         & =
         \dder{
            \dintrpa{\ux}{x}
            \dintrpa{\ux}{x}
         }{x}
         -
         \ux \dder{
            \dintrpa{\ux}{x}
         }{x} \\
         & =
         \frac{
            \vat{\left(
               \dintrpa{\ux}{x}
               \dintrpa{\ux}{x}
            \right)}{\xip, \xjc}
            -
            \vat{\left(
               \dintrpa{\ux}{x}
               \dintrpa{\ux}{x}
            \right)}{\xim, \xjc}
         }{\Delta x_{\xic}}
         -
         \vat{\ux}{\xic, \xjc}
         \frac{
            \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
            -
            \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
         }{\Delta x_{\xic}} \\
         & =
         \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
         \frac{
            \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
            -
            \vat{\ux}{\xic, \xjc}
         }{\Delta x_{\xic}}
         -
         \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
         \frac{
            \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
            -
            \vat{\ux}{\xic, \xjc}
         }{\Delta x_{\xic}} \\
         & =
         \vat{\dintrpa{\ux}{x}}{\xip, \xjc}
         \frac{1}{\Delta x_{\xic}} \frac{
            \vat{\diffe{\ux}{x}}{\xip, \xjc}
         }{2}
         +
         \vat{\dintrpa{\ux}{x}}{\xim, \xjc}
         \frac{1}{\Delta x_{\xic}} \frac{
            \vat{\diffe{\ux}{x}}{\xim, \xjc}
         }{2} \\
         & =
         \frac{\Delta x_{\xip}}{2 \Delta x_{\xic}}
         \vat{\left( \dintrpa{\ux}{x} \dder{\ux}{x} \right)}{\xip, \xjc}
         +
         \frac{\Delta x_{\xim}}{2 \Delta x_{\xic}}
         \vat{\left( \dintrpa{\ux}{x} \dder{\ux}{x} \right)}{\xim, \xjc} \\
         & =
         \vat{C}{\xip}
         \vat{\left( \dintrpa{\ux}{x} \dder{\ux}{x} \right)}{\xip, \xjc}
         +
         \vat{C}{\xim}
         \vat{\left( \dintrpa{\ux}{x} \dder{\ux}{x} \right)}{\xim, \xjc} \\
         & =
         \color{red}{
            \vat{
               \dintrpv{
                  \dintrpa{\ux}{x} \dder{\ux}{x}
               }{x}
            }{\xic, \xjc}
         }

      and

      .. math::
         \uy \dder{\ux}{x}
         & =
         \dder{\uy \ux}{x}
         -
         \uy \dder{\ux}{x} \\
         & =
         \dder{
            \dintrpv{\uy}{x}
            \dintrpa{\ux}{y}
         }{y}
         -
         \ux \dintrpv{
            \dder{\uy}{y}
         }{x} \\
         & =
         \dder{
            \dintrpv{\uy}{x}
            \dintrpa{\ux}{y}
         }{y}
         -
         \ux \dder{
            \dintrpv{\uy}{x}
         }{y} \\
         & =
         \frac{
            \vat{
               \left(
                  \dintrpv{\uy}{x}
                  \dintrpa{\ux}{y}
               \right)
            }{\xic, \xjp}
            -
            \vat{
               \left(
                  \dintrpv{\uy}{x}
                  \dintrpa{\ux}{y}
               \right)
            }{\xic, \xjm}
         }{\Delta y}
         -
         \vat{
            \ux
         }{\xic, \xjc}
         \frac{
            \vat{
               \dintrpv{\uy}{x}
            }{\xic, \xjp}
            -
            \vat{
               \dintrpv{\uy}{x}
            }{\xic, \xjm}
         }{\Delta y} \\
         & =
         \vat{\dintrpv{\uy}{x}}{\xic, \xjp}
         \frac{
            \vat{\dintrpa{\ux}{y}}{\xic, \xjp}
            -
            \vat{\ux}{\xic, \xjc}
         }{\Delta y}
         -
         \vat{\dintrpv{\uy}{x}}{\xic, \xjm}
         \frac{
            \vat{\dintrpa{\ux}{y}}{\xic, \xjm}
            -
            \vat{\ux}{\xic, \xjc}
         }{\Delta y} \\
         & =
         \frac{1}{2}
         \vat{
            \left(
               \dintrpv{\uy}{x}
               \dder{\ux}{y}
            \right)
         }{\xic, \xjp}
         +
         \frac{1}{2} \vat{
            \left(
               \dintrpv{\uy}{x}
               \dder{\ux}{y}
            \right)
         }{\xic, \xjm} \\
         & =
         \color{red}{
            \vat{
               \dintrpa{
                  \dintrpv{\uy}{x}
                  \dder{\ux}{y}
               }{y}
            }{\xic, \xjc}
         }.

   #. Advection of :math:`\uy`

      The gradient form

      .. math::
         \ux \dder{\uy}{x}
         +
         \uy \dder{\uy}{y}

      is defined at :math:`y` cell face :math:`\left( \yic, \yjc \right)` and  is written as

      .. math::
         \dder{\ux \uy}{x}
         +
         \dder{\uy \uy}{y}
         -
         \uy \left(
            \dder{\ux}{x}
            +
            \dder{\uy}{y}
         \right)

      i.e.,

      .. math::
         \left( \text{divergence form} \right) - \uy \left( \text{incompressibility constraint} \right).

      Since the incompressibility constraint is defined at cell center, we need to interpolate them to the cell face in-between:

      .. math::
         \vat{
            \dder{u_i}{x_i}
         }{\yic, \yjc}
         =
         \vat{
            \dintrpa{
               \dder{u_i}{x_i}
            }{y}
         }{\yic, \yjc}.

      Thus,

      .. math::
         \ux \dder{\uy}{x}
         & =
         \dder{\ux \uy}{x}
         -
         \uy \dder{\ux}{x} \\
         & =
         \dder{
            \dintrpa{\ux}{y}
            \dintrpa{\uy}{x}
         }{x}
         -
         \uy \dintrpa{
            \dder{\ux}{x}
         }{y} \\
         & =
         \dder{
            \dintrpa{\ux}{y}
            \dintrpa{\uy}{x}
         }{x}
         -
         \uy \dder{
            \dintrpa{\ux}{y}
         }{x} \\
         & =
         \frac{
            \vat{\left(
               \dintrpa{\ux}{y}
               \dintrpa{\uy}{x}
            \right)}{\yip, \yjc}
            -
            \vat{\left(
               \dintrpa{\ux}{y}
               \dintrpa{\uy}{x}
            \right)}{\yim, \yjc}
         }{\Delta x_{\yic}}
         -
         \vat{\uy}{\yic, \yjc}
         \frac{
            \vat{\dintrpa{\ux}{y}}{\yip, \yjc}
            -
            \vat{\dintrpa{\ux}{y}}{\yim, \yjc}
         }{\Delta x_{\yic}} \\
         & =
         \vat{\dintrpa{\ux}{y}}{\yip, \yjc}
         \frac{
            \vat{\dintrpa{\uy}{x}}{\yip, \yjc}
            -
            \vat{\uy}{\yic, \yjc}
         }{\Delta x_{\yic}}
         -
         \vat{\dintrpa{\ux}{y}}{\yim, \yjc}
         \frac{
            \vat{\dintrpa{\uy}{x}}{\yim, \yjc}
            -
            \vat{\uy}{\yic, \yjc}
         }{\Delta x_{\yic}} \\
         & =
         \vat{\dintrpa{\ux}{y}}{\yip, \yjc}
         \frac{1}{\Delta x_{\yic}} \frac{
            \vat{\diffe{\uy}{x}}{\yip, \yjc}
         }{2}
         +
         \vat{\dintrpa{\ux}{y}}{\yim, \yjc}
         \frac{1}{\Delta x_{\yic}} \frac{
            \vat{\diffe{\uy}{x}}{\yim, \yjc}
         }{2} \\
         & =
         \frac{\Delta x_{\yip}}{2 \Delta x_{\yic}}
         \vat{\left( \dintrpa{\ux}{y} \dder{\uy}{x} \right)}{\yip, \yjc}
         +
         \frac{\Delta x_{\yim}}{2 \Delta x_{\yic}}
         \vat{\left( \dintrpa{\ux}{y} \dder{\uy}{x} \right)}{\yim, \yjc} \\
         & =
         \vat{C}{\yip}
         \vat{\left( \dintrpa{\ux}{y} \dder{\uy}{x} \right)}{\yip, \yjc}
         +
         \vat{C}{\yim}
         \vat{\left( \dintrpa{\ux}{y} \dder{\uy}{x} \right)}{\yim, \yjc} \\
         & =
         \color{red}{
            \vat{
               \dintrpv{
                  \dintrpa{\ux}{y} \dder{\uy}{x}
               }{x}
            }{\yic, \yjc}
         }

      and

      .. math::
         \uy \dder{\uy}{y}
         & =
         \dder{\uy \uy}{y}
         -
         \uy \dder{\uy}{y} \\
         & =
         \dder{
            \dintrpa{\uy}{y}
            \dintrpa{\uy}{y}
         }{y}
         -
         \uy \dintrpa{
            \dder{\uy}{y}
         }{y} \\
         & =
         \dder{
            \dintrpa{\uy}{y}
            \dintrpa{\uy}{y}
         }{y}
         -
         \uy \dder{
            \dintrpa{\uy}{y}
         }{y} \\
         & =
         \frac{
            \vat{
               \left(
                  \dintrpa{\uy}{y}
                  \dintrpa{\uy}{y}
               \right)
            }{\yic, \yjp}
            -
            \vat{
               \left(
                  \dintrpa{\uy}{y}
                  \dintrpa{\uy}{y}
               \right)
            }{\yic, \yjm}
         }{\Delta y}
         -
         \vat{
            \uy
         }{\yic, \yjc}
         \frac{
            \vat{
               \dintrpa{\uy}{y}
            }{\yic, \yjp}
            -
            \vat{
               \dintrpa{\uy}{y}
            }{\yic, \yjm}
         }{\Delta y} \\
         & =
         \vat{\dintrpa{\uy}{y}}{\yic, \yjp}
         \frac{
            \vat{\dintrpa{\uy}{y}}{\yic, \yjp}
            -
            \vat{\uy}{\yic, \yjc}
         }{\Delta y}
         -
         \vat{\dintrpa{\uy}{y}}{\yic, \yjm}
         \frac{
            \vat{\dintrpa{\uy}{y}}{\yic, \yjm}
            -
            \vat{\uy}{\yic, \yjc}
         }{\Delta y} \\
         & =
         \frac{1}{2} \vat{
            \left(
               \dintrpa{\uy}{y}
               \dder{\uy}{y}
            \right)
         }{\yic, \yjp}
         +
         \frac{1}{2} \vat{
            \left(
               \dintrpa{\uy}{y}
               \dder{\uy}{y}
            \right)
         }{\yic, \yjm} \\
         & =
         \color{red}{
            \vat{
               \dintrpa{
                  \dintrpa{\uy}{y}
                  \dder{\uy}{y}
               }{y}
            }{\yic, \yjc}
         }.

'''''''''''''''''''''''
Pressure-gradient terms
'''''''''''''''''''''''

Since they are simple gradients, we discretise them as

.. math::
   \vat{\dder{p}{x}}{\xic, \xjc},
   \vat{\dder{p}{y}}{\yic, \yjc}

in :math:`x` and :math:`y` directions, respectively.

'''''''''''''''
Diffusive terms
'''''''''''''''

These terms *diffuse* the momentum in all directions.
Also, they play a crucial role to (diffuse and) *dissipate* the kinetic energy.
In this project, all injected energy should be eventually dissipated by them since there is no other energy sink.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1. Diffusion of :math:`\ux` and :math:`\uy`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Since they are linear (and thus we can treat them implicitly in time, see :ref:`the temporal discretisation <temporal_discretisation>`), we can simply discretise them as

.. math::
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{\ux}{x} \right)
      +
      \dder{}{y} \left( \dder{\ux}{y} \right)
   \right\}

in :math:`x` direction at :math:`\left( \xic, \xjc \right)` where :math:`\ux` is defined, while

.. math::
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{\uy}{x} \right)
      +
      \dder{}{y} \left( \dder{\uy}{y} \right)
   \right\}

in :math:`y` direction at :math:`\left( \yic, \yjc \right)` where :math:`\uy` is defined.
All first-order differentiations are defined where needed and thus no interpolation is necessary.

~~~~~~~~~~~~~~~~~~~~~~~~~~~
2. Dissipation of :math:`k`
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Discrete form of :math:`\der{u_i}{x_j} \der{u_i}{x_j}`, which are used to compute the dissipation rate of the kinetic energy, are discretised, which are

.. math::
   \left( \der{\ux}{x} \right)^2
   +
   \left( \der{\ux}{y} \right)^2
   \approx &
   s_{xx} s_{xx}
   +
   s_{xy} s_{xy} \\
   \equiv &
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
   + &
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
   \left( \der{\uy}{x} \right)^2
   +
   \left( \der{\uy}{y} \right)^2
   \approx &
   s_{yx} s_{yx}
   +
   s_{yy} s_{yy} \\
   \equiv &
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
   + &
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

at :math:`\left( \yic, \yjc \right)`.

.. details:: Derivations

   In :ref:`the governing equations <governing_equations>` (for continuous domain), we took the inner product of :math:`u_i` and the momentum balance to derive the relation of the diffusion and dissipation of :math:`k`:

   .. math::
      u_i \der{}{x_j} \left( \der{u_i}{x_j} \right)
      =
      \der{}{x_j} \left( u_i \der{u_i}{x_j} \right)
      -
      \der{u_i}{x_j} \der{u_i}{x_j},

   where pre-factors :math:`\sqrt{Pr} / \sqrt{Ra}` are dropped for convenience.
   Here we consider the counterpart in the discrete space.

   First, we focus on the contribution of the momentum in :math:`x` direction.
   At :math:`\left( \xic, \xjc \right)`, the left-hand-side is

   .. math::
      \ux
      \left\{
         \dder{}{x} \left( \dder{\ux}{x} \right)
         +
         \dder{}{y} \left( \dder{\ux}{y} \right)
      \right\}
      & =
      \frac{
         \vat{\ux}{\xic, \xjc}
         \vat{
            \dder{\ux}{x}
         }{\xip, \xjc}
         -
         \vat{\ux}{\xic, \xjc}
         \vat{
            \dder{\ux}{x}
         }{\xim, \xjc}
      }{\Delta x_{\xic}} \\
      & +
      \frac{
         \vat{\ux}{\xic, \xjc}
         \vat{
            \dder{\ux}{y}
         }{\xic, \xjp}
         -
         \vat{\ux}{\xic, \xjc}
         \vat{
            \dder{\ux}{y}
         }{\xic, \xjm}
      }{\Delta y},

   while the first term in the right-hand-side (diffusion of :math:`\ux^2/2`) leads

   .. math::
      \dder{}{x} \left( \ux \dder{\ux}{x} \right)
      +
      \dder{}{y} \left( \ux \dder{\ux}{y} \right)
      & =
      \frac{
         \vat{
            \dintrpa{\ux}{x}
         }{\xip, \xjc}
         \vat{
            \dder{\ux}{x}
         }{\xip, \xjc}
         -
         \vat{
            \dintrpa{\ux}{x}
         }{\xim, \xjc}
         \vat{
            \dder{\ux}{x}
         }{\xim, \xjc}
      }{\Delta x_{\xic}} \\
      & +
      \frac{
         \vat{
            \dintrpa{\ux}{y}
         }{\xic, \xjp}
         \vat{
            \dder{\ux}{y}
         }{\xic, \xjp}
         -
         \vat{
            \dintrpa{\ux}{y}
         }{\xic, \xjm}
         \vat{
            \dder{\ux}{y}
         }{\xic, \xjm}
      }{\Delta y}.

   Subtracting the first equation from the second one yields

   .. math::
      &
      \frac{
         \left(
            \vat{
               \dintrpa{\ux}{x}
            }{\xip, \xjc}
            -
            \vat{\ux}{\xic, \xjc}
         \right)
         \vat{
            \dder{\ux}{x}
         }{\xip, \xjc}
         -
         \left(
            \vat{
               \dintrpa{\ux}{x}
            }{\xim, \xjc}
            -
            \vat{\ux}{\xic, \xjc}
         \right)
         \vat{
            \dder{\ux}{x}
         }{\xim, \xjc}
      }{\Delta x_{\xic}} \\
      + &
      \frac{
         \left(
            \vat{
               \dintrpa{\ux}{y}
            }{\xic, \xjp}
            -
            \vat{\ux}{\xic, \xjc}
         \right)
         \vat{
            \dder{\ux}{y}
         }{\xic, \xjp}
         -
         \left(
            \vat{
               \dintrpa{\ux}{y}
            }{\xic, \xjm}
            -
            \vat{\ux}{\xic, \xjc}
         \right)
         \vat{
            \dder{\ux}{y}
         }{\xic, \xjm}
      }{\Delta y} \\
      = &
      \color{red}{
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
         }{\xim, \xjc}
      } \\
      \color{red}{+} &
      \color{red}{
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
      }.

   .. note::

      We find that four contributions exist:

      .. math::
         \begin{cases}
            \text{left cell} \left( \xim, \xjc \right)
            &
            \frac{1}{2}
            \frac{1}{\Delta x_{\xic}}
            \vat{
               \diffe{\ux}{x}
            }{\xim, \xjc}
            \vat{
               \dder{\ux}{x}
            }{\xim, \xjc} \\
            \text{right cell} \left( \xip, \xjc \right)
            &
            \frac{1}{2}
            \frac{1}{\Delta x_{\xic}}
            \vat{
               \diffe{\ux}{x}
            }{\xip, \xjc}
            \vat{
               \dder{\ux}{x}
            }{\xip, \xjc} \\
            \text{bottom cell} \left( \xic, \xjm \right)
            &
            \frac{1}{2}
            \frac{1}{\Delta y}
            \vat{
               \diffe{\ux}{y}
            }{\xic, \xjm}
            \vat{
               \dder{\ux}{y}
            }{\xic, \xjm} \\
            \text{top cell} \left( \xic, \xjp \right)
            &
            \frac{1}{2}
            \frac{1}{\Delta y}
            \vat{
               \diffe{\ux}{y}
            }{\xic, \xjp}
            \vat{
               \dder{\ux}{y}
            }{\xic, \xjp}
         \end{cases}

      The bottom and top contributions are implemented directly in :ref:`src/analyses.c <analyses>`, while the left and right contributions need special attention.
      On the left boundary, the left-cell contribution is null since it is inside the wall, while the right contribution remains.
      The same notice holds for the right boundary.

      If the boundary effects are neglected, we have

      .. math::
         &
         \frac{\Delta x_{\xip}}{2 \Delta x_{\xic}}
         \left(
            \vat{
               \dder{\ux}{x}
            }{\xip, \xjc}
         \right)^2
         +
         \frac{\Delta x_{\xim}}{2 \Delta x_{\xic}}
         \left(
            \vat{
               \dder{\ux}{x}
            }{\xim, \xjc}
         \right)^2 \\
         + &
         \frac{1}{2}
         \left(
            \vat{
               \dder{\ux}{y}
            }{\xic, \xjp}
         \right)^2
         +
         \frac{1}{2}
         \left(
            \vat{
               \dder{\ux}{y}
            }{\xic, \xjm}
         \right)^2 \\
         & =
         \dintrpv{
            \left(
               \dder{\ux}{x}
            \right)^2
         }{x}
         +
         \dintrpa{
            \left(
               \dder{\ux}{y}
            \right)^2
         }{y}.

   Similarly,

   .. math::
      &
      \frac{
         \left(
            \vat{
               \dintrpa{\uy}{x}
            }{\yip, \yjc}
            -
            \vat{\uy}{\yic, \yjc}
         \right)
         \vat{
            \dder{\uy}{x}
         }{\yip, \yjc}
         -
         \left(
            \vat{
               \dintrpa{\uy}{x}
            }{\yim, \yjc}
            -
            \vat{\uy}{\yic, \yjc}
         \right)
         \vat{
            \dder{\uy}{x}
         }{\yim, \yjc}
      }{\Delta x_{\yic}} \\
      + &
      \frac{
         \left(
            \vat{
               \dintrpa{\uy}{y}
            }{\yic, \yjp}
            -
            \vat{\uy}{\yic, \yjc}
         \right)
         \vat{
            \dder{\uy}{y}
         }{\yic, \yjp}
         -
         \left(
            \vat{
               \dintrpa{\uy}{y}
            }{\yic, \yjm}
            -
            \vat{\uy}{\yic, \yjc}
         \right)
         \vat{
            \dder{\uy}{y}
         }{\yic, \yjm}
      }{\Delta y} \\
      = &
      \color{red}{
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
         }{\yim, \yjc}
      } \\
      \color{red}{+} &
      \color{red}{
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
      },

   which is :math:`\uy` contribution defined at :math:`\left( \yic, \yjc \right)`.

   .. note::

      If the boundary effects are neglected, we have

      .. math::
         \dintrpv{
            \left(
               \dder{\uy}{x}
            \right)^2
         }{x}
         +
         \dintrpa{
            \left(
               \dder{\uy}{y}
            \right)^2
         }{y}.

   The reddish parts are computed in :ref:`analyses_compute_kinetic_dissipation <analyses>` since these quantities have direct relations with the dissipation rate of the kinetic energy.

''''''''''''''''''''''
External forcing terms
''''''''''''''''''''''

In the momentum balance, we have

.. math::
   \dintrpu{T}{x}

in :math:`x` direction at :math:`\left( \xic, \xjc \right)`, while :math:`0` in :math:`y` direction.

In the kinetic energy balance, we have

.. math::
   \ux \dintrpu{T}{x}

in :math:`x` direction at :math:`\left( \yic, \yjc \right)`, while :math:`0` in :math:`y` direction.

.. note::

   In order to replace :math:`\dintrpu{T}{x}`, we need to focus on :ref:`the Nusselt number relations <nusselt_number_relations>`.

**********************************
Derivations - global conservations
**********************************

In this part, we analyse the *global* properties of equations averaged in the whole volume, which plays a crucial role when we discuss :ref:`the energy balance of Rayleigh-Bénard convections <nusselt_number_relations>`.

Following the above discussion, the evolutions of :math:`\frac{1}{2} \ux^2` and :math:`\frac{1}{2} \uy^2` lead

.. math::
   \der{}{t} \left( \frac{1}{2} \ux^2 \right)
   & +
   \dder{
      \dintrpa{\ux}{x}
      q_{xx}
   }{x}
   +
   \dder{
      \dintrpv{\uy}{x}
      q_{xy}
   }{y} \\
   & =
   -\ux \dder{p}{x}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \ux \dder{\ux}{x} \right)
      +
      \dder{}{y} \left( \ux \dder{\ux}{y} \right)
   \right\}
   -
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left(
      s_{xx} s_{xx}
      +
      s_{xy} s_{xy}
   \right) \\
   & +
   \ux \dintrpu{T}{x}

defined at :math:`\left( \xic, \xjc \right)` and

.. math::
   \der{}{t} \left( \frac{1}{2} \uy^2 \right)
   & +
   \dder{
      \dintrpa{\ux}{y}
      q_{yx}
   }{x}
   +
   \dder{
      \dintrpa{\uy}{y}
      q_{yy}
   }{y} \\
   & =
   -\uy \dder{p}{y}
   +
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left\{
      \dder{}{x} \left( \uy \dder{\uy}{x} \right)
      +
      \dder{}{y} \left( \uy \dder{\uy}{y} \right)
   \right\}
   -
   \frac{\sqrt{Pr}}{\sqrt{Ra}} \left(
      s_{yx} s_{yx}
      +
      s_{yy} s_{yy}
   \right)

defined at :math:`\left( \yic, \yjc \right)`.

Now we consider to integrate these equations in the whole volume to deduce the evolutions of the *total* *discrete* kinetic energy :math:`K`:

.. math::
   K
   \equiv
   \sum_{i} \sum_{j}
   \vat{
      \left( \frac{1}{2} \ux^2 \Delta x \Delta y \right)
   }{\xic, \xjc}
   +
   \sum_{i} \sum_{j}
   \vat{
      \left( \frac{1}{2} \uy^2 \Delta x \Delta y \right)
   }{\yic, \yjc}.

As usual, conservative terms vanish.
Also the pressure gradients do not contribute to the net change in the kinetic energy.

.. details:: Derivations

   Their contributions to the energy equation leads

   .. math::
      \int \ux \der{p}{x} dV
      \approx
      \sum_{i} \sum_{j}
      \vat{
         \left(
            \ux \dder{p}{x} \Delta x \Delta y
         \right)
      }{\xic, \xjc}

   from the momentum balance in :math:`x` direction, while

   .. math::
      \int \uy \der{p}{y} dV
      \approx
      \sum_{i} \sum_{J}
      \vat{
         \left(
            \uy \dder{p}{y} \Delta x \Delta y
         \right)
      }{\yic, \yjc}

   from the momentum balance in :math:`y` direction.
   Note that the summation symbols are for all positions :math:`\ux` and :math:`\uy` are defined, respectively.

   They lead

   .. math::
      \sum_{i} \sum_{j}
      \vat{\ux}{\xic, \xjc}
      \frac{
         \vat{p}{\xip, \xjc}
         -
         \vat{p}{\xim, \xjc}
      }{\Delta x_{\xic}}
      \Delta x_{\xic}
      \Delta y
      =
      \sum_{i} \sum_{j}
      \vat{\ux}{\xic, \xjc}
      \left(
         \vat{p}{\xip, \xjc}
         -
         \vat{p}{\xim, \xjc}
      \right)
      \Delta y,

   and

   .. math::
      \sum_{i} \sum_{j}
      \vat{\uy}{\yic, \yjc}
      \frac{
         \vat{p}{\yic, \yjp}
         -
         \vat{p}{\yic, \yjm}
      }{\Delta y}
      \Delta x_{\yic}
      \Delta y
      =
      \sum_{i} \sum_{j}
      \vat{\uy}{\yic, \yjc}
      \left(
         \vat{p}{\yic, \yjp}
         -
         \vat{p}{\yic, \yjm}
      \right)
      \Delta x_{\yic}.

   Note that, although we write them as the sum of terms defined at :math:`\ux` locations (:math:`\sum \ux \left( \cdots \right)`) and :math:`\uy` locations (:math:`\sum \uy \left( \cdots \right)`), they can be written as the sum of terms defined at :math:`p` locations (:math:`\sum p \left( \cdots \right)`):

   .. math::
      \sum_{i} \sum_{j}
      -
      \vat{p}{\pic, \pjc}
      \left(
         \vat{\ux}{\pip, \pjc}
         -
         \vat{\ux}{\pim, \pjc}
      \right)
      \Delta y

   and

   .. math::
      \sum_{i} \sum_{j}
      -
      \vat{p}{\pic, \pjc}
      \left(
         \vat{\uy}{\pic, \pjp}
         -
         \vat{\uy}{\pic, \pjm}
      \right)
      \Delta x_{\pic}.

   Since they are defined at the same locations, we merge them as

   .. math::
      \sum_{i} \sum_{j}
      -
      \vat{p}{\pic, \pjc}
      \vat{
         \left(
            \dder{\ux}{x}
            +
            \dder{\uy}{y}
         \right)
      }{\pic, \pjc}
      \Delta x_{\pic}
      \Delta y,

   which vanishes because of the continuity.

   .. note::

      The last equation is the discrete approximation of

      .. math::
         \int -p \der{u_i}{x_i} dV.

As a result, we have

.. math::
   \der{K}{t}
   & \equiv
   \der{}{t} \sum_{i} \sum_{j} \vat{
      \left(
         \frac{1}{2} \ux^2 \Delta x \Delta y
      \right)
   }{\xic, \xjc}
   +
   \der{}{t} \sum_{i} \sum_{j} \vat{
      \left(
         \frac{1}{2} \uy^2 \Delta x \Delta y
      \right)
   }{\yic, \yjc} \\
   & =
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
   & +
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
   }{\yic, \yjc}.

.. note::

   In a statistically-steady state where the temporal dependencies vanish, we find that the energy injection by the buoyancy force is balanced by the kinetic dissipation.

.. details:: When the walls move

   It would be useful to derive the relation when the walls are not at rest, i.e., :math:`\vat{\uy}{\text{left wall}} \ne 0, \vat{\uy}{\text{right wall}} \ne 0`.
   In this case, when being integrated in the whole volume, the diffusive terms in :math:`x` direction lead

   .. math::
      \sum_j \vat{
         \left(
            \frac{\sqrt{Pr}}{\sqrt{Ra}} \left[
               \ux \dder{\ux}{x}
            \right]_{\text{left wall}}^{\text{right wall}} \Delta y
         \right)
      }{\xic, \xjc},
      \sum_j \vat{
         \left(
            \frac{\sqrt{Pr}}{\sqrt{Ra}} \left[
               \uy \dder{\uy}{x}
            \right]_{\text{left wall}}^{\text{right wall}} \Delta y
         \right)
      }{\yic, \yjc},

   respectively.

   Being regardless of the wall motions, impermeable walls impose :math:`\ux \equiv 0` and thus the first term vanishes anyway (permeable walls are out of focus now).

   Regarding the second term, :math:`\uy` on the walls are given as the boundary conditions and thus the integrand can be linearised.
   :math:`\frac{\sqrt{Pr}}{\sqrt{Ra}} \dder{\uy}{x}` on the walls are the discrete shear stress on the walls which are evaluated when computing the diffusive term in the momentum balance.


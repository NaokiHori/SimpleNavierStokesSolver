
.. _thermal_energy_balance:

#############################################
Thermal energy balance and quadratic quantity
#############################################

************
Introduction
************

In this part, we consider to discretise

.. math::
   \der{T}{t}
   +
   u_i \der{T}{x_i}
   =
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \frac{\partial^2 T}{\partial x_i \partial x_i}

at cell center :math:`\left( \pic, \pjc \right)`.

Also a relevant (dependent) balance of the quadratic quantity

.. math::
   \der{h}{t}
   +
   u_i \der{h}{x_i}
   =
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{}{x_i} \left( T \der{T}{x_i} \right)
   -
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \der{T}{x_i} \der{T}{x_i}

is considered.
Note that this can be obtained by multiplying the temperature :math:`T` and the thermal energy balance, whose derivation in the continuous domain can be found in :ref:`the governing equations <governing_equations>`.

**********
Conclusion
**********

The following discrete equations are directly implemented in the code.

.. math::
   \der{T}{t}
   +
   \dintrpv{
      \ux
      \dder{T}{x}
   }{x}
   +
   \dintrpa{
      \uy
      \dder{T}{y}
   }{y}
   =
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{T}{x} \right)
      +
      \dder{}{y} \left( \dder{T}{y} \right)
   \right\},

which is defined at :math:`\left( \pic, \pjc \right)`.

The implementation can be found in :ref:`src/temperature/update.c <temperature_update>`.

*********************************
Derivations - local conservations
*********************************

In this part, we focus on the *local* property of equations, e.g., how each term is discretised to make it :ref:`conservative <basic_operators>`.
This is necessary to discuss the *global* properties (after being integrated in the volume), which will be discussed later.

===============
Advective terms
===============

Similar to the momentum balance, these terms should not alter the total amount of :math:`T` as well as :math:`h`.
We should keep this property even after being discretised.

Derivations are given below.

-------------------------------------
1. Divergence form of advective terms
-------------------------------------

We find the discrete form of the advection of :math:`T` is given as

.. math::
   \dder{\ux \dintrpu{T}{x}}{x}
   +
   \dder{\uy \dintrpa{T}{y}}{y},

where :math:`\dintrpu{T}{x}` has not been defined yet.

.. details:: Derivations

   As being derived in :ref:`the governing equations <governing_equations>`, the advection of the temperature is described as

   .. math::
      u_i \der{T}{x_i},

   which is the so-called *gradient form*.
   Thanks to the incompressibility constraint, this term can be written in a conservative form as

   .. math::
      u_i \der{T}{x_i}
      +
      T \der{u_i}{x_i}
      =
      \der{u_i T}{x_i},

   whose right-hand-side is named as the *divergence form*.

   Since the divergence form is inherently conservative, we obtain a discrete form of the advective term as

   .. math::
      \dder{u_i T}{x_i}
      =
      \dder{\ux \dintrpu{T}{x}}{x}
      +
      \dder{\uy \dintrpu{T}{y}}{y},

   which is defined at cell center :math:`\left( \pic, \pjc \right)`.

   .. note::
      Interpolations are not necessary for the velocities :math:`\ux` and :math:`\uy` since they are defined at cell faces.

   Because of the uniform grid spacings in :math:`y` direction, the interpolation in :math:`y` direction can be replaced by an arithmetic average, giving

   .. math::
      \dder{u_i T}{x_i}
      =
      \dder{\ux \dintrpu{T}{x}}{x}
      +
      \dder{\uy \dintrpa{T}{y}}{y}.

   In order to obtain an explicit form of the interpolation in :math:`x` direction, we investigate the advection of :math:`h`.

------------------------------------
2. Advection of quadratic quantities
------------------------------------

We find the discrete form of the advection of :math:`T` is given as

.. math::
   \dder{\ux \dintrpa{T}{x}}{x}
   +
   \dder{\uy \dintrpa{T}{y}}{y},

where the interpolation which was undefined is defined.

.. details:: Derivations

   As shown in :ref:`the governing equations <governing_equations>`, this can be represented by multiplying the advective terms of the temperature by :math:`T`.
   The discrete counterpart is twofold,

   .. math::
      T \dder{\ux \dintrpu{T}{x}}{x}
      =
      \color{blue}{
      \vat{
         T
      }{\pic, \pjc}
      }
      \frac{
         \color{blue}{
         \vat{\ux}{\pip, \pjc}
         }
         \left(
            \color{blue}{
            \vat{c^+}{\pipp} \vat{T}{\pipp, \pjc}
            }
            +
            \vat{c^+}{\pic } \vat{T}{\pic,  \pjc}
         \right)
         -
         \color{blue}{
         \vat{\ux}{\pim, \pjc}
         }
         \left(
            \vat{c^-}{\pic } \vat{T}{\pic,  \pjc}
            +
            \color{blue}{
            \vat{c^-}{\pimm} \vat{T}{\pimm, \pjc}
            }
         \right)
      }{\Delta x_{\pic}}

   and

   .. math::
      T \dder{\uy \dintrpu{T}{y}}{y}
      =
      \vat{
         T
      }{\pic, \pjc}
      \frac{
         \vat{\uy}{\pic, \pjp}
         \frac{
            \vat{T}{\pic, \pjpp}
            +
            \vat{T}{\pic, \pjc }
         }{2}
         -
         \vat{\uy}{\pic, \pjm}
         \frac{
            \vat{T}{\pic, \pjc }
            +
            \vat{T}{\pic, \pjmm}
         }{2}
      }{\Delta y},

   where small letters :math:`c` are coefficients to be determined.

   In order to keep the net amount of :math:`h`, we enforce them to be conservative.
   The second part yields

   .. math::
      \dder{\uy q_y}{y}
      +
      \frac{
         \vat{T^2}{\pic, \pjc}
      }{2}
      \dder{\uy}{y},

   where :math:`q_y` is the quadratic quantity, defined as the product of the surrounding :math:`T` at cell faces where :math:`\uy` are located, e.g.,

   .. math::
      \vat{q_y}{\pip, \pjc}
      \equiv
      \frac{1}{2}
      \vat{T}{\pic,  \pjc}
      \vat{T}{\pipp, \pjc}

   at :math:`\left( \pip, \pjc \right)`.
   Since the first term is in a conservative form, the volume integral vanishes, while the second part is the residual, which is generally non-zero.

   Similarly, the first part can be decomposed to two terms.

   #. Quadratic quantity

      The bluish terms consist of the other quadratic quantity :math:`q_x` and should be in a conservative form.
      To be so, we request two coefficients :math:`\vat{c^+}{\pipp}` and :math:`\vat{c^-}{\pimm}` to be :math:`1/2`.

   #. Residual

      The second part leads

      .. math::
         \vat{T^2}{\pic, \pjc}
         \frac{
            \vat{c^+}{\pic }
            \vat{\ux}{\pim, \pjc}
            -
            \vat{c^-}{\pic }
            \vat{\ux}{\pim, \pjc}
         }{\Delta x_{\pic}}

      This should be canceled out with the other residual

      .. math::
         \frac{
            \vat{T^2}{\pic, \pjc}
         }{2}
         \dder{\uy}{y},

      requesting two coefficients :math:`\vat{c^+}{\pic }` and :math:`\vat{c^-}{\pic }` to be :math:`1/2`, so that the summation of two vanishes thanks to the incompressibility constraint.

   In conclusion, all coefficients are :math:`1/2` and thus we find :math:`\dintrpu{T}{x}` is an arithmetic average :math:`\dintrpa{T}{x}`.
   Finally we obtain the advective terms in divergence form:

   .. math::
      \dder{\ux T}{x}
      +
      \dder{\uy T}{y}
      =
      \color{red}{
         \dder{
            \ux
            \dintrpa{T}{x}
         }{x}
         +
         \dder{
            \uy
            \dintrpa{T}{y}
         }{y}
      }

   defined at cell center :math:`\left( \pic, \pjc \right)`.

-----------------------------------
3. Gradient form of advective terms
-----------------------------------

We find that the advective terms can also be written as

.. math::
   \dintrpv{
      \ux
      \dder{T}{x}
   }{x}
   +
   \dintrpa{
      \uy
      \dder{T}{y}
   }{y}.

.. details:: Derivations

   Being analogous to the momentum advections, the divergence and gradient forms should be identical to each other via the incompressibility constraint, i.e.,

   .. math::
      u_i \dder{T}{x_i}
      =
      \dder{u_i T}{x_i}
      -
      T \dder{u_i}{x_i},

   which is defined at cell center :math:`\left( \pic, \pjc \right)`.

   Being different from the advective terms in the momentum balance, we do not have to interpolate the incompressibility constraint since it is located at the same position as the temperature.
   Thus the gradient form leads

   .. math::
      \ux \dder{T}{x}
      & =
      \dder{\ux T}{x}
      -
      T \dder{\ux}{x} \\
      & =
      \dder{
         \ux
         \dintrpa{T}{x}
      }{x}
      - T \dder{
         \ux
      }{x} \\
      & =
      \frac{
         \vat{\ux}{\pip, \pjc}
         \frac{
            \vat{T}{\pipp, \pjc}
            +
            \vat{T}{\pic,  \pjc}
         }{2}
         -
         \vat{\ux}{\pim, \pjc}
         \frac{
            \vat{T}{\pic,  \pjc}
            +
            \vat{T}{\pimm, \pjc}
         }{2}
      }{\Delta x_{\pic}}
      -
      \vat{T}{\pic, \pjc} \frac{
         \vat{\ux}{\pip, \pjc}
         -
         \vat{\ux}{\pim, \pjc}
      }{\Delta x_{\pic}} \\
      & =
      \vat{\ux}{\pip, \pjc}
      \frac{1}{\Delta x_{\pic}}
      \frac{
         \vat{
            \diffe{T}{x}
         }{\pip, \pjc}
      }{2}
      +
      \vat{\ux}{\pim, \pjc}
      \frac{1}{\Delta x_{\pic}}
      \frac{
         \vat{
            \diffe{T}{x}
         }{\pim, \pjc}
      }{2} \\
      & =
      \frac{\Delta x_{\pip}}{2 \Delta x_{\pic}} \vat{
         \left(
            \ux
            \dder{T}{x}
         \right)
      }{\pip, \pjc}
      +
      \frac{\Delta x_{\pim}}{2 \Delta x_{\pic}} \vat{
         \left(
            \ux
            \dder{T}{x}
         \right)
      }{\pim, \pjc} \\
      & =
      \vat{C}{\pip} \vat{
         \left(
            \ux
            \dder{T}{x}
         \right)
      }{\pip, \pjc}
      +
      \vat{C}{\pim} \vat{
         \left(
            \ux
            \dder{T}{x}
         \right)
      }{\pim, \pjc} \\
      & =
      \color{red}{
         \vat{
            \dintrpv{
               \ux
               \dder{T}{x}
            }{x}
         }{\pic, \pjc}
      }

   and

   .. math::
      \uy \dder{T}{y}
      & =
      \dder{\uy T}{y}
      -
      T \dder{\uy}{y} \\
      & =
      \dder{
         \uy
         \dintrpa{T}{y}
      }{y}
      - T \dder{
         \uy
      }{y} \\
      & =
      \frac{
         \vat{\uy}{\pic, \pjp}
         \frac{
            \vat{T}{\pic, \pjpp}
            +
            \vat{T}{\pic, \pjc}
         }{2}
         -
         \vat{\uy}{\pic, \pjm}
         \frac{
            \vat{T}{\pic, \pjc}
            +
            \vat{T}{\pic, \pjmm}
         }{2}
      }{\Delta y}
      -
      \vat{T}{\pic, \pjc} \frac{
         \vat{\uy}{\pic, \pjp}
         -
         \vat{\uy}{\pic, \pjm}
      }{\Delta y} \\
      & =
      \vat{\uy}{\pic, \pjp}
      \frac{1}{\Delta y}
      \frac{
         \vat{
            \diffe{T}{y}
         }{\pic, \pjp}
      }{2}
      +
      \vat{\uy}{\pic, \pjm}
      \frac{1}{\Delta y}
      \frac{
         \vat{
            \diffe{T}{y}
         }{\pic, \pjm}
      }{2} \\
      & =
      \frac{1}{2} \vat{
         \left(
            \uy
            \dder{T}{y}
         \right)
      }{\pic, \pjp}
      +
      \frac{1}{2} \vat{
         \left(
            \uy
            \dder{T}{y}
         \right)
      }{\pic, \pjm} \\
      & =
      \color{red}{
         \vat{
            \dintrpa{
               \uy
               \dder{T}{y}
            }{y}
         }{\pic, \pjc}
      }.

===============
Diffusive terms
===============

These terms *diffuse* the thermal energy in all directions.
Also, they play a crucial role to (diffuse and) *dissipate* :math:`h`.
In this project, all injection via heating on the walls should be eventually dissipated by them.

-------------------------
1. Diffusion of :math:`T`
-------------------------

Since they are linear (and thus we can treat them implicitly in time, see :ref:`the temporal discretisation <temporal_discretisation>`), we can simply discretise them as

.. math::
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
      \dder{}{x} \left( \dder{T}{x} \right)
      +
      \dder{}{y} \left( \dder{T}{y} \right)
   \right\}

at :math:`\left( \pic, \pjc \right)` where :math:`T` is defined.
All first-order differentiations are defined where needed and thus no interpolation is necessary.

---------------------------
2. Dissipation of :math:`h`
---------------------------

Discrete form of :math:`\der{T}{x_i} \der{T}{x_i}`, which are used to compute the dissipation rate of the thermal energy, are discretised, which are

.. math::
   \left( \der{T}{x} \right)^2
   +
   \left( \der{T}{y} \right)^2
   & \approx
   r_x r_x
   +
   r_y r_y \\
   & \equiv
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
   & +
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
   }{\pic, \pjm}

at :math:`\left( \pic, \pjc \right)`.

.. details:: Derivations

   In :ref:`the governing equations <governing_equations>` (for continuous domain), we multiplied :math:`T` and the equation of internal energy balance to derive the relation of the diffusion and dissipation of :math:`h`:

   .. math::
      T \der{}{x_i} \left( \der{T}{x_i} \right)
      =
      \der{}{x_i} \left( T \der{T}{x_i} \right)
      -
      \der{T}{x_i} \der{T}{x_i},

   where pre-factors :math:`1 / \sqrt{Pr} \sqrt{Ra}` are dropped for convenience.
   Here we consider the counterpart in the discrete space.

   It is readily apparent that the left-hand-side is

   .. math::
      T
      \left\{
         \dder{}{x} \left( \dder{T}{x} \right)
         +
         \dder{}{y} \left( \dder{T}{y} \right)
      \right\}
      & =
      \frac{
         \vat{T}{\pic, \pjc}
         \vat{
            \dder{T}{x}
         }{\pip, \pjc}
         -
         \vat{T}{\pic, \pjc}
         \vat{
            \dder{T}{x}
         }{\pim, \pjc}
      }{\Delta x_{\pic}} \\
      & +
      \frac{
         \vat{T}{\pic, \pjc}
         \vat{
            \dder{T}{y}
         }{\pic, \pjp}
         -
         \vat{T}{\pic, \pjc}
         \vat{
            \dder{T}{y}
         }{\pic, \pjm}
      }{\Delta y},

   while the first term in the right-hand-side (diffusion of :math:`h`) leads

   .. math::
      \dder{}{x} \left( T \dder{T}{x} \right)
      +
      \dder{}{y} \left( T \dder{T}{y} \right)
      & =
      \frac{
         \vat{
            \dintrpa{T}{x}
         }{\pip, \pjc}
         \vat{
            \dder{T}{x}
         }{\pip, \pjc}
         -
         \vat{
            \dintrpa{T}{x}
         }{\pim, \pjc}
         \vat{
            \dder{T}{x}
         }{\pim, \pjc}
      }{\Delta x_{\pic}} \\
      & +
      \frac{
         \vat{
            \dintrpa{T}{y}
         }{\pic, \pjp}
         \vat{
            \dder{T}{y}
         }{\pic, \pjp}
         -
         \vat{
            \dintrpa{T}{y}
         }{\pic, \pjm}
         \vat{
            \dder{T}{y}
         }{\pic, \pjm}
      }{\Delta y}.

   Subtracting the first equation from the second one yields

   .. math::
      &
      \frac{
         \left(
            \vat{
               \dintrpa{T}{x}
            }{\pip, \pjc}
            -
            \vat{T}{\pic, \pjc}
         \right)
         \vat{
            \dder{T}{x}
         }{\pip, \pjc}
         -
         \left(
            \vat{
               \dintrpa{T}{x}
            }{\pim, \pjc}
            -
            \vat{T}{\pic, \pjc}
         \right)
         \vat{
            \dder{T}{x}
         }{\pim, \pjc}
      }{\Delta x_{\pic}} \\
      + &
      \frac{
         \left(
            \vat{
               \dintrpa{T}{y}
            }{\pic, \pjp}
            -
            \vat{T}{\pic, \pjc}
         \right)
         \vat{
            \dder{T}{y}
         }{\pic, \pjp}
         -
         \left(
            \vat{
               \dintrpa{T}{y}
            }{\pic, \pjm}
            -
            \vat{T}{\pic, \pjc}
         \right)
         \vat{
            \dder{T}{y}
         }{\pic, \pjm}
      }{\Delta y} \\
      = &
      \color{red}{
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
         }{\pim, \pjc}
      } \\
      \color{red}{+} &
      \color{red}{
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
         }{\pic, \pjm}
      },

   whose reddish part is computed in :ref:`analyses_compute_thermal_dissipation <analyses>`, since this quantity has a direct relation with the dissipation rate of the thermal energy.

   .. note::

      :math:`\vat{C}{\pip}, \vat{C}{\pim}` are coefficients

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
         \end{cases},

      to reflect the boundary corrections.

      If the boundary effects are neglected, we have

      .. math::
         &
         \frac{\Delta x_{\pip}}{2 \Delta x_{\pic}}
         \left(
            \vat{
               \dder{T}{x}
            }{\pip, \pjc}
         \right)^2
         +
         \frac{\Delta x_{\pim}}{2 \Delta x_{\pic}}
         \left(
            \vat{
               \dder{T}{x}
            }{\pim, \pjc}
         \right)^2 \\
         + &
         \frac{1}{2}
         \left(
            \vat{
               \dder{T}{y}
            }{\pic, \pjp}
         \right)^2
         +
         \frac{1}{2}
         \left(
            \vat{
               \dder{T}{y}
            }{\pic, \pjm}
         \right)^2 \\
         = &
         \dintrpv{
            \left(
               \dder{T}{x}
            \right)^2
         }{x}
         +
         \dintrpa{
            \left(
               \dder{T}{y}
            \right)^2
         }{y}.

   .. warning::

      A more intuitive way to discretise :math:`\der{T}{y}` at :math:`\left( \pic, \pjc \right)` might be

      .. math::
         \frac{
            \vat{T}{\pic, \pjpp}
            -
            \vat{T}{\pic, \pjmm}
         }{2 \Delta y},

      and a similar way in :math:`x` direction.

      This is clearly different from what was derived in this section, and as a result the energy consistency is broken.
      In particular, the dissipation is *underestimated* since high-frequency signals are smoothened by using a wider stencil.

**********************************
Derivations - global conservations
**********************************

In this part, we analyse the *global* properties of equations averaged in the whole volume, which plays a crucial role when we discuss :ref:`the energy balance of Rayleigh-Bénard convections <nusselt_number_relations>`.

Following the above discussion, the evolution of :math:`h \equiv \frac{1}{2} T^2` leads

.. math::
   \der{}{t} \left( \frac{1}{2} T^2 \right)
   & +
   \dder{\ux q_x}{x}
   +
   \dder{\uy q_y}{y} \\
   & =
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left\{
      \dder{}{x} \left( T \dder{T}{x} \right)
      +
      \dder{}{y} \left( T \dder{T}{y} \right)
   \right\}
   -
   \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left(
      r_x r_x
      +
      r_y r_y
   \right).

Now we consider to integrate these equations in the whole volume to deduce the evolution of :math:`H`:

.. math::
   H
   \equiv
   \sum_{i} \sum_{j}
   \vat{
      \left(
         h
         \Delta x
         \Delta y
      \right)
   }{\pic, \pjc}
   =
   \sum_{i} \sum_{j}
   \vat{
      \left(
         \frac{1}{2} T^2 \Delta x \Delta y
      \right)
   }{\pic, \pjc}.

As usual, conservative terms vanish except

.. math::
   \frac{1}{\sqrt{Pr} \sqrt{Ra}}
   \der{}{x} \left( T \der{T}{x} \right),

whose volume integral leads

.. math::
   \sum_{i} \sum_{j}
   \vat{
      \left\{
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \dder{}{x} \left( T \dder{T}{x} \right)
         \Delta x
         \Delta y
      \right\}
   }{\pic, \pjc}
   =
   \sum_{j}
   \vat{
      \left\{
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \left[ T \dder{T}{x} \right]_{\text{left wall}}^{\text{right wall}}
         \Delta y
      \right\}
   }{\pjc}.

As a result, we have

.. math::
   \der{H}{t}
   & \equiv
   \der{}{t} \sum_{i} \sum_{j}
   \vat{
      \left(
         \frac{1}{2} T^2 \Delta x \Delta y
      \right)
   }{\pic, \pjc} \\
   & =
   \sum_{j}
   \vat{
      \left\{
         \frac{1}{\sqrt{Pr} \sqrt{Ra}}
         \left[ T \dder{T}{x} \right]_{\text{left wall}}^{\text{right wall}}
         \Delta y
      \right\}
   }{\pjc} \\
   & -
   \sum_{i} \sum_{j}
   \vat{
      \left\{
         \frac{1}{\sqrt{Pr} \sqrt{Ra}} \left(
            r_x r_x
            +
            r_y r_y
         \right)
         \Delta x
         \Delta y
      \right\}
   }{\pic, \pjc}.

.. note::
   In a statistically-steady state where the temporal dependencies vanish, we find that the energy injection by the heat fluxes on the walls are balanced by the thermal dissipation.

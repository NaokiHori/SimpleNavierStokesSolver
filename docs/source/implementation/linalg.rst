
.. _linalg :

##########################################################################################
`linalg.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/linalg.c>`_
##########################################################################################

``linalg.c`` contains functions which handle **lin** ear **alg** ebraic operations such as matrix manipulations.
For now only three functions, :c-lang:`my_dgtsv_b`, :c-lang:`my_dgtsv_p` and :c-lang:`my_zgtsv_b`, which are used to solve tri-diagonal linear systems are included, whose names come from functions included in `LAPACK <http://www.netlib.org/lapack/>`_.

.. note::
   No pivotting operations are included for simplicity, which is different from the functions defined in LAPACK.
   In this application, however, all systems to be solved are diagonally dominant and thus no performance degenerations are observed.
   Some functions implemented here are used to solve linear systems which are singular because of the Neumann or periodic boundary conditions, whose treatments are also different from what are included in LAPACK.

*********************
my_dgtsv_b,my_zgtsv_b
*********************

==========
Definition
==========

.. code-block:: c

  int my_dgtsv_b(
      const int n,
      const double *tdm_l,
      const double *tdm_c,
      const double *tdm_u,
      double *tdm_q
  );

  int my_zgtsv_b(
      const int n,
      const double *tdm_l,
      const double *tdm_c,
      const double *tdm_u,
      fftw_complex *tdm_q
  );

===== ====== ========================
Name  intent description
===== ====== ========================
n     in     matrix size
tdm_l in     lower diagonal part
tdm_c in     center diagonal part
tdm_u in     upper diagonal part
tdm_q in/out right-hand-side & answer
===== ====== ========================

===========
Description
===========

Note that the difference between :c-lang:`my_dgtsv_b` and :c-lang:`my_zgtsv_b` are only the datatype of :c-lang:`tdm_q`.

These functions solve a tri-diagonal system by means of `the tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_ whose size is :math:`n` and boundaries are bounded (non-periodic, the suffix :c-lang:`_b` comes from **b** ounded):

.. math::
   \begin{bmatrix}
     c_0    & u_0    & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     l_1    & c_1    & u_1    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     0      & l_2    & c_2    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     \vdots & \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
     0      & 0      & 0      & \cdots & c_{i-1} & u_{i-1} & 0       & \cdots & 0       & 0       & 0       \\
     0      & 0      & 0      & \cdots & l_{i  } & c_{i  } & u_{i  } & \cdots & 0       & 0       & 0       \\
     0      & 0      & 0      & \cdots & 0       & l_{i+1} & c_{i+1} & \cdots & 0       & 0       & 0       \\
     \vdots & \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & c_{n-3} & u_{n-3} & 0       \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & l_{n-2} & c_{n-2} & u_{n-2} \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{n-1} & c_{n-1}
   \end{bmatrix}
   \begin{bmatrix}
   x_0     \\
   x_1     \\
   x_2     \\
   \vdots  \\
   x_{i-1} \\
   x_{i  } \\
   x_{i+1} \\
   \vdots  \\
   x_{n-3} \\
   x_{n-2} \\
   x_{n-1}
   \end{bmatrix}
   =
   \begin{bmatrix}
   q_0     \\
   q_1     \\
   q_2     \\
   \vdots  \\
   q_{i-1} \\
   q_{i  } \\
   q_{i+1} \\
   \vdots  \\
   q_{n-3} \\
   q_{n-2} \\
   q_{n-1}
   \end{bmatrix},

where :math:`x` is the answer to be computed.
Note that :c-lang:`tdm_l`, :c-lang:`tdm_c`, and :c-lang:`tdm_u` all have length :math:`n` for simplicity, although :c-lang:`tdm_l[0]` and :c-lang:`tdm_u[n-1]` are not used (see the above equation).
Also note that :c-lang:`tdm_q` is used as the output (solution :math:`x`) of the linear system as well as an input (right-hand-side) of the system.

The algorithm will be discussed below.

**********
my_dgtsv_p
**********

==========
Definition
==========

.. code-block:: c

  int my_dgtsv_p(
      const int n,
      const double *tdm_l,
      const double *tdm_c,
      const double *tdm_u,
      double *tdm_q
  );

===== ====== ========================
Name  intent description
===== ====== ========================
n     in     matrix size
tdm_l in     lower diagonal part
tdm_c in     center diagonal part
tdm_u in     upper diagonal part
tdm_q in/out right-hand-side & answer
===== ====== ========================

===========
Description
===========

This function is identical to :c-lang:`my_dgtsv_b` except the boundary condition; here periodicity (the suffix :c-lang:`_p` comes from **p** eriodic) is assumed:

.. math::
   \begin{bmatrix}
     c_0     & u_0    & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & l_0     \\
     l_1     & c_1    & u_1    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     0       & l_2    & c_2    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     \vdots  & \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
     0       & 0      & 0      & \cdots & c_{i-1} & u_{i-1} & 0       & \cdots & 0       & 0       & 0       \\
     0       & 0      & 0      & \cdots & l_{i  } & c_{i  } & u_{i  } & \cdots & 0       & 0       & 0       \\
     0       & 0      & 0      & \cdots & 0       & l_{i+1} & c_{i+1} & \cdots & 0       & 0       & 0       \\
     \vdots  & \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & c_{n-3} & u_{n-3} & 0       \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & l_{n-2} & c_{n-2} & u_{n-2} \\
     u_{n-1} & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{n-1} & c_{n-1}
   \end{bmatrix}
   \begin{bmatrix}
   x_0     \\
   x_1     \\
   x_2     \\
   \vdots  \\
   x_{i-1} \\
   x_{i  } \\
   x_{i+1} \\
   \vdots  \\
   x_{n-3} \\
   x_{n-2} \\
   x_{n-1}
   \end{bmatrix}
   =
   \begin{bmatrix}
   q_0     \\
   q_1     \\
   q_2     \\
   \vdots  \\
   q_{i-1} \\
   q_{i  } \\
   q_{i+1} \\
   \vdots  \\
   q_{n-3} \\
   q_{n-2} \\
   q_{n-1}
   \end{bmatrix},

where top-right and bottom-left corners have non-zero values.
The algorithm will be discussed below.

*********
Algorithm
*********

============
Bounded case
============

First we merge the tri-diagonal matrix and the right-hand-side:

.. math::
   \begin{bmatrix}
     c_0    & u_0    & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       & q_0     \\
     l_1    & c_1    & u_1    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       & q_1     \\
     0      & l_2    & c_2    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       & q_2     \\
     \vdots & \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  & \vdots  \\
     0      & 0      & 0      & \cdots & c_{i-1} & u_{i-1} & 0       & \cdots & 0       & 0       & 0       & q_{i-1} \\
     0      & 0      & 0      & \cdots & l_{i  } & c_{i  } & u_{i  } & \cdots & 0       & 0       & 0       & q_{i  } \\
     0      & 0      & 0      & \cdots & 0       & l_{i+1} & c_{i+1} & \cdots & 0       & 0       & 0       & q_{i+1} \\
     \vdots & \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  & \vdots  \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & c_{n-3} & u_{n-3} & 0       & q_{n-3} \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & l_{n-2} & c_{n-2} & u_{n-2} & q_{n-2} \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{n-1} & c_{n-1} & q_{n-1}
   \end{bmatrix}

for convenience.
Our objective is to eliminate the non-diagonal parts of the matrix, i.e, to convert the above matrix to

.. math::
   \begin{bmatrix}
     1      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       & x_0     \\
     0      & 1      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       & x_1     \\
     0      & 0      & 1      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       & x_2     \\
     \vdots & \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  & \vdots  \\
     0      & 0      & 0      & \cdots & 1       & 0       & 0       & \cdots & 0       & 0       & 0       & x_{i-1} \\
     0      & 0      & 0      & \cdots & 0       & 1       & 0       & \cdots & 0       & 0       & 0       & x_{i  } \\
     0      & 0      & 0      & \cdots & 0       & 0       & 1       & \cdots & 0       & 0       & 0       & x_{i+1} \\
     \vdots & \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  & \vdots  \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 1       & 0       & 0       & x_{n-3} \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 1       & 0       & x_{n-2} \\
     0      & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 1       & x_{n-1}
   \end{bmatrix}

using `gaussian elimination <https://en.wikipedia.org/wiki/gaussian_elimination>`_.

1. Forward substitution

   .. details:: Click here to expand text

      First we try to eliminate the lower-diagonal components :math:`l_i`, where :math:`i \in \left[ 1 : n-1 \right]`.
      As a starting point, we focus on the top two rows:

      .. math::
         \begin{bmatrix}
           c_0 & u_0 & 0   & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_0 \\
           l_1 & c_1 & u_1 & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_1
         \end{bmatrix}.

      Dividing the first row by :math:`c_1` yields

      .. math::
         \begin{aligned}
           &\begin{bmatrix}
             1   & u_0 / c_0 & 0   & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_0 / c_0 \\
             l_1 & c_1       & u_1 & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_1
           \end{bmatrix} \\
           &= \\
           &\begin{bmatrix}
             1   & u_0^{\prime} & 0   & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_0^{\prime} \\
             l_1 & c_1          & u_1 & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_1
           \end{bmatrix},
         \end{aligned}

      where we define :math:`u_0^{\prime} \equiv u_0 / c_0` and :math:`q_0^{\prime} \equiv q_{0} / c_0`.
      The implementation can be found here:

      .. myliteralinclude:: /../../src/linalg.c
        :language: c
        :tag: divide first row by center-diagonal term

      where :c-lang:`tdm_u` is overridden, which requests to re-initialise :math:`u_i` before calling linear solvers every time.

      Next, we subtract the first row after multiplied by :math:`l_1` from the second row to eliminate :math:`l_1`, which yields

      .. math::
         \begin{bmatrix}
           1 & u_0^{\prime}           & 0   & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_0^{\prime} \\
           0 & c_1 - l_1 u_0^{\prime} & u_1 & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_1 - l_1 q_0^{\prime}
         \end{bmatrix}.

      to make :math:`c_1 - l_1 u_0^{\prime} \rightarrow 1`, we divide the second row by :math:`c_1 - l_1 u_0^{\prime}`, which yields

      .. math::
         \begin{aligned}
           &\begin{bmatrix}
             1 & u_0^{\prime} & 0                                  & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_0^{\prime} \\
             0 & 1            & \frac{u_1}{c_1 - l_1 u_0^{\prime}} & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & \frac{q_1 - l_1 q_0^{\prime}}{c_1 - l_1 u_0^{\prime}}
           \end{bmatrix}, \\
           &= \\
           &\begin{bmatrix}
             1 & u_0^{\prime} & 0            & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_0^{\prime} \\
             0 & 1            & u_1^{\prime} & \cdots & 0 & 0 & 0 & \cdots & 0 & 0 & 0 & q_1^{\prime}
           \end{bmatrix}.
         \end{aligned}

      This process can be generalised for updating :c-lang:`i`-th row using the updated :c-lang:`i-1`-th row; we focus on the :c-lang:`i-1`-th and :c-lang:`i`-th rows:

      .. math::
         \begin{bmatrix}
           0 & 0 & 0 & \cdots & 1   & u_{i-1}^{\prime} & 0   & \cdots & 0 & 0 & 0 & q_{i-1}^{\prime} \\
           0 & 0 & 0 & \cdots & l_i & c_i              & u_i & \cdots & 0 & 0 & 0 & q_{i}
         \end{bmatrix},

      where the upper row (:c-lang:`i-1`-th row) is already updated, while the bottom row (:c-lang:`i`-th row) is to be updated now.

      applying the same procedure leads

      .. math::
         \begin{bmatrix}
           0 & 0 & 0 & \cdots & 1   & u_{i-1}^{\prime}           & 0   & \cdots & 0 & 0 & 0 & q_{i-1}^{\prime} \\
           0 & 0 & 0 & \cdots & 0   & c_i - l_i u_{i-1}^{\prime} & u_i & \cdots & 0 & 0 & 0 & q_{i} - l_i q_{i-1}^{\prime}
         \end{bmatrix},

      and dividing the :math:`i`-th row by :math:`c_i - l_i u_{i-1}^{\prime}` (to make :math:`c_i = 1`) yields:

      .. math::
         \begin{aligned}
           &\begin{bmatrix}
             0 & 0 & 0 & \cdots & 1   & u_{i-1}^{\prime} & 0                                      & \cdots & 0 & 0 & 0 & q_{i-1}^{\prime} \\
             0 & 0 & 0 & \cdots & 0   & 1                & \frac{u_i}{c_i - l_i u_{i-1}^{\prime}} & \cdots & 0 & 0 & 0 & \frac{q_{i} - l_i q_{i-1}^{\prime}}{c_i - l_i u_{i-1}^{\prime}}
           \end{bmatrix} \\
           &= \\
           &\begin{bmatrix}
             0 & 0 & 0 & \cdots & 1   & u_{i-1}^{\prime} & 0              & \cdots & 0 & 0 & 0 & q_{i-1}^{\prime} \\
             0 & 0 & 0 & \cdots & 0   & 1                & u_{i}^{\prime} & \cdots & 0 & 0 & 0 & q_{i}^{\prime}
           \end{bmatrix}.
         \end{aligned}

      This procedure is repeated to :c-lang:`i = n-1`, whose implementation can be found here:

      .. myliteralinclude:: /../../src/linalg.c
        :language: c
        :tag: forward sweep

      It should be noted that, for the last row :c-lang:`i = n-1`, the denominator :c-lang:`val` can be :math:`0` (i.e., the rank of the matrix is :math:`n-1`), especially when the Nuemann boundary condition is imposed and equally-spaced grid is used.
      In order to avoid the resulting zero division, we have a special treatment in the implementation, i.e., checking the denominator first, and assign :c-lang:`0` when is it is very small.

2. Backward substitution

   .. details:: Click here to expand text

      Now we have the following system:

      .. math::
         \begin{bmatrix}
           1      & u_0^{\prime} & 0            & \cdots & 0       & 0                & 0            & \cdots & 0       & 0                & 0                \\
           0      & 1            & u_1^{\prime} & \cdots & 0       & 0                & 0            & \cdots & 0       & 0                & 0                \\
           0      & 0            & 1            & \cdots & 0       & 0                & 0            & \cdots & 0       & 0                & 0                \\
           \vdots & \vdots       & \vdots       & \ddots & \vdots  & \vdots           & \vdots       &        & \vdots  & \vdots           & \vdots           \\
           0      & 0            & 0            & \cdots & 1       & u_{i-1}^{\prime} & 0            & \cdots & 0       & 0                & 0                \\
           0      & 0            & 0            & \cdots & 0       & 1                & u_i^{\prime} & \cdots & 0       & 0                & 0                \\
           0      & 0            & 0            & \cdots & 0       & 0                & 1            & \cdots & 0       & 0                & 0                \\
           \vdots & \vdots       & \vdots       &        & \vdots  & \vdots           & \vdots       & \ddots & \vdots  & \vdots           & \vdots           \\
           0      & 0            & 0            & \cdots & 0       & 0                & 0            & \cdots & 1       & u_{n-3}^{\prime} & 0                \\
           0      & 0            & 0            & \cdots & 0       & 0                & 0            & \cdots & 0       & 1                & u_{n-2}^{\prime} \\
           0      & 0            & 0            & \cdots & 0       & 0                & 0            & \cdots & 0       & 0                & 1
         \end{bmatrix}
         \begin{bmatrix}
           x_0     \\
           x_1     \\
           x_2     \\
           \vdots  \\
           x_{i-1} \\
           x_{i  } \\
           x_{i+1} \\
           \vdots  \\
           x_{n-3} \\
           x_{n-2} \\
           x_{n-1}
         \end{bmatrix}
         =
         \begin{bmatrix}
           q_0^{\prime}     \\
           q_1^{\prime}     \\
           q_2^{\prime}     \\
           \vdots           \\
           q_{i-1}^{\prime} \\
           q_{i  }^{\prime} \\
           q_{i+1}^{\prime} \\
           \vdots           \\
           q_{n-3}^{\prime} \\
           q_{n-2}^{\prime} \\
           q_{n-1}^{\prime}
         \end{bmatrix},

      where we immediately notice (in the last row)

      .. math::
        x_{n-1} = q_{n-1}^{\prime},

      which is already assigned in the implementation since we share :c-lang:`tdm_q`.

      since we have a relation:

      .. math::
        x_i = q_i^{\prime} - u_i^{\prime} x_{i+1},

      we can obtain :math:`x_i` one after another (sequentially from :math:`i = n-2` to :math:`i = 0`), which is implemented here:

      .. myliteralinclude:: /../../src/linalg.c
        :language: c
        :tag: backward sweep

Note again that :c-lang:`tdm_q` is shared among :math:`x_i` and :math:`q_i` in the implementation.

=============
Periodic case
=============

When the periodicity is assumed, we have a linear system:

.. math::
   \begin{bmatrix}
     c_0     & u_0    & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & l_0     \\
     l_1     & c_1    & u_1    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     0       & l_2    & c_2    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     \vdots  & \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
     0       & 0      & 0      & \cdots & c_{i-1} & u_{i-1} & 0       & \cdots & 0       & 0       & 0       \\
     0       & 0      & 0      & \cdots & l_{i  } & c_{i  } & u_{i  } & \cdots & 0       & 0       & 0       \\
     0       & 0      & 0      & \cdots & 0       & l_{i+1} & c_{i+1} & \cdots & 0       & 0       & 0       \\
     \vdots  & \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & c_{n-3} & u_{n-3} & 0       \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & l_{n-2} & c_{n-2} & u_{n-2} \\
     u_{n-1} & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{n-1} & c_{n-1}
   \end{bmatrix}
   \begin{bmatrix}
   x_0     \\
   x_1     \\
   x_2     \\
   \vdots  \\
   x_{i-1} \\
   x_{i  } \\
   x_{i+1} \\
   \vdots  \\
   x_{n-3} \\
   x_{n-2} \\
   x_{n-1}
   \end{bmatrix}
   =
   \begin{bmatrix}
   q_0     \\
   q_1     \\
   q_2     \\
   \vdots  \\
   q_{i-1} \\
   q_{i  } \\
   q_{i+1} \\
   \vdots  \\
   q_{n-3} \\
   q_{n-2} \\
   q_{n-1}
   \end{bmatrix},

which is no longer a tri-diagonal matrix because of the two non-zero values.
This matrix, however, still can be inversed by using a similar algorithm described above by using `Sherman–Morrison formula <https://en.wikipedia.org/wiki/Sherman–Morrison_formula>`_ as follows.

Since we have

.. math::
   \begin{alignat}{5}
     & c_0     x_0     & & + u_0     x_1     & & + l_0     x_{n-1} & & = q_0     & \,\,\, &        0           \text{th row} \\
     & l_{n-2} x_{n-3} & & + c_{n-2} x_{n-2} & & + u_{n-2} x_{n-1} & & = q_{n-2} & \,\,\, & \left( n-2 \right) \text{th row}
   \end{alignat}

i.e.,

.. math::
   \begin{alignat}{3}
     & c_0     x_0     & & + u_0     x_1     & & = q_0     - l_0     x_{n-1} \\
     & l_{n-2} x_{n-3} & & + c_{n-2} x_{n-2} & & = q_{n-2} - u_{n-2} x_{n-1}
   \end{alignat}

the first :math:`n-2`-th rows and :math:`n-2`-th columns can be extracted as another linear system (whose size is :math:`\left( n-1 \right) \times \left( n-1 \right)` ):

.. math::
   \begin{bmatrix}
     c_0     & u_0    & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     l_1     & c_1    & u_1    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     0       & l_2    & c_2    & \cdots & 0       & 0       & 0       & \cdots & 0       & 0       & 0       \\
     \vdots  & \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots  & \vdots  & \vdots  \\
     0       & 0      & 0      & \cdots & c_{i-1} & u_{i-1} & 0       & \cdots & 0       & 0       & 0       \\
     0       & 0      & 0      & \cdots & l_{i  } & c_{i  } & u_{i  } & \cdots & 0       & 0       & 0       \\
     0       & 0      & 0      & \cdots & 0       & l_{i+1} & c_{i+1} & \cdots & 0       & 0       & 0       \\
     \vdots  & \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots  & \vdots  & \vdots  \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & c_{n-4} & u_{n-4} & 0       \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & l_{n-3} & c_{n-3} & u_{n-3} \\
     0       & 0      & 0      & \cdots & 0       & 0       & 0       & \cdots & 0       & l_{n-2} & c_{n-2}
   \end{bmatrix}
   \begin{bmatrix}
   x_0     \\
   x_1     \\
   x_2     \\
   \vdots  \\
   x_{i-1} \\
   x_{i  } \\
   x_{i+1} \\
   \vdots  \\
   x_{n-4} \\
   x_{n-3} \\
   x_{n-2}
   \end{bmatrix}
   =
   \begin{bmatrix}
   q_0 - l_0 x_{n-1} \\
   q_1               \\
   q_2               \\
   \vdots            \\
   q_{i-1}           \\
   q_{i  }           \\
   q_{i+1}           \\
   \vdots            \\
   q_{n-4}           \\
   q_{n-3}           \\
   q_{n-2} - u_{n-2} x_{n-1}
   \end{bmatrix},

or for convenience we write this as

.. math::
   \underline{\underline{A}} \, \underline{x} = \underline{q},

where terms including :math:`x_{n-1}` is moved to the right-hand-side.
This treatment removes the additional components in the original matrix coming from the periodic boundary condition, and as a result we can recover a tri-diagonal system again.

The new system, however, includes an unknown :math:`x_{n-1}`, which prevents to directly apply the tri-diagonal matrix algorithm (since we need it to start the forward substitution).
In order to overcome this issue, we consider to split this system into two systems using the linearity:

.. math::
   \begin{aligned}
     {\underline{\underline{A}}} \, {\underline{x}}^0 & = {\underline{q}}^0, \\
     {\underline{\underline{A}}} \, {\underline{x}}^1 & = {\underline{q}}^1,
   \end{aligned}

where we let

.. math::
   \underline{q}^0 =
   \begin{bmatrix}
     q_0     &
     q_1     &
     q_2     &
     \cdots  &
     q_{i-1} &
     q_{i  } &
     q_{i+1} &
     \cdots  &
     q_{n-4} &
     q_{n-3} &
     q_{n-2}
   \end{bmatrix}^T

and

.. math::
   \underline{q}^1 =
   \begin{bmatrix}
     - l_0  &
     0      &
     0      &
     \cdots &
     0      &
     0      &
     0      &
     \cdots &
     0      &
     0      &
     - u_{n-2}
   \end{bmatrix}^T,

Note that the superscripts are used to distinguish two systems and do not mean exponents.
Also note that we have :math:`{\underline{q}} = {\underline{q}}^0 + x_{n-1} {\underline{q}}^1`.

By solving these two tri-diagonal systems, we can obtain the solution of the original system :math:`\underline{x}` by

.. math::
   {\underline{x}} = {\underline{x}}^0 + x_{n-1} \times {\underline{x}}^1.

Finally, regarding :math:`x_{n-1}`, we use the relation

.. math::
   u_{n-1} x_0 + l_{n-1} x_{n-2} + c_{n-1} x_{n-1} = q_{n-1},

which can be seen from the last row of the original (:math:`n \times n`) system.

Because of

.. math::
   \begin{aligned}
     x_0     & = x_0^0     + x_{n-1} \times x_0^1,     \\
     x_{n-2} & = x_{n-2}^0 + x_{n-1} \times x_{n-2}^1, \\
   \end{aligned}

we have

.. math::
     \left( u_{n-1} x_0^0 + l_{n-1} x_{n-2}^0           \right)
   + \left( u_{n-1} x_0^1 + l_{n-1} x_{n-2}^1 + c_{n-1} \right) x_{n-1}
   = q_{n-1},

from which :math:`x_{n-1}` can be computed after solving the two linear systems :math:`{\underline{\underline{A}}} \, {\underline{x}}^0 = {\underline{q}}^0` and :math:`{\underline{\underline{A}}} \, {\underline{x}}^1 = {\underline{q}}^1` as

.. math::
   x_{n-1} =
     \frac{q_{n-1} - u_{n-1} x_0^0 - l_{n-1} x_{n-2}^0}
     {c_{n-1} + u_{n-1} x_0^1 + l_{n-1} x_{n-2}^1}.

In summary, the procedure is as follows:

1. Solve :math:`{\underline{\underline{A}}} \, {\underline{x}}^0 = {\underline{q}}^0` and :math:`{\underline{\underline{A}}} \, {\underline{x}}^1 = {\underline{q}}^1` using non-periodic tri-diagonal matrix solver:

  .. myliteralinclude:: /../../src/linalg.c
    :language: c
    :tag: solve two small systems

  where the matrix and the right-hand-side are created here for the first small linear system :math:`{\underline{\underline{A}}} \, {\underline{x}}^0 = {\underline{q}}^0`:

  .. myliteralinclude:: /../../src/linalg.c
    :language: c
    :tag: create 1st small tri-diagonal system

  and for the second small linear system :math:`{\underline{\underline{A}}} \, {\underline{x}}^1 = {\underline{q}}^1`:

  .. myliteralinclude:: /../../src/linalg.c
    :language: c
    :tag: create 2nd small tri-diagonal system

2. Compute :math:`x_{n-1} = \frac{q_{n-1} - u_{n-1} x_0^0 - l_{n-1} x_{n-2}^0}{c_{n-1} + u_{n-1} x_0^1 + l_{n-1} x_{n-2}^1}`:

  .. myliteralinclude:: /../../src/linalg.c
    :language: c
    :tag: compute bottom solution

  Note that :c-lang:`tdm_q[n-1]` is used to store the solution :math:`x_{n-1}` as well as the right-hand-side of the system :math:`q_{n-1}`; the original :c-lang:`tdm_q[n-1]` contains the right-hand-side, which will be overridden and the answer is assigned.

3. Compute the solution of the original linear system :math:`{\underline{\underline{A}}} \, {\underline{x}} = {\underline{q}}`:

  .. myliteralinclude:: /../../src/linalg.c
    :language: c
    :tag: assign answers of the original system


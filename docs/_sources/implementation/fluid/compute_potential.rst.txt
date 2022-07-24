
.. _fluid_compute_potential:

############################################################################################################################
`fluid/compute_potential.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fluid/compute_potential.c>`_
############################################################################################################################

Compute a scalar potential :math:`\psi` which projects a non-solenoidal velocity field to a solenoidal one by solving a Poisson equation

.. math::

   \frac{\delta^2 \psi}{\delta x_i \delta x_i} = \frac{1}{\gamma \Delta t} \frac{\delta u_i^*}{\delta x_i}.

The methodology is discussed :ref:`here <smac_method>`.

***********************
fluid_compute_potential
***********************

==========
Definition
==========

.. code-block:: c

   int fluid_compute_potential(
       const param_t *param,
       const parallel_t *parallel,
       fluid_t *fluid
   );

======== ====== =====================================
Name     intent description
======== ====== =====================================
param    in     general parameters
parallel in     MPI parameters
fluid    in/out velocity (in), scalar potential (out)
======== ====== =====================================

===========
Description
===========

This function solves the Poisson equation described above.

First of all, we compute the right-hand-side values and store them to a variable :c-lang:`qrx` (**x** -aligned **r** eal **q** uantity), which is allocated in the function as well as other buffers:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: allocate buffers (different alignments, datatypes)

Note that the size of this variable is :c-lang:`itot` :math:`\times` :c-lang:`jsize = parallel_get_size(jtot, mpisize, mpirank)`, i.e., no halo cells are included.

:c-lang:`qrx` is defined at the same location as pressure (i.e., cell center) and thus the discrete equation leads

.. math::
   \left( qrx \right)_{i, j} =
     \frac{1}{\gamma \Delta t} \left(
         \frac{\left. u_x \right|_{i+\frac{1}{2},j} - \left. u_x \right|_{i-\frac{1}{2},j}}{\Delta x_i}
       + \frac{\left. u_y \right|_{i,j+\frac{1}{2}} - \left. u_y \right|_{i,j-\frac{1}{2}}}{\Delta y  }
     \right).

In the code, it is implemented as

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: compute right-hand-side

.. image:: image/compute_potential1.pdf
   :width: 800

Note that halo values are used here (:c-lang:`UY(i, jsize+1)`), which should be communicated beforehand (at the end of :c-lang:`fluid/update_velocity.c <fluid_update_velocity>`).

Since we adopt the second-order accurate central finite difference scheme in space, the Poisson equation is discretised as

.. math::
   \frac{\frac{\psi_{i+1,j} - \psi_{i,j}}{\Delta x_{i+\frac{1}{2}}} - \frac{\psi_{i,j} - \psi_{i-1,j}}{\Delta x_{i-\frac{1}{2}}}}{\Delta x_i} + \frac{\psi_{i,j+1} - 2 \psi_{i,j} + \psi_{i,j-1}}{\Delta y^2} = \left( qrx \right)_{i,j}.

Recall that we consider a domain which is periodic in :math:`y` direction, while the grid size can vary in :math:`x` direction.

As we can see in the left-hand-side, this equation contains 5 different :math:`P` values, which reduces to a sparse matrix with size :math:`\left( \text{itot} \times \text{jtot} \right)^2` and a bit tedious to solve as it is.

In order to avoid this, here we consider the Discrete Fourier transform (a notation :math:`\mathcal{F}^D` is used hereafter) of a quantity :math:`q_j` in :math:`y` direction, which is defined and computed as

.. math::
   Q_J \equiv \mathcal{F}^D \left[ q_j \right] = \sum_{j=1}^{\text{jtot}} q_j \exp{\left\{ -2 \pi \left( j - 1 \right) J \sqrt{-1} / \left( \text{jtot} \right) \right\}},

following `the implementation of FFTW3 <https://www.fftw.org/fftw3_doc/The-1d-Real_002ddata-DFT.html>`_.
Here :math:`J` is used as a index in the (:math:`y` direction) wavespace, :math:`J \in \left[ 0 : \text{jtot}/2 \right]`.
Hereafter capital letters in mathematical equations (not code) imply that the quantity is transformed to the corresponding wavespace.

Since

.. math::
   \mathcal{F}^D \left[ \psi_{i,j\pm1} \right] = \mathcal{F}^D \left[ \psi_{i,j} \right] \exp{\left\{ \pm 2 \pi J \sqrt{-1} / \left( \text{jtot} \right) \right\}}

holds as long as the signal is periodic in :math:`y` direction, the original discrete Poisson equation can be written as

.. math::
   \frac{\frac{\Psi_{i+1,J} - \Psi_{i,J}}{\Delta x_{i+\frac{1}{2}}} - \frac{\Psi_{i,J} - \Psi_{i-1,J}}{\Delta x_{i-\frac{1}{2}}}}{\Delta x_i} + \frac{\exp{\left\{ \frac{2 \pi J \sqrt{-1}}{\left( \text{jtot} \right)} \right\}}\Psi_{i,J} - 2 \Psi_{i,J} + \exp{\left\{ \frac{-2 \pi J \sqrt{-1}}{\left( \text{jtot} \right)} \right\}}\Psi_{i,J}}{\Delta y^2} = \left( QRX \right)_{i,J},

or by using the relation

.. math::
   \exp{ \left( 2 \theta \sqrt{-1} \right) } + \exp{ \left( -2 \theta \sqrt{-1} \right) } - 2 = 2  \cos \left( 2 \theta \right) - 2 = -4 \sin^2 \theta,

we have

.. math::
   \begin{aligned}
       \frac{1}{\Delta x_{i+\frac{1}{2}} \Delta x_i} \Psi_{i+1,J}
     & + \left(
       - \frac{1}{\Delta x_{i+\frac{1}{2}} \Delta x_i}
       - \frac{1}{\Delta x_{i-\frac{1}{2}} \Delta x_i}
       - \frac{4}{\Delta y^2} \sin^2 \left( \pi J \right)
     \right) \Psi_{i,J}
     + \frac{1}{\Delta x_{i-\frac{1}{2}} \Delta x_i} \Psi_{i-1,J} \\
     & = \left( QRX \right)_{i,J}.
   \end{aligned}

Note that the right-hand-side is also transformed (from :math:`\left( qrx \right)_{i,j}` to :math:`\left( QRX \right)_{i,J}`)

Here only three neighbouring values :math:`\Psi_{i-1,J}`, :math:`\Psi_{i,J}`, and :math:`\Psi_{i+1,J}` exist, i.e., :math:`J`-variations (i.e., :math:`J+1` and :math:`J-1`) are gone and what we need to consider is an independent system for each :math:`J`.
This is the primary advantage of using Fourier transform.

**In short, by adopint the discrete Fourier transform in** :math:`y` **direction, the original Poisson equation can be simplified.**

As we see in the definition of the discrete Fourier transform, however, for each :c-lang:`i`, all :math:`\left( qrx \right)_{i, j}` values from :c-lang:`j=1` to :c-lang:`j=jtot` (**not** :c-lang:`jsize`) are needed to perform this computation (:math:`\because \sum_{j=1}^{\text{jtot}}`), which cannot be done since our domain is split in :math:`y` direction.

In order to resolve this issue, we first transpose the original variable :c-lang:`qrx` (decomposed in :math:`y` direction) to a new variable :c-lang:`qry` (decomposed in :math:`x` direction, **y** -aligned **r** eal **q** uantity):

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: transpose real x-aligned matrix to y-aligned matrix

whose schematic can be found here:

.. image:: image/compute_potential2.pdf
   :width: 800

where :math:`x`-aligned variable (split in :math:`y` direction) :c-lang:`qrx` in the left figure is transposed to a :math:`y`-aligned variable (split in :math:`x` direction) :c-lang:`qry` in the right figure.

Now each processor contains information aligned in :math:`y` direction, which is followed by the discrete Fourier transform (forward transform) in :math:`y` direction by calling a function offered by `FFTW3 library <https://www.fftw.org>`_:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: project to wave space

where :c-lang:`fwrd` is a pointer to the pre-defined plan, which is initialised a priori:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: create fftw plans

Here `guru interface <https://www.fftw.org/fftw3_doc/Guru-Real_002ddata-DFTs.html>`_ is adopted for simplicity, which executes multiple discrete Fourier transforms in :math:`y` direction.

By this operation, **y** -aligned **r** eal **q** uantity :c-lang:`qry` is transformed to the **y** -aligned **c** omplex **q** uantity :c-lang:`qcy`, whose size is :c-lang:`parallel_get_size(itot, mpisize, mpirank)` :math:`\times` :c-lang:`jtot/2+1` (size in :math:`y` direction is halved) because of the `Hermitian symmetry <https://www.fftw.org/fftw3_doc/The-1d-Real_002ddata-DFT.html#The-1d-Real_002ddata-DFT>`_, whose concept is drawn here:

.. image:: image/compute_potential3.pdf
   :width: 800

where the size of the whole matrix *shrinks* in :math:`y` direction by transforming :c-lang:`qry` to :c-lang:`qcy`.

Now, we have a equation which is independent of :math:`y` (i.e., only :math:`J` is involved, not :math:`J+1` nor :math:`J-1`); for convenience the equation is re-displayed here:

.. math::
   l_i \Psi_{i-1,J} + c_i \Psi_{i,J} + u_i \Psi_{i+1,J} = \left( QCX \right)_{i,J}.

where we defined

.. math::
   \begin{aligned}
     l_i & \equiv \frac{1}{\Delta x_{i-\frac{1}{2}} \Delta x_i}, \\
     u_i & \equiv \frac{1}{\Delta x_{i+\frac{1}{2}} \Delta x_i}, \\
     c_i & \equiv
       - \frac{1}{\Delta x_{i+\frac{1}{2}} \Delta x_i}
       - \frac{1}{\Delta x_{i-\frac{1}{2}} \Delta x_i}
       - \frac{4}{\Delta y^2} \sin^2 \left( \pi J \right), \\
         & =
       - l_i
       - u_i
       - \frac{4}{\Delta y^2} \sin^2 \left( \pi J \right)
   \end{aligned}

for simplicity.
See the schematic below for the used grid arrangement:

.. image:: image/compute_potential4.pdf
   :width: 800

This can be written as a linear system for each :math:`J`:

.. math::
   \begin{bmatrix}
     c_1    & u_1    & \cdots & 0       & 0       & 0       & \cdots & 0                 & 0                 \\
     l_2    & c_2    & \cdots & 0       & 0       & 0       & \cdots & 0                 & 0                 \\
     \vdots & \vdots & \ddots & \vdots  & \vdots  & \vdots  &        & \vdots            & \vdots            \\
     0      & 0      & \cdots & c_{i-1} & u_{i-1} & 0       & \cdots & 0                 & 0                 \\
     0      & 0      & \cdots & l_{i  } & c_{i  } & u_{i  } & \cdots & 0                 & 0                 \\
     0      & 0      & \cdots & 0       & l_{i+1} & c_{i+1} & \cdots & 0                 & 0                 \\
     \vdots & \vdots &        & \vdots  & \vdots  & \vdots  & \ddots & \vdots            & \vdots            \\
     0      & 0      & \cdots & 0       & 0       & 0       & \cdots & c_{\text{itot}-1} & u_{\text{itot}-1} \\
     0      & 0      & \cdots & 0       & 0       & 0       & \cdots & l_{\text{itot}  } & c_{\text{itot}  }
   \end{bmatrix}
   \begin{bmatrix}
   \Psi_{1, J}             \\
   \Psi_{2, J}             \\
   \vdots                  \\
   \Psi_{i-1, J}           \\
   \Psi_{i  , J}           \\
   \Psi_{i+1, J}           \\
   \vdots                  \\
   \Psi_{\text{itot}-1, J} \\
   \Psi_{\text{itot}  , J}
   \end{bmatrix}
   =
   \begin{bmatrix}
   \left( QCX \right)_{1, J}             \\
   \left( QCX \right)_{2, J}             \\
   \vdots                                \\
   \left( QCX \right)_{i-1, J}           \\
   \left( QCX \right)_{i  , J}           \\
   \left( QCX \right)_{i+1, J}           \\
   \vdots                                \\
   \left( QCX \right)_{\text{itot}-1, J} \\
   \left( QCX \right)_{\text{itot}  , J}
   \end{bmatrix},

where the first matrix in the left-hand-side is the tri-diagonal matrix, which can be solved by the `tri-diagonal matrix algorithm <https://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm>`_.
See :ref:`src/linalg.c <linalg>` for details.

In this code, two diagonal values (**u** pper- and **l** ower-diagonals) are stored as:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: set lower and upper diagonal components

Another (**c** enter) diagonal values are assigned as

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: set center diagonal components

where :c-lang:`eigenvalue` is

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: compute eigenvalue of this j position

Note that an offset :c-lang:`joffset` is added since :c-lang:`J` should be global.
Also :math:`1` is subtracted since :c-lang:`J` starts from 0.

Additional care should be taken for the boundary treatment.

At :math:`x = 0`, we have

.. math::
   l_1 \Psi_{0,J} + c_1 \Psi_{1,J} + u_1 \Psi_{2,J} = \left( QCX \right)_{1,J},

where :math:`\Psi_{0,J}` is the value at :math:`x=0` (or it can be defined inside the wall as a ghost cell, the same conclusion can be obtained).

Since Neumann boundary condition :math:`\frac{\delta \psi}{\delta x} = 0` is imposed on the scalar potential (and this holds even after the Fourier transform is applied), we have :math:`\Psi_{0,J} = \Psi_{1,J}` and thus we obtain

.. math::
   \left( l_1 + c_1 \right) \Psi_{1,J} + u_1 \Psi_{2,J} = \left( QCX \right)_{1,J},

i.e., the center diagonal value should be modified.
The same story holds for the other boundary (:math:`c_{\text{itot}} \leftarrow c_{\text{itot}} + u_{\text{itot}}`), and this treatment is implemented as:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: boundary treatment (Neumann boundary condition)

Since the matrix solver is ready now, after the alignment is modified (from :c-lang:`qcy`, :math:`y`-aligned to :c-lang:`qcx`, :math:`x`-aligned):

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: transpose complex y-aligned matrix to x-aligned matrix

.. image:: image/compute_potential5.pdf
   :width: 800

the tri-diagonal matrix is solved:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: solve linear system

which is repeated for all :math:`J`.

Now we have the answer of the Poisson equation, which is, however, defined in the wavespace (:math:`\Psi`).

After the alignment of the variable is changed (from :c-lang:`qcx`, :math:`x`-aligned to :c-lang:`qcy`, :math:`y`-aligned):

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: transpose complex x-aligned matrix to y-aligned matrix

.. image:: image/compute_potential6.pdf
   :width: 800

we use the discrete inverse Fourier transform in order to retrieve the solution in the physical space (:math:`\psi`):

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: project to physical space

.. image:: image/compute_potential7.pdf
   :width: 800

Finally, the alignment is again changed (to recover the same shape as the original scalar potential :c-lang:`psi`:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: transpose real y-aligned matrix to x-aligned matrix

.. image:: image/compute_potential8.pdf
   :width: 800

and the result is stored to :c-lang:`psi`:

.. myliteralinclude:: /../../src/fluid/compute_potential.c
   :language: c
   :tag: normalise and store result

Note that a division by :c-lang:`jtot` is necessary because `FFTW3 does not normalise the result <https://www.fftw.org/fftw3_doc/The-1d-Real_002ddata-DFT.html#The-1d-Real_002ddata-DFT>`_.


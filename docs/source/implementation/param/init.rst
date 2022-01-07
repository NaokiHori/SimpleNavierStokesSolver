
.. _param_init:

##################################################################################################
`param/init.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/param/init.c>`_
##################################################################################################

Initialise a structure :c-lang:`param_t *param` and its members.

**********
param_init
**********

==========
Definition
==========

.. code-block:: c

   int param_init(
       param_t **param
   );

===== ====== =========================
Name  intent description
===== ====== =========================
param out    allocated and initialised
===== ====== =========================

===========
Description
===========

.. note::

   Mainly, this function takes care of the following things.

   #. Allocate a :c-lang:`param_t` structure

   #. Load and initialise parameters (e.g., domain size, number of grid points, maximum simulation time)

   #. Initialise coordinate system (e.g., :c-lang:`param->xf`) and grid sizes (e.g., :c-lang:`param->dxf`, :c-lang:`dy`)

   #. Initialise coefficients which are used by :ref:`the three-step Runge-Kutta scheme <schemes>`

First of all, a :c-lang:`param` structure is allocated:

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: allocate structure

:c-lang:`param` structure contains coordinates, which cannot be allocated at this point since the number of grid points (e.g., :c-lang:`param->itot` and :c-lang:`param->jtot`) are unknown.

The next step is to load parameters (environmental variables, such as domain size) to configure:

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: load parameters from environmental variables

which is followed by allocating and initialising coordinates:

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: allocate and initialise coordinates

The simulation can be restarted by loading previous flow field when desired, in particular when an environmental variable :sh:`dirname_restart` (in which the flow field is contained) is given.
When we do so, step and time are loaded, otherwise :c-lang:`0` is assigned:

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: set time step and time

Some procedures are outsourced to the other functions, whose detailed descriptions can be found below.

***********
load_config
***********

==========
Definition
==========

.. code-block:: c

   static int load_config(
       param_t *param
   );

===== ====== =======================
Name  intent description
===== ====== =======================
param out    members are initialised
===== ====== =======================

===========
Description
===========

Members of the :c-lang:`param` structure are initialised, where values from environmental variables (normally a configuration file ``exec.sh`` is used to define them for convenience) are assigned.
When a parameter is not given (the corresponding environmental variable is not defined), a default value is used.

In particular, this function tries to load a variable :c-lang:`"dirname_restart"`, which is used to designate the name of the directory which contains data of the intermediate flow field.
If given, a flag :c-lang:`param->load_flow_field` is set to :c-lang:`true` and the simulator tries to load the intermediate velocity, pressure, and temperature fields from the files later.
Otherwise all these fields are initialised later.

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: try to load the name of the directory having restart data

Other parameters are also loaded.

#. Flags to decide the temperature coupling:

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: flags to decide temperature coupling

   Note that the second argument is a default value, which is used when the parameter is not given.

#. Temporal information (e.g., maximum simulation time, rate to output logs, to save flow fields, and to collect statistics):

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: schedulers

#. Spatial information:

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: domain

#. Non-dimensional parameters governing the physics (see :ref:`the governing equations <governing_equations>`)

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: non-dimensional parameters

See :ref:`param <param>` for the detailed explanation of all members.

**************
set_coordinate
**************

==========
Definition
==========

.. code-block:: c

   static int set_coordinate(
       param_t *param
   );

===== ====== ===================================
Name  intent description
===== ====== ===================================
param out    coordinates members are initialised
===== ====== ===================================

===========
Description
===========

The structure :c-lang:`param` has members defining the locations of grid points (:c-lang:`param->xf`, :c-lang:`param->xc`) and the distances between two grid points (:c-lang:`param->dxf`, :c-lang:`param->dxc`, and :c-lang:`param->dy`), which are initialised in this function.

First of all, the vectors to store the coordinates are allocated:

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: allocate coordinate vectors

Coordinate generation process in the wall-normal direction (**non-uniform grid spacings are allowed**) is as follows.

#. :c-lang:`XF`: cell-face positions

   Coordinate creation starts by defining the cell-face locations (:c-lang:`param->xf`: :math:`x` locations where :math:`\ux` are positioned):

   .. image:: image/grid1.pdf
      :width: 800

   .. details:: Click here for details

      In order to resolve the boundary layers close to the walls, more grid points can be clustered in the vicinity of the walls.
      By default, it is based on a cosine function whose edges are clipped (clipped Chebyshev).

      The following image shows how the coordinates are changed by manipulating :c-lang:`str`, where :c-lang:`itot = 8`.

      .. image:: image/chebyshev.pdf
         :width: 600

      We notice that, for :c-lang:`str = 0` (red line), :c-lang:`XF` does not change rapidly (as a function of :c-lang:`i`) in the vicinity of the boundaries, indicating that the grid is gathered there.
      For :c-lang:`str = 4` (green line), on the other hand, :c-lang:`XF` changes almost linearly (as a function of :c-lang:`i`), telling that the cell boundaries :c-lang:`XF` are almost uniformly distributed.

      As can be seen in the figure, :c-lang:`XF` changes from :c-lang:`1` to :c-lang:`-1`, which should be transformed to a coordinate starting from :c-lang:`0` and ends at :c-lang:`lx`.

      The full implementation can be found here:

      .. myliteralinclude:: /../../src/param/init.c
         :language: c
         :tag: xf: cell face coordinates

      Of course users can adopt other functions if needed to change the behaviour.

      .. note::
         ``str`` denotes the number of *clipped* points at both edges.
         Thus it is non-sense to give larger value than ``itot/2``.
         In this case, uniform grid is created instead.

#. :c-lang:`DXF`: face-to-face distance

   Since the cell face positions are known now, we initialise the distances between cell face to face (:c-lang:`param->dxf`, :math:`x` locations where :math:`u_x` are positioned):

   .. image:: image/grid2.pdf
      :width: 800

   The implementation can be found here:

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: dxf: distance from cell face to cell face

#. :c-lang:`XC`: cell-center positions

   Cell centers (:c-lang:`param->xc`, :math:`x` positions where :math:`p` and :math:`u_y` are located) are defined in the middle of the two neighbouring cell faces:

   .. image:: image/grid3.pdf
      :width: 800

   The implementation can be found here:

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: xc: cell center coordinates

#. :c-lang:`DXC`: center-to-center distance

   Finally the distance between cell centers are computed:

   .. image:: image/grid4.pdf
      :width: 800

   The implementation can be found here:

   .. myliteralinclude:: /../../src/param/init.c
      :language: c
      :tag: dxc: distance from cell center to cell center (generally)

   Note that a special treatment is needed at the edges; cell centers (and variables defined there, e.g., pressure and temperature) are shifted to cell faces at the boundaries.

Regarding the grid size in :math:`y` direction (**only uniform grid spacings are possible**), it is simply given as:

.. myliteralinclude:: /../../src/param/init.c
   :language: c
   :tag: y grid size (uniform)

since :math:`y` direction only allows uniform grid spacings for now.

.. note::

   :c-lang:`YC` and :c-lang:`YF` are not used in the main integration.
   They exist just for completeness.



.. _numerics:

################
Numerical method
################

Numerical treatments of :ref:`the governing equations <governing_equations>` are discussed here.
Temporal and spatial discretisations are discussed separately.

#. Temporal discretisation

   Conventional techniques to integrate equations in time (e.g. SMAC method, implicit treatments of the diffusive terms) are discussed.
   Also formal accuracies of several schemes are briefly reviewed and derived.

#. Spatial discretisation

   How the variables are discretised in the computational domain is extensively discussed.
   Although five equations were considered in :ref:`the governing equations <governing_equations>`, :math:`k` and :math:`h` are not solved numerically since they are dependent on the other equations (mass, momentum, and temperature).
   These *implicit* dependencies are easily broken if we do not treat the main three equations properly.
   This proper numerical treatment is our interest in this section.

.. toctree::
   :maxdepth: 1

   temporal_discretisation/index
   spatial_discretisation/index


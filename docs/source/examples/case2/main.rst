
.. _example_case2:

.. include:: /references.txt

#############################################
Case 2 - Conservation of quadratic quantities
#############################################

Check conservation of volume-integrated quadratic quantities :math:`K` and :math:`H` (see :ref:`governing equations <governing_equations>` for the definitions of these quantities).

.. note::

   This section is updated automatically.

.. literalinclude:: data/artifacts/ci.txt
   :language: text

*************
Configuration
*************

Initially we run our solver for :math:`50` time units with the following configuration to obtain random velocity and temperature fields.

.. literalinclude:: data/exec1.sh
   :language: sh

Notice that :math:`Ra` is set to an extremely large value to describe inviscid fluid.

This is followed by another run for :math:`50` time units, where the previous simulation is restarted with the thermal forcing off.

.. literalinclude:: data/exec2.sh
   :language: sh

********************
Quadratic quantities
********************

As being derived in :ref:`the discrete momentum balance <momentum_balance>` and :ref:`the discrete thermal energy balance <thermal_energy_balance>`, they should be constant in time in theory.
This is not the case in this project since we adopt an :ref:`explicit Runge-Kutta scheme <temporal_discretisation>`, which is dissipative (see |MORINISHI1998|, |COPPOLA2019|).
Thus two quantities should display monotonic decrease in time, which is advantageous from a stability point of view.

.. image:: data/energy.pdf
   :width: 800

.. seealso::

   Conservations of :math:`K` and :math:`H` are highly dependent on the discretisation of the advective terms.
   See :ref:`a bit detailed analysis <inconsistent_results>`.


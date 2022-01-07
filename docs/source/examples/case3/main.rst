
.. _example_case3:

##################################
Case 3 - Nusselt number agreements
##################################

Perfect :math:`Nu` agreements are investigated.
To eliminate oscillations, laminar states (:math:`Ra = 10^4`) are considered.

.. note::

   This section is updated automatically.

.. literalinclude:: data/artifacts/ci.txt
   :language: text

*************
Configuration
*************

Three Prandtl numbers are considered, :math:`Pr = 10^{-1}, 10^0, 10^1`.
Here is the configuration for :math:`Pr = 10^{-1}`.

.. literalinclude:: data/exec1.sh
   :language: sh

***************************
:math:`Nu \left( t \right)`
***************************

Changes in :math:`Nu` (computed based on the heat fluxes on the walls :math:`Nu_{wall}`) are plotted:

.. image:: data/nusselt_raw.pdf
   :width: 800

We notice the flows indeed reach steady states.

:math:`Nu` computed by other formula are also considered, (red) energy injection, (blue) kinetic energy dissipation, and (green) thermal energy dissipation, respectively.

.. seealso::

   :ref:`Nusselt number relations <nusselt_number_relations>` for the derivations.

They are plotted as differences from :math:`Nu_{wall}` to highlight the agreements to each other:

:math:`Pr = 10^{-1}`:

.. image:: data/nusselt_dif_1.pdf
   :width: 800

:math:`Pr = 10^{ 0}`:

.. image:: data/nusselt_dif_2.pdf
   :width: 800

:math:`Pr = 10^{ 1}`:

.. image:: data/nusselt_dif_3.pdf
   :width: 800

We notice that all definitions give identical results to each other.

.. seealso::

   Agreements of :math:`Nu` are highly dependent on the discretisation of the dissipations.
   See :ref:`a bit detailed analysis <inconsistent_results>`.


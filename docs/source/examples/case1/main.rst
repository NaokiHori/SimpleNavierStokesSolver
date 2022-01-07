
.. _example_case1:

.. include:: /references.txt

#########################
Case 1 - Run default case
#########################

Run `exec.sh <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/exec.sh>`_.

.. note::

   This section is updated automatically.

.. literalinclude:: data/artifacts/ci.txt
   :language: text

*************
Configuration
*************

.. literalinclude:: /../../exec.sh
   :language: sh
   :linenos:

**************
Visualisations
**************

Temperature field at the end of the run is visualised here.

.. image:: data/visualise.png
   :width: 800

****************************
Incompressibility constraint
****************************

Thanks to :ref:`the direct Poisson solver <fluid_compute_potential>`, local divergence of the velocity field should be sufficiently small, i.e.,

.. math::
   \mathcal{O} \left( \epsilon / \Delta \right),

where :math:`\epsilon` and :math:`\Delta` are machine epsilon :math:`\sim 10^{-16}` and the representative grid size, respectively.

.. image:: data/divergence.pdf
   :width: 800

***************
Nusselt numbers
***************

:math:`Nu` computed by different formula are shown, (red/blue) heat fluxes on the bottom/top walls, (green) energy injection, (magenta) kinetic energy dissipation, and (cyan) thermal energy dissipation, respectively.

Black-dashed line shows a reference value by |VANDERPOEL2013| with the same :math:`Ra` and :math:`Pr` but with a different domain geometry (box).

.. seealso::

   :ref:`Nusselt number relations <nusselt_number_relations>` for the definition of each :math:`Nu`, and :ref:`src/logging.c <logging>` for how they are computed.

.. image:: data/nusselt.pdf
   :width: 800

**********
Statistics
**********

Variances of (red) :math:`\ux`, (blue) :math:`\uy`, and (green) :math:`T` are plotted here.

.. image:: data/stat.pdf
   :width: 800


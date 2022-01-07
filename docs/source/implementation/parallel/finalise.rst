
.. _parallel_finalise:

################################################################################################################
`parallel/finalise.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/parallel/finalise.c>`_
################################################################################################################

Deallocate memory of the structure :c-lang:`parallel`.

*****************
parallel_finalise
*****************

==========
Definition
==========

.. code-block:: c

   int parallel_finalise(
       parallel_t *parallel
   );

======== ====== ===========
Name     intent description
======== ====== ===========
parallel out    deallocated
======== ====== ===========

===========
Description
===========

The memory of the structure :c-lang:`parallel` is freed.


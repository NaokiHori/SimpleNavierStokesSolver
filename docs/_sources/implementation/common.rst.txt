
.. _common:

##########################################################################################
`common.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/common.c>`_
##########################################################################################

``common.c`` contains general and auxiliary functions.
For the time being only memory managers are registered.

*************
common_calloc
*************

==========
Definition
==========

.. code-block:: c

   void *common_calloc(
       size_t count,
       size_t size
   );

===== =========== ===============================
Name  intent      description
===== =========== ===============================
count in          number of elements
size  in          datasize of each element
ptr   out(return) pointer to the allocated buffer
===== =========== ===============================

===========
Description
===========

This function is a wrapper of a function :c-lang:`calloc` in C standard library :c-lang:`stdlib`.
:c-lang:`calloc` returns :c-lang:`NULL` when the allocation fails.
This function checks it and output an error message.

Since the failure of memory allocation is fatal, :c-lang:`MPI_Abort` is called and the simulator is terminated.

.. myliteralinclude:: /../../src/common.c
   :language: c
   :tag: calloc with error handling

***********
common_free
***********

==========
Definition
==========

.. code-block:: c

   void *common_free(
       void *ptr
   );

===== =========== =======================================
Name  intent      description
===== =========== =======================================
ptr   in/out      pointer to the buffer to be deallocated
===== =========== =======================================

===========
Description
===========

This function is a wrapper of a function :c-lang:`free` in C standard library :c-lang:`stdlib`.
:c-lang:`NULL` is assigned after being deallocated.

.. myliteralinclude:: /../../src/common.c
   :language: c
   :tag: free with error handling


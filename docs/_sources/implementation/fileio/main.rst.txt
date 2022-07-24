
.. _fileio:

##########################################################################################
`fileio.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/fileio.c>`_
##########################################################################################

``fileio.c`` contains functions which handle file input/output operations.
Most functions are designed to write and read `files in npy format <https://numpy.org/doc/stable/reference/generated/numpy.lib.format.html>`_.

The reasons why we adopt `npy` format in this project are as follows:

#. Being binary

   We should avoid to save arrays in text format since the original data in floating points is modulated and also the file size tends to be further increased.

#. Simplicity

   In order to recover the original data later, we need to store the datatype and shape as metadata with the raw data.
   In a *npy* file, these information are stored in the header part as *descr* and *shape*, respectively.
   Although `HDF5 format <https://www.hdfgroup.org/solutions/hdf5/>`_ offers the same and more general functionalities, they are too general and too complicated for the current *simple* purpose.
   Also we would like to reduce the number of external libraries to be simple.

#. Generality

   `NumPy <https://numpy.org>`_ is one of the most popular libraries for scientific computings (especially for post-processing and visualisation with `Matplotlib <https://matplotlib.org/stable/>`_), and *npy* format is its native binary format.
   Thanks to its simple structure, this format is easily accessible from other languages (e.g., `Rust <https://docs.rs/npy/latest/npy/>`_, `MATLAB <https://github.com/kwikteam/npy-matlab>`_).

.. seealso::

   Reading and writing *npy* headers rely on our library `SimpleNpyIO <https://github.com/NaokiHori/SimpleNpyIO>`_, which is copied and used here.

************
fileio_fopen
************

==========
Definition
==========

.. code-block:: c

   FILE *fileio_fopen(
       const char * restrict path,
       const char * restrict mode
   );

====== =========== ======================
Name   intent      description
====== =========== ======================
path   in          file path to be opened
mode   in          file open mode
stream out(return) file pointer
====== =========== ======================

===========
Description
===========

This function is a wrapper of a function :c-lang:`fopen` in C standard library :c-lang:`stdio`.
:c-lang:`fopen` returns :c-lang:`NULL` when the file-open operation fails.
This function checks it and output an error message.

.. myliteralinclude:: /../../src/fileio.c
   :language: c
   :tag: fopen with error handling

.. note::

   A *serial* operation is assumed, i.e., only one process should call this function, and the same process should access to (read or write) the file, and the same process should call :c-lang:`fileio_fclose`.

*************
fileio_fclose
*************

==========
Definition
==========

.. code-block:: c

   int fileio_fclose(
       FILE *stream
   );

======= =========== =========================
Name    intent      description
======= =========== =========================
stream  in/out      file pointer to be closed
======= =========== =========================

===========
Description
===========

This function is a wrapper of a function :c-lang:`fclose` in C standard library :c-lang:`stdio`.
:c-lang:`fclose` returns :c-lang:`EOF` when the file-close operation fails.
This function checks it and output an error message.

.. myliteralinclude:: /../../src/fileio.c
   :language: c
   :tag: fclose with error handling

.. note::

   A *serial* operation is assumed, i.e., only one process should call :c-lang:`fileio_fopen`, and the same process should access to (read or write) the file, and the same process should call this function.


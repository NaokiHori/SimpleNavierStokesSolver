
.. _parallel_halo:

########################################################################################################
`parallel/halo.c <https://github.com/NaokiHori/SimpleNavierStokesSolver/blob/main/src/parallel/halo.c>`_
########################################################################################################

Functions dealing with halo cell communications.

***********************
parallel_update_halo_ym
***********************

==========
Definition
==========

.. code-block:: c

   int parallel_update_halo_ym(
       const parallel_t *parallel,
       const int cnt,
       const MPI_Datatype dtype,
       const void *sendbuf,
       void *recvbuf
   );

   int parallel_update_halo_yp(
       const parallel_t *parallel,
       const int cnt,
       const MPI_Datatype dtype,
       const void *sendbuf,
       void *recvbuf
   );

======== ====== =====================================
Name     intent description
======== ====== =====================================
parallel in     MPI parameters
cnt      in     number of elements to be communicated
dtype    in     type of the elements
sendbuf  in     pointer to the data send
recvbuf  out    pointer to the data received
======== ====== =====================================

===========
Description
===========

These functions are wrapper functions of :c-lang:`MPI_Sendrecv`, where information are communicated between two processes.

They are mainly used to exchange the halo cell information, which is needed to evaluate the derivative at the edge of the domain; For instance, second-order derivative of :math:`\ux` in :math:`y` direction at :math:`\left( i, 1 \right)` is computed as:

.. math::
   \vat{\frac{\delta^2 \ux}{\delta y^2}}{i,1}
   = \frac{1}{\Delta y^2} \vat{\ux}{i,0}
   - \frac{2}{\Delta y^2} \vat{\ux}{i,1}
   + \frac{1}{\Delta y^2} \vat{\ux}{i,2},

where obviously information from the lower process :math:`\vat{\ux}{i,\text{jsize}}` is needed.
From the lower process' point of view, :math:`\vat{\ux}{i,\text{jsize}+1}` is needed, which is :math:`\vat{\ux}{i,1}` of the current process.

The function :c-lang:`parallel_update_halo_ym` is designed to exchange these information with the lower process.
For example, the communication of :c-lang:`UX` can be drawn as:

.. image:: image/halo1.pdf
   :width: 800

Similarly, the function :c-lang:`parallel_update_halo_yp` deals with the exchange with the upper process:

.. image:: image/halo2.pdf
   :width: 800


#if !defined(SIMPLE_NPYIO)
#define SIMPLE_NPYIO

#include <stdint.h>
#include <stdbool.h>

extern size_t simple_npyio_w_header(const size_t  ndim, const size_t  *shape, const char dtype[], const bool  is_fortran_order, FILE *fp);
extern size_t simple_npyio_r_header(      size_t *ndim,       size_t **shape,       char **dtype,       bool *is_fortran_order, FILE *fp);

#endif // SIMPLE_NPYIO

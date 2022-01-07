#if !defined(FILEIO_H)
#define FILEIO_H

#include <stdio.h>
#include <stddef.h>

#include "param.h"
#include "parallel.h"

/* directory names */
#define FILEIO_SAVE "output/save"
#define FILEIO_LOG  "output/log"
#define FILEIO_STAT "output/stat"

/* general file opener / closer */
extern FILE *fileio_fopen(const char * restrict path, const char * restrict mode);
extern int fileio_fclose(FILE *stream);

/* create directory from main process */
extern int fileio_mkdir_by_main_process(const char dirname[], const parallel_t *parallel);

/* for simple_npyio lib */
// datatypes
#define NPYIO_INT    "'int32'"
#define NPYIO_DOUBLE "'float64'"
// wrapper functions of simple_npyio header writer / reader
// data writer / reader are also included
extern int fileio_w_0d_serial(const char dirname[], const char dsetname[], const char dtype[], const size_t size, const void *data);
extern int fileio_r_0d_serial(const char dirname[], const char dsetname[],                     const size_t size,       void *data);
extern int fileio_w_1d_serial(const char dirname[], const char dsetname[], const char dtype[], const size_t size, const size_t nitems, const void *data);
extern int fileio_r_ux_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel,       double *data);
extern int fileio_w_ux_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, const double *data);
extern int fileio_r_uy_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel,       double *data);
extern int fileio_w_uy_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, const double *data);
extern int fileio_r_p_like_parallel (const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel,       double *data);
extern int fileio_w_p_like_parallel (const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, const double *data);

#endif // FILEIO_H

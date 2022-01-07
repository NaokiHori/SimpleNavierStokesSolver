#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <mpi.h>
#include "common.h"
#include "fileio.h"
#include "simple_npyio.h"


static char *generate_error_message(const char fname[], const int line, const char message[]){
  /* foramt is sprintf("%s:%d, %s", filename, line, message) */
  size_t nchars[3] = {0};
  nchars[0] = strlen(fname);
  nchars[2] = strlen(message);
  nchars[1] = 1;
  {
    int l = line; // copy since line is const
    while(l /= 10){
      nchars[1] += 1;
    }
  }
  /* allocate and copy contents */
  // number of all characters + separators (':' and ", ") and NUL, 4 additional characters in total
  char *retval = common_calloc(nchars[0]+nchars[1]+nchars[2]+4, sizeof(char));
  sprintf(retval, "%s:%d, %s", fname, line, message);
  return retval;
}

static char *generate_npy_filename(const char dirname[], const char dsetname[]){
  size_t nchars[2] = {0};
  nchars[0] = strlen(dirname);
  nchars[1] = strlen(dsetname);
  // allocate with "/" and ".npy" and NUL, 6 additional characters in total
  char *fname = common_calloc(nchars[0]+nchars[1]+6, sizeof(char));
  sprintf(fname, "%s/%s.npy", dirname, dsetname);
  return fname;
}

/* ! fopen with error handling ! 9 ! */
FILE *fileio_fopen(const char * restrict path, const char * restrict mode){
  FILE *stream = fopen(path, mode);
  if(stream == NULL){
    char *error_message = generate_error_message(__FILE__, __LINE__, path);
    perror(error_message);
    common_free(error_message);
  }
  return stream;
}

/* ! fclose with error handling ! 10 ! */
int fileio_fclose(FILE *stream){
  int retval = fclose(stream);
  if(retval != 0){
    char *error_message = generate_error_message(__FILE__, __LINE__, "");
    perror(error_message);
    common_free(error_message);
  }
  stream = NULL;
  return 0;
}

int fileio_mkdir_by_main_process(const char dirname[], const parallel_t *parallel){
  // NOTE: continue even if failed,
  //   since we want to override previous data (errorcode: EEXIST)
  const int mpirank = parallel->mpirank;
  if(mpirank == 0){
    if(mkdir(dirname, 0777) != 0){
      // failed to create directory
      char *error_message = generate_error_message(__FILE__, __LINE__, dirname);
      perror(error_message);
      common_free(error_message);
    }
  }
  // wait for the completion of mkdir
  MPI_Barrier(MPI_COMM_WORLD);
  return 0;
}

/* wrapper function of simple_npyio_r_header with error handling */
static size_t fileio_r_npy_header(const char fname[], size_t *ndim, size_t **shape, char **dtype){
  size_t header_size = 0;
  FILE *fp = fileio_fopen(fname, "r");
  if(fp != NULL){
    bool is_fortran_order;
    header_size = simple_npyio_r_header(ndim, shape, dtype, &is_fortran_order, fp);
    if(header_size == 0){
      fprintf(stderr, "%s:%d npyio header read failed\n", __FILE__, __LINE__);
    }
    fclose(fp);
  }
  return header_size;
}

/* wrapper function of simple_npyio_w_header with error handling */
static size_t fileio_w_npy_header(const char fname[], const size_t ndim, const size_t *shape, const char dtype[]){
  size_t header_size = 0;
  FILE *fp = fileio_fopen(fname, "w");
  if(fp != NULL){
    header_size = simple_npyio_w_header(ndim, shape, dtype, false, fp);
    if(header_size == 0){
      fprintf(stderr, "%s:%d npyio header write failed\n", __FILE__, __LINE__);
    }
    fclose(fp);
  }
  return header_size;
}

int fileio_r_0d_serial(const char dirname[], const char dsetname[], const size_t size, void *data){
  size_t ndim;
  size_t *shape = NULL;
  char *dtype = NULL;
  char *fname = generate_npy_filename(dirname, dsetname);
  const size_t header_size = fileio_r_npy_header(fname, &ndim, &shape, &dtype);
  if(header_size != 0){
    FILE *fp = fileio_fopen(fname, "r");
    fseek(fp, header_size, SEEK_SET);
    if(fp != NULL){
      size_t retval = fread(data, size, 1, fp);
      if(retval != 1){
        char *error_message = generate_error_message(__FILE__, __LINE__, dirname);
        fprintf(stderr, "%s fread failed\n", error_message);
        common_free(error_message);
      }
      fclose(fp);
    }
  }
  common_free(shape);
  common_free(dtype);
  common_free(fname);
  return 0;
}

int fileio_w_0d_serial(const char dirname[], const char dsetname[], const char dtype[], const size_t size, const void *data){
  const size_t ndim = 0;
  const size_t *shape = NULL;
  char *fname = generate_npy_filename(dirname, dsetname);
  const size_t header_size = fileio_w_npy_header(fname, ndim, shape, dtype);
  if(header_size != 0){
    FILE *fp = fileio_fopen(fname, "a");
    if(fp != NULL){
      fwrite(data, size, 1, fp);
      fclose(fp);
    }
  }
  common_free(fname);
  return 0;
}

int fileio_w_1d_serial(const char dirname[], const char dsetname[], const char dtype[], const size_t size, const size_t nitems, const void *data){
  const size_t ndim = 1;
  const size_t shape[] = {nitems};
  char *fname = generate_npy_filename(dirname, dsetname);
  const size_t header_size = fileio_w_npy_header(fname, ndim, shape, dtype);
  if(header_size != 0){
    FILE *fp = fileio_fopen(fname, "a");
    if(fp != NULL){
      fwrite(data, shape[0]*size, 1, fp);
      fclose(fp);
    }
  }
  common_free(fname);
  return 0;
}

static int fileio_r_2d_parallel(const char dirname[], const char dsetname[], const parallel_t *parallel, const size_t shape[2], const size_t offset, const size_t count, double *data){
  const int mpirank = parallel->mpirank;
  char *fname = generate_npy_filename(dirname, dsetname);
  // load and check header
  size_t header_size;
  if(mpirank == 0){
    const size_t ndim = 2;
    const char dtype[] = NPYIO_DOUBLE;
    size_t ndim_;
    size_t *shape_ = NULL;
    char *dtype_ = NULL;
    header_size = fileio_r_npy_header(fname, &ndim_, &shape_, &dtype_);
    // sanitise input
    if(ndim != ndim_){
      printf("ndim should be %zu, not %zu\n", ndim, ndim_);
      header_size = 0;
    }
    for(size_t n = 0; n < ndim; n++){
      if(shape[n] != shape_[n]){
        printf("shape[%zu] should be %zu, not %zu\n", n, shape[n], shape_[n]);
        header_size = 0;
      }
    }
    if(strcmp(dtype, dtype_) != 0){
      printf("dtype should be %s, not %s\n", dtype, dtype_);
      header_size = 0;
    }
    common_free(shape_);
    common_free(dtype_);
  }
  // error detected in header, abort
  MPI_Bcast(&header_size, sizeof(size_t)/sizeof(uint8_t), MPI_BYTE, 0, MPI_COMM_WORLD);
  if(header_size == 0){
    common_free(fname);
    return 1;
  }
  // load data
  MPI_File fh = NULL;
  int mpi_error_code = MPI_File_open(MPI_COMM_WORLD, fname, MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);
  if(MPI_SUCCESS != mpi_error_code){
    char string[MPI_MAX_ERROR_STRING];
    int resultlen;
    MPI_Error_string(mpi_error_code, string, &resultlen);
    fprintf(stderr, "%s:%d %s\n", __FILE__, __LINE__, string);
    common_free(fname);
    return 1;
  }
  MPI_File_read_at_all(
      fh,
      offset*sizeof(double)+header_size,
      data+shape[1], // 1 halo cell in y is assumed and skipped
      count *sizeof(double),
      MPI_BYTE,
      MPI_STATUS_IGNORE
  );
  MPI_File_close(&fh);
  common_free(fname);
  return 0;
}

static int fileio_w_2d_parallel(const char dirname[], const char dsetname[], const parallel_t *parallel, const size_t shape[2], const size_t offset, const size_t count, const double *data){
  const int mpirank = parallel->mpirank;
  const size_t ndim = 2;
  const char dtype[] = NPYIO_DOUBLE;
  char *fname = generate_npy_filename(dirname, dsetname);
  size_t header_size = 0;
  if(mpirank == 0){
    header_size = fileio_w_npy_header(fname, ndim, shape, dtype);
  }
  MPI_Bcast(&header_size, sizeof(size_t)/sizeof(uint8_t), MPI_BYTE, 0, MPI_COMM_WORLD);
  if(header_size == 0){
    common_free(fname);
    return 1;
  }
  MPI_File fh = NULL;
  int mpi_error_code = MPI_File_open(MPI_COMM_WORLD, fname, MPI_MODE_APPEND | MPI_MODE_WRONLY, MPI_INFO_NULL, &fh);
  if(MPI_SUCCESS != mpi_error_code){
    char string[MPI_MAX_ERROR_STRING];
    int resultlen;
    MPI_Error_string(mpi_error_code, string, &resultlen);
    fprintf(stderr, "%s:%d %s\n", __FILE__, __LINE__, string);
    common_free(fname);
    return 1;
  }
  MPI_File_write_at_all(
      fh,
      offset*sizeof(double)+header_size,
      data+shape[1],
      count*sizeof(double),
      MPI_BYTE,
      MPI_STATUS_IGNORE
  );
  MPI_File_close(&fh);
  common_free(fname);
  return 0;
}

int fileio_r_ux_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, double *data){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
  const size_t shape[] = {jtot, itot+1};
  const size_t offset = shape[1]*joffset;
  const size_t count  = shape[1]*jsize;
  fileio_r_2d_parallel(dirname, dsetname, parallel, shape, offset, count, data);
  return 0;
}

int fileio_r_uy_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, double *data){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
  const size_t shape[] = {jtot, itot+2};
  const size_t offset = shape[1]*joffset;
  const size_t count  = shape[1]*jsize;
  fileio_r_2d_parallel(dirname, dsetname, parallel, shape, offset, count, data);
  return 0;
}

int fileio_r_p_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, double *data){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
  const size_t shape[] = {jtot, itot+2};
  const size_t offset = shape[1]*joffset;
  const size_t count  = shape[1]*jsize;
  fileio_r_2d_parallel(dirname, dsetname, parallel, shape, offset, count, data);
  return 0;
}

int fileio_w_ux_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, const double *data){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
  const size_t shape[] = {jtot, itot+1};
  const size_t offset = shape[1]*joffset;
  const size_t count  = shape[1]*jsize;
  fileio_w_2d_parallel(dirname, dsetname, parallel, shape, offset, count, data);
  return 0;
}

int fileio_w_uy_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, const double *data){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
  const size_t shape[] = {jtot, itot+2};
  const size_t offset = shape[1]*joffset;
  const size_t count  = shape[1]*jsize;
  fileio_w_2d_parallel(dirname, dsetname, parallel, shape, offset, count, data);
  return 0;
}

int fileio_w_p_like_parallel(const char dirname[], const char dsetname[], const param_t *param, const parallel_t *parallel, const double *data){
  const int mpisize = parallel->mpisize;
  const int mpirank = parallel->mpirank;
  const int itot = param->itot;
  const int jtot = param->jtot;
  const int jsize = parallel_get_size(jtot, mpisize, mpirank);
  const int joffset = parallel_get_offset(jtot, mpisize, mpirank);
  const size_t shape[] = {jtot, itot+2};
  const size_t offset = shape[1]*joffset;
  const size_t count  = shape[1]*jsize;
  fileio_w_2d_parallel(dirname, dsetname, parallel, shape, offset, count, data);
  return 0;
}


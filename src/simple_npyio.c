// https://github.com/NaokiHori/SimpleNpyIO

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include "simple_npyio.h"


/* assumptions and definitions */
// check 1 byte is 8 bits
#if CHAR_BIT != 8
#error "CHAR_BIT is not 8"
#endif
/* ! all npy files should start from this magic string ! 1 ! */
static const char magic_string[] = {"\x93NUMPY"};
// end-of-string
#define NUL '\x00'

/* logger */
#if defined(LOGGING_SIMPLE_NPYIO) // dump log info
#define LOGGING(...){                            \
  fprintf(stderr, "[NPYIO LOG:%4d] ", __LINE__); \
  fprintf(stderr, __VA_ARGS__);                  \
}
#else // do nothing if not requested
#define LOGGING(...)
#endif

/* dump error message with line number etc. */
#define ERROR(...){                              \
  fprintf(stderr, "[NPYIO ERR:%4d] ", __LINE__); \
  fprintf(stderr, __VA_ARGS__);                  \
}

// NULL check, return "retval" when it is
#define REJECT_NULL(ptr, retval){ \
  if((ptr) == NULL){ \
    ERROR("%s is NULL\n", #ptr); \
    return (retval); \
  } \
}

// errorcode (return value)
#define RETVAL_SUCCESS ( 0)
#define RETVAL_FAILURE (-1)

// maximum number of items
// more than 65535, sufficiently large for my purpose
#define NITEMS_MAX USHRT_MAX

/* ! memory pool storing all allocated pointers in this library ! 8 ! */
typedef struct smt_t_ smt_t;
struct smt_t_ {
  // pointer to the allocated buffer (by my_calloc)
  void *ptr;
  // pointer to the next node
  smt_t *node_next;
};
static smt_t *all_memories = NULL;

/* take care of actual allocation / deallocation */
static void *my_calloc(const size_t count, const size_t size){
  void *ptr = calloc(count, size);
  if(ptr == NULL){
    ERROR("Memory allocation error\n");
    exit(EXIT_FAILURE);
  }
  return ptr;
}

static void my_free(void *ptr){
  free(ptr);
  ptr = NULL;
}

/* get_nitems */
static int kernel_smt_get_nitems(size_t *nitems, smt_t *node_root){
  smt_t *node_curr = node_root;
  for(*nitems = 0; node_curr != NULL; node_curr = node_curr->node_next, (*nitems)++){
    if(*nitems >= NITEMS_MAX){
      return RETVAL_FAILURE;
    }
  }
  return RETVAL_SUCCESS;
}

/* search pointer */
static int search(smt_t **node_root, smt_t **node_curr, smt_t **node_prev, const void *ptr){
  /*
   * return RETVAL_SUCCESS if "ptr" is found,
   * otherwise return RETVAL_FAILURE
   */
  for(*node_prev = NULL, *node_curr = *node_root;
      *node_curr != NULL;
      *node_prev = *node_curr, *node_curr = (*node_curr)->node_next
  ){
    if((*node_curr)->ptr == ptr){
      return RETVAL_SUCCESS;
    }
  }
  return RETVAL_FAILURE;
}

/* functions which increase members */
static int kernel_smt_attach(smt_t **node_root, void *ptr){
  // too many members should be rejected
  size_t nitems;
  if(kernel_smt_get_nitems(&nitems, *node_root) != RETVAL_SUCCESS){
    return RETVAL_FAILURE;
  }
  smt_t *node_prev = NULL;
  smt_t *node_curr = NULL;
  // check duplication
  // we should NOT be able to find the new pointer in the already-registered list
  if(search(node_root, &node_curr, &node_prev, ptr) != RETVAL_FAILURE){
    return RETVAL_FAILURE;
  }
  // allocate a node to hold ptr information
  node_curr = my_calloc(1, sizeof(smt_t));
  // next node is current root (new node is new root node)
  node_curr->node_next = *node_root;
  // assign other info
  node_curr->ptr = ptr;
  // now curr node is the root
  *node_root = node_curr;
  return RETVAL_SUCCESS;
}

static void *smt_calloc(const size_t count, const size_t size){
  // allocate pointer
  void *ptr = my_calloc(count, size);
  if(kernel_smt_attach(&all_memories, ptr) != RETVAL_SUCCESS){
    ERROR("More than %d buffers are allocated.\n", NITEMS_MAX);
    ERROR("This is not accepted by default.\n");
    ERROR("Define NITEMS_MAX explicitly to change this behaviour\n");
    exit(EXIT_FAILURE);
  }
  return ptr;
}

/* functions which decrease members */
static int kernel_smt_detach(smt_t **node_root, const void *ptr){
  smt_t *node_prev = NULL;
  smt_t *node_curr = NULL;
  // we should be able to find it, since we know there is
  if(search(node_root, &node_curr, &node_prev, ptr) != RETVAL_SUCCESS){
    return RETVAL_FAILURE;
  }
  if(node_prev == NULL){
    // update root node
    *node_root = node_curr->node_next;
  }else{
    // update link
    node_prev->node_next = node_curr->node_next;
  }
  my_free(node_curr);
  return RETVAL_SUCCESS;
}

static void smt_detach(const void *ptr){
  if(kernel_smt_detach(&all_memories, ptr) != RETVAL_SUCCESS){
    ERROR("Cannot find %p in the allocated list\n", ptr);
    exit(EXIT_FAILURE);
  }
}

static void smt_free(void *ptr){
  if(kernel_smt_detach(&all_memories, ptr) != RETVAL_SUCCESS){
    ERROR("Cannot find %p in the allocated list\n", ptr);
    exit(EXIT_FAILURE);
  }
  my_free(ptr);
}

static void smt_free_all(void){
  while(all_memories != NULL){
    void *ptr = all_memories->ptr;
    smt_free(ptr);
  }
}

#undef RETVAL_SUCCESS
#undef RETVAL_FAILURE
#undef NITEMS_MAX

/* auxiliary functions which are used by writer and reader */

// https://gist.github.com/NaokiHori/91c560a59f4e4ef37eb33b8e1c055fbc
static bool is_big_endian(void){
  const uint16_t val = 1 << 8;
  return (bool)(((const uint8_t *)(&val))[0]);
}

// https://gist.github.com/NaokiHori/81ad6e1562e1ec23253246902c281cc2
static int convert_endian(void *val, const size_t size){
  REJECT_NULL(val, -1);
  // positive size check
  if(size <= 0){
    ERROR("size of buffer should be positive\n");
    return -1;
  }
  // reject too large size
  // 128 is normally sufficient
  // even converting size_t would request 8 (64-bit arc.)
  if(size >= 128){
    ERROR("size of buffer is larger than 128\n");
    return -1;
  }
  size_t n_bytes = size/sizeof(uint8_t);
  uint8_t *buf = smt_calloc(n_bytes, sizeof(uint8_t));
  for(size_t i = 0; i < n_bytes; i++){
    buf[i] = ((uint8_t *)val)[n_bytes-i-1];
  }
  memcpy(val, buf, size);
  smt_free(buf);
  return 0;
}

static int find_pattern(size_t *location, const char *p0, const size_t size_p0, const char *p1, const size_t size_p1){
  /*
   * try to find a pattern "p1" in "p0"
   *   and return its location IN BYTES
   * -1 is returned when error is detected
   *   if the pattern is not found
   * note that sizes of "p0" and "p1" are
   *   in BYTES, NOT number of elements
   * thus it is necessary to divide by the
   *   sizeof original datatype
   *   after the result is obtained
   */
  REJECT_NULL(p0, -1);
  REJECT_NULL(p1, -1);
  // p0 is shorter than p1, return not found
  if(size_p0 < size_p1){
    return -1;
  }
  // e.g., size_p0 = 7, size_p1 = 3
  //     0 1 2 3 4 5 6
  // p0: a b c d e f g
  // p1: x y z
  //       x y z
  //         x y z
  //           x y z
  //             x y z
  //     ^       ^
  //    imin    imax
  size_t imin = 0;
  size_t imax = size_p0-size_p1;
  for(size_t i = imin; i <= imax; i++){
    if(memcmp(p0+i, p1, size_p1) == 0){
      *location = i;
      return 0;
    }
  }
  return -1;
}

static void error_handlings(void){
  smt_free_all();
}

/* reader */

static int load_magic_string(size_t *buf_size, FILE *fp){
  /*
   * all npy file should start with \x93NUMPY,
   *   which is checked here by comparing
   *   the fist 6 bytes of the file
   *   and the magic string given a priori
   */
  REJECT_NULL(fp, -1);
  size_t nitems = strlen(magic_string);
  // allocate buffer and load from file
  // NOTE: file pointer is moved forward as well
  uint8_t *buf = smt_calloc(nitems, sizeof(uint8_t));
  {
    size_t retval = fread(buf, sizeof(uint8_t), nitems, fp);
    if(retval != nitems){
      ERROR("fread failed (%zu items loaded, while %zu items requested)\n", retval, nitems);
      return -1;
    }
  }
  *buf_size = sizeof(uint8_t)*nitems;
  // compare memories of
  //   1. "buf" (loaded from file)
  //   2. "magic_str" (answer)
  if(memcmp(buf, magic_string, *buf_size) != 0){
    ERROR("magic string \"\\x93NUMPY\" cannot be found\n");
    return -1;
  }
  smt_free(buf);
  return 0;
}

static int load_versions(uint8_t *major_version, uint8_t *minor_version, size_t *buf_size, FILE *fp){
  /*
   * check version of the file
   * for now 1.0, 2.0, and 3.0 are considered,
   *    and others are rejected
   */
  const size_t nitems_major_version = 1;
  const size_t nitems_minor_version = 1;
  const size_t buf_size_major_version = sizeof(uint8_t)*nitems_major_version;
  const size_t buf_size_minor_version = sizeof(uint8_t)*nitems_minor_version;
  // load from file
  // (file pointer is moved forward as well)
  {
    size_t retval = fread(major_version, sizeof(uint8_t), nitems_major_version, fp);
    if(retval != nitems_major_version){
      ERROR("fread failed (%zu items loaded, while %zu items requested)\n", retval, nitems_major_version);
      return -1;
    }
  }
  {
    size_t retval = fread(minor_version, sizeof(uint8_t), nitems_minor_version, fp);
    if(retval != nitems_minor_version){
      ERROR("fread failed (%zu items loaded, while %zu items requested)\n", retval, nitems_minor_version);
      return -1;
    }
  }
  // check version 1.x or 2.x or 3.x
  if(*major_version != 1 && *major_version != 2 && *major_version != 3){
    ERROR("major version (%u) should be 1 or 2\n", *major_version);
    return -1;
  }
  // check version x.0
  if(*minor_version != 0){
    ERROR("minor version (%u) should be 0\n", *minor_version);
    return -1;
  }
  LOGGING("major version: %u\n", *major_version);
  LOGGING("minor version: %u\n", *minor_version);
  *buf_size = buf_size_major_version + buf_size_minor_version;
  return 0;
}

static int load_header_len(size_t *header_len, size_t *buf_size, size_t major_version, FILE *fp){
  /*
   * check header size of the npy file
   * in particular HEADER_LEN = len(dict) + len(padding)
   *   is loaded
   * memory size of this variable depends on the major version
   *   of the npy file, 2 bytes for major_version = 1,
   *   while 4 bytes for major_version = 2
   */
  /* ! buffer size differs based on major_version ! 10 ! */
  size_t nitems;
  if(major_version == 1){
    *buf_size = sizeof(uint16_t);
    // usually 2
    nitems = *buf_size/sizeof(uint8_t);
  }else{
    *buf_size = sizeof(uint32_t);
    // usually 4
    nitems = *buf_size/sizeof(uint8_t);
  }
  /* ! allocate buffer and load corresponding memory size from file ! 8 ! */
  uint8_t *buf = smt_calloc(nitems, sizeof(uint8_t));
  {
    size_t retval = fread(buf, sizeof(uint8_t), nitems, fp);
    if(retval != nitems){
      ERROR("fread failed (%zu items loaded, while %zu items requested)\n", retval, nitems);
      return -1;
    }
  }
  /* ! convert endian of loaded buffer when needed ! 3 ! */
  if(is_big_endian()){
    convert_endian(buf, *buf_size);
  }
  /* ! interpret buffer (sequence of uint8_t) as a value having corresponding datatype ! 11 ! */
  if(major_version == 1){
    // interpret as a 2-byte value
    uint16_t tmp;
    memcpy(&tmp, buf, sizeof(uint8_t)*nitems);
    *header_len = (size_t)tmp;
  }else{
    // interpret as a 4-byte value
    uint32_t tmp;
    memcpy(&tmp, buf, sizeof(uint8_t)*nitems);
    *header_len = (size_t)tmp;
  }
  smt_free(buf);
  LOGGING("header_len: %zu\n", *header_len);
  return 0;
}

static int load_dict_and_padding(uint8_t **dict_and_padding, size_t *buf_size, size_t header_len, FILE *fp){
  /*
   * load dictionary and padding
   * loading padding is also necessary (or at least one of the easiest ways)
   *   to move file pointer "fp" forward
   */
  size_t nitems = header_len/sizeof(uint8_t);
  *dict_and_padding = smt_calloc(nitems, sizeof(uint8_t));
  {
    size_t retval = fread(*dict_and_padding, sizeof(uint8_t), nitems, fp);
    if(retval != nitems){
      ERROR("fread failed (%zu items loaded, while %zu items requested)\n", retval, nitems);
      return -1;
    }
  }
  *buf_size = header_len;
  return 0;
}

static int extract_dict(char **dict, uint8_t *dict_and_padding, size_t header_len){
  /*
   * extract dictionary "dict" from "dict_and_padding",
   *   which contains dictionary and padding
   * also unnecessary spaces are removed from the original array
   *   to simplify the following procedures
   * note that spaces inside quotations (e.g. dictionary key might contain spaces)
   *   should NOT be eliminated, which are "necessary spaces" so to say
   */
  // look for "{" and "}" to find the range of dict in dict_and_padding,
  // e.g., dict_and_padding:
  //   <------------------------ dict ------------------------><- padding ->
  //   {'descr': VALUE, 'fortran_order': VALUE, 'shape': VALUE}           \n
  //   ^                                                      ^
  //   s                                                      e
  // s: start
  // this should be 0, because of NPY format definition,
  //   i.e., dict should start just after HEADER_LEN
  // confirm it just in case
  //   by checking whether the first byte is "{"
  size_t s;
  {
    // use char since it's "{"
    char p0 = (char)(dict_and_padding[0]);
    char p1 = '{';
    if(memcmp(&p0, &p1, sizeof(char)) != 0){
      ERROR("dict_and_padding (%s) does not start with '{'\n", dict_and_padding);
      return -1;
    }
    s = 0;
  }
  // e: end
  // checking from the last, since padding only contains
  //   space 0x20 and 0x0a, which is much safer than
  //   walking through all dicts which have much richer info
  size_t e = 0;
  {
    for(size_t i = header_len-1; i > 0; i--){
      // use uint8_t since padding is essentially binary
      //  rather than ascii
      uint8_t p0 = dict_and_padding[i];
      char p1 = '}';
      if(memcmp(&p0, &p1, sizeof(char)) == 0){
        e = i;
        break;
      }
      if(i == 1){
        ERROR("dict_and_padding (%s) is empty\n", dict_and_padding);
        return -1;
      }
    }
  }
  // flag dict_and_padding to decide
  //   which part should be / should not be extracted
  // "meaningless spaces" (spaces outside quotations) are de-flagged
  // e.g., meaningless spaces are
  //   {'descr': VALUE, 'fortran_order': VALUE, 'shape': VALUE}
  //            ^      ^                ^      ^        ^
  size_t n_chars_dict = 0;
  bool *is_dict = smt_calloc(e-s+1, sizeof(bool));
  {
    bool is_inside_s_quotations = false;
    bool is_inside_d_quotations = false;
    for(size_t i = s; i <= e; i++){
      uint8_t c = dict_and_padding[i];
      // check whether we are inside a pair of single quotations
      if(c == (uint8_t)('\'')){
        is_inside_s_quotations = !is_inside_s_quotations;
      }
      // check whether we are inside a pair of double quotations
      if(c == (uint8_t)('"')){
        is_inside_d_quotations = !is_inside_d_quotations;
      }
      if(c != (uint8_t)(' ')){
        // if "c" is not space, the information is meaningful
        //   as a member of the dictionary
        n_chars_dict++;
        is_dict[i-s] = true;
      }else{
        if(is_inside_s_quotations || is_inside_d_quotations){
          // key can contain spaces (not recommended though)
          // these spaces should NOT be removed
          n_chars_dict++;
          is_dict[i-s] = true;
        }else{
          // "c" is a space and outside pair of quotations,
          //   indicating this space is meaningless
          is_dict[i-s] = false;
        }
      }
    }
  }
  // copy flagged part to dict
  *dict = smt_calloc(n_chars_dict+1, sizeof(char)); // + NUL
  for(size_t i = s, j = 0; i <= e; i++){
    if(is_dict[i-s]){
      (*dict)[j] = (char)(dict_and_padding[i]);
      j++;
    }
  }
  smt_free(is_dict);
  LOGGING("dict: %s\n", *dict);
  return 0;
}

static int find_dict_value(const char key[], char **val, const char *dict){
  /*
   * dictionary consists of pairs of "key" and "val"
   * this function extracts the "val" of the specified "key"
   */
  REJECT_NULL(key,  -1);
  REJECT_NULL(dict, -1);
  // number of characters
  size_t n_chars_key = strlen(key);
  size_t n_chars_dict = strlen(dict);
  // do not accept zero-length strings
  if(n_chars_key == 0){
    ERROR("key is empty\n");
    return -1;
  }
  if(n_chars_dict == 0){
    ERROR("dict is empty\n");
    return -1;
  }
  // 1. find key locations (start and end)
  size_t key_s = 0;
  {
    size_t location;
    int retval = find_pattern(
        &location,
        dict,
        sizeof(char)*n_chars_dict,
        key,
        sizeof(char)*n_chars_key
    );
    if(retval < 0){
      ERROR("key (%s) not found in dict (%s)\n", key, dict);
      return -1;
    }
    key_s = location/sizeof(char);
  }
  // end is easy since we know the length of the key
  size_t key_e = key_s + n_chars_key - 1;
  // 2. find val locations (start and end)
  // start: end of the key + ":",
  //   assuming no spaces
  //   ... key:value ...
  //         ^ ^
  size_t val_s = key_e + 2;
  size_t val_e;
  // parse dict to figure out the end location of value,
  //   which is based on the fact "python dict is delimited by ','"
  // we might not be able to find ","
  //   if the pair of key / value locates at the last of the given dict
  // in this case "}" is used to notice we are at the end of dict
  // note that "," might exist inside values
  // thus we need to regard
  //   "," ONLY outside pair of brackets as delimiters
  int bracket_level_r = 0; // ( and )
  int bracket_level_s = 0; // [ and ]
  for(val_e = val_s; val_e < n_chars_dict; val_e++){
    char c = dict[val_e];
    if(c == '('){
      bracket_level_r++;
    }
    if(c == ')'){
      bracket_level_r--;
    }
    if(c == '['){
      bracket_level_s++;
    }
    if(c == ']'){
      bracket_level_s--;
    }
    bool is_outside_brackets_r = false;
    bool is_outside_brackets_s = false;
    if(bracket_level_r == 0){
      is_outside_brackets_r = true;
    }else if(bracket_level_r < 0){
      // indicating ) is found but ( could not found in front of it
      ERROR("strange dict (%s), ')' found but corresponding '(' not found in front of it\n", dict);
      return -1;
    }
    if(bracket_level_s == 0){
      is_outside_brackets_s = true;
    }else if(bracket_level_s < 0){
      // indicating ] is found but [ could not found in front of it
      ERROR("strange dict (%s), ']' found but corresponding '[' not found in front of it\n", dict);
      return -1;
    }
    // we are at the end of val if "," is found outside all brackets
    if(c == ','){
      if(is_outside_brackets_r && is_outside_brackets_s){
        // end of val should be just before found ','
        val_e -= 1;
        break;
      }
    }
    // we are at the end of dict if "}" is found
    if(c == '}'){
      // end of val should be just before '}'
      val_e -= 1;
      break;
    }
  }
  // 3. now we know where val starts and terminates, so extract it
  size_t n_chars_val = val_e-val_s+1;
  *val = smt_calloc(n_chars_val+1, sizeof(char)); // + NUL
  memcpy(*val, dict+val_s, sizeof(char)*n_chars_val);
  return 0;
}

static int extract_shape(size_t *ndim, size_t **shape, const char *val){
  /*
   * parse given python tuple "val" and obtain shape of data,
   *   which is necessary to be parsed to re-construct the data
   */
  REJECT_NULL(val, -1);
  // 1. check number of dimension (ndim) to store shape
  {
    char *str = NULL;
    // copy "val" to a buffer "str" after removing parentheses
    size_t n_chars_val = strlen(val);
    // no parentheses (-2), with NUL (+1)
    str = smt_calloc(n_chars_val-2+1, sizeof(char));
    memcpy(str, val+1, sizeof(char)*(n_chars_val-2));
    // parse "val" to know "ndim",
    // e.g.,
    //   <empty> -> ndim = 0
    //   314,    -> ndim = 1
    //   31,4    -> ndim = 2
    //   3,1,4,  -> ndim = 3
    *ndim = 0;
    for(size_t i = 0; ; i++){
      const char sep[] = {","};
      char *buf = NULL;
      if(i == 0){
        buf = strtok(str,  sep);
      }else{
        buf = strtok(NULL, sep);
      }
      if(buf == NULL){
        break;
      }else{
        (*ndim)++;
      }
    }
    smt_free(str);
  }
  // 2. allocate shape and assign size in each dimension
  *shape = smt_calloc(*ndim, sizeof(size_t));
  {
    char *str = NULL;
    // copy "val" to a buffer "str" after removing parentheses
    size_t n_chars_val = strlen(val);
    // no parentheses (-2), with NUL (+1)
    str = smt_calloc(n_chars_val-2+1, sizeof(char));
    memcpy(str, val+1, sizeof(char)*(n_chars_val-2));
    // parse value to know shape
    // e.g.,
    //   <empty> -> N/A
    //   314,    -> shape[0] = 314
    //   31,4    -> shape[0] = 31, shape[1] = 4
    //   3,1,4,  -> shape[0] = 3,  shape[1] = 1, shape[2] = 4
    for(size_t i = 0, j = 0; ; i++){
      const char sep[] = {","};
      char *buf = NULL;
      if(i == 0){
        buf = strtok(str,  sep);
      }else{
        buf = strtok(NULL, sep);
      }
      if(buf == NULL){
        break;
      }else{
        // assign to the resulting buffer "shape"
        long long tmp = strtoll(buf, NULL, 10);
        if(tmp <= 0){
          ERROR("non-positive shape: %lld\n", tmp);
        }else{
          (*shape)[j] = (size_t)tmp;
          j++;
        }
      }
    }
    smt_free(str);
  }
  LOGGING("ndim: %zu\n", *ndim);
  for(size_t i = 0; i < *ndim; i++){
    LOGGING("shape[%zu]: %zu\n", i, (*shape)[i]);
  }
  return 0;
}

static int extract_dtype(char **dtype, const char *val){
  /*
   * find a key 'descr' and extract its value
   * return obtained value directly since it is enough
   */
  REJECT_NULL(val, -1);
  size_t n_chars_val = strlen(val);
  *dtype = smt_calloc(n_chars_val+1, sizeof(char));
  memcpy(*dtype, val, sizeof(char)*n_chars_val);
  (*dtype)[n_chars_val] = NUL;
  LOGGING("dtype: %s\n", *dtype);
  return 0;
}

static int extract_is_fortran_order(bool *is_fortran_order, const char *val){
  /*
   * find a key 'fortran_order' and extract its value
   * check whether it is "True" or "False",
   *   convert it to boolean and return
   */
  REJECT_NULL(val, -1);
  bool  true_is_found = false;
  bool false_is_found = false;
  // try to find "True"
  {
    const char pattern[] = {"True"};
    size_t location;
    size_t n_chars_val = strlen(val);
    size_t n_chars_pattern = strlen(pattern);
    int retval = find_pattern(
        &location,
        val,
        sizeof(char)*n_chars_val,
        pattern,
        sizeof(char)*n_chars_pattern
    );
    if(retval < 0){
      true_is_found = false;
    }else{
      true_is_found = true;
    }
  }
  // try to find "False"
  {
    const char pattern[] = {"False"};
    size_t location;
    size_t n_chars_val = strlen(val);
    size_t n_chars_pattern = strlen(pattern);
    int retval = find_pattern(
        &location,
        val,
        sizeof(char)*n_chars_val,
        pattern,
        sizeof(char)*n_chars_pattern
    );
    if(retval < 0){
      false_is_found = false;
    }else{
      false_is_found = true;
    }
  }
  // check two results and decide final outcome
  if(true_is_found && false_is_found){
    ERROR("both True and False are found: %s\n", val);
    return -1;
  }else if((!true_is_found) && (!false_is_found)){
    ERROR("none of True and False are found: %s\n", val);
    return -1;
  }else if(true_is_found){
    *is_fortran_order = true;
  }else{
    *is_fortran_order = false;
  }
  LOGGING("is_fortran_order: %u\n", *is_fortran_order);
  return 0;
}

size_t simple_npyio_r_header(size_t *ndim, size_t **shape, char **dtype, bool *is_fortran_order, FILE *fp){
  uint8_t major_version, minor_version;
  size_t header_len, header_size;
  uint8_t *dict_and_padding = NULL;
  // check the file is really opened (at least non-NULL)
  REJECT_NULL(fp, 0);
  /* step 1: load header from file and move file pointer forward */
  // load header to get / sanitise input and move file pointer forward
  // also the total header size "header_size" is calculated
  //   by summing up the size of each data "buf_size"
  {
    header_size = 0;
    size_t buf_size;
    /* ! check magic string ! 5 ! */
    if(load_magic_string(&buf_size, fp) < 0){
      error_handlings();
      return 0;
    }
    header_size += buf_size;
    /* ! check versions ! 5 ! */
    if(load_versions(&major_version, &minor_version, &buf_size, fp) < 0){
      error_handlings();
      return 0;
    }
    header_size += buf_size;
    /* ! load HEADER_LEN ! 5 ! */
    if(load_header_len(&header_len, &buf_size, major_version, fp) < 0){
      error_handlings();
      return 0;
    }
    header_size += buf_size;
    /* ! load dictionary and padding ! 5 ! */
    if(load_dict_and_padding(&dict_and_padding, &buf_size, header_len, fp) < 0){
      error_handlings();
      return 0;
    }
    header_size += buf_size;
  }
  /* ! step 2: extract dictionary ! 10 ! */
  // extract dict from dict + padding
  // also non-crutial spaces (spaces outside quotations) are eliminated
  //   e.g., {'descr': '<i4','fortran_order': False,'shape': (3, 5, )}
  //      -> {'descr':'<i4','fortran_order':False,'shape':(3,5,)}
  char *dict = NULL;
  if(extract_dict(&dict, dict_and_padding, header_len) < 0){
    error_handlings();
    return 0;
  }
  smt_free(dict_and_padding);
  /* step 3: extract information which are needed to reconstruct array */
  /* in particular, shape, datatype, and memory order of the array */
  // shape
  {
    /* ! extract value of shape ! 10 ! */
    char *val = NULL;
    if(find_dict_value("'shape'", &val, dict) < 0){
      error_handlings();
      return 0;
    }
    if(extract_shape(ndim, shape, val) < 0){
      error_handlings();
      return 0;
    }
    smt_free(val);
  }
  // descr (data type)
  {
    /* ! extract value of descr ! 10 ! */
    char *val = NULL;
    if(find_dict_value("'descr'", &val, dict) < 0){
      error_handlings();
      return 0;
    }
    if(extract_dtype(dtype, val) < 0){
      error_handlings();
      return 0;
    }
    smt_free(val);
  }
  // fortran order (memory order)
  {
    /* ! extract value of fortran_order ! 10 ! */
    char *val = NULL;
    if(find_dict_value("'fortran_order'", &val, dict) < 0){
      error_handlings();
      return 0;
    }
    if(extract_is_fortran_order(is_fortran_order, val) < 0){
      error_handlings();
      return 0;
    }
    smt_free(val);
  }
  // clean-up buffer
  smt_free(dict);
  // detach memories from memory pool to use outside
  // user is responsible for deallocating them
  smt_detach(*shape);
  smt_detach(*dtype);
  return header_size;
}

/* writer */

static int create_descr_value(char **value, const char dtype[]){
  /*
   * create a value of a dictionary key: "descr",
   *   containing user-specified dtype
   * for now this function just copies the input
   *   after sanitising a bit
   * this function is kept here, however, for consistency
   *   and future extensions
   *
   * NOTE: user is responsible for giving a proper datatype
   * NOTE: this function allocates memory for value,
   *   which should be deallocated afterwards by the caller
   */
  REJECT_NULL(dtype, -1);
  size_t n_chars = strlen(dtype);
  // check empty string,
  //   since empty datatype is obviously strange
  if(n_chars == 0){
    ERROR("given dtype is empty\n");
    return -1;
  }
  // +1 for NUL
  *value = smt_calloc(n_chars+1, sizeof(char));
  // the last character is NUL, just in case
  //   (calloc should assign 0 already)
  (*value)[n_chars] = NUL;
  // copy dtype
  memcpy(*value, dtype, sizeof(char)*n_chars);
  return 0;
}

static int create_fortran_order_value(char **value, const bool is_fortran_order){
  /*
   * Create a value of a dictionary key: "fortran_order",
   * which is True or False with last NUL
   *
   * NOTE: this function allocates memory for value,
   *   which should be deallocated afterwards by the caller
   */
  if(is_fortran_order){
    const char string[] = {"True"};
    const size_t n_chars = strlen(string);
    // "True" + NUL
    *value = smt_calloc(n_chars+1, sizeof(char));
    memcpy(*value, string, sizeof(char)*n_chars);
    (*value)[n_chars] = NUL;
  }else{
    const char string[] = {"False"};
    const size_t n_chars = strlen(string);
    // "False" + NUL
    *value = smt_calloc(n_chars+1, sizeof(char));
    memcpy(*value, string, sizeof(char)*n_chars);
    (*value)[n_chars] = NUL;
  }
  return 0;
}

static int create_shape_value(char **value, const size_t ndim, const size_t *shape){
  /*
   * Create a value of a dictionary key: "shape"
   * Examples:
   * 0D array: ndim = 0, *dims = NULL  -> ()
   * 1D array: ndim = 1, *dims = {5}   -> (5,)
   * 2D array: ndim = 2, *dims = {5,2} -> (5,2,)
   * from left to right,
   *   from outer (less contiguous) to inner (contiguous)
   *
   * NOTE: this function allocates memory for value,
   *   which should be deallocated afterwards by the caller
   *
   * WARNING: the user of this function is responsible for
   *   allocating memory for "shape" properly
   */
  // check whether shape contains only non-negative integers
  // numpy does accpect tuples containing 0 as shape,
  //   but they are not useful in most cases
  for(size_t i = 0; i < ndim; i++){
    if(shape[i] <= 0){
      ERROR("shape[%zu] should be positive\n", i);
      return -1;
    }
  }
  // 1. count number of digits (e.g., 5: 1 digit, 15: 2 digits)
  //   of shape in each direction
  size_t *n_digits = NULL;
  n_digits = smt_calloc(ndim, sizeof(size_t));
  for(size_t i = 0; i < ndim; i++){
    // simple way to compute digits,
    //   dividing by 10 as many as possible
    size_t num = shape[i];
    n_digits[i] = 1;
    while(num /= 10){
      n_digits[i]++;
    }
  }
  // 2. compute total number of characters
  //   i.e., memory size to be allocated
  size_t n_chars = 3; // at least "(", ")", and "NUL" exist
  for(size_t i = 0; i < ndim; i++){
    // number of digits in i-th direction
    // with comma (+1)
    n_chars += n_digits[i]+1;
  }
  // 3. allocate memory and assign values
  *value = smt_calloc(n_chars, sizeof(char));
  for(size_t i = 0, offset = 1; i < ndim; i++){
    // assign size of the array in each direction to "value"
    //   after converting the integer to characters, e.g., 128 -> "128"
    char *buf = NULL;
    size_t n_digit = n_digits[i];
    // + "," and "NUL"
    buf = smt_calloc(n_digit+2, sizeof(char));
    // including ","
    {
      int retval = snprintf(buf, n_digit+2, "%zu,", shape[i]);
      if(retval != (int)(n_digit+1)){
        ERROR("snprintf failed (expected: %d, given: %d)\n", retval, (int)(n_digit+1));
        return -1;
      }
    }
    // copy result excluding NUL
    memcpy((*value)+offset, buf, sizeof(char)*(n_digit+1));
    offset += n_digit+1;
    smt_free(buf);
  }
  // first character is a parenthesis
  (*value)[        0] = '(';
  // last-1 character is a parenthesis
  (*value)[n_chars-2] = ')';
  // last character is NUL
  (*value)[n_chars-1] = NUL;
  // clean-up buffer
  smt_free(n_digits);
  return 0;
}

static int create_dict(char **dict, size_t *n_dict, const size_t ndim, const size_t *shape, const char dtype[], const bool is_fortran_order){
  /*
   * "dict" contains information which is necessary to recover the original array,
   *   1. datatype, 2. memory ordering, and 3. shape of the data
   * It is a python-like dictionary, whose structure is a pair of key and value:
   * --- -------------- -----------------------------------------------------------------
   *  1.  descr         Datatype, e.g., '<f8', 'float64'
   *  2.  fortran_order Memory order, True or False (usually False)
   *  3.  shape         A tuple having number of elements in each direction, e.g., (5,2,)
   * See corresponding function for how they are created
   * Also the number of elements of the dict is returned (to be consistent with "create_padding")
   */
  // keys, which are completely fixed
  char descr_key[]         = {"'descr'"};
  char fortran_order_key[] = {"'fortran_order'"};
  char shape_key[]         = {"'shape'"};
  // values, which depend on inputs
  char *descr_value         = NULL;
  char *fortran_order_value = NULL;
  char *shape_value         = NULL;
  /* 1. create dictionary values,
   *   in which inputs are evaluated and sanitised
   */
  /* ! create value of data type ! 4 ! */
  if(create_descr_value(&descr_value, dtype) != 0){
    ERROR("create_descr_value failed\n");
    return -1;
  }
  /* ! create value of memory order ! 4 ! */
  if(create_fortran_order_value(&fortran_order_value, is_fortran_order) != 0){
    ERROR("create_fortran_order_value failed\n");
    return -1;
  }
  /* ! create value of data sizes ! 4 ! */
  if(create_shape_value(&shape_value, ndim, shape) != 0){
    ERROR("create_shape_value failed\n");
    return -1;
  }
  /* ! 2. assign all elements (strings) which compose dict ! 20 ! */
  const size_t n_elements_dict = 13;
  char **elements = smt_calloc(n_elements_dict, sizeof(char *));
  // initial wave bracket
  elements[ 0] = "{";
  // 'descr':descr_value
  elements[ 1] = (char *)descr_key;
  elements[ 2] = ":";
  elements[ 3] = (char *)descr_value;
  elements[ 4] = ",";
  // 'fortran_order':fortran_order_value
  elements[ 5] = (char *)fortran_order_key;
  elements[ 6] = ":";
  elements[ 7] = (char *)fortran_order_value;
  elements[ 8] = ",";
  // 'shape':shape_value
  elements[ 9] = (char *)shape_key;
  elements[10] = ":";
  elements[11] = (char *)shape_value;
  // final wave bracket
  elements[12] = "}";
  // 3. check total number of characters of
  //   {'descr':VALUE,'fortran_order':VALUE,'shape':VALUE}
  //   to allocate dict
  // NOTE: n_chars_dict is the number of characters of dict
  //   INCLUDING the last NUL, while n_dict = strlen(dict),
  //   EXCLUDING the last NUL.
  //   Thus n_dict = n_chars_dict - 1
  size_t n_chars_dict = 0;
  for(size_t i = 0; i < n_elements_dict; i++){
    // check each element and sum up its number of characters
    size_t n_chars = strlen(elements[i]);
    n_chars_dict += n_chars;
  }
  // last NUL
  n_chars_dict += 1;
  // 4. allocate dict and assign above "elements"
  *dict = smt_calloc(n_chars_dict, sizeof(char));
  for(size_t i = 0, offset = 0; i < n_elements_dict; i++){
    size_t n_chars = strlen(elements[i]);
    memcpy((*dict)+offset, elements[i], sizeof(char)*n_chars);
    offset += n_chars;
  }
  (*dict)[n_chars_dict-1] = NUL;
  // clean-up all working memories
  smt_free(descr_value);
  smt_free(fortran_order_value);
  smt_free(shape_value);
  smt_free(elements);
  // as the length of "dict", use length WITHOUT NUL,
  // i.e. strlen(*dict)
  *n_dict = strlen(*dict);
  LOGGING("dict: %s\n", *dict);
  LOGGING("size: %zu\n", *n_dict);
  return 0;
}

static int create_padding(uint8_t **padding, size_t *n_padding, uint8_t *major_version, const size_t n_dict){
  /*
   * The following relation holds for the header size
   *   size_header =
   *     + sizeof(magic string)      (= 6            bytes)
   *     + sizeof(major_version)     (= 1            byte )
   *     + sizeof(minor_version)     (= 1            byte )
   *     + sizeof(header_len)        (= 2 or 4       bytes)
   *     + sizeof(char)*strlen(dict) (= strlen(dict) bytes)
   *     + sizeof(uint8_t)*n_padding (= n_padding    bytes)
   *   is divisible by 64
   * Definitely this is not generally true, and we need some paddings
   *   consisting of some (0 or more) spaces ' ' and one newline '\n',
   *   whose length (number of elements) is returned
   */
  /* ! size of each element is computed ! 5 ! */
  size_t n_magic_string = strlen(magic_string);
  size_t size_magic_string  = sizeof(char)*n_magic_string;
  size_t size_major_version = sizeof(uint8_t);
  size_t size_minor_version = sizeof(uint8_t);
  size_t size_dict          = sizeof(char)*n_dict;
  /* ! reject too large dict ! 4 ! */
  if(size_dict > UINT_MAX-64){
    ERROR("size of dictionary is huge (%zu)\n", size_dict);
    return -1;
  }
  /* ! decide major version and datatype of HEADER_LEN ! 11 ! */
  // large portion of the header is occupied by dict
  // so check dict size, and if it is larger than USHRT_MAX-64,
  //   use major_version = 2
  size_t size_header_len;
  if(size_dict > USHRT_MAX-64){
    *major_version = 2;
    size_header_len = sizeof(uint32_t);
  }else{
    *major_version = 1;
    size_header_len = sizeof(uint16_t);
  }
  /* ! compute size of all data except padding ! 6 ! */
  size_t size_except_padding =
    +size_magic_string
    +size_major_version
    +size_minor_version
    +size_header_len
    +size_dict;
  /* ! decide total size of the header, which should be 64 x N ! 8 ! */
  // increase total size by 64 until becoming larger than size_except_padding
  // NOTE: size_padding == 0 is NOT allowed since '\n' is necessary at the end
  //   thus the condition to continue loop is "<=", not "<"
  size_t size_header = 0;
  while(size_header <= size_except_padding){
    size_header += 64;
  }
  size_t size_padding = size_header-size_except_padding;
  /* ! create padding ! 6 ! */
  *n_padding = size_padding/sizeof(uint8_t);
  *padding = smt_calloc(*n_padding, sizeof(uint8_t));
  // many ' 's: 0x20
  memset(*padding, 0x20, sizeof(uint8_t)*(*n_padding-1));
  // last '\n': 0x0a
  (*padding)[*n_padding-1] = 0x0a;
  LOGGING("padding, size: %zu\n", *n_padding);
  return 0;
}

static int create_header_len(uint8_t **header_len, size_t *n_header_len, const uint8_t major_version, const size_t n_dict, const size_t n_padding){
  /*
   * In short, HEADER_LEN = n_dict + n_padding,
   * which should be written as a little-endian form
   *   (irrespective to the architecture)
   */
  /* ! reject too large dict / padding sizes ! 10 ! */
  // Here "too large" means header size (not data size)
  //   is larger than approx. 2GB, which would not happen normally
  if(n_dict >= UINT_MAX/2){
    ERROR("dictionary size is huge (%zu)\n", n_dict);
    return -1;
  }
  if(n_padding >= UINT_MAX/2){
    ERROR("padding size is huge (%zu)\n", n_padding);
    return -1;
  }
  /* ! compute header_len and store as an array of unit8_t ! 15 ! */
  if(major_version == 2){
    // major version 2, use uint32_t to store header_len
    uint32_t header_len_uint32_t = (uint32_t)n_dict+(uint32_t)n_padding;
    *n_header_len = sizeof(uint32_t)/sizeof(uint8_t);
    *header_len = smt_calloc(*n_header_len, sizeof(uint8_t));
    memcpy(*header_len, &header_len_uint32_t, *n_header_len);
    LOGGING("header_len (uint32_t): %u\n", header_len_uint32_t);
  }else{
    // major version 1, use uint16_t to store header_len
    uint16_t header_len_uint16_t = (uint16_t)n_dict+(uint16_t)n_padding;
    *n_header_len = sizeof(uint16_t)/sizeof(uint8_t);
    *header_len = smt_calloc(*n_header_len, sizeof(uint8_t));
    memcpy(*header_len, &header_len_uint16_t, *n_header_len);
    LOGGING("header_len (uint16_t): %hu\n", header_len_uint16_t);
  }
  /* ! convert endian of buffer which will be written if needed ! 6 ! */
  if(is_big_endian()){
    if(convert_endian(header_len, sizeof(*header_len)) != 0){
      ERROR("convert_endian failed\n");
      return -1;
    }
  }
  return 0;
}

size_t simple_npyio_w_header(const size_t ndim, const size_t *shape, const char dtype[], const bool is_fortran_order, FILE *fp){
  /*
   * From input information (ndim, shape, dtype, is_fortran_order),
   *   create and output "header", which is enough and sufficient information consists of a *.npy file
   * NPY file format is defined here:
   *   https://numpy.org/devdocs/reference/generated/numpy.lib.format.html#format-version-1-0
   *
   * The size of the "header", defined as "header_size",
   *   is returned, which could be useful by the user
   *
   * Header of a npy file contains these 6 data (n_datasets):
   *       -----NAME----- --TYPE-- -# OF ELEMENTS- -------SIZE-------
   * No. 0 magic_string   char     6               6 bytes
   * No. 1 major_version  uint8_t  1               1 byte
   * No. 2 minor_version  uint8_t  1               1 byte
   * No. 3 header_len     uint8_t  n_header_len    n_header_len bytes
   * No. 4 dict           char     n_dict          n_dict bytes
   * No. 5 padding        uint8_t  n_padding       n_padding bytes
   *
   * See below and corresponding function for details of each member
   */
  // check the file is really opened (at least non-NULL)
  REJECT_NULL(fp, 0);
  /* prepare all 6 datasets */
  /* ! magic_string ! */
  const size_t n_magic_string = strlen(magic_string);
  /* ! minor_version, always 0 ! 1 ! */
  const uint8_t minor_version = 0;
  /* ! dictionary (and its size) ! 6 ! */
  char *dict = NULL;
  size_t n_dict;
  if(create_dict(&dict, &n_dict, ndim, shape, dtype, is_fortran_order) != 0){
    error_handlings();
    return 0;
  }
  /* ! major_version and padding (and its size) ! 7 ! */
  uint8_t major_version;
  uint8_t *padding = NULL;
  size_t n_padding;
  if(create_padding(&padding, &n_padding, &major_version, n_dict) != 0){
    error_handlings();
    return 0;
  }
  /* ! comptue header_len ! 6 ! */
  uint8_t *header_len = NULL;
  size_t n_header_len;
  if(create_header_len(&header_len, &n_header_len, major_version, n_dict, n_padding) != 0){
    error_handlings();
    return 0;
  }
  /* dump all information to a buffer "header" and compute total size "header_size" */
  uint8_t *header = NULL;
  size_t header_size;
  size_t header_nitems;
  {
    const size_t n_datasets = 6;
    size_t *sizes   = NULL;
    size_t *offsets = NULL;
    sizes   = smt_calloc(n_datasets, sizeof(size_t));
    offsets = smt_calloc(n_datasets, sizeof(size_t));
    sizes[0] = sizeof(   char)*n_magic_string;
    sizes[1] = sizeof(uint8_t);
    sizes[2] = sizeof(uint8_t);
    sizes[3] = sizeof(uint8_t)*n_header_len;
    sizes[4] = sizeof(   char)*n_dict;
    sizes[5] = sizeof(uint8_t)*n_padding;
    // total size
    header_size = 0;
    for(uint8_t i = 0; i < n_datasets; i++){
      header_size += sizes[i];
    }
    // offsets
    offsets[0] = 0;
    for(uint8_t i = 1; i < n_datasets; i++){
      offsets[i] = offsets[i-1]+sizes[i-1];
    }
    // allocate buffer to store whole header
    header_nitems = header_size/sizeof(uint8_t);
    header = smt_calloc(header_nitems, sizeof(uint8_t));
    // write all information to a buffer "header"
    memcpy(header+offsets[0], magic_string,   sizes[0]);
    memcpy(header+offsets[1], &major_version, sizes[1]);
    memcpy(header+offsets[2], &minor_version, sizes[2]);
    memcpy(header+offsets[3], header_len,     sizes[3]);
    memcpy(header+offsets[4], dict,           sizes[4]);
    memcpy(header+offsets[5], padding,        sizes[5]);
    // clean-up buffers
    smt_free(sizes);
    smt_free(offsets);
  }
  LOGGING("header_size: %zu\n", header_size);
  /* write to the given file stream */
  {
    size_t retval = fwrite(header, sizeof(uint8_t), header_nitems, fp);
    if(retval != header_nitems){
      ERROR("fwrite failed (%zu items written, while %zu items given)\n", retval, header_nitems);
      error_handlings();
      return 0;
    }
  }
  // clean-up all buffers
  smt_free(dict);
  smt_free(padding);
  smt_free(header_len);
  smt_free(header);
  return header_size;
}

#undef LOGGING
#undef ERROR
#undef REJECT_NULL
#undef NUL


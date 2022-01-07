#if !defined(COMMON_H)
#define COMMON_H

#include <stdlib.h>

// C stadnard does not define M_PI
#if !defined(M_PI)
#define M_PI 3.1415926535897932
#endif

// memory allocation/deallocation with error handler
extern void *common_calloc(size_t count, size_t size);
extern void common_free(void *ptr);

#endif // COMMON_H

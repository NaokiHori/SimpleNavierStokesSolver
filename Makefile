CC        := mpicc
CFLAGS    := -O3 -std=c99 -flto -Wall -Wextra
DEPEND    := -MMD
LIBS      := -lfftw3 -lm
INCLUDES  := -Iinclude
SRCSDIR   := src
OBJSDIR   := obj
SRCS      := $(foreach dir, $(shell find $(SRCSDIR) -type d), $(wildcard $(dir)/*.c))
OBJS      := $(addprefix $(OBJSDIR)/, $(subst $(SRCSDIR)/,,$(SRCS:.c=.o)))
DEPS      := $(addprefix $(OBJSDIR)/, $(subst $(SRCSDIR)/,,$(SRCS:.c=.d)))
OUTPUTDIR := output
TARGET    := a.out

help:
	@echo "all     : create $(TARGET)"
	@echo "clean   : remove $(TARGET) and object files $(OBJSDIR)/*.o"
	@echo "datadel : remove files dumped by simulator $(OUTPUTDIR)/*"
	@echo "test    : (DEBUG USE) test parallel matrix transpose"
	@echo "help    : show this help message"

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(DEPEND) -o $@ $^ $(LIBS)

$(OBJSDIR)/%.o: $(SRCSDIR)/%.c
	@if [ ! -e `dirname $@` ]; then \
		mkdir -p `dirname $@`; \
	fi
	$(CC) $(CFLAGS) $(DEPEND) $(INCLUDES) -c $< -o $@

test:
	$(CC) -DDEBUG_TEST $(CFLAGS) $(INCLUDES) src/common.c src/parallel/others.c src/parallel/transpose.c -o a.out

clean:
	$(RM) -r $(OBJSDIR) $(TARGET)

datadel:
	$(RM) -r $(OUTPUTDIR)

output:
	@if [ ! -e $(OUTPUTDIR)/save ]; then \
		mkdir -p $(OUTPUTDIR)/save; \
	fi
	@if [ ! -e $(OUTPUTDIR)/log ]; then \
		mkdir -p $(OUTPUTDIR)/log; \
	fi
	@if [ ! -e $(OUTPUTDIR)/stat ]; then \
		mkdir -p $(OUTPUTDIR)/stat; \
	fi

-include $(DEPS)

.PHONY : help all test clean datadel output


CFLAGS =

ifneq (, $(shell which dcc))
CC	?= dcc
else
CC	?= clang
CFLAGS += -Wall
endif

EXERCISES	  += cursed

SRC = cursed.c main.c
INCLUDES = cursed.h commands.h escape.h

# if you add extra .c files, add them here
SRC +=

# if you add extra .h files, add them here
INCLUDES +=


cursed:	$(SRC) $(INCLUDES)
	$(CC) $(CFLAGS) $(SRC) -o $@

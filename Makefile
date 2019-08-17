# Unix makefile for Git (shamelessly ripped off from Glulxe's makefile)

# -----------------------------------------------------------------
# Step 1: pick a Glk library.

# Note: when using xglk, do NOT define USE_MMAP in step 2, below.

#GLK = cheapglk
#GLK = glkterm
#GLK = xglk
GLK = emglken

GLKINCLUDEDIR = ../$(GLK)
GLKLIBDIR = ../$(GLK)
GLKMAKEFILE = Make.$(GLK)

# -----------------------------------------------------------------
# Step 2: pick a C compiler.

# Generic C compiler
#CC = cc -O2
#OPTIONS = 

# Emscripten
CC = emcc \
	-O3

LINK_OPTS = \
	--js-library $(GLKINCLUDEDIR)/library.js \
	-s EMTERPRETIFY=1 \
	-s EMTERPRETIFY_ASYNC=1 \
	-s EMTERPRETIFY_FILE='"git-core.js.bin"' \
	-s EMTERPRETIFY_WHITELIST='"@whitelist.json"' \
	-s EXPORTED_FUNCTIONS='["_emgiten"]' \
	-s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall"]' \
	-s MODULARIZE=1 \
	-s WASM=0

#--closure 1 
#--separate-asm 

OPTIONS = -DUSE_OWN_POWF

# Best settings for GCC 2.95. This generates faster code than
# GCC 3, so you should use this setup if possible.
#CC = gcc -Wall -O3
#OPTIONS = -DUSE_DIRECT_THREADING -DUSE_MMAP -DUSE_INLINE

# Best settings for GCC 3. The optimiser in this version of GCC
# is somewhat broken, so we can't use USE_DIRECT_THREADING.
#CC = gcc -Wall -O3
#OPTIONS = -DUSE_MMAP -DUSE_INLINE

# Mac OS X (PowerPC) settings.
#CC = gcc2 -Wall -O3 -no-cpp-precomp
#OPTIONS = -DUSE_DIRECT_THREADING -DUSE_BIG_ENDIAN_UNALIGNED -DUSE_MMAP -DUSE_INLINE

# -----------------------------------------------------------------
# Step 3: decide where you want to install the compiled executable.

INSTALLDIR = /usr/local/bin

# -----------------------------------------------------------------
# You shouldn't have to change anything from here on down.

MAJOR = 1
MINOR = 3
PATCH = 5

include $(GLKINCLUDEDIR)/$(GLKMAKEFILE)

CFLAGS = $(OPTIONS) -I$(GLKINCLUDEDIR)

LIBS = -L$(GLKLIBDIR) $(GLKLIB) $(LINKLIBS)

HEADERS = version.h git.h config.h compiler.h \
	memory.h opcodes.h labels.inc

SOURCE = compiler.c gestalt.c git.c \
	glkop.c heap.c memory.c opcodes.c \
	operands.c peephole.c savefile.c saveundo.c \
	search.c terp.c accel.c \
	emgiten.c 

OBJS = git.o memory.o compiler.o opcodes.o operands.o \
	peephole.o terp.o glkop.o search.o \
	savefile.o saveundo.o gestalt.o heap.o accel.o \
	emgiten.o 

TESTS = test/test.sh \
	test/Alabaster.gblorb test/Alabaster.walk test/Alabaster.golden

all: git-core.js

git-core.js: $(OBJS) $(GLKINCLUDEDIR)/Make.$(GLK) $(GLKINCLUDEDIR)/libemglken.a $(GLKINCLUDEDIR)/library.js
	$(CC) $(OPTIONS) $(LINK_OPTS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f *~ *.o git-core* test/*.tmp

$(OBJS): $(HEADERS)

version.h: Makefile
	echo "// Automatically generated file -- do not edit!" > version.h
	echo "#define GIT_MAJOR" $(MAJOR) >> version.h
	echo "#define GIT_MINOR" $(MINOR) >> version.h
	echo "#define GIT_PATCH" $(PATCH) >> version.h
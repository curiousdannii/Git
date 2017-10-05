// $Id: git_unix.c,v 1.5 2004/01/25 18:44:51 iain Exp $

// unixstrt.c: Unix-specific code for Glulxe.
// Designed by Andrew Plotkin <erkyrath@eblong.com>
// http://www.eblong.com/zarf/glulx/index.html

#include <string.h>
#include "git.h"
#include <glk.h>
#include "emglken.h"

#ifdef USE_MMAP
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <errno.h>
#endif

#define CACHE_SIZE (256 * 1024L)
#define UNDO_SIZE (2 * 1024 * 1024L)

void fatalError (const char * s)
{
    char buffer[256];
    strlcpy( buffer, "*** fatal error: ", 256 );
    strlcat( buffer, s, 256 );
    strlcat( buffer, " ***", 256 );
    glem_fatal_error( buffer );
    exit (1);
}
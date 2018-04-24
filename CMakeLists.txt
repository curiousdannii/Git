# CMake definition for Git

cmake_minimum_required( VERSION 3.9 )

add_executable( git-core emgiten.c )
target_sources( git-core PRIVATE accel.c compiler.c gestalt.c heap.c git.c )
target_sources( git-core PRIVATE glkop.c memory.c opcodes.c operands.c )
target_sources( git-core PRIVATE peephole.c savefile.c saveundo.c search.c terp.c )

emglken_setup( git-core )
add_definitions( -DUSE_OWN_POWF )
em_setting( git-core "EXTRA_EXPORTED_RUNTIME_METHODS" "'[\"ccall\"]'" )
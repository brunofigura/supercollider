# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/2.8.8/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/2.8.8/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/local/Cellar/cmake/2.8.8/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch"

# Include any dependencies generated for this target.
include CMakeFiles/Dstoch.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Dstoch.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Dstoch.dir/flags.make

CMakeFiles/Dstoch.dir/Dstoch.cpp.o: CMakeFiles/Dstoch.dir/flags.make
CMakeFiles/Dstoch.dir/Dstoch.cpp.o: Dstoch.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch/CMakeFiles" $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/Dstoch.dir/Dstoch.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/Dstoch.dir/Dstoch.cpp.o -c "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch/Dstoch.cpp"

CMakeFiles/Dstoch.dir/Dstoch.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Dstoch.dir/Dstoch.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch/Dstoch.cpp" > CMakeFiles/Dstoch.dir/Dstoch.cpp.i

CMakeFiles/Dstoch.dir/Dstoch.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Dstoch.dir/Dstoch.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch/Dstoch.cpp" -o CMakeFiles/Dstoch.dir/Dstoch.cpp.s

CMakeFiles/Dstoch.dir/Dstoch.cpp.o.requires:
.PHONY : CMakeFiles/Dstoch.dir/Dstoch.cpp.o.requires

CMakeFiles/Dstoch.dir/Dstoch.cpp.o.provides: CMakeFiles/Dstoch.dir/Dstoch.cpp.o.requires
	$(MAKE) -f CMakeFiles/Dstoch.dir/build.make CMakeFiles/Dstoch.dir/Dstoch.cpp.o.provides.build
.PHONY : CMakeFiles/Dstoch.dir/Dstoch.cpp.o.provides

CMakeFiles/Dstoch.dir/Dstoch.cpp.o.provides.build: CMakeFiles/Dstoch.dir/Dstoch.cpp.o

# Object files for target Dstoch
Dstoch_OBJECTS = \
"CMakeFiles/Dstoch.dir/Dstoch.cpp.o"

# External object files for target Dstoch
Dstoch_EXTERNAL_OBJECTS =

Dstoch.scx: CMakeFiles/Dstoch.dir/Dstoch.cpp.o
Dstoch.scx: CMakeFiles/Dstoch.dir/build.make
Dstoch.scx: CMakeFiles/Dstoch.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX shared module Dstoch.scx"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Dstoch.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Dstoch.dir/build: Dstoch.scx
.PHONY : CMakeFiles/Dstoch.dir/build

CMakeFiles/Dstoch.dir/requires: CMakeFiles/Dstoch.dir/Dstoch.cpp.o.requires
.PHONY : CMakeFiles/Dstoch.dir/requires

CMakeFiles/Dstoch.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Dstoch.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Dstoch.dir/clean

CMakeFiles/Dstoch.dir/depend:
	cd "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch" "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch" "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch" "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch" "/Users/MarinusKlaassen/Library/Application Support/SuperCollider/Extensions/AC-Mlib/demand/Dstoch/CMakeFiles/Dstoch.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/Dstoch.dir/depend


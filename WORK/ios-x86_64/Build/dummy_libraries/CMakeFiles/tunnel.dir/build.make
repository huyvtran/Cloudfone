# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.4

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


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
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.4.3/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.4.3/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries

# Include any dependencies generated for this target.
include CMakeFiles/tunnel.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/tunnel.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/tunnel.dir/flags.make

CMakeFiles/tunnel.dir/libtunnel.c.o: CMakeFiles/tunnel.dir/flags.make
CMakeFiles/tunnel.dir/libtunnel.c.o: libtunnel.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/tunnel.dir/libtunnel.c.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/tunnel.dir/libtunnel.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries/libtunnel.c

CMakeFiles/tunnel.dir/libtunnel.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/tunnel.dir/libtunnel.c.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries/libtunnel.c > CMakeFiles/tunnel.dir/libtunnel.c.i

CMakeFiles/tunnel.dir/libtunnel.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/tunnel.dir/libtunnel.c.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries/libtunnel.c -o CMakeFiles/tunnel.dir/libtunnel.c.s

CMakeFiles/tunnel.dir/libtunnel.c.o.requires:

.PHONY : CMakeFiles/tunnel.dir/libtunnel.c.o.requires

CMakeFiles/tunnel.dir/libtunnel.c.o.provides: CMakeFiles/tunnel.dir/libtunnel.c.o.requires
	$(MAKE) -f CMakeFiles/tunnel.dir/build.make CMakeFiles/tunnel.dir/libtunnel.c.o.provides.build
.PHONY : CMakeFiles/tunnel.dir/libtunnel.c.o.provides

CMakeFiles/tunnel.dir/libtunnel.c.o.provides.build: CMakeFiles/tunnel.dir/libtunnel.c.o


# Object files for target tunnel
tunnel_OBJECTS = \
"CMakeFiles/tunnel.dir/libtunnel.c.o"

# External object files for target tunnel
tunnel_EXTERNAL_OBJECTS =

libtunnel.a: CMakeFiles/tunnel.dir/libtunnel.c.o
libtunnel.a: CMakeFiles/tunnel.dir/build.make
libtunnel.a: CMakeFiles/tunnel.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library libtunnel.a"
	$(CMAKE_COMMAND) -P CMakeFiles/tunnel.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/tunnel.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/tunnel.dir/build: libtunnel.a

.PHONY : CMakeFiles/tunnel.dir/build

CMakeFiles/tunnel.dir/requires: CMakeFiles/tunnel.dir/libtunnel.c.o.requires

.PHONY : CMakeFiles/tunnel.dir/requires

CMakeFiles/tunnel.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/tunnel.dir/cmake_clean.cmake
.PHONY : CMakeFiles/tunnel.dir/clean

CMakeFiles/tunnel.dir/depend:
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/dummy_libraries/CMakeFiles/tunnel.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/tunnel.dir/depend


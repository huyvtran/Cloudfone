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
CMAKE_BINARY_DIR = /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries

# Include any dependencies generated for this target.
include CMakeFiles/bcg729.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/bcg729.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/bcg729.dir/flags.make

CMakeFiles/bcg729.dir/libbcg729.c.o: CMakeFiles/bcg729.dir/flags.make
CMakeFiles/bcg729.dir/libbcg729.c.o: libbcg729.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/bcg729.dir/libbcg729.c.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=armv7-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/bcg729.dir/libbcg729.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries/libbcg729.c

CMakeFiles/bcg729.dir/libbcg729.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bcg729.dir/libbcg729.c.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=armv7-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries/libbcg729.c > CMakeFiles/bcg729.dir/libbcg729.c.i

CMakeFiles/bcg729.dir/libbcg729.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bcg729.dir/libbcg729.c.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=armv7-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries/libbcg729.c -o CMakeFiles/bcg729.dir/libbcg729.c.s

CMakeFiles/bcg729.dir/libbcg729.c.o.requires:

.PHONY : CMakeFiles/bcg729.dir/libbcg729.c.o.requires

CMakeFiles/bcg729.dir/libbcg729.c.o.provides: CMakeFiles/bcg729.dir/libbcg729.c.o.requires
	$(MAKE) -f CMakeFiles/bcg729.dir/build.make CMakeFiles/bcg729.dir/libbcg729.c.o.provides.build
.PHONY : CMakeFiles/bcg729.dir/libbcg729.c.o.provides

CMakeFiles/bcg729.dir/libbcg729.c.o.provides.build: CMakeFiles/bcg729.dir/libbcg729.c.o


# Object files for target bcg729
bcg729_OBJECTS = \
"CMakeFiles/bcg729.dir/libbcg729.c.o"

# External object files for target bcg729
bcg729_EXTERNAL_OBJECTS =

libbcg729.a: CMakeFiles/bcg729.dir/libbcg729.c.o
libbcg729.a: CMakeFiles/bcg729.dir/build.make
libbcg729.a: CMakeFiles/bcg729.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library libbcg729.a"
	$(CMAKE_COMMAND) -P CMakeFiles/bcg729.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/bcg729.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/bcg729.dir/build: libbcg729.a

.PHONY : CMakeFiles/bcg729.dir/build

CMakeFiles/bcg729.dir/requires: CMakeFiles/bcg729.dir/libbcg729.c.o.requires

.PHONY : CMakeFiles/bcg729.dir/requires

CMakeFiles/bcg729.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/bcg729.dir/cmake_clean.cmake
.PHONY : CMakeFiles/bcg729.dir/clean

CMakeFiles/bcg729.dir/depend:
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-armv7/Build/dummy_libraries/CMakeFiles/bcg729.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/bcg729.dir/depend

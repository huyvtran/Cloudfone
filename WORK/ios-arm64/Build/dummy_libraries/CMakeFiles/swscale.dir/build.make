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
CMAKE_BINARY_DIR = /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries

# Include any dependencies generated for this target.
include CMakeFiles/swscale.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/swscale.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/swscale.dir/flags.make

CMakeFiles/swscale.dir/libswscale.c.o: CMakeFiles/swscale.dir/flags.make
CMakeFiles/swscale.dir/libswscale.c.o: libswscale.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/swscale.dir/libswscale.c.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=arm64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/swscale.dir/libswscale.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries/libswscale.c

CMakeFiles/swscale.dir/libswscale.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/swscale.dir/libswscale.c.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=arm64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries/libswscale.c > CMakeFiles/swscale.dir/libswscale.c.i

CMakeFiles/swscale.dir/libswscale.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/swscale.dir/libswscale.c.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=arm64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries/libswscale.c -o CMakeFiles/swscale.dir/libswscale.c.s

CMakeFiles/swscale.dir/libswscale.c.o.requires:

.PHONY : CMakeFiles/swscale.dir/libswscale.c.o.requires

CMakeFiles/swscale.dir/libswscale.c.o.provides: CMakeFiles/swscale.dir/libswscale.c.o.requires
	$(MAKE) -f CMakeFiles/swscale.dir/build.make CMakeFiles/swscale.dir/libswscale.c.o.provides.build
.PHONY : CMakeFiles/swscale.dir/libswscale.c.o.provides

CMakeFiles/swscale.dir/libswscale.c.o.provides.build: CMakeFiles/swscale.dir/libswscale.c.o


# Object files for target swscale
swscale_OBJECTS = \
"CMakeFiles/swscale.dir/libswscale.c.o"

# External object files for target swscale
swscale_EXTERNAL_OBJECTS =

libswscale.a: CMakeFiles/swscale.dir/libswscale.c.o
libswscale.a: CMakeFiles/swscale.dir/build.make
libswscale.a: CMakeFiles/swscale.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library libswscale.a"
	$(CMAKE_COMMAND) -P CMakeFiles/swscale.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/swscale.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/swscale.dir/build: libswscale.a

.PHONY : CMakeFiles/swscale.dir/build

CMakeFiles/swscale.dir/requires: CMakeFiles/swscale.dir/libswscale.c.o.requires

.PHONY : CMakeFiles/swscale.dir/requires

CMakeFiles/swscale.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/swscale.dir/cmake_clean.cmake
.PHONY : CMakeFiles/swscale.dir/clean

CMakeFiles/swscale.dir/depend:
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/submodules/cmake-builder/cmake/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-arm64/Build/dummy_libraries/CMakeFiles/swscale.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/swscale.dir/depend


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
CMAKE_SOURCE_DIR = /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox

# Include any dependencies generated for this target.
include src/CMakeFiles/bctoolbox-static.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/bctoolbox-static.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/bctoolbox-static.dir/flags.make

src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/list.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -o CMakeFiles/bctoolbox-static.dir/containers/list.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/list.c

src/CMakeFiles/bctoolbox-static.dir/containers/list.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bctoolbox-static.dir/containers/list.c.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/list.c > CMakeFiles/bctoolbox-static.dir/containers/list.c.i

src/CMakeFiles/bctoolbox-static.dir/containers/list.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bctoolbox-static.dir/containers/list.c.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/list.c -o CMakeFiles/bctoolbox-static.dir/containers/list.c.s

src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.requires

src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.provides: src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.provides

src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o


src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/logging/logging.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -o CMakeFiles/bctoolbox-static.dir/logging/logging.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/logging/logging.c

src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bctoolbox-static.dir/logging/logging.c.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/logging/logging.c > CMakeFiles/bctoolbox-static.dir/logging/logging.c.i

src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bctoolbox-static.dir/logging/logging.c.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/logging/logging.c -o CMakeFiles/bctoolbox-static.dir/logging/logging.c.s

src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.requires

src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.provides: src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.provides

src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o


src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/port.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -o CMakeFiles/bctoolbox-static.dir/utils/port.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/port.c

src/CMakeFiles/bctoolbox-static.dir/utils/port.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bctoolbox-static.dir/utils/port.c.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/port.c > CMakeFiles/bctoolbox-static.dir/utils/port.c.i

src/CMakeFiles/bctoolbox-static.dir/utils/port.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bctoolbox-static.dir/utils/port.c.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/port.c -o CMakeFiles/bctoolbox-static.dir/utils/port.c.s

src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.requires

src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.provides: src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.provides

src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o


src/CMakeFiles/bctoolbox-static.dir/vfs.c.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/vfs.c.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/vfs.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object src/CMakeFiles/bctoolbox-static.dir/vfs.c.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -o CMakeFiles/bctoolbox-static.dir/vfs.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/vfs.c

src/CMakeFiles/bctoolbox-static.dir/vfs.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bctoolbox-static.dir/vfs.c.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/vfs.c > CMakeFiles/bctoolbox-static.dir/vfs.c.i

src/CMakeFiles/bctoolbox-static.dir/vfs.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bctoolbox-static.dir/vfs.c.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/vfs.c -o CMakeFiles/bctoolbox-static.dir/vfs.c.s

src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.requires

src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.provides: src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.provides

src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/vfs.c.o


src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/crypto/mbedtls.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -o CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o   -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/crypto/mbedtls.c

src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/crypto/mbedtls.c > CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.i

src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang  --target=x86_64-apple-darwin $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -Werror -Wdeclaration-after-statement -Wstrict-prototypes -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/crypto/mbedtls.c -o CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.s

src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.requires

src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.provides: src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.provides

src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o


src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/map.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  --target=x86_64-apple-darwin  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -o CMakeFiles/bctoolbox-static.dir/containers/map.cc.o -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/map.cc

src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bctoolbox-static.dir/containers/map.cc.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  --target=x86_64-apple-darwin $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/map.cc > CMakeFiles/bctoolbox-static.dir/containers/map.cc.i

src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bctoolbox-static.dir/containers/map.cc.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  --target=x86_64-apple-darwin $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/containers/map.cc -o CMakeFiles/bctoolbox-static.dir/containers/map.cc.s

src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.requires

src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.provides: src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.provides

src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o


src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o: src/CMakeFiles/bctoolbox-static.dir/flags.make
src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o: /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/exception.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  --target=x86_64-apple-darwin  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -o CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o -c /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/exception.cc

src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/bctoolbox-static.dir/utils/exception.cc.i"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  --target=x86_64-apple-darwin $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -E /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/exception.cc > CMakeFiles/bctoolbox-static.dir/utils/exception.cc.i

src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/bctoolbox-static.dir/utils/exception.cc.s"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  --target=x86_64-apple-darwin $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS)  -Wall -Wuninitialized -Wno-error=unknown-warning-option -Qunused-arguments -Wno-tautological-compare -Wno-builtin-requires-header -Wno-unused-function -Wno-gnu-designator -Wno-array-bounds -Werror -Wextra -Wno-unused-parameter -Wno-error=unknown-pragmas -Wno-missing-field-initializers -fno-strict-aliasing -S /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src/utils/exception.cc -o CMakeFiles/bctoolbox-static.dir/utils/exception.cc.s

src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.requires:

.PHONY : src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.requires

src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.provides: src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.requires
	$(MAKE) -f src/CMakeFiles/bctoolbox-static.dir/build.make src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.provides.build
.PHONY : src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.provides

src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.provides.build: src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o


# Object files for target bctoolbox-static
bctoolbox__static_OBJECTS = \
"CMakeFiles/bctoolbox-static.dir/containers/list.c.o" \
"CMakeFiles/bctoolbox-static.dir/logging/logging.c.o" \
"CMakeFiles/bctoolbox-static.dir/utils/port.c.o" \
"CMakeFiles/bctoolbox-static.dir/vfs.c.o" \
"CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o" \
"CMakeFiles/bctoolbox-static.dir/containers/map.cc.o" \
"CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o"

# External object files for target bctoolbox-static
bctoolbox__static_EXTERNAL_OBJECTS =

src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/vfs.c.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/build.make
src/libbctoolbox.a: src/CMakeFiles/bctoolbox-static.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Linking CXX static library libbctoolbox.a"
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && $(CMAKE_COMMAND) -P CMakeFiles/bctoolbox-static.dir/cmake_clean_target.cmake
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/bctoolbox-static.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/bctoolbox-static.dir/build: src/libbctoolbox.a

.PHONY : src/CMakeFiles/bctoolbox-static.dir/build

src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/containers/list.c.o.requires
src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/logging/logging.c.o.requires
src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/utils/port.c.o.requires
src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/vfs.c.o.requires
src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/crypto/mbedtls.c.o.requires
src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/containers/map.cc.o.requires
src/CMakeFiles/bctoolbox-static.dir/requires: src/CMakeFiles/bctoolbox-static.dir/utils/exception.cc.o.requires

.PHONY : src/CMakeFiles/bctoolbox-static.dir/requires

src/CMakeFiles/bctoolbox-static.dir/clean:
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src && $(CMAKE_COMMAND) -P CMakeFiles/bctoolbox-static.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/bctoolbox-static.dir/clean

src/CMakeFiles/bctoolbox-static.dir/depend:
	cd /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox /Users/eicaptain/Desktop/linphone-iphone/submodules/bctoolbox/src /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src /Users/eicaptain/Desktop/linphone-iphone/WORK/ios-x86_64/Build/bctoolbox/src/CMakeFiles/bctoolbox-static.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/bctoolbox-static.dir/depend


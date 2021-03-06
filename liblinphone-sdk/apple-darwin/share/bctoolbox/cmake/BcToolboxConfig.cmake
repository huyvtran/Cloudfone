############################################################################
# BcToolboxConfig.cmake
# Copyright (C) 2015  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################
#
# Config file for the bctoolbox package.
# Some components can be asked for: core, tester.
#
# It defines the following variables:
#
#  BCTOOLBOX_FOUND - system has bctoolbox
#  BCTOOLBOX_INCLUDE_DIRS - the bctoolbox include directory
#  BCTOOLBOX_LIBRARIES - The libraries needed to use bctoolbox
#  BCTOOLBOX_LDFLAGS - The linking flags needed to use bctoolbox
#  BCTOOLBOX_${comp}_FOUND - system has bctoolbox "comp" component
#  BCTOOLBOX_${comp}_INCLUDE_DIRS - the bctoolbox "comp" component include directory
#  BCTOOLBOX_${comp}_LIBRARIES - The libraries needed to use bctoolbox "comp" component

if(NOT LINPHONE_BUILDER_GROUP_EXTERNAL_SOURCE_PATH_BUILDERS)
	include("${CMAKE_CURRENT_LIST_DIR}/BcToolboxTargets.cmake")
endif()

list(APPEND BcToolbox_FIND_COMPONENTS core)
list(REMOVE_DUPLICATES BcToolbox_FIND_COMPONENTS)
set(BcToolbox_FIND_REQUIRED_core TRUE)

get_filename_component(BCTOOLBOX_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
if(LINPHONE_BUILDER_GROUP_EXTERNAL_SOURCE_PATH_BUILDERS)
	set(BCTOOLBOX_INCLUDE_DIRS "${EP_bctoolbox_INCLUDE_DIR}")
else()
	set(BCTOOLBOX_INCLUDE_DIRS "${BCTOOLBOX_CMAKE_DIR}/../../../include")
endif()

set(BCTOOLBOX_LDFLAGS "-framework Foundation -framework CoreFoundation -framework CFNetwork -framework UIKit")
set(BCTOOLBOX_LIBRARIES )
foreach(comp ${BcToolbox_FIND_COMPONENTS})
	string(TOUPPER ${comp} uppercomp)
	if(comp STREQUAL "core")
		set(targetname "bctoolbox")
	else()
		set(targetname "bctoolbox-${comp}")
	endif()
	if(NOT NO)
		set(targetname "${targetname}-static")
	endif()
	if(TARGET ${targetname})
		set(BCTOOLBOX_${uppercomp}_INCLUDE_DIRS "${BCTOOLBOX_INCLUDE_DIRS}")
		set(BCTOOLBOX_${uppercomp}_LIBRARIES ${targetname})
		list(APPEND BCTOOLBOX_LIBRARIES ${targetname})
		set(BCTOOLBOX_${uppercomp}_FOUND 1)
		if(comp STREQUAL "core")
			set(BCTOOLBOX_FOUND 1)
		endif()
	elseif(BcToolbox_FIND_REQUIRED_${comp})
		message(FATAL_ERROR "Required bctoolbox component \"${comp}\" cannot be found")
	endif()
endforeach()

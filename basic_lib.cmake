# Simple CMakeLists.txt file for basic Libraries. Builds libraris from all 
# of the files in the ./src and ./include directories. Binary will be installed
# to /usr/local/lib. Headers will be installed to /usr/local/include/${lib_name}
######################################
# User settable flags

######################################
# Define platform specific paths
if (UNIX)
  #nothing to set for UNIX right now
endif (UNIX)
if (WIN32)
  #set(BOOST_ROOT "C:/Users/greensea/depends/boost_1_55_0" CACHE STRING "Boost root directory")
  #set(BOOST_LIBRARYDIR "C:/Users/greensea/depends/boost_1_55_0/stage/lib/" CACHE STRING "Boost library directory")
  set(BOOST_ROOT "C:/Boost" CACHE STRING "Boost root directory")
  #set(BOOST_LIBRARYDIR "C:/Users/greensea/depends/boost_1_55_0/stage/lib/" CACHE STRING "Boost library directory")
endif (WIN32)

######################################
# Things to be included for CMake
set(CMAKE_MODULE_PATH ${cmake_dir}/cmake-modules)

######################################
## Define the project
project(${project_name})

######################################
# Versioning
set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)
set(${project_name}_VERSION_MAJOR ${VERSION_MAJOR})
set(${project_name}_VERSION_MINOR ${VERSION_MINOR})
set(${project_name}_VERSION_PATCH ${VERSION_PATCH})
set(PROJECT_VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

######################################
#Configure a header file to pass some of the CMake settings to the source code
configure_file("${cmake_dir}/config.h.in" 
                "${PROJECT_SOURCE_DIR}/src/config.h")

######################################
## Build flags
#If a build type hasn't been defined, use RelWithDebInfo
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)

#Set flags for different build modes
if(CMAKE_COMPILER_IS_GNUCC)
  set(CMAKE_CXX_FLAGS "-Wall -Wextra -pedantic -Wno-long-long -std=c++11")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g")
  set(CMAKE_CXX_FLAGS_RELEASE "-O3")
  set(CMAKE_CXX_FLAGS_DEBUG  "-O0 -g")  #todo: -Og? instead of 00?
  MESSAGE(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
endif(CMAKE_COMPILER_IS_GNUCC)

######################################
## Find 3rd party sources/libs
#Boost
find_package( Boost 1.55 COMPONENTS thread system program_options atomic filesystem REQUIRED )
IF (NOT Boost_FOUND)
  message(FATAL_ERROR "Could not find boost")
ENDIF()

######################################
## Source files
#Grab all the files in the src/ directory
file(GLOB headers include/[a-z]*.h)
file(GLOB sources src/[a-z]*.cpp)

######################
## Include paths
#Local header locations
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

#Boost headers
include_directories( ${Boost_INCLUDE_DIR} )

######################################
## Define Binaries
#Define the library we're building
add_library(${lib_name} SHARED ${sources} ${headers})

#################################
## Linking
set(libs ${libs} ${Boost_LIBRARIES})
target_link_libraries(${lib_name} ${libs})

#################################
## Installation
#Library installation
set(_library_dir lib)
set(LIB_INSTALL_DIR ${_library_dir}${LIB_SUFFIX})
install(TARGETS ${lib_name}
	      LIBRARY DESTINATION ${LIB_INSTALL_DIR}
	      ARCHIVE DESTINATION lib${LIB_SUFFIX})
#Header installation
set(INCLUDE_INSTALL_DIR include/${lib_name})
install(FILES ${headers} DESTINATION ${INCLUDE_INSTALL_DIR})


######################################
# .deb package generation
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libsno") # todo, automate
include(${cmake_dir}/cpack_config.cmake)

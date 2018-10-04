# Simple CMakeLists.txt file for basic Libraries. Builds libraris from all 
# of the files in the ./src and ./include directories. Binary will be installed
# to /usr/local/lib. Headers will be installed to /usr/local/include/${project_name}
#
# Before including this file the following variables should be defined
#  project_name    The name of the project
#  lib_name        The name of the library to create

######################################
# User settable flags
# enable with cmake -DTESTS=ON
option(TESTS "Build all tests" OFF)

######################################
# Define platform specific paths
if (UNIX)
  #nothing to set for UNIX right now
  set(cmake_dir "/usr/local/share/cmake/so_cmake")
endif (UNIX)
if (WIN32)
  #If things ever go to windows, define path to cmake stuff
endif (WIN32)
include(${cmake_dir}/paths-config.cmake)

######################################
# Things to be included for CMake
set(CMAKE_MODULE_PATH ${cmake_dir}/cmake-modules)

######################################
## Define the project
set(lib_name lib${project_name})
project(${lib_name})

######################################
# Versioning
set(version_header_dir ${project_name})
include(${cmake_dir}/setversion.cmake)

######################################
#Configure a header file to pass some of the CMake settings to the source code
configure_file("${cmake_dir}/config.h.in" 
                "${PROJECT_SOURCE_DIR}/include/config.h")

######################################
## Find 3rd party sources/libs
#Boost
find_package( Boost 1.62 COMPONENTS thread system program_options atomic filesystem REQUIRED )
IF (NOT Boost_FOUND)
  message(FATAL_ERROR "Could not find boost")
ENDIF()

######################################
## Source files
file(GLOB public_headers ${project_name}/[a-zA-Z]*.h)
file(GLOB headers include/[a-zA-Z]*.h)
file(GLOB sources src/[a-zA-Z]*.cpp)

######################################
## Include paths
# Local header locations
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# Boost headers
include_directories( ${Boost_INCLUDE_DIR} )

######################################
## Define Binaries
#Define the library we're building
add_library(${project_name} SHARED ${sources} ${headers} ${public_headers})

######################################
## Build flags
set(CMAKE_EXPORT_COMPILE_COMMANDS true)
include(${cmake_dir}/cxxflags-config.cmake)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,-z,defs")
#################################
## Linking
set(libs ${libs} ${Boost_LIBRARIES})
target_link_libraries(${project_name} ${libs})

#################################
## Installation
#Library installation
set(library_install_dir lib)
set(include_install_dir include/${project_name})
set(install_destinations
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION ${library_install_dir}
    ARCHIVE DESTINATION ${library_install_dir})

#Header 
install(TARGETS ${project_name} COMPONENT lib ${install_destinations})
install(FILES ${public_headers} DESTINATION ${include_install_dir})

######################################
# .deb package generation
set(deps ${deps} "libboost-thread1.62.0, libboost-system1.62.0, libboost-program-options1.62.0, libboost-atomic1.62.0, libboost-filesystem1.62.0")
include(${cmake_dir}/cpack-config.cmake)

######################################
# Unit Testing
if (UNIX AND TESTS)
  #Set files needed for testing
  set(TEST_SOURCES ${TEST_SOURCES} ${sources})
  set(TEST_HEADERS ${TEST_HEADERS} ${headers})
  set(TEST_LIBS ${TEST_LIBS} ${libs})
  include(${cmake_dir}/gtest-config.cmake)
endif(UNIX AND TESTS)

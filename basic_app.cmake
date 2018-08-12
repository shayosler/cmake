# Simple CMakeLists.txt file for basic applications. Builds executable from all 
# of the files in the ./src directory

######################################
# User settable flags
# enable with cmake -DTESTS=ON
option(TESTS "Build all tests" OFF)

######################################
# Define platform specific paths
if (UNIX)
  #nothing to set for UNIX right now
  set(cmake_dir "/home/shay/development/cmake")
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
## Find 3rd party sources/libs
#Boost
find_package( Boost 1.62 COMPONENTS thread system program_options atomic filesystem REQUIRED )
IF (NOT Boost_FOUND)
  message(FATAL_ERROR "Could not find boost")
ENDIF()

######################################
## Source files in our project
#Grab all the files in the src/ directory
file(GLOB_RECURSE headers src/[a-z]*.h)
file(GLOB_RECURSE sources src/[a-z]*.cpp)

######################################
## Include paths
#Local Header locations
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

#Boost headers
include_directories( ${Boost_INCLUDE_DIR} )

######################################
## Define Binaries
#Define the executable we're building
add_executable(${project_name} ${sources} ${headers})

######################################
## Build flags
set(CMAKE_EXPORT_COMPILE_COMMANDS true)
include(${cmake_dir}/cxxflags-config.cmake)

######################################
## Linking
# Boost
set(libs ${libs} ${Boost_LIBRARIES})

# libsno
set(libs ${libs} sno)

# Link
target_link_libraries(${project_name} ${libs})

######################################
# Define installation of the binary
install(TARGETS ${project_name} DESTINATION bin)

######################################
# .deb package generation
SET(deps ${deps} "libsno") # todo, automate
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

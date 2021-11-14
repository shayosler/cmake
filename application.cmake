cmake_minimum_required(VERSION 3.8) #we need 3.8 for CPack stuff

######################################
# User settable flags
# Flag to control building unit tests
option(TESTS "Build unit tests" OFF)
# Flag to statically link OPENSEA libraries
option(SNO_STATIC "Statically link in opensea libraries" OFF)

######################################
# Define platform specific paths
set(cmake_dir "/usr/local/share/cmake/so_cmake")

######################################
# Things to be included for CMake
set(license ${cmake_dir}/gpl-3.0.txt)
set(CMAKE_MODULE_PATH ${cmake_dir}/cmake-modules)
include(${cmake_dir}/doc-config.cmake)

######################################
# Define the project name
set(CMAKE_EXPORT_COMPILE_COMMANDS true)

######################################
# Find external libraries
# Find Boost
set(boost_version 1.74.0)
set(boost_components ${boost_components} thread system program_options atomic filesystem date_time chrono regex iostreams)
find_package( Boost ${boost_version} COMPONENTS ${boost_components} REQUIRED )

# Find YAML
find_package(yaml-cpp REQUIRED)

# libsno
find_package(sno_core REQUIRED)

######################################
# Locations of files for this project
if(NOT SNO_NO_GLOB_SRC)
  file(GLOB_RECURSE glob_headers src/[a-z]*.h)
  file(GLOB_RECURSE glob_sources src/[a-z]*.cpp)
endif()
set(sources ${sources} ${glob_sources})
set(headers ${headers} ${glob_headers})

######################################
#Set build type and compiler flags
#define a build type if one has not been defined alread
include(${cmake_dir}/cxxflags-config.cmake)

######################################
# Make RUNPATH the same for the installed/normally built binaries
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

######################################
# Define the binary we're building
add_executable(${CMAKE_PROJECT_NAME} ${sources} ${headers})

######################################
# Versioning. Set version numbers, generate version headers, etc
include(${cmake_dir}/setversion.cmake)

######################################
# Include directories
# Headers from our application
set(include_dirs ${CMAKE_CURRENT_SOURCE_DIR}/src ${include_dirs})

# Include Boost
set(include_dirs ${include_dirs} ${Boost_INCLUDE_DIR})

# Include YAML
set(include_dirs ${include_dirs} ${YAML_INCLUDE_PATH})

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${include_dirs})

######################################
# Libraries to be linked against
# link against Boost and YAML
set(libs ${libs} ${Boost_LIBRARIES})
set(libs ${libs} ${YAML_LIB})

# link against pthread
set(libs ${libs} rt)
set(libs ${libs} pthread)

# link against sno
set(libs ${libs} ${sno_core_LIBRARIES})

# Link project
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE ${libs})

######################################
# Define installation of the binary
install(TARGETS ${CMAKE_PROJECT_NAME} DESTINATION bin)

######################################
# .deb package generation
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libsno")
include(${cmake_dir}/cpack-config.cmake)

######################################
# Unit Testing
if (UNIX AND TESTS)
  # Set files needed for testing
  set(TEST_SOURCES ${TEST_SOURCES} ${sources})
  set(TEST_HEADERS ${TEST_HEADERS}  ${headers})
  set(TEST_EXCLUDES ${TEST_EXCLUDES} ${CMAKE_CURRENT_SOURCE_DIR}/src/${CMAKE_PROJECT_NAME}.cpp)
  set(TEST_LIBS ${TEST_LIBS} ${libs})
  include(${cmake_dir}/gtest-config.cmake)
endif (UNIX AND TESTS)

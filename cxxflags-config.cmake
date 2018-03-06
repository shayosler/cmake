# Set build type and compiler flags for GCC compilers
# This file must be included after a build target whose name is stored in a 
# variable called 'project_name' has been defined

#Define a build type if one has not been defined alread
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)

#Turn on verbose compiler warnings, set flags for different build modes
if(CMAKE_COMPILER_IS_GNUCC)
  set_property(TARGET ${project_name} PROPERTY CXX_STANDARD 14)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic -Wno-long-long -Wunused -Wconversion -Wsign-conversion -Woverloaded-virtual -Wold-style-cast")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g")
  set(CMAKE_CXX_FLAGS_RELEASE "-O3")
  set(CMAKE_CXX_FLAGS_DEBUG  "-O0 -g")
endif(CMAKE_COMPILER_IS_GNUCC)
MESSAGE(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

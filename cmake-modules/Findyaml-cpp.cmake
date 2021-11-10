# Find the include directory and libraries associated with yaml-cpp
# If successful the following variables will be populated:
# 	YAML_LIB:		The yaml library to be linked agains
#	YAML_INCLUDE_PATH:	The path to the YAML headers
# The yaml-cpp_FOUND variable will be populated with either TRUE or FALSE
# depending on whether or not YAML could be found.
#
# By default this script looks for libraries in /usr/local/lib and /usr/lib
# on UNIX systems and C:/Program Files/YAML_CPP/lib on Windows systems. 
# It defaults to looking for headers in /usr/local/include and /usr/include
# on UNIX and C:/Program Files/YAML_CPP/include on Windows.
#
# If the YAML_ROOT variable is defined or present in the environment then
# the script will search ${YAML_ROOT}/lib and ${YAML_ROOT}/include for the
# libraries and headers, unless a different location is specified by
# YAML_LIBDIR or YAML_INCLUDEDIR.
#
# If either of the YAML_LIBDIR or YAML_INCLUDEDIR variables are defined or 
# present in the environment then the script will use the path from that
# variable when searching for headers or libraries instead of the default
# path or the path defined by YAML_ROOT.

set(yaml-cpp_FOUND 0)

######################################
#Define default search paths TODO: This might be unnecessary
message(STATUS "looking for yaml-cpp")

if(UNIX)
  set(YAML_CPP_INC_SEARCH_PATH
    /usr/local/include
    /usr/include)

  set(YAML_CPP_LIB_SEARCH_PATH
    /usr/local/lib
    /usr/lib)
  find_library(YAML_LIB yaml-cpp ${YAML_CPP_LIB_SEARCH_PATH})
elseif(WIN32)
  set(YAML_CPP_BASE_DIR C:/Users/gss/depends/yaml-cpp-0.3.0)
  set(YAML_CPP_INC_SEARCH_PATH ${YAML_CPP_BASE_DIR}/include)
  if (WINDOWS_ARCH STREQUAL "x86")
    set(YAML_CPP_LIB_SEARCH_PATH ${YAML_CPP_BASE_DIR}/build)
  else()
    set(YAML_CPP_LIB_SEARCH_PATH  ${YAML_CPP_BASE_DIR}/build_x64)
  endif()
  find_library(YAML_LIB libyaml-cppmd ${YAML_CPP_LIB_SEARCH_PATH})
endif()

find_path(YAML_INCLUDE_PATH NAMES yaml-cpp/yaml.h PATHS ${YAML_CPP_INC_SEARCH_PATH})

message(STATUS "YAML_INCLUDE_PATH = ${YAML_INCLUDE_PATH}")
message(STATUS "YAML_LIB = ${YAML_LIB}")

if(YAML_INCLUDE_PATH AND YAML_LIB)
  set(yaml-cpp_FOUND 1)
  message("-- Found yaml-cpp")
endif()

if(NOT yaml-cpp_FOUND)
  if(yaml-cpp_FIND_REQUIRED)
    message(FATAL_ERROR "yaml-cpp not found")
  else()
    message(WARNING "yaml-cpp not found")
  endif()
endif()

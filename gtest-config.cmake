# CMake file for including the Google Test/Google Mock unit testing 
# framework in a project.
#
# There 7 variables that can be used to configure how the tests are generated:
# GTEST_ROOT		The directory containing the top level CMakeLists.txt
#			for Google Test/Google Mock. Defaults to 
#			/usr/local/src/gtest-1.8.0
#
# TEST_SOURCE_ROOT	The directory containing the unit test source files. All of 
#			.h and .cpp files in this directory will be used for the
#			test executable
# TEST_SOURCES		List of and other source files to be included in the unit
#			test executable
# TEST_HEADERS		List of any other header files to be included in the unit
#			test executable
# TEST_EXCLUDES		List of paths to files that should be excluded from the unit
#			test executable. 
# TEST_LIBS		List of libraries the unit test executable should link against.
#			Any libraries not linked against with target_link_libraries(...)
#			need to be specified here
# project_name		The test executable will be named ${project_name}_tests
#
# Examples:
# To add myclass.h and myclass.cpp from the application's src directory:
# set(TEST_SOURCES ${TEST_SOURCES} myclass.cpp)
# set(TEST_HEADERS ${TEST_HEADERS}  myclass.h)
#
# If the file ${project_name}.cpp contains a main() function it will need to be excluded 
# from the test executable. We can do that as follows:
# set(TEST_EXCLUDES ${TEST_EXCLUDES} ${CMAKE_CURRENT_SOURCE_DIR}/src/${project_name}.cpp)
#
# If the unit tests use classes from openSEA we will need to link against openSEA
# set(TEST_LIBS ${TEST_LIBS} opensea)

#Get linked libs
get_target_property(PROJ_LIBS ${project_name} LINK_LIBRARIES)

#Add the google testing files.
if(NOT DEFINED GTEST_ROOT)
  set(GTEST_ROOT "/usr/local/src/googletest-release-1.8.0")
endif(NOT DEFINED GTEST_ROOT)
message(STATUS "Using gtest from ${GTEST_ROOT}")

#These include dirs should get grabbed automatically by the CMakeLists.txt in ${GTEST_ROOT}/googletest.
#However, at least in cmake version 2.8.9 they doesn't get added. Works fine for 3.0.2 though.
#Explicitly including these here (before calling add_subdirectory) allows us to specify the includes as
#system includes which suppresses all the warnings from them
include_directories(SYSTEM ${GTEST_ROOT}/googletest/include)
include_directories(SYSTEM ${GTEST_ROOT}/googlemock/include)
add_subdirectory(${GTEST_ROOT} ${CMAKE_CURRENT_BINARY_DIR}/gtest)

#######################
# Unit Test Executable
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/tests)

if(NOT DEFINED TEST_SOURCE_ROOT)
  set(TEST_SOURCE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/tests")
endif(NOT DEFINED TEST_SOURCE_ROOT)

# Get files from the test directory
file(GLOB test_dir_sources "${TEST_SOURCE_ROOT}/*.cpp")
file(GLOB test_dir_headers "${TEST_SOURCE_ROOT}/*.h")
set(TEST_SOURCES ${TEST_SOURCES} ${test_dir_sources})
set(TEST_HEADERS ${TEST_HEADERS} ${test_dir_headers})

#Get files specified elsewhere
#message(STATUS "Test sources: ${TEST_SOURCES}")
#message(STATUS "Test headers: ${TEST_HEADERS}")
set(test_files ${TEST_SOURCES} ${TEST_HEADERS})
if(TEST_EXCLUDES)
  #message(STATUS "Excluding: ${TEST_EXCLUDES}")
  list(REMOVE_ITEM test_files ${TEST_EXCLUDES})
endif(TEST_EXCLUDES)
#message(STATUS "Building unit tests with: " ${test_files})

#Need to have at least 1 tests file, even if it's empty
if(NOT test_files)
  set(no_tests ${CMAKE_CURRENT_BINARY_DIR}/tests.cpp)
  message(STATUS "No test files found, generating empty test file: ${no_tests}")  
  file(WRITE ${no_tests} "")
  set(test_files ${no_tests})
endif(NOT test_files)

#Create test executable
SET(TEST_EXECUTABLE ${project_name}_tests)
add_executable(${TEST_EXECUTABLE} ${test_files})

#Link against gtest, device libraries
target_link_libraries(${TEST_EXECUTABLE} gtest gtest_main ${PROJ_LIBS} ${TEST_LIBS})


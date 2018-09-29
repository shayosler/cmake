# CMake script to print out the current version. Requires a file called 'version.cmake'
# to be present
# Invoke with:
# cmake -DVERSION_DIR=/path/to/dir/containing/version/file/ -P /path/to/gss_getversion.cmake 2>&1
include(${VERSION_DIR}/version.cmake)

# Determine if commit is a tagged release, non-zero return code means not tagged
execute_process (
  COMMAND bash -c "git describe --tags --exact-match --match 'v[0-9]*.[0-9]*.[0-9]*'"
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  RESULT_VARIABLE TAG_RETURN_CODE
  OUTPUT_QUIET
  ERROR_QUIET
)

# Set project version
# Code is pointing to a tagged release
if("${TAG_RETURN_CODE}" STREQUAL "0")
  message(${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
else()
  execute_process (
    COMMAND bash -c "git log --pretty=format:'%h' -n 1"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE COMMIT_HASH
    RESULT_VARIABLE GIT_RETURN_CODE
    ERROR_QUIET
  )

  if("${GIT_RETURN_CODE}" STREQUAL "0")
    message(${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}-${COMMIT_HASH})
  else()
    message(${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
  endif()
endif()

# Load the version definition script
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/version.cmake")
   include(${CMAKE_CURRENT_SOURCE_DIR}/version.cmake)
endif()

# If the version is not set, set a default on
if(NOT DEFINED PROJECT_VERSION_MAJOR)
  set(PROJECT_VERSION_MAJOR "0")
  message(WARNING "Project MAJOR version undefined. Defaulting to ${PROJECT_VERSION_MAJOR}")
endif(NOT DEFINED PROJECT_VERSION_MAJOR)

if(NOT DEFINED PROJECT_VERSION_MINOR)
  set(PROJECT_VERSION_MINOR "0")
  message(WARNING "Project MINOR version undefined. Defaulting to ${PROJECT_VERSION_MINOR}")
endif(NOT DEFINED PROJECT_VERSION_MINOR)

if(NOT DEFINED PROJECT_VERSION_PATCH)
  set(PROJECT_VERSION_PATCH "0")
  message(WARNING "Project PATCH version undefined. Defaulting to ${PROJECT_VERSION_PATCH}")
endif(NOT DEFINED PROJECT_VERSION_PATCH)

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
  set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
# Code is not a tagged release, add the commit hash to the project version
else()
  execute_process (
    COMMAND bash -c "git log --pretty=format:'%h' -n 1"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE COMMIT_HASH
    RESULT_VARIABLE GIT_RETURN_CODE
    ERROR_QUIET
  )

  if("${GIT_RETURN_CODE}" STREQUAL "0")
    message(STATUS "Project not a tagged release. Adding commit hash ${COMMIT_HASH} to project version")
    set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}-${COMMIT_HASH}")
  else()
    message(STATUS "Failed to determine git hash")
    set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
  endif()
endif()
set(SEMANTIC_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
MESSAGE(STATUS "Building ${CMAKE_PROJECT_NAME} version ${PROJECT_VERSION}" )

if(TARGET ${CMAKE_PROJECT_NAME})
  get_target_property(target_type ${CMAKE_PROJECT_NAME} TYPE)
  if(target_type STREQUAL "EXECUTABLE")
    set(APPLICATION_VERSION_MAJOR true)
    set(APPLICATION_VERSION_MINOR true)
    set(APPLICATION_VERSION_PATCH true)
    set(APPLICATION_VERSION_HASH true)
    set(APPLICATION_VERSION_FULL true)
  endif()
else()
  message(WARNING "No ${CMAKE_PROJECT_NAME} target defined. Version macros may be incomplete")
endif(TARGET ${CMAKE_PROJECT_NAME})

# Set a default directory to place the version header in
if(NOT DEFINED version_header_dir)
  set(version_header_dir src)
endif(NOT DEFINED version_header_dir)

# Generate version header, replace - with _
string(TOUPPER ${CMAKE_PROJECT_NAME} project_upper)
string(REPLACE "-" "_" project_upper ${project_upper})
configure_file(${cmake_dir}/version.h.in ${CMAKE_CURRENT_SOURCE_DIR}/${version_header_dir}/${CMAKE_PROJECT_NAME}_version.h)
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/${version_header_dir}/${CMAKE_PROJECT_NAME}_version.h
                            PROPERTIES GENERATED TRUE
                            HEADER_FILE_ONLY TRUE)

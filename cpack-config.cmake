######################################
# .deb package generation
# Expects there to be a variable called PROJECT_VERSION that contains the project version
# Expects the package description to be set in either the CPACK_PACKAGE_DESCRIPTION_SUMMARY variable or the PROJECT_SUMMARY variable
# Expects any package dependencies to be set in the CPACK_DEBIAN_PACKAGE_DEPENDS variable
# Expects the path to the license to be in a variable called license
if (UNIX)
  INCLUDE(InstallRequiredSystemLibraries)
  SET(CPACK_SET_DESTDIR "on")
  SET(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
  SET(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
  SET(CPACK_DEBIAN_PACKAGE_SECTION "SNO")
  SET(CPACK_RESOURCE_FILE_LICENSE ${license})
  SET(CPACK_PACKAGE_VENDOR "Greensea Systems, Inc")
  SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0)
  SET(CPACK_PACKAGING_INSTALL_PREFIX "/")
  if(DEFINED PROJECT_SUMMARY)
    SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_SUMMARY})
  endif(DEFINED PROJECT_SUMMARY)
  SET(CPACK_GENERATOR "DEB")
  SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "iwishiwuzskiing@gmail.com")
  SET(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)    
  INCLUDE(CPack)
endif (UNIX)

set(doc_dir /home/sosler/cmake/cmake/doc)

if(USE_DOXY)
  MESSAGE(STATUS "Using DOXY" )
  # add a target to generate API documentation with Doxygen
  find_package(Doxygen)
  if(DOXYGEN_FOUND)
    configure_file(${doc_dir}/Doxyfile.in ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
    add_custom_target(doc ${DOXYGEN_EXECUTABLE} 
		      ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
		      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
		      COMMENT "Generating API documentation with Doxygen" VERBATIM)
  else(DOXYGEN_FOUND)
    add_custom_target(doc COMMENT "Doxygen is not installed on this system - 'sudo apt-get install doxgen graphviz' to install" VERBATIM)
  endif(DOXYGEN_FOUND)
endif(USE_DOXY)

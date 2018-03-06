# Defines the locations of various libraries and headers
# Defines the following variables on Windows systems:
#	WINDOWS_ARCH		Architecture of the system. x86 or x64
#     	BOOST_ROOT		Root directory containing Boost files
#      	BOOST_LIBRARYDIR	Directory containing Boost libs
#      	LCM_ROOT		Directory containing LCM files
#      	GEOGRAPHIC_ROOT		Directory containing libgeographic files

if(WIN32)
  #set variable to know what architecture to use for building windows
  set(WINDOWS_ARCH x86 CACHE STRING "Variable to indicate which windows architecture to build with (x86|x64)")
  message(STATUS "WINDOWS_ARCH: ${WINDOWS_ARCH}")
  
  #Boost locations
  set(BOOST_ROOT "C:/Boost/boost_1_59_0" CACHE STRING "Boost root directory")
  if (WINDOWS_ARCH STREQUAL "x86")
    set(BOOST_LIBRARYDIR "${BOOST_ROOT}/lib32-msvc-14.0" CACHE STRING "Boost library directory")
  else()
    set(BOOST_LIBRARYDIR "${BOOST_ROOT}/lib64-msvc-14.0" CACHE STRING "Boost library directory")
  endif()
  
  #LCM location
  set(LCM_ROOT "C:/Users/gss/depends/lcm-1.3.1/" CACHE STRING "LCM root directory")
  
  #Libgeographic locations
  set(GEOGRAPHIC_ROOT "C:/Users/gss/depends/GeographicLib-1.46/" CACHE STRING "Libgeographic root directory")
endif(WIN32)
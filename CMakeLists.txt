#
# NOTE: determine required cmake here (use 'pip install cmake')
#
cmake_minimum_required(VERSION 3.10...3.21)

#
# NOTE: Include our own cmake scripts, and the CPM package manager
#
include(cmake/CPM.cmake)
include(cmake/print.cmake)
include(cmake/utils.cmake)
get_version()
project(
  starter
  VERSION ${STARTER_VERSION}
  LANGUAGES CXX
)

#
# NOTE: Set our source and include directory variables for use through the build
#
set(SOURCE_DIR "${PROJECT_SOURCE_DIR}/src")
set(INCLUDE_DIR "${PROJECT_SOURCE_DIR}/include")

#
# NOTE: Prevent in source builds (can't build in src/ or in project root)
#
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR OR PROJECT_BINARY_DIR STREQUAL SOURCE_DIR)
  print(
    FATAL_ERROR
    "In source builds are not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

#
# NOTE: bring in standard cmake includes
#
include(CMakeDependentOption)
include(GNUInstallDirs)
include(CheckIPOSupported)

#
# NOTE: Export compile_commands.json file to support clang tooling
#
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#
# NOTE: Set C/C++ parameters for all targets in this CMakeLists.txt
#
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic --std=c++17 -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -pedantic -fPIC")

#
# NOTE: This is where 3rd party libraries should be installed via the light weight CPM dependancy
# management system. The CPM wiki is here: https://github.com/cpm-cmake/CPM.cmake/wiki/More-Snippets
#
CPMAddPackage(
  NAME docopt.cpp
  GITHUB_REPOSITORY docopt/docopt.cpp
  VERSION 0.6.3
)
if(docopt.cpp_ADDED)
  print(STATUS "docopt configured correctly")
else()
  print(WARNING "docopt was not configured properly")
endif()

CPMAddPackage(
  NAME fmt
  GITHUB_REPOSITORY fmtlib/fmt
  GIT_TAG 8.0.1
)
if(fmt_ADDED)
  print(STATUS "fmt configured correctly")
else()
  print(WARNING "fmt was not configured properly")
endif()

#
# NOTE: add additional project options
#
option(ENABLE_DEBUG "Building Debug version" OFF)
option(ENABLE_PCH "Enable Precompiled Headers" OFF)
option(ENABLE_TESTING "Enable Test builds" OFF)
option(ENABLE_EXAMPLES "Enable example builds" OFF)

#
# NOTE: Build defaults to a release optimized build, cmake -DENABLE_DEBUG=ON will build debug
#
if(ENABLE_DEBUG)
  print(STATUS "Building ${PROJECT_NAME}-${PROJECT_VERSION} [DEBUG]")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
else()
  print(STATUS "Building ${PROJECT_NAME}-${PROJECT_VERSION} [RELEASE]")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")
endif()

#
# NOTE: Output build param information
#
print(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")

#
# HACK: glob src files and header files (some people may not like this)
#
file(GLOB_RECURSE GLOBBED_HEADERS CONFIGURE_DEPENDS "${INCLUDE_DIR}/${PROJECT_NAME}/*.hpp")
file(GLOB_RECURSE GLOBBED_SOURCES CONFIGURE_DEPENDS "${SOURCE_DIR}/*.cpp")

#
# NOTE: This sets a global PCH parameter, each project will build its own PCH, which is a good idea
# if any #define's change consider breaking this out per project as necessary
#
if(ENABLE_PCH)
  target_precompile_headers(project_options INTERFACE <vector> <string> <map> <utility>)
endif()

#
# NOTE: Build tests with catch2
#
if(ENABLE_TESTING)
  enable_testing()
  include(CTest)
  print(STATUS "Building Tests")
  file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/test/*.cpp")
  set(TEST_BINARY "${PROJECT_NAME}-tests")
  # here we need to compile each header and cpp file, but ommit the main.cpp, since catch2 will
  # register two main functions, which will cause an error
  add_executable(${TEST_BINARY} ${TEST_SOURCES} ${SOURCE_DIR}/addition.cpp)
  target_include_directories(${TEST_BINARY} PUBLIC ${INCLUDE_DIR})
  target_link_libraries(${TEST_BINARY} PRIVATE stdc++fs)
endif()

#
# NOTE: Build project examples, mostly useful for shared/static libraries
#
if(ENABLE_EXAMPLES)
  print(STATUS "Building examples")
  add_subdirectory(examples)
endif()

print(STATUS "Building main executable")
set(BINARY "${PROJECT_NAME}-client")
add_executable(${BINARY} ${GLOBBED_SOURCES})
# NOTE: Add our external include directory => include/starter
target_include_directories(${BINARY} PUBLIC ${INCLUDE_DIR})
# NOTE: Link 3rd party libraries with the executable here
target_link_libraries(${BINARY} PRIVATE stdc++fs docopt fmt::fmt)

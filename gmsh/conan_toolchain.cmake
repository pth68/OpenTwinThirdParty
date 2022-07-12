

# Conan automatically generated toolchain file
# DO NOT EDIT MANUALLY, it will be overwritten

# Avoid including toolchain file several times (bad if appending to variables like
#   CMAKE_CXX_FLAGS. See https://github.com/android/ndk/issues/323
include_guard()

message(STATUS "Using Conan toolchain: ${CMAKE_CURRENT_LIST_FILE}")

if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeToolchain' generator only works with CMake >= 3.15")
endif()






set(CMAKE_GENERATOR_PLATFORM "x64" CACHE STRING "" FORCE)


# Definition of VS runtime, defined from build_type, compiler.runtime, compiler.runtime_type
cmake_policy(GET CMP0091 POLICY_CMP0091)
if(NOT "${POLICY_CMP0091}" STREQUAL NEW)
    message(FATAL_ERROR "The CMake policy CMP0091 must be NEW, but is '${POLICY_CMP0091}'")
endif()
set(CMAKE_MSVC_RUNTIME_LIBRARY "$<$<CONFIG:Release>:MultiThreadedDLL>$<$<CONFIG:Debug>:MultiThreadedDebugDLL>")

string(APPEND CONAN_CXX_FLAGS " /MP2")
string(APPEND CONAN_C_FLAGS " /MP2")

# Extra c, cxx, linkflags and defines


if(DEFINED CONAN_CXX_FLAGS)
  string(APPEND CMAKE_CXX_FLAGS_INIT " ${CONAN_CXX_FLAGS}")
endif()
if(DEFINED CONAN_C_FLAGS)
  string(APPEND CMAKE_C_FLAGS_INIT " ${CONAN_C_FLAGS}")
endif()
if(DEFINED CONAN_SHARED_LINKER_FLAGS)
  string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${CONAN_SHARED_LINKER_FLAGS}")
endif()
if(DEFINED CONAN_EXE_LINKER_FLAGS)
  string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${CONAN_EXE_LINKER_FLAGS}")
endif()

get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
if(_CMAKE_IN_TRY_COMPILE)
    message(STATUS "Running toolchain IN_TRY_COMPILE")
    return()
endif()

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG ON)

# Definition of CMAKE_MODULE_PATH
# Explicitly defined "builddirs" of "host" dependencies
list(PREPEND CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/freetype/2.10.4/_/_/package/502fb0910faf9e6a163421a78f2ef5e62f15891b/lib/cmake" "C:/Users/johannes/.conan/data/bzip2/1.0.8/_/_/package/93732b8419686234c98e4e880c6f87289cf78b4f/lib/cmake")
# The root (which is the default builddirs) path of dependencies in the host context
list(PREPEND CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/freetype/2.10.4/_/_/package/502fb0910faf9e6a163421a78f2ef5e62f15891b/" "C:/Users/johannes/.conan/data/libpng/1.6.37/_/_/package/2026793585d04329599fcef815fc80b19828f099/" "C:/Users/johannes/.conan/data/zlib/1.2.12/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/" "C:/Users/johannes/.conan/data/bzip2/1.0.8/_/_/package/93732b8419686234c98e4e880c6f87289cf78b4f/" "C:/Users/johannes/.conan/data/brotli/1.0.9/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/")
# the generators folder (where conan generates files, like this toolchain)
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# Definition of CMAKE_PREFIX_PATH, CMAKE_XXXXX_PATH
# The explicitly defined "builddirs" of "host" context dependencies must be in PREFIX_PATH
list(PREPEND CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/freetype/2.10.4/_/_/package/502fb0910faf9e6a163421a78f2ef5e62f15891b/lib/cmake" "C:/Users/johannes/.conan/data/bzip2/1.0.8/_/_/package/93732b8419686234c98e4e880c6f87289cf78b4f/lib/cmake")
# The Conan local "generators" folder, where this toolchain is saved.
list(PREPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR} )
list(PREPEND CMAKE_LIBRARY_PATH "C:/Users/johannes/.conan/data/freetype/2.10.4/_/_/package/502fb0910faf9e6a163421a78f2ef5e62f15891b/lib" "C:/Users/johannes/.conan/data/libpng/1.6.37/_/_/package/2026793585d04329599fcef815fc80b19828f099/lib" "C:/Users/johannes/.conan/data/zlib/1.2.12/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/lib" "C:/Users/johannes/.conan/data/bzip2/1.0.8/_/_/package/93732b8419686234c98e4e880c6f87289cf78b4f/lib" "C:/Users/johannes/.conan/data/brotli/1.0.9/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/lib")
list(PREPEND CMAKE_INCLUDE_PATH "C:/Users/johannes/.conan/data/freetype/2.10.4/_/_/package/502fb0910faf9e6a163421a78f2ef5e62f15891b/include" "C:/Users/johannes/.conan/data/freetype/2.10.4/_/_/package/502fb0910faf9e6a163421a78f2ef5e62f15891b/include/freetype2" "C:/Users/johannes/.conan/data/libpng/1.6.37/_/_/package/2026793585d04329599fcef815fc80b19828f099/include" "C:/Users/johannes/.conan/data/zlib/1.2.12/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/include" "C:/Users/johannes/.conan/data/bzip2/1.0.8/_/_/package/93732b8419686234c98e4e880c6f87289cf78b4f/include" "C:/Users/johannes/.conan/data/brotli/1.0.9/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/include" "C:/Users/johannes/.conan/data/brotli/1.0.9/_/_/package/bf9ec17af5844bd8d3cc139070000dc26fc5f076/include/brotli")





message(STATUS "Conan toolchain: Setting BUILD_SHARED_LIBS = ON")
set(BUILD_SHARED_LIBS ON)

# Variables
# Variables  per configuration


# Preprocessor definitions
# Preprocessor definitions per configuration

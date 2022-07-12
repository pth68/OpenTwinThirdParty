########## MACROS ###########################################################################
#############################################################################################

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


########### FOUND PACKAGE ###################################################################
#############################################################################################

include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findkissfft.cmake")
set(kissfft_FOUND 1)
set(kissfft_VERSION "131.1.0")

find_package_handle_standard_args(kissfft REQUIRED_VARS
                                  kissfft_VERSION VERSION_VAR kissfft_VERSION)
mark_as_advanced(kissfft_FOUND kissfft_VERSION)

set(kissfft_COMPONENTS kissfft::kissfft-float)

if(kissfft_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${kissfft_FIND_COMPONENTS})
        list(FIND kissfft_COMPONENTS "kissfft::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'kissfft'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'kissfft'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(kissfft_INCLUDE_DIRS "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include"
			"C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include/kissfft")
set(kissfft_INCLUDE_DIR "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include;C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include/kissfft")
set(kissfft_INCLUDES "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include"
			"C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include/kissfft")
set(kissfft_RES_DIRS )
set(kissfft_DEFINITIONS "-Dkiss_fft_scalar=float"
			"-DKISS_FFT_SHARED")
set(kissfft_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(kissfft_COMPILE_DEFINITIONS "kiss_fft_scalar=float"
			"KISS_FFT_SHARED")
set(kissfft_COMPILE_OPTIONS_LIST "" "")
set(kissfft_COMPILE_OPTIONS_C "")
set(kissfft_COMPILE_OPTIONS_CXX "")
set(kissfft_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(kissfft_LIBRARIES "") # Will be filled later
set(kissfft_LIBS "") # Same as kissfft_LIBRARIES
set(kissfft_SYSTEM_LIBS )
set(kissfft_FRAMEWORK_DIRS )
set(kissfft_FRAMEWORKS )
set(kissfft_FRAMEWORKS_FOUND "") # Will be filled later
set(kissfft_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(kissfft_FRAMEWORKS_FOUND "${kissfft_FRAMEWORKS}" "${kissfft_FRAMEWORK_DIRS}")

mark_as_advanced(kissfft_INCLUDE_DIRS
                 kissfft_INCLUDE_DIR
                 kissfft_INCLUDES
                 kissfft_DEFINITIONS
                 kissfft_LINKER_FLAGS_LIST
                 kissfft_COMPILE_DEFINITIONS
                 kissfft_COMPILE_OPTIONS_LIST
                 kissfft_LIBRARIES
                 kissfft_LIBS
                 kissfft_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to kissfft_LIBS and kissfft_LIBRARY_LIST
set(kissfft_LIBRARY_LIST kissfft-float)
set(kissfft_LIB_DIRS "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_kissfft_DEPENDENCIES "${kissfft_FRAMEWORKS_FOUND} ${kissfft_SYSTEM_LIBS} ")

conan_package_library_targets("${kissfft_LIBRARY_LIST}"  # libraries
                              "${kissfft_LIB_DIRS}"      # package_libdir
                              "${_kissfft_DEPENDENCIES}"  # deps
                              kissfft_LIBRARIES            # out_libraries
                              kissfft_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "kissfft")                                      # package_name

set(kissfft_LIBS ${kissfft_LIBRARIES})

foreach(_FRAMEWORK ${kissfft_FRAMEWORKS_FOUND})
    list(APPEND kissfft_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND kissfft_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${kissfft_SYSTEM_LIBS})
    list(APPEND kissfft_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND kissfft_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(kissfft_LIBRARIES_TARGETS "${kissfft_LIBRARIES_TARGETS};")
set(kissfft_LIBRARIES "${kissfft_LIBRARIES};")

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/" ${CMAKE_PREFIX_PATH})


########### COMPONENT kissfft-float VARIABLES #############################################

set(kissfft_kissfft-float_INCLUDE_DIRS "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include"
			"C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include/kissfft")
set(kissfft_kissfft-float_INCLUDE_DIR "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include;C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include/kissfft")
set(kissfft_kissfft-float_INCLUDES "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include"
			"C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/include/kissfft")
set(kissfft_kissfft-float_LIB_DIRS "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/lib")
set(kissfft_kissfft-float_RES_DIRS )
set(kissfft_kissfft-float_DEFINITIONS "-Dkiss_fft_scalar=float"
			"-DKISS_FFT_SHARED")
set(kissfft_kissfft-float_COMPILE_DEFINITIONS "kiss_fft_scalar=float"
			"KISS_FFT_SHARED")
set(kissfft_kissfft-float_COMPILE_OPTIONS_C "")
set(kissfft_kissfft-float_COMPILE_OPTIONS_CXX "")
set(kissfft_kissfft-float_LIBS kissfft-float)
set(kissfft_kissfft-float_SYSTEM_LIBS )
set(kissfft_kissfft-float_FRAMEWORK_DIRS )
set(kissfft_kissfft-float_FRAMEWORKS )
set(kissfft_kissfft-float_BUILD_MODULES_PATHS )
set(kissfft_kissfft-float_DEPENDENCIES )
set(kissfft_kissfft-float_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT kissfft-float FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(kissfft_kissfft-float_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(kissfft_kissfft-float_FRAMEWORKS_FOUND "${kissfft_kissfft-float_FRAMEWORKS}" "${kissfft_kissfft-float_FRAMEWORK_DIRS}")

set(kissfft_kissfft-float_LIB_TARGETS "")
set(kissfft_kissfft-float_NOT_USED "")
set(kissfft_kissfft-float_LIBS_FRAMEWORKS_DEPS ${kissfft_kissfft-float_FRAMEWORKS_FOUND} ${kissfft_kissfft-float_SYSTEM_LIBS} ${kissfft_kissfft-float_DEPENDENCIES})
conan_package_library_targets("${kissfft_kissfft-float_LIBS}"
                              "${kissfft_kissfft-float_LIB_DIRS}"
                              "${kissfft_kissfft-float_LIBS_FRAMEWORKS_DEPS}"
                              kissfft_kissfft-float_NOT_USED
                              kissfft_kissfft-float_LIB_TARGETS
                              ""
                              "kissfft_kissfft-float")

set(kissfft_kissfft-float_LINK_LIBS ${kissfft_kissfft-float_LIB_TARGETS} ${kissfft_kissfft-float_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/kissfft/131.1.0/_/_/package/70e267584ab124ae7dd6763463ca406db4cb952b/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT kissfft-float TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET kissfft::kissfft-float)
        add_library(kissfft::kissfft-float INTERFACE IMPORTED)
        set_target_properties(kissfft::kissfft-float PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${kissfft_kissfft-float_INCLUDE_DIRS}")
        set_target_properties(kissfft::kissfft-float PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${kissfft_kissfft-float_LIB_DIRS}")
        set_target_properties(kissfft::kissfft-float PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${kissfft_kissfft-float_LINK_LIBS};${kissfft_kissfft-float_LINKER_FLAGS_LIST}")
        set_target_properties(kissfft::kissfft-float PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${kissfft_kissfft-float_COMPILE_DEFINITIONS}")
        set_target_properties(kissfft::kissfft-float PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${kissfft_kissfft-float_COMPILE_OPTIONS_C};${kissfft_kissfft-float_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET kissfft::kissfft)
        add_library(kissfft::kissfft INTERFACE IMPORTED)
    endif()
    set_property(TARGET kissfft::kissfft APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${kissfft_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT kissfft-float BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${kissfft_kissfft-float_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

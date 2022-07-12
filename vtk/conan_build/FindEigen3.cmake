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

conan_message(STATUS "Conan: Using autogenerated FindEigen3.cmake")
set(Eigen3_FOUND 1)
set(Eigen3_VERSION "3.3.7")

find_package_handle_standard_args(Eigen3 REQUIRED_VARS
                                  Eigen3_VERSION VERSION_VAR Eigen3_VERSION)
mark_as_advanced(Eigen3_FOUND Eigen3_VERSION)

set(Eigen3_COMPONENTS Eigen3::Eigen)

if(Eigen3_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${Eigen3_FIND_COMPONENTS})
        list(FIND Eigen3_COMPONENTS "Eigen3::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'Eigen3'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'Eigen3'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(Eigen3_INCLUDE_DIRS "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/eigen3")
set(Eigen3_INCLUDE_DIR "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/eigen3")
set(Eigen3_INCLUDES "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/eigen3")
set(Eigen3_RES_DIRS )
set(Eigen3_DEFINITIONS )
set(Eigen3_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(Eigen3_COMPILE_DEFINITIONS )
set(Eigen3_COMPILE_OPTIONS_LIST "" "")
set(Eigen3_COMPILE_OPTIONS_C "")
set(Eigen3_COMPILE_OPTIONS_CXX "")
set(Eigen3_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(Eigen3_LIBRARIES "") # Will be filled later
set(Eigen3_LIBS "") # Same as Eigen3_LIBRARIES
set(Eigen3_SYSTEM_LIBS )
set(Eigen3_FRAMEWORK_DIRS )
set(Eigen3_FRAMEWORKS )
set(Eigen3_FRAMEWORKS_FOUND "") # Will be filled later
set(Eigen3_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(Eigen3_FRAMEWORKS_FOUND "${Eigen3_FRAMEWORKS}" "${Eigen3_FRAMEWORK_DIRS}")

mark_as_advanced(Eigen3_INCLUDE_DIRS
                 Eigen3_INCLUDE_DIR
                 Eigen3_INCLUDES
                 Eigen3_DEFINITIONS
                 Eigen3_LINKER_FLAGS_LIST
                 Eigen3_COMPILE_DEFINITIONS
                 Eigen3_COMPILE_OPTIONS_LIST
                 Eigen3_LIBRARIES
                 Eigen3_LIBS
                 Eigen3_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to Eigen3_LIBS and Eigen3_LIBRARY_LIST
set(Eigen3_LIBRARY_LIST )
set(Eigen3_LIB_DIRS )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_Eigen3_DEPENDENCIES "${Eigen3_FRAMEWORKS_FOUND} ${Eigen3_SYSTEM_LIBS} ")

conan_package_library_targets("${Eigen3_LIBRARY_LIST}"  # libraries
                              "${Eigen3_LIB_DIRS}"      # package_libdir
                              "${_Eigen3_DEPENDENCIES}"  # deps
                              Eigen3_LIBRARIES            # out_libraries
                              Eigen3_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "Eigen3")                                      # package_name

set(Eigen3_LIBS ${Eigen3_LIBRARIES})

foreach(_FRAMEWORK ${Eigen3_FRAMEWORKS_FOUND})
    list(APPEND Eigen3_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND Eigen3_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${Eigen3_SYSTEM_LIBS})
    list(APPEND Eigen3_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND Eigen3_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(Eigen3_LIBRARIES_TARGETS "${Eigen3_LIBRARIES_TARGETS};")
set(Eigen3_LIBRARIES "${Eigen3_LIBRARIES};")

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})


########### COMPONENT Eigen VARIABLES #############################################

set(Eigen3_Eigen_INCLUDE_DIRS "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/eigen3")
set(Eigen3_Eigen_INCLUDE_DIR "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/eigen3")
set(Eigen3_Eigen_INCLUDES "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include/eigen3")
set(Eigen3_Eigen_LIB_DIRS )
set(Eigen3_Eigen_RES_DIRS )
set(Eigen3_Eigen_DEFINITIONS )
set(Eigen3_Eigen_COMPILE_DEFINITIONS )
set(Eigen3_Eigen_COMPILE_OPTIONS_C "")
set(Eigen3_Eigen_COMPILE_OPTIONS_CXX "")
set(Eigen3_Eigen_LIBS )
set(Eigen3_Eigen_SYSTEM_LIBS )
set(Eigen3_Eigen_FRAMEWORK_DIRS )
set(Eigen3_Eigen_FRAMEWORKS )
set(Eigen3_Eigen_BUILD_MODULES_PATHS )
set(Eigen3_Eigen_DEPENDENCIES )
set(Eigen3_Eigen_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT Eigen FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(Eigen3_Eigen_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(Eigen3_Eigen_FRAMEWORKS_FOUND "${Eigen3_Eigen_FRAMEWORKS}" "${Eigen3_Eigen_FRAMEWORK_DIRS}")

set(Eigen3_Eigen_LIB_TARGETS "")
set(Eigen3_Eigen_NOT_USED "")
set(Eigen3_Eigen_LIBS_FRAMEWORKS_DEPS ${Eigen3_Eigen_FRAMEWORKS_FOUND} ${Eigen3_Eigen_SYSTEM_LIBS} ${Eigen3_Eigen_DEPENDENCIES})
conan_package_library_targets("${Eigen3_Eigen_LIBS}"
                              "${Eigen3_Eigen_LIB_DIRS}"
                              "${Eigen3_Eigen_LIBS_FRAMEWORKS_DEPS}"
                              Eigen3_Eigen_NOT_USED
                              Eigen3_Eigen_LIB_TARGETS
                              ""
                              "Eigen3_Eigen")

set(Eigen3_Eigen_LINK_LIBS ${Eigen3_Eigen_LIB_TARGETS} ${Eigen3_Eigen_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/eigen/3.3.7/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT Eigen TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET Eigen3::Eigen)
        add_library(Eigen3::Eigen INTERFACE IMPORTED)
        set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${Eigen3_Eigen_INCLUDE_DIRS}")
        set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${Eigen3_Eigen_LIB_DIRS}")
        set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${Eigen3_Eigen_LINK_LIBS};${Eigen3_Eigen_LINKER_FLAGS_LIST}")
        set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${Eigen3_Eigen_COMPILE_DEFINITIONS}")
        set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${Eigen3_Eigen_COMPILE_OPTIONS_C};${Eigen3_Eigen_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET Eigen3::Eigen3)
        add_library(Eigen3::Eigen3 INTERFACE IMPORTED)
    endif()
    set_property(TARGET Eigen3::Eigen3 APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${Eigen3_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT Eigen BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${Eigen3_Eigen_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

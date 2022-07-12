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

conan_message(STATUS "Conan: Using autogenerated FindCURL.cmake")
set(CURL_FOUND 1)
set(CURL_VERSION "7.83.1")

find_package_handle_standard_args(CURL REQUIRED_VARS
                                  CURL_VERSION VERSION_VAR CURL_VERSION)
mark_as_advanced(CURL_FOUND CURL_VERSION)

set(CURL_COMPONENTS CURL::libcurl)

if(CURL_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${CURL_FIND_COMPONENTS})
        list(FIND CURL_COMPONENTS "CURL::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'CURL'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'CURL'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(CURL_INCLUDE_DIRS "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/include")
set(CURL_INCLUDE_DIR "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/include")
set(CURL_INCLUDES "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/include")
set(CURL_RES_DIRS "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/res")
set(CURL_DEFINITIONS )
set(CURL_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(CURL_COMPILE_DEFINITIONS )
set(CURL_COMPILE_OPTIONS_LIST "" "")
set(CURL_COMPILE_OPTIONS_C "")
set(CURL_COMPILE_OPTIONS_CXX "")
set(CURL_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(CURL_LIBRARIES "") # Will be filled later
set(CURL_LIBS "") # Same as CURL_LIBRARIES
set(CURL_SYSTEM_LIBS ws2_32)
set(CURL_FRAMEWORK_DIRS )
set(CURL_FRAMEWORKS )
set(CURL_FRAMEWORKS_FOUND "") # Will be filled later
set(CURL_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(CURL_FRAMEWORKS_FOUND "${CURL_FRAMEWORKS}" "${CURL_FRAMEWORK_DIRS}")

mark_as_advanced(CURL_INCLUDE_DIRS
                 CURL_INCLUDE_DIR
                 CURL_INCLUDES
                 CURL_DEFINITIONS
                 CURL_LINKER_FLAGS_LIST
                 CURL_COMPILE_DEFINITIONS
                 CURL_COMPILE_OPTIONS_LIST
                 CURL_LIBRARIES
                 CURL_LIBS
                 CURL_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to CURL_LIBS and CURL_LIBRARY_LIST
set(CURL_LIBRARY_LIST libcurl_imp)
set(CURL_LIB_DIRS "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_CURL_DEPENDENCIES "${CURL_FRAMEWORKS_FOUND} ${CURL_SYSTEM_LIBS} OpenSSL::OpenSSL;ZLIB::ZLIB")

conan_package_library_targets("${CURL_LIBRARY_LIST}"  # libraries
                              "${CURL_LIB_DIRS}"      # package_libdir
                              "${_CURL_DEPENDENCIES}"  # deps
                              CURL_LIBRARIES            # out_libraries
                              CURL_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "CURL")                                      # package_name

set(CURL_LIBS ${CURL_LIBRARIES})

foreach(_FRAMEWORK ${CURL_FRAMEWORKS_FOUND})
    list(APPEND CURL_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND CURL_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${CURL_SYSTEM_LIBS})
    list(APPEND CURL_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND CURL_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(CURL_LIBRARIES_TARGETS "${CURL_LIBRARIES_TARGETS};OpenSSL::OpenSSL;ZLIB::ZLIB")
set(CURL_LIBRARIES "${CURL_LIBRARIES};OpenSSL::OpenSSL;ZLIB::ZLIB")

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/" ${CMAKE_PREFIX_PATH})


########### COMPONENT libcurl VARIABLES #############################################

set(CURL_libcurl_INCLUDE_DIRS "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/include")
set(CURL_libcurl_INCLUDE_DIR "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/include")
set(CURL_libcurl_INCLUDES "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/include")
set(CURL_libcurl_LIB_DIRS "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/lib")
set(CURL_libcurl_RES_DIRS "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/res")
set(CURL_libcurl_DEFINITIONS )
set(CURL_libcurl_COMPILE_DEFINITIONS )
set(CURL_libcurl_COMPILE_OPTIONS_C "")
set(CURL_libcurl_COMPILE_OPTIONS_CXX "")
set(CURL_libcurl_LIBS libcurl_imp)
set(CURL_libcurl_SYSTEM_LIBS ws2_32)
set(CURL_libcurl_FRAMEWORK_DIRS )
set(CURL_libcurl_FRAMEWORKS )
set(CURL_libcurl_BUILD_MODULES_PATHS )
set(CURL_libcurl_DEPENDENCIES OpenSSL::OpenSSL ZLIB::ZLIB)
set(CURL_libcurl_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)

if(NOT OpenSSL_FOUND)
    find_dependency(OpenSSL REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency OpenSSL already found")
endif()

if(NOT ZLIB_FOUND)
    find_dependency(ZLIB REQUIRED)
else()
    conan_message(STATUS "Conan: Dependency ZLIB already found")
endif()


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT libcurl FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(CURL_libcurl_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(CURL_libcurl_FRAMEWORKS_FOUND "${CURL_libcurl_FRAMEWORKS}" "${CURL_libcurl_FRAMEWORK_DIRS}")

set(CURL_libcurl_LIB_TARGETS "")
set(CURL_libcurl_NOT_USED "")
set(CURL_libcurl_LIBS_FRAMEWORKS_DEPS ${CURL_libcurl_FRAMEWORKS_FOUND} ${CURL_libcurl_SYSTEM_LIBS} ${CURL_libcurl_DEPENDENCIES})
conan_package_library_targets("${CURL_libcurl_LIBS}"
                              "${CURL_libcurl_LIB_DIRS}"
                              "${CURL_libcurl_LIBS_FRAMEWORKS_DEPS}"
                              CURL_libcurl_NOT_USED
                              CURL_libcurl_LIB_TARGETS
                              ""
                              "CURL_libcurl")

set(CURL_libcurl_LINK_LIBS ${CURL_libcurl_LIB_TARGETS} ${CURL_libcurl_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/libcurl/7.83.1/_/_/package/f93673ef5dfc8df5f495fff92566470c5dd28e45/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT libcurl TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET CURL::libcurl)
        add_library(CURL::libcurl INTERFACE IMPORTED)
        set_target_properties(CURL::libcurl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${CURL_libcurl_INCLUDE_DIRS}")
        set_target_properties(CURL::libcurl PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${CURL_libcurl_LIB_DIRS}")
        set_target_properties(CURL::libcurl PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${CURL_libcurl_LINK_LIBS};${CURL_libcurl_LINKER_FLAGS_LIST}")
        set_target_properties(CURL::libcurl PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${CURL_libcurl_COMPILE_DEFINITIONS}")
        set_target_properties(CURL::libcurl PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${CURL_libcurl_COMPILE_OPTIONS_C};${CURL_libcurl_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET CURL::CURL)
        add_library(CURL::CURL INTERFACE IMPORTED)
    endif()
    set_property(TARGET CURL::CURL APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${CURL_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT libcurl BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${CURL_libcurl_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
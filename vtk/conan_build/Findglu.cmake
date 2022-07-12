

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


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findglu.cmake")
# Global approach
set(glu_FOUND 1)
set(glu_VERSION "system")

find_package_handle_standard_args(glu REQUIRED_VARS
                                  glu_VERSION VERSION_VAR glu_VERSION)
mark_as_advanced(glu_FOUND glu_VERSION)


set(glu_INCLUDE_DIRS )
set(glu_INCLUDE_DIR "")
set(glu_INCLUDES )
set(glu_RES_DIRS )
set(glu_DEFINITIONS )
set(glu_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(glu_COMPILE_DEFINITIONS )
set(glu_COMPILE_OPTIONS_LIST "" "")
set(glu_COMPILE_OPTIONS_C "")
set(glu_COMPILE_OPTIONS_CXX "")
set(glu_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(glu_LIBRARIES "") # Will be filled later
set(glu_LIBS "") # Same as glu_LIBRARIES
set(glu_SYSTEM_LIBS Glu32)
set(glu_FRAMEWORK_DIRS )
set(glu_FRAMEWORKS )
set(glu_FRAMEWORKS_FOUND "") # Will be filled later
set(glu_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(glu_FRAMEWORKS_FOUND "${glu_FRAMEWORKS}" "${glu_FRAMEWORK_DIRS}")

mark_as_advanced(glu_INCLUDE_DIRS
                 glu_INCLUDE_DIR
                 glu_INCLUDES
                 glu_DEFINITIONS
                 glu_LINKER_FLAGS_LIST
                 glu_COMPILE_DEFINITIONS
                 glu_COMPILE_OPTIONS_LIST
                 glu_LIBRARIES
                 glu_LIBS
                 glu_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to glu_LIBS and glu_LIBRARY_LIST
set(glu_LIBRARY_LIST )
set(glu_LIB_DIRS )

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_glu_DEPENDENCIES "${glu_FRAMEWORKS_FOUND} ${glu_SYSTEM_LIBS} opengl::opengl")

conan_package_library_targets("${glu_LIBRARY_LIST}"  # libraries
                              "${glu_LIB_DIRS}"      # package_libdir
                              "${_glu_DEPENDENCIES}"  # deps
                              glu_LIBRARIES            # out_libraries
                              glu_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "glu")                                      # package_name

set(glu_LIBS ${glu_LIBRARIES})

foreach(_FRAMEWORK ${glu_FRAMEWORKS_FOUND})
    list(APPEND glu_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND glu_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${glu_SYSTEM_LIBS})
    list(APPEND glu_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND glu_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(glu_LIBRARIES_TARGETS "${glu_LIBRARIES_TARGETS};opengl::opengl")
set(glu_LIBRARIES "${glu_LIBRARIES};opengl::opengl")

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/glu/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/glu/system/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET glu::glu)
        add_library(glu::glu INTERFACE IMPORTED)
        if(glu_INCLUDE_DIRS)
            set_target_properties(glu::glu PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${glu_INCLUDE_DIRS}")
        endif()
        set_property(TARGET glu::glu PROPERTY INTERFACE_LINK_LIBRARIES
                     "${glu_LIBRARIES_TARGETS};${glu_LINKER_FLAGS_LIST}")
        set_property(TARGET glu::glu PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${glu_COMPILE_DEFINITIONS})
        set_property(TARGET glu::glu PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${glu_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT opengl_system_FOUND)
            find_dependency(opengl_system REQUIRED)
        else()
            message(STATUS "Dependency opengl_system already found")
        endif()

    endif()
endif()

foreach(_BUILD_MODULE_PATH ${glu_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
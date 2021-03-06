

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

conan_message(STATUS "Conan: Using autogenerated Findjsoncpp.cmake")
# Global approach
set(jsoncpp_FOUND 1)
set(jsoncpp_VERSION "1.9.2")

find_package_handle_standard_args(jsoncpp REQUIRED_VARS
                                  jsoncpp_VERSION VERSION_VAR jsoncpp_VERSION)
mark_as_advanced(jsoncpp_FOUND jsoncpp_VERSION)


set(jsoncpp_INCLUDE_DIRS "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/include")
set(jsoncpp_INCLUDE_DIR "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/include")
set(jsoncpp_INCLUDES "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/include")
set(jsoncpp_RES_DIRS )
set(jsoncpp_DEFINITIONS "-DJSON_DLL")
set(jsoncpp_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(jsoncpp_COMPILE_DEFINITIONS "JSON_DLL")
set(jsoncpp_COMPILE_OPTIONS_LIST "" "")
set(jsoncpp_COMPILE_OPTIONS_C "")
set(jsoncpp_COMPILE_OPTIONS_CXX "")
set(jsoncpp_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(jsoncpp_LIBRARIES "") # Will be filled later
set(jsoncpp_LIBS "") # Same as jsoncpp_LIBRARIES
set(jsoncpp_SYSTEM_LIBS )
set(jsoncpp_FRAMEWORK_DIRS )
set(jsoncpp_FRAMEWORKS )
set(jsoncpp_FRAMEWORKS_FOUND "") # Will be filled later
set(jsoncpp_BUILD_MODULES_PATHS "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/lib/cmake/conan-official-jsoncpp-targets.cmake")

conan_find_apple_frameworks(jsoncpp_FRAMEWORKS_FOUND "${jsoncpp_FRAMEWORKS}" "${jsoncpp_FRAMEWORK_DIRS}")

mark_as_advanced(jsoncpp_INCLUDE_DIRS
                 jsoncpp_INCLUDE_DIR
                 jsoncpp_INCLUDES
                 jsoncpp_DEFINITIONS
                 jsoncpp_LINKER_FLAGS_LIST
                 jsoncpp_COMPILE_DEFINITIONS
                 jsoncpp_COMPILE_OPTIONS_LIST
                 jsoncpp_LIBRARIES
                 jsoncpp_LIBS
                 jsoncpp_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to jsoncpp_LIBS and jsoncpp_LIBRARY_LIST
set(jsoncpp_LIBRARY_LIST jsoncpp)
set(jsoncpp_LIB_DIRS "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_jsoncpp_DEPENDENCIES "${jsoncpp_FRAMEWORKS_FOUND} ${jsoncpp_SYSTEM_LIBS} ")

conan_package_library_targets("${jsoncpp_LIBRARY_LIST}"  # libraries
                              "${jsoncpp_LIB_DIRS}"      # package_libdir
                              "${_jsoncpp_DEPENDENCIES}"  # deps
                              jsoncpp_LIBRARIES            # out_libraries
                              jsoncpp_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "jsoncpp")                                      # package_name

set(jsoncpp_LIBS ${jsoncpp_LIBRARIES})

foreach(_FRAMEWORK ${jsoncpp_FRAMEWORKS_FOUND})
    list(APPEND jsoncpp_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND jsoncpp_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${jsoncpp_SYSTEM_LIBS})
    list(APPEND jsoncpp_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND jsoncpp_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(jsoncpp_LIBRARIES_TARGETS "${jsoncpp_LIBRARIES_TARGETS};")
set(jsoncpp_LIBRARIES "${jsoncpp_LIBRARIES};")

set(CMAKE_MODULE_PATH "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/"
			"C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/lib/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/"
			"C:/Users/johannes/.conan/data/jsoncpp/1.9.2/_/_/package/e9a552ebe8f994398de9ceee972f0ad207df0658/lib/cmake" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET jsoncpp::jsoncpp)
        add_library(jsoncpp::jsoncpp INTERFACE IMPORTED)
        if(jsoncpp_INCLUDE_DIRS)
            set_target_properties(jsoncpp::jsoncpp PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${jsoncpp_INCLUDE_DIRS}")
        endif()
        set_property(TARGET jsoncpp::jsoncpp PROPERTY INTERFACE_LINK_LIBRARIES
                     "${jsoncpp_LIBRARIES_TARGETS};${jsoncpp_LINKER_FLAGS_LIST}")
        set_property(TARGET jsoncpp::jsoncpp PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${jsoncpp_COMPILE_DEFINITIONS})
        set_property(TARGET jsoncpp::jsoncpp PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${jsoncpp_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${jsoncpp_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

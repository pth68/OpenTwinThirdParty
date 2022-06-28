cmake_minimum_required(VERSION 3.15)

# Custom build configuration for base64 library.
#
# This configuration was not distributed with the original library.
# It was added specifically for the integration of the library in OpenTwin!

project(base64)

add_library(base64 src/base64.c)

target_include_directories(base64 PUBLIC include)

install(TARGETS base64)

install(DIRECTORY include/
    DESTINATION include)

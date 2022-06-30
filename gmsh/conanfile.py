from conans import ConanFile, tools
from conan.tools.cmake import CMake, CMakeToolchain
import os
import sys
from pathlib import Path

required_conan_version = '>=1.50.0'

class GmshConan(ConanFile):
    name = "gmsh"
    version = "4.8.0"
    url = "https://gitlab.onelab.info/gmsh/gmsh/-/tree/gmsh_4_8_0"
    description = "Automatic three-dimensional finite element mesh generator with built-in pre- and post-processing facilities."
    license = "GPL-2.0-only"
    generators = "cmake_find_package"
    settings = "os", "arch", "compiler", "build_type"
    exports_sources = "CMakeLists.txt", "api/*", "Common/*", "contrib/*", "Fltk/*", "Geo/*", "Grahpics/*", "Mesh/*", "Numeric/*", "Parser/*", "Plugin/*", "Post/*", "Solver/*", "utils/*", "LICENSE.txt", "CREDITS.txt", "CHANGELOG.txt"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {
        "shared": False,
        "fPIC": True,
    }
    requires = [
        "freetype/2.10.4",
    ]

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def generate(self):
        tc = CMakeToolchain(self)
        tc.cache_variables["ENABLE_BUILD_SHARED"] = bool(self.options.shared)
        tc.cache_variables["ENABLE_BUILD_LIB"] = bool(not self.options.shared)
        tc.cache_variables["ENABLE_BUILD_DYNAMIC"] = bool(self.options.shared)
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

        
    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
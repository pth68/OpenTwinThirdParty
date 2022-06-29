from conans import ConanFile, CMake, tools
import os
import sys
from pathlib import Path

required_conan_version = '>=1.33.0'

class TabToolbarConan(ConanFile):
    name = "TabToolbar"
    version = "1.0.0"
    url = "https://github.com/SeriousAlexej/TabToolbar/tree/a22ed2a4885b252c4d49cb43f82d71e10d0ec51e"
    description = "TabToolbar is a small library, meant to be used with Qt, that provides a few classes for creating of tabbed toolbars."
    license = "LGPL-3.0-only"
    generators = "cmake_find_package"
    settings = "os", "arch", "compiler"
    exports_sources = "CMakeLists.txt", "src/*", "include/*", "COPYING", "COPYING.LESSER", "LICENSE"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {
        "shared": False,
        "fPIC": True,
        "qt:qtwebsockets": True
    }
    requires = [
        "qt/5.15.2",
        "freetype/2.10.4",
        "sqlite3/3.36.0",
        "zlib/1.2.12"
    ]

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def build(self):
        cmake = CMake(self)
        # qt rcc needs the zlib and zstd path to be on the PATH
        # see https://github.com/conan-io/conan-center-index/issues/11118#issuecomment-1153524854
        path = os.environ["PATH"]
        for binpath in self.deps_cpp_info["zlib"].bin_paths:
            path = os.pathsep.join([binpath, path])
        for binpath in self.deps_cpp_info["zstd"].bin_paths:
            path = os.pathsep.join([binpath, path])
        self.output.info(f"PATH {path}")
        with tools.environment_append({"PATH": path}):
            cmake.configure()
            cmake.build()
            cmake.install()


        
    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
from conans import ConanFile, tools
from conan.tools.cmake import CMake, CMakeToolchain
import os

required_conan_version = '>=1.33.0'

class VtkConan(ConanFile):
    name = "VTK"
    version = "9.0.3"
    url = "https://gitlab.kitware.com/vtk/vtk/-/tree/v9.0.3"
    description = "Software system for image processing, 3D graphics, volume rendering and visualization."
    license = "BSD-3-Clause"
    generators = "cmake_find_package"
    settings = "os", "arch", "compiler", "build_type"
    exports_sources = "CMakeLists.txt", "Accelerators/*", "Charts/*", "CMake/*", "Common/*", "Domains/*", "Filters/*", "Geovis/*", "GUISupport/*", "Imaging/*", "Infovis/*", "Interaction/*", "IO/*", "Parallel/*", "Remote/*", "Rendering/*", "ThirdParty/*", "Utilities/*", "Views/*", "Web/*", "Copyright.txt", "LICENSE", "CONTRIBUTING.md"
    options = {"shared": [True, False], "fPIC": [True, False]}
    no_copy_source = True
    default_options = {
        "shared": False,
        "fPIC": True,
    }

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC


    def generate(self):
        tc = CMakeToolchain(self)
        tc.cache_variables["VTK_ENABLE_WRAPPING"] = False
        tc.generate()


    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

        
    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
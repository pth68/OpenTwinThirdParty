from conans import ConanFile, tools
from conan.tools.cmake import CMake, CMakeToolchain
import os

required_conan_version = '>=1.33.0'

class Base64Conan(ConanFile):
    name = "base64"
    version = "1.0.0"
    url = "https://github.com/pth68/OpenTwinThirdParty"
    description = "a simple base64 library by apple"
    license = "APSL-2.0"
    settings = "os", "arch", "compiler", "build_type"
    exports_sources = "CMakeLists.txt", "src/*", "include/*"

    def generate(self):
        tc = CMakeToolchain(self)
        tc.generate()


    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
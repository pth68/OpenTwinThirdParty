from conans import ConanFile, CMake, tools
import os

required_conan_version = '>=1.33.0'

class Base64Conan(ConanFile):
    name = "base64"
    version = "1.0.0"
    url = "https://github.com/pth68/OpenTwinThirdParty"
    description = "a simple base64 library by apple"
    license = "APSL-2.0"
    settings = "os", "arch", "compiler"
    exports_sources = "CMakeLists.txt", "src/*", "include/*"

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
        cmake.install()

    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
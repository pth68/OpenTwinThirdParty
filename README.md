# OpenTwin Third-Party Dependencies

Repository that contains all the thirdparty dependencies that are needed in order to build OpenTwin.

## Prerequisites

### Tools

The following tools need to be available on your machine:

* [CMake](https://cmake.org) >= 3.15
* [Conan](https://conan.io) >= 1.50
* [Python 3](https://www.python.org/)
* On Windows:
    * Visual Studio 17 2022

### Conan Setup

1. Configure release & debug [Conan profiles](https://docs.conan.io/en/latest/reference/config_files/default_profile.html#default-profile) for your setup. In the following steps it is assumed that `default` is the profile for release builds and `debug` is the profile for debug builds.
2. The Artifactory Remote has to be added:
    ```
    conan remote add opentwin https://artifactory.opentwin.net/artifactory/api/conan/opentwin
    ```
3. Login to the added remote. You will pre prompted for your password.
    ```
    conan user -r opentwin <USERNAME> -p
    ```
    *In order to be allowed to publish packages, the Artifactory user has to be in the "Publisher" group!*

## Publishing a package

To upload a package to the Artifactory, the following steps are required:

1. Change into the root dir of the package:
   ```
   cd base64
   ```
2. Install any third-party libraries that might be missing, for both `debug` and `release` profiles:
   ```
   conan install --build missing --options *:shared=True --profile default .
   conan install --build missing --options *:shared=True --profile debug .
   ```
3. Create the package for both `debug` and `release`: 
   ```bash
   conan create . opentwin/thirdparty --options *:shared=True --profile release
   conan create . opentwin/thirdparty --options *:shared=True --profile debug
   ```
   This will build the package for you build configuration and install the created artifacts.
4. Export the package: 
   ```bash
   conan export . base64/1.0.0@opentwin/thirdparty
   ```
5. Upload the package to the Artifactory: 
   ```bash
   conan upload base64/1.0.0@opentwin/thirdparty --all --remote=opentwin
   ```
   This will upload:
      - The source files of the library, so users are able to build it themselves if no prebuilt package matches their configuration
      - All compiled packages. When you have built packages for both *Debug* and *Release*, both will be published.
      - **Attention:** When for the given version and configuration there already is a package stored in Artifactory, it will be overridden.

## Updating a Dependency

To update a dependency to a newer version, the old version can be overridden. The sources and binaries of the old version are still availabe in the Artifactory, if needed!

1. Find the original sourcecode of the old version. The link to the source should be given in the `url` property in `conanfile.py`.
2. Create a diff between the files in this repo and the original source to get an overview over what has been altered for the Conan port. Files may have been deleted or changed!
3. Get the sourcecode of the new version. Adapt the changes made to the old code as far as possible.
4. Overwrite the old sources in this repository with the new sources
5. Update the `conanfile.py`: A new `version` has to be set and the `url` should be updated to the source of the new version!
5. Create a new Conan package and upload it to the Artifactory.

## Adding a new Dependency

To add a new dependency with the name "Foo" to this repository, the following steps must be followed (It is assumed that the library is built with CMake):

1. Create a new folder for the dependency, e.g. `mkdir foo`
2. Create a `conanfile.py` with the following base structure:
   ```python
   from conans import ConanFile, tools
   from conan.tools.cmake import CMake, CMakeToolchain
   import os

   required_conan_version = '>=1.50.0'

   class FooConan(ConanFile):
      name = "Foo"
      version = "1.0.0" # Version of Foo
      url = "https://foo.com" # Link to the original sources. If from a repo, give a link to the specific commit
      description = "Lorem ipsum set dolor"
      license = "GPL-2.0-only" # License identifier from https://spdx.devlicenses/
      generators = "cmake_find_package"
      settings = "os", "arch", "compiler", "build_type"
      exports_sources = "CMakeLists.txt", "src/*", "include/*" # all sources that are required for building
      options = {"shared": [True, False], "fPIC": [True, False]}
      default_options = {
         "shared": False,
         "fPIC": True,
      }
      requires = [
         "bar/2.1.0" # dependencies of the library
      ]

      def config_options(self):
         if self.settings.os == "Windows":
               del self.options.fPIC

      def generate(self):
         tc = CMakeToolchain(self)
         # any CMake options required for the build can be set here
         tc.cache_variables["ENABLE_BUILD_SHARED"] = bool(self.options.shared) 
         tc.generate()

      def build(self):
         cmake = CMake(self)
         cmake.configure()
         cmake.build()
         cmake.install()

         
      def package_info(self):
         self.cpp_info.libs = tools.collect_libs(self)
   ```
2. Copy all sources of the dependency into the folder. If required, modify the `CMakeLists.txt` in order to work with dependencies pulled in by conan (`find_package()` and `target_link_library()` may have to be altered).
3. De-clutter the sources if possible! Anything thats not needed for the build, like documentation or examples may be removed to save some space.
4. If everything is working, create a new Conan package and upload it to the Artifactory.

## Further reading…

- [Conan Documentation](https://docs.conan.io/en/latest/)
  - [Conan: Creating Packages](https://docs.conan.io/en/latest/creating_packages.html)
  - [Conan: Uploading Packages to Remotes](https://docs.conan.io/en/latest/uploading_packages/uploading_to_remotes.html#)
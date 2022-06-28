# OpenTwin ThirdParty

Repository that contains all the thirdparty dependencies that are needed in order to build OpenTwin.

## Prerequisites

### Dependencies

The following tools need to be available on your machine:

* [CMake](https://cmake.org) >= 3.15
* [Conan](https://conan.io) >= 1.49
* [Python](https://www.python.org/)
* On Windows:
    * Visual Studio 17 2022

### Conan Setup

1. A [Conan profile](https://docs.conan.io/en/latest/reference/config_files/default_profile.html#default-profile) has to be configured for your setup.
2. The Artifactory Remote has to be added:
    ```
    conan remote add opentwin https://artifactory.opentwin.net/artifactory/api/conan/opentwin
    ```
3. Login to the added remote:
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
1. Create the package: 
   ```bash
   conan create .
   ```
   This will build the package for you build configuration and install the created artifacts. 
    * *If you have a custom profile defined for OpenTwin, it needs to be passed to this command, e.g. `conan create . --profile=opentwin`.*
    * *To build a shared library, the option `--options shared=True` has to be appended to the `create` command. This may not be supported by all dependencies in this repository!*
2. Export the package: 
   ```bash
   conan export .
   ```
3. Upload the package to the Artifactory: 
   ```bash
   conan upload base64/1.0.0 --all --remote=opentwin
   ```


## Further reading…

- [Conan Documentation](https://docs.conan.io/en/latest/)
- [Conan: Uploading Packages to Remotes](https://docs.conan.io/en/latest/uploading_packages/uploading_to_remotes.html#)
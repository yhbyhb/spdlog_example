# use_vcpkg.cmake - Setup vcpkg as a dependency using FetchContent
include(FetchContent)

# Path to the vcpkg-configuration.json file
set(vcpkg_config_file "${CMAKE_SOURCE_DIR}/vcpkg-configuration.json")

# Function to extract the baseline hash from the default registry
function(vcpkg_get_default_registry_baseline json_file out_var)
  file(READ "${json_file}" json_content)

  string(REGEX MATCH
         "\"default-registry\"[^{]*{[^}]*\"baseline\": \"([^\"]+)\""
         _
         "${json_content}")

  if(CMAKE_MATCH_1)
    set(${out_var} "${CMAKE_MATCH_1}" PARENT_SCOPE)
  else()
    message(FATAL_ERROR "Could not extract baseline from ${json_file}")
  endif()
endfunction()

# Extract vcpkg commit hash from the baseline
vcpkg_get_default_registry_baseline("${vcpkg_config_file}" vcpkg_git_commit_hash)

message(STATUS "Using VCPKG baseline commit hash: ${vcpkg_git_commit_hash}")

# Fetch vcpkg at specified commit
FetchContent_Declare(
  vcpkg
  GIT_REPOSITORY https://github.com/microsoft/vcpkg.git
  GIT_TAG        ${vcpkg_git_commit_hash}
)
FetchContent_MakeAvailable(vcpkg)

# Set vcpkg toolchain file
set(CMAKE_TOOLCHAIN_FILE "${vcpkg_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake")

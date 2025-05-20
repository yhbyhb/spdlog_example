cmake_minimum_required(VERSION 3.28)

include(use_vcpkg.cmake)

project(spdlog_example LANGUAGES C CXX)

add_executable(${PROJECT_NAME})

find_package(spdlog CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE spdlog::spdlog)

target_sources(
  ${PROJECT_NAME}
    PRIVATE
        spdlog_example.cpp  
)
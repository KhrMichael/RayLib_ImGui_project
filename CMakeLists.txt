cmake_minimum_required(VERSION 3.20)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

project(HolyLight)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(DEPS_DIR ${CMAKE_SOURCE_DIR}/deps)
set(LIB_DIR ${DEPS_DIR}/lib)
set(INCLUDE_DIR ${DEPS_DIR}/include)

file(GLOB SOURCES
    src/*.h
    src/*.cpp
    src/**/*.h
    src/**/*.cpp
)

add_executable(HolyLight ${SOURCES})

target_include_directories(HolyLight PRIVATE ${INCLUDE_DIR})
target_link_directories(HolyLight PRIVATE ${LIB_DIR})
target_link_libraries(HolyLight raylib)

if(MSVC)
endif()

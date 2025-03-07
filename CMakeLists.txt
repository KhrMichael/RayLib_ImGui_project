cmake_minimum_required(VERSION 3.28)

project(HolyLight)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(DEPS_DIR ${CMAKE_SOURCE_DIR}/deps)
set(LIB_DIR ${DEPS_DIR}/lib)
set(INCLUDE_DIR ${DEPS_DIR}/include)

set(SRC src/main.cpp)

add_executable(HolyLight.exe ${SRC})

include_directories(${INCLUDE_DIR})
target_include_directories(HolyLight.exe PRIVATE ${INCLUDE_DIR})

link_directories(${LIB_DIR})


target_link_libraries(HolyLight.exe
  PRIVATE
  raylib
)

if(MSVC)
endif()


cmake_minimum_required(VERSION 3.28)

project(HolyLight )

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(SRC src/main.cpp)

add_executable(HolyLight.exe ${SRC})


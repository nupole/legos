cmake_minimum_required(VERSION 3.30.5)

project(legos)

find_program(GHDL_COMMAND ghdl REQUIRED)
find_program(PYTEST_COMMAND pytest REQUIRED)

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(add_ghdl_analysis)
include(add_ghdl_test)

enable_testing()

add_subdirectory(decoder)
add_subdirectory(encoder)
add_subdirectory(pcie)
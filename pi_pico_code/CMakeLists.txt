# sudo apt install gcc-arm-none-eabi

cmake_minimum_required(VERSION 3.13)

# initialize pico-sdk from submodule
include(pico-sdk/pico_sdk_init.cmake)

project(openautolab C CXX)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

add_executable(display_test)

target_sources(display_test PUBLIC 
    display_test.c
    pico-ssd1306/ssd1306.c)

target_include_directories(display_test PUBLIC ${CMAKE_CURRENT_LIST_DIR}/)
target_include_directories(display_test PUBLIC ${CMAKE_CURRENT_LIST_DIR}/pico-ssd1306)

# Add pico_stdlib library which aggregates commonly used features
target_link_libraries(display_test pico_stdlib hardware_i2c)

# pico_enable_stdio_usb(display_test 1) 
# pico_enable_stdio_uart(display_test 0)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(display_test)
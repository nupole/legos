add_subdirectory(encoder)

add_ghdl_analysis(hdl_uart SOURCES uart.vhdl
                           DEPENDS hdl_uart_encoder)

add_subdirectory(test)
add_ghdl_analysis(hdl_uart_encoder SOURCES uart_encoder.vhdl
                                   DEPENDS hdl_math
                                           hdl_counter
                                           hdl_serializer)

add_subdirectory(test)
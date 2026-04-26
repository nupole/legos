add_ghdl_analysis(hdl_deserializer SOURCES deserializer_pkg.vhdl
                                           deserializer.vhdl
                                   DEPENDS hdl_math
                                           hdl_counter
                                           hdl_shift_register)

add_subdirectory(test)
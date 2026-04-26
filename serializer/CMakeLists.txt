add_ghdl_analysis(hdl_serializer SOURCES serializer_pkg.vhdl
                                         serializer.vhdl
                                 DEPENDS hdl_math
                                         hdl_counter
                                         hdl_shift_register)

add_subdirectory(test)
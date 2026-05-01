add_ghdl_analysis(hdl_priority_arbiter SOURCES priority_arbiter.vhdl
                                       DEPENDS hdl_math
                                               hdl_priority_encoder)

add_subdirectory(test)
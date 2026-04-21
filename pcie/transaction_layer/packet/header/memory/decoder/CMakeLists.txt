add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_memory_decoder SOURCES pcie_transaction_layer_packet_header_memory_decoder.vhdl
                                                                          DEPENDS hdl_math
                                                                                  hdl_decoder
                                                                                  hdl_pcie_transaction_layer_packet_header_memory)

add_subdirectory(test)
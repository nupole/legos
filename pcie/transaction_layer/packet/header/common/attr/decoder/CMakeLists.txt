add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_common_attr_decoder SOURCES pcie_transaction_layer_packet_header_common_attr_decoder.vhdl
                                                                               DEPENDS hdl_decoder
                                                                                       hdl_pcie_transaction_layer_packet_header_common_attr)

add_subdirectory(test)
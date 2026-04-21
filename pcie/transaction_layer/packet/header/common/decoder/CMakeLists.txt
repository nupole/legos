add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_common_decoder SOURCES pcie_transaction_layer_packet_header_common_decoder.vhdl
                                                                          DEPENDS hdl_pcie_transaction_layer_packet_header_common
                                                                                  hdl_pcie_transaction_layer_packet_header_common_fmt_decoder
                                                                                  hdl_pcie_transaction_layer_packet_header_common_attr_decoder)

add_subdirectory(test)
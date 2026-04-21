add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_common_encoder SOURCES pcie_transaction_layer_packet_header_common_encoder.vhdl
                                                                          DEPENDS hdl_pcie_transaction_layer_packet_header_common
                                                                                  hdl_pcie_transaction_layer_packet_header_common_fmt_encoder
                                                                                  hdl_pcie_transaction_layer_packet_header_common_attr_encoder)

add_subdirectory(test)
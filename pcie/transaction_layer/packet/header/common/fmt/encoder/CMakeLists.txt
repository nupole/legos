add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_common_fmt_encoder SOURCES pcie_transaction_layer_packet_header_common_fmt_encoder.vhdl
                                                                              DEPENDS hdl_encoder
                                                                                      hdl_pcie_transaction_layer_packet_header_common_fmt)

add_subdirectory(test)
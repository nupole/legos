add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_common_fmt_decoder SOURCES pcie_transaction_layer_packet_header_common_fmt_decoder.vhdl
                                                                              DEPENDS hdl_decoder
                                                                                      hdl_pcie_transaction_layer_packet_header_common_fmt)

add_subdirectory(test)
add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_request_encoder SOURCES pcie_transaction_layer_packet_header_request_encoder.vhdl
                                                                           DEPENDS hdl_math
                                                                                   hdl_encoder
                                                                                   hdl_pcie_transaction_layer_packet_header_request)

add_subdirectory(test)
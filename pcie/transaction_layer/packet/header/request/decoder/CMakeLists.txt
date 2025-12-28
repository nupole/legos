add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_request_decoder SOURCE pcie_transaction_layer_packet_header_request_decoder.vhdl
                                                                           DEPENDS hdl_math
                                                                                   hdl_decoder
                                                                                   hdl_pcie_transaction_layer_packet_header_request)

add_subdirectory(test)
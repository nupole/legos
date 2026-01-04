add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_decoder SOURCE pcie_transaction_layer_packet_header_decoder.vhdl
                                                                   DEPENDS hdl_pcie_transaction_layer_packet_header
                                                                           hdl_pcie_transaction_layer_packet_header_common_decoder
                                                                           hdl_pcie_transaction_layer_packet_header_request_decoder)

add_subdirectory(test)
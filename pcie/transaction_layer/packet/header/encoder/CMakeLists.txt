add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_encoder SOURCE pcie_transaction_layer_packet_header_encoder.vhdl
                                                                   DEPENDS hdl_pcie_transaction_layer_packet_header
                                                                           hdl_pcie_transaction_layer_packet_header_common_encoder
                                                                           hdl_pcie_transaction_layer_packet_header_request_encoder)

add_subdirectory(test)
add_subdirectory(common)
add_subdirectory(request)
add_subdirectory(memory)

add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header SOURCE pcie_transaction_layer_packet_header_pkg.vhdl
                                                           DEPENDS hdl_pcie_transaction_layer_packet_header_common
                                                                   hdl_pcie_transaction_layer_packet_header_request)

add_subdirectory(decoder)
add_subdirectory(encoder)
add_subdirectory(fmt)
add_subdirectory(attr)

add_ghdl_analysis(hdl_pcie_transaction_layer_packet_header_common SOURCE pcie_transaction_layer_packet_header_common_pkg.vhdl
                                                                  DEPENDS hdl_pcie_transaction_layer_packet_header_common_fmt
                                                                          hdl_pcie_transaction_layer_packet_header_common_attr)

add_subdirectory(decoder)
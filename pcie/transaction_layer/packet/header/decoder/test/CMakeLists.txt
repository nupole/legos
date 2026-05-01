add_ghdl_test(test_pcie_transaction_layer_packet_header_decoder ANALYSIS_NAME hdl_pcie_transaction_layer_packet_header_decoder_tb
                                                                ANALYSIS_SOURCE pcie_transaction_layer_packet_header_decoder_tb.vhdl
                                                                ELABORATION_NAME elaboration_pcie_transaction_layer_packet_header_decoder_tb
                                                                DEPENDS hdl_pcie_transaction_layer_packet_header_decoder
                                                                DUT pcie_transaction_layer_packet_header_decoder_tb
                                                                PYTHON_SOURCE test_pcie_transaction_layer_packet_header_decoder.py)
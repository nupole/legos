add_ghdl_test(test_pcie_transaction_layer_packet_header_request_decoder ANALYSIS_NAME hdl_pcie_transaction_layer_packet_header_request_decoder_tb
                                                                        ANALYSIS_SOURCE pcie_transaction_layer_packet_header_request_decoder_tb.vhdl
                                                                        ELABORATION_NAME elaboration_pcie_transaction_layer_packet_header_request_decoder_tb
                                                                        DEPEND hdl_pcie_transaction_layer_packet_header_request_decoder
                                                                        DUT pcie_transaction_layer_packet_header_request_decoder_tb
                                                                        PYTHON_SOURCE test_pcie_transaction_layer_packet_header_request_decoder.py)
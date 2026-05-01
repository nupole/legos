add_ghdl_test(test_pcie_transaction_layer_packet_header_encoder ANALYSIS_NAME hdl_pcie_transaction_layer_packet_header_encoder_tb
                                                                ANALYSIS_SOURCE pcie_transaction_layer_packet_header_encoder_tb.vhdl
                                                                ELABORATION_NAME elaboration_pcie_transaction_layer_packet_header_encoder_tb
                                                                DEPENDS hdl_pcie_transaction_layer_packet_header_encoder
                                                                DUT pcie_transaction_layer_packet_header_encoder_tb
                                                                PYTHON_SOURCE test_pcie_transaction_layer_packet_header_encoder.py)
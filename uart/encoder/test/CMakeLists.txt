add_ghdl_test(test_uart_encoder ANALYSIS_NAME hdl_uart_encoder_tb
                                ANALYSIS_SOURCE uart_encoder_tb.vhdl
                                ELABORATION_NAME elaboration_uart_encoder_tb
                                DEPENDS hdl_uart_encoder
                                DUT uart_encoder_tb
                                PYTHON_SOURCE test_uart_encoder.py)
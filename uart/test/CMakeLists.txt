add_ghdl_test(test_uart ANALYSIS_NAME hdl_uart_tb
                        ANALYSIS_SOURCE uart_tb.vhdl
                        ELABORATION_NAME elaboration_uart_tb
                        DEPENDS hdl_uart
                        DUT uart_tb
                        PYTHON_SOURCE test_uart.py)
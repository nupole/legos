add_ghdl_test(test_decoder ANALYSIS_NAME hdl_decoder_tb
                           ANALYSIS_SOURCE decoder_tb.vhdl
                           ELABORATION_NAME elaboration_decoder_tb
                           DEPEND hdl_decoder
                           DUT decoder_tb
                           PYTHON_SOURCE test_decoder.py)
add_ghdl_test(test_encoder ANALYSIS_NAME hdl_encoder_tb
                           ANALYSIS_SOURCE encoder_tb.vhdl
                           ELABORATION_NAME elaboration_encoder_tb
                           DEPEND hdl_encoder
                           DUT encoder_tb
                           PYTHON_SOURCE test_encoder.py)
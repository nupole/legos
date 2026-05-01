add_ghdl_test(test_priority_encoder ANALYSIS_NAME hdl_priority_encoder_tb
                                    ANALYSIS_SOURCE priority_encoder_tb.vhdl
                                    ELABORATION_NAME elaboration_priority_encoder_tb
                                    DEPENDS hdl_math
                                            hdl_priority_encoder
                                    DUT priority_encoder_tb
                                    PYTHON_SOURCE test_priority_encoder.py)
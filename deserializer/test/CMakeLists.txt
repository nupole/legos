add_ghdl_test(test_deserializer ANALYSIS_NAME hdl_deserializer_tb
                                ANALYSIS_SOURCE deserializer_tb.vhdl
                                ELABORATION_NAME elaboration_deserializer_tb
                                DEPEND hdl_deserializer
                                DUT deserializer_tb
                                PYTHON_SOURCE test_deserializer.py)
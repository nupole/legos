add_ghdl_test(test_serializer ANALYSIS_NAME hdl_serializer_tb
                              ANALYSIS_SOURCE serializer_tb.vhdl
                              ELABORATION_NAME elaboration_serializer_tb
                              DEPENDS hdl_serializer
                              DUT serializer_tb
                              PYTHON_SOURCE test_serializer.py)
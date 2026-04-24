add_ghdl_test(test_counter ANALYSIS_NAME hdl_counter_tb
                           ANALYSIS_SOURCE counter_tb.vhdl
                           ELABORATION_NAME elaboration_counter_tb
                           DEPEND hdl_counter
                           DUT counter_tb
                           PYTHON_SOURCE test_counter.py)
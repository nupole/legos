add_ghdl_test(test_shift_register ANALYSIS_NAME hdl_shift_register_tb
                                  ANALYSIS_SOURCE shift_register_tb.vhdl
                                  ELABORATION_NAME elaboration_shift_register_tb
                                  DEPEND hdl_shift_register
                                  DUT shift_register_tb
                                  PYTHON_SOURCE test_shift_register.py)
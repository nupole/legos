add_ghdl_test(test_priority_arbiter ANALYSIS_NAME hdl_priority_arbiter_tb
                                    ANALYSIS_SOURCE priority_arbiter_tb.vhdl
                                    ELABORATION_NAME elaboration_priority_arbiter_tb
                                    DEPENDS hdl_math
                                            hdl_priority_arbiter
                                    DUT priority_arbiter_tb
                                    PYTHON_SOURCE test_priority_arbiter.py)
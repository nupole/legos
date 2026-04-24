library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package counter_pkg is
    type counter_opcode_t is (COUNTER_OPCODE_NOOP,
                              COUNTER_OPCODE_DECR,
                              COUNTER_OPCODE_INCR,
                              COUNTER_OPCODE_LOAD);

    type counter_instruction_t is record
        opcode:  counter_opcode_t;
        operand: unsigned;
    end record;

    function update_counter(instruction: counter_instruction_t;
                            result:      unsigned) return unsigned;
end package;

package body counter_pkg is
    function update_counter(instruction: counter_instruction_t;
                            result:      unsigned) return unsigned is
        variable next_result: unsigned(result'RANGE);
    begin
        case instruction.opcode is
            when COUNTER_OPCODE_NOOP => next_result := result;
            when COUNTER_OPCODE_DECR => next_result := result - '1';
            when COUNTER_OPCODE_INCR => next_result := result + '1';
            when COUNTER_OPCODE_LOAD => next_result := instruction.operand;
        end case;
        return next_result;
    end function;
end package body;
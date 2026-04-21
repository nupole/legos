library ieee;
use ieee.std_logic_1164.all;

package shift_register_pkg is 
    type shift_register_opcode_t is (SHIFT_REGISTER_OPCODE_NOOP,
                                     SHIFT_REGISTER_OPCODE_SLL,
                                     SHIFT_REGISTER_OPCODE_SRL,
                                     SHIFT_REGISTER_OPCODE_LOAD);

    type shift_register_instruction_t is record
        opcode:  shift_register_opcode_t;
        operand: std_logic_vector;
    end record;

    function update_shift_register(NUMBER_OF_SHIFTS_PER_INSTRUCTION: positive;
                                   instruction:                      shift_register_instruction_t;
                                   data:                             std_logic_vector) return std_logic_vector;
end package;

package body shift_register_pkg is
    function update_shift_register(NUMBER_OF_SHIFTS_PER_INSTRUCTION: positive;
                                   instruction:                      shift_register_instruction_t;
                                   data:                             std_logic_vector) return std_logic_vector is
        constant UPPER_INDEX: natural := data'LEFT;
        variable result:      std_logic_vector(data'RANGE);
    begin
        case instruction.opcode is
            when SHIFT_REGISTER_OPCODE_NOOP => result := data;
            when SHIFT_REGISTER_OPCODE_SLL  => result := data((UPPER_INDEX-NUMBER_OF_SHIFTS_PER_INSTRUCTION) downto 0) & instruction.operand((NUMBER_OF_SHIFTS_PER_INSTRUCTION-1) downto 0);
            when SHIFT_REGISTER_OPCODE_SRL  => result := instruction.operand(UPPER_INDEX downto (UPPER_INDEX-NUMBER_OF_SHIFTS_PER_INSTRUCTION+1)) & data(UPPER_INDEX downto NUMBER_OF_SHIFTS_PER_INSTRUCTION);
            when SHIFT_REGISTER_OPCODE_LOAD => result := instruction.operand;
        end case;
        return result;
    end function;
end package body;
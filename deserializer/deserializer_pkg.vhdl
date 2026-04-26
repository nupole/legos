library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package deserializer_pkg is
    type deserializer_operand_t is record
        number_of_words: unsigned;
        data:            std_logic_vector;
    end record;

    type deserializer_state_t is (DESERIALIZER_STATE_IDLE,
                                  DESERIALIZER_STATE_DESERIALIZE);
end package;
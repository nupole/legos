library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package serializer_pkg is
    type serializer_operand_t is record
        number_of_words: unsigned;
        data:            std_logic_vector;
    end record;

    type serializer_state_t is (SERIALIZER_STATE_IDLE,
                                SERIALIZER_STATE_SERIALIZE);
end package;
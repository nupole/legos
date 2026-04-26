library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_counter;
use hdl_counter.counter_pkg.all;

library hdl_shift_register;
use hdl_shift_register.shift_register_pkg.all;

library hdl_serializer;
use hdl_serializer.serializer_pkg.all;

entity serializer is
    generic(OPERAND_DATA_WIDTH: positive := 64;
            RESULT_WIDTH:       positive := 8);
    port(clk:           in  std_logic;
         rst:           in  std_logic;
         ready_operand: out std_logic;
         valid_operand: in  std_logic;
         operand:       in  serializer_operand_t(number_of_words((log2(OPERAND_DATA_WIDTH/RESULT_WIDTH)-1) downto 0), data((OPERAND_DATA_WIDTH-1) downto 0));
         ready_result:  in  std_logic;
         valid_result:  out std_logic;
         result:        out std_logic_vector((RESULT_WIDTH-1) downto 0));
end entity;

architecture rtl of serializer is
    constant NUMBER_OF_WORDS:       positive := OPERAND_DATA_WIDTH / RESULT_WIDTH;
    constant NUMBER_OF_WORDS_WIDTH: natural  := log2(NUMBER_OF_WORDS);

    signal number_of_words_serialized_counter_opcode_c: counter_opcode_t;
    signal number_of_words_serialized_counter_result:   unsigned((NUMBER_OF_WORDS_WIDTH-1) downto 0);

    signal result_shift_register_opcode_c: shift_register_opcode_t;
    signal result_shift_register_result:   std_logic_vector((OPERAND_DATA_WIDTH-1) downto 0);

    signal number_of_words_to_serialize_c: unsigned((NUMBER_OF_WORDS_WIDTH-1) downto 0);
    signal number_of_words_to_serialize_r: unsigned((NUMBER_OF_WORDS_WIDTH-1) downto 0);

    signal ready_operand_c: std_logic;
    signal valid_result_c:  std_logic;

    signal state_c: serializer_state_t;
    signal state_r: serializer_state_t;
begin
    number_of_words_serialized_counter: entity hdl_counter.counter generic map(RESULT_WIDTH => NUMBER_OF_WORDS_WIDTH)
                                                                   port map(clk                 => clk,
                                                                            rst                 => rst,
                                                                            instruction.opcode  => number_of_words_serialized_counter_opcode_c,
                                                                            instruction.operand => (others => '0'),
                                                                            next_result         => open,
                                                                            result              => number_of_words_serialized_counter_result);

    result_shift_register: entity hdl_shift_register.shift_register generic map(NUMBER_OF_SHIFTS_PER_INSTRUCTION => RESULT_WIDTH,
                                                                                RESULT_WIDTH                     => OPERAND_DATA_WIDTH)
                                                                    port map(clk                 => clk,
                                                                             instruction.opcode  => result_shift_register_opcode_c,
                                                                             instruction.operand => operand.data,
                                                                             result              => result_shift_register_result);

    process(all) begin
        number_of_words_serialized_counter_opcode_c <= COUNTER_OPCODE_NOOP;
        result_shift_register_opcode_c              <= SHIFT_REGISTER_OPCODE_NOOP;
        number_of_words_to_serialize_c              <= number_of_words_to_serialize_r;
        ready_operand_c                             <= ready_operand;
        valid_result_c                              <= valid_result;
        state_c                                     <= state_r;
        case(state_r) is
            when SERIALIZER_STATE_IDLE =>
                number_of_words_serialized_counter_opcode_c <= COUNTER_OPCODE_LOAD;
                result_shift_register_opcode_c              <= SHIFT_REGISTER_OPCODE_LOAD;
                number_of_words_to_serialize_c              <= operand.number_of_words;
                if(valid_operand) then
                    ready_operand_c <= '0';
                    valid_result_c  <= '1';
                    state_c         <= SERIALIZER_STATE_SERIALIZE;
                end if;

            when SERIALIZER_STATE_SERIALIZE =>
                if(ready_result) then
                    number_of_words_serialized_counter_opcode_c <= COUNTER_OPCODE_INCR;
                    result_shift_register_opcode_c              <= SHIFT_REGISTER_OPCODE_SRL;
                    if(number_of_words_serialized_counter_result = number_of_words_to_serialize_r) then
                        ready_operand_c <= '1';
                        valid_result_c  <= '0';
                        state_c         <= SERIALIZER_STATE_IDLE;
                    end if;
                end if;
        end case;
    end process;

    process(clk) begin
        if(rising_edge(clk)) then
            number_of_words_to_serialize_r <= number_of_words_to_serialize_c;
        end if;
    end process;

    process(clk) begin
        if(rising_edge(clk)) then
            if(rst) then
                ready_operand <= '1';
                valid_result  <= '0';
                state_r       <= SERIALIZER_STATE_IDLE;
            else
                ready_operand <= ready_operand_c;
                valid_result  <= valid_result_c;
                state_r       <= state_c;
            end if;
        end if;
    end process;

    result <= result_shift_register_result((RESULT_WIDTH-1) downto 0);
end architecture;
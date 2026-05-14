library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_counter;
use hdl_counter.counter_pkg.all;

library hdl_serializer;

entity uart_encoder is
    generic(CLK_FREQUENCY: positive := 100000000;
            BAUD_RATE:     positive := 115200;
            FRAME_WIDTH:   positive := 8);
    port(clk:         in  std_logic;
         rst:         in  std_logic;
         tx:          out std_logic;
         ready_frame: out std_logic;
         valid_frame: in  std_logic;
         frame:       in  std_logic_vector((FRAME_WIDTH-1) downto 0));
end entity;

architecture rtl of uart_encoder is
    constant CLKS_PER_BAUD_RATE_BEAT:             positive := CLK_FREQUENCY / BAUD_RATE;
    constant BAUD_RATE_BEAT_COUNTER_RESULT_WIDTH: positive := log2(CLKS_PER_BAUD_RATE_BEAT);

    constant TX_SERIALIZER_OPERAND_DATA_WIDTH:            positive := FRAME_WIDTH + 2;
    constant TX_SERIALIZER_OPERAND_NUMBER_OF_WORDS_WIDTH: positive := log2(TX_SERIALIZER_OPERAND_DATA_WIDTH);

    constant TX_SERIALIZER_OPERAND_NUMBER_OF_WORDS: unsigned((TX_SERIALIZER_OPERAND_NUMBER_OF_WORDS_WIDTH-1) downto 0) := to_unsigned(TX_SERIALIZER_OPERAND_DATA_WIDTH - 1, TX_SERIALIZER_OPERAND_NUMBER_OF_WORDS_WIDTH);

    signal baud_rate_beat_counter_opcode_c: counter_opcode_t;
    signal baud_rate_beat_counter_result:   unsigned((BAUD_RATE_BEAT_COUNTER_RESULT_WIDTH-1) downto 0);

    signal tx_serializer_ready_result_c: std_logic;
    signal tx_serializer_ready_result_r: std_logic;
    signal tx_serializer_valid_result:   std_logic;
    signal tx_serializer_result:         std_logic;

    signal tx_c: std_logic;
begin
    baud_rate_beat_counter: entity hdl_counter.counter generic map(RESULT_WIDTH => BAUD_RATE_BEAT_COUNTER_RESULT_WIDTH)
                                                       port map(clk                 => clk,
                                                                rst                 => rst,
                                                                instruction.opcode  => baud_rate_beat_counter_opcode_c,
                                                                instruction.operand => (others => '0'),
                                                                result              => baud_rate_beat_counter_result);

    tx_serializer: entity hdl_serializer.serializer generic map(OPERAND_DATA_WIDTH => TX_SERIALIZER_OPERAND_DATA_WIDTH,
                                                                RESULT_WIDTH       => 1)
                                                    port map(clk                     => clk,
                                                             rst                     => rst,
                                                             ready_operand           => ready_frame,
                                                             valid_operand           => valid_frame,
                                                             operand.number_of_words => TX_SERIALIZER_OPERAND_NUMBER_OF_WORDS,
                                                             operand.data            => ('1' & frame & '0'),
                                                             ready_result            => tx_serializer_ready_result_r,
                                                             valid_result            => tx_serializer_valid_result,
                                                             result(0)               => tx_serializer_result);

    process(all) begin
        baud_rate_beat_counter_opcode_c <= COUNTER_OPCODE_INCR;
        tx_serializer_ready_result_c    <= '0';
        if baud_rate_beat_counter_result = CLKS_PER_BAUD_RATE_BEAT - 1 then
            baud_rate_beat_counter_opcode_c <= COUNTER_OPCODE_LOAD;
            tx_serializer_ready_result_c    <= '1';
        end if;
    end process;

    process(all) begin
        tx_c <= tx;
        if tx_serializer_ready_result_r and tx_serializer_valid_result then
            tx_c <= tx_serializer_result;
        end if;
    end process;

    process(clk) begin
        if(rising_edge(clk)) then
            if(rst) then
                tx_serializer_ready_result_r <= '0';
                tx                           <= '1';
            else
                tx_serializer_ready_result_r <= tx_serializer_ready_result_c;
                tx                           <= tx_c;
            end if;
        end if;
    end process;
end architecture;
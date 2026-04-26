library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_serializer;

entity serializer_tb is
    generic(OPERAND_DATA_WIDTH: positive := 4;
            RESULT_WIDTH:       positive := 1);
    port(clk:                     in  std_logic;
         rst:                     in  std_logic;
         ready_operand:           out std_logic;
         valid_operand:           in  std_logic;
         operand_number_of_words: in  unsigned((log2(OPERAND_DATA_WIDTH/RESULT_WIDTH)-1) downto 0);
         operand_data:            in  std_logic_vector((OPERAND_DATA_WIDTH-1) downto 0);
         ready_result:            in  std_logic;
         valid_result:            out std_logic;
         result:                  out std_logic_vector((RESULT_WIDTH-1) downto 0));
end entity;

architecture rtl of serializer_tb is
begin
    dut: entity hdl_serializer.serializer generic map(OPERAND_DATA_WIDTH => OPERAND_DATA_WIDTH,
                                                      RESULT_WIDTH       => RESULT_WIDTH)
                                          port map(clk                     => clk,
                                                   rst                     => rst,
                                                   ready_operand           => ready_operand,
                                                   valid_operand           => valid_operand,
                                                   operand.number_of_words => operand_number_of_words,
                                                   operand.data            => operand_data,
                                                   ready_result            => ready_result,
                                                   valid_result            => valid_result,
                                                   result                  => result);
end architecture;
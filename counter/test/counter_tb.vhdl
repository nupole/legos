library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_counter;
use hdl_counter.counter_pkg.all;

entity counter_tb is
    generic(RESULT_WIDTH: positive := 4);
    port(clk:                 in  std_logic;
         instruction_opcode:  in  counter_opcode_t;
         instruction_operand: in  unsigned((RESULT_WIDTH-1) downto 0);
         result:              out unsigned((RESULT_WIDTH-1) downto 0));
end entity;

architecture rtl of counter_tb is
begin
    dut: entity hdl_counter.counter generic map(RESULT_WIDTH => RESULT_WIDTH)
                                    port map(clk                 => clk,
                                             rst                 => '0',
                                             instruction.opcode  => instruction_opcode,
                                             instruction.operand => instruction_operand,
                                             next_result         => open,
                                             result              => result);
end architecture;
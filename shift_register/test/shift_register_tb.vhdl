library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_shift_register;
use hdl_shift_register.shift_register_pkg.all;

entity shift_register_tb is
    generic(NUMBER_OF_SHIFTS_PER_INSTRUCTION: positive := 1;
            RESULT_WIDTH:                     positive := 4);
    port(clk:                 in  std_logic;
         instruction_opcode:  in  shift_register_opcode_t;
         instruction_operand: in  std_logic_vector((RESULT_WIDTH-1) downto 0);
         result:              out std_logic_vector((RESULT_WIDTH-1) downto 0));
end entity;

architecture rtl of shift_register_tb is
begin
    dut: entity hdl_shift_register.shift_register generic map(NUMBER_OF_SHIFTS_PER_INSTRUCTION => NUMBER_OF_SHIFTS_PER_INSTRUCTION,
                                                              RESULT_WIDTH                     => RESULT_WIDTH)
                                                  port map(clk                 => clk,
                                                           instruction.opcode  => instruction_opcode,
                                                           instruction.operand => instruction_operand,
                                                           result              => result);
end architecture;
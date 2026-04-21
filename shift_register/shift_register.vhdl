library ieee;
use ieee.std_logic_1164.all;

library hdl_shift_register;
use hdl_shift_register.shift_register_pkg.all;

entity shift_register is
    generic(NUMBER_OF_SHIFTS_PER_INSTRUCTION: positive := 8;
            RESULT_WIDTH:                     positive := 64);
    port(clk:         in  std_logic;
         instruction: in  shift_register_instruction_t(operand((RESULT_WIDTH-1) downto 0));
         result:      out std_logic_vector((RESULT_WIDTH-1) downto 0));
end entity;

architecture rtl of shift_register is
begin
    process(clk) begin
        if(rising_edge(clk)) then
            result <= update_shift_register(NUMBER_OF_SHIFTS_PER_INSTRUCTION, instruction, result);
        end if;
    end process;
end architecture;
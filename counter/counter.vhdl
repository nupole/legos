library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_counter;
use hdl_counter.counter_pkg.all;

entity counter is
    generic(RESULT_WIDTH: positive := 64);
    port(clk:         in  std_logic;
         rst:         in  std_logic;
         instruction: in  counter_instruction_t(operand((RESULT_WIDTH-1) downto 0));
         next_result: out unsigned((RESULT_WIDTH-1) downto 0);
         result:      out unsigned((RESULT_WIDTH-1) downto 0));
end entity;

architecture rtl of counter is
begin
    next_result <= update_counter(instruction, result);

    process(clk) begin
        if(rising_edge(clk)) then
            if(rst) then
                result <= (others => '0');
            else
                result <= next_result;
            end if;
        end if;
    end process;
end architecture;
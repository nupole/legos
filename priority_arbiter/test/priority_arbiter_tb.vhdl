library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_priority_arbiter;

entity priority_arbiter_tb is
    generic(OUTPUT_REGISTER:   boolean  := true;
            REQUEST_WIDTH:     positive := 4;
            GRANT_INDEX_WIDTH: positive := log2(REQUEST_WIDTH));
    port(clk:         in  std_logic;
         request:     in  std_logic_vector((REQUEST_WIDTH-1) downto 0);
         grant:       out std_logic_vector((REQUEST_WIDTH-1) downto 0);
         grant_index: out unsigned((GRANT_INDEX_WIDTH-1) downto 0));
end entity;

architecture rtl of priority_arbiter_tb is
begin
    dut: entity hdl_priority_arbiter.priority_arbiter generic map(OUTPUT_REGISTER   => OUTPUT_REGISTER,
                                                                  REQUEST_WIDTH     => REQUEST_WIDTH)
                                                      port map(clk         => clk,
                                                               request     => request,
                                                               grant       => grant,
                                                               grant_index => grant_index);
end architecture;
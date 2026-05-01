library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_priority_encoder;

entity priority_arbiter is
    generic(OUTPUT_REGISTER:   boolean  := true;
            REQUEST_WIDTH:     positive := 8;
            GRANT_INDEX_WIDTH: positive := log2(REQUEST_WIDTH));
    port(clk:         in  std_logic;
         request:     in  std_logic_vector((REQUEST_WIDTH-1) downto 0);
         grant:       out std_logic_vector((REQUEST_WIDTH-1) downto 0);
         grant_index: out unsigned((GRANT_INDEX_WIDTH-1) downto 0));
end entity;

architecture rtl of priority_arbiter is
    signal grant_c: std_logic_vector((REQUEST_WIDTH-1) downto 0);
begin
    process(all) begin
        grant_c(0) <= request(0);
        for index in request'RANGE loop
            grant_c(index) <= request(index) and not (or request((index-1) downto 0));
        end loop;
    end process;

    generate_output: if(OUTPUT_REGISTER) generate
        process(clk) begin
            if(rising_edge(clk)) then
                grant <= grant_c;
            end if;
        end process;
    else generate
        grant <= grant_c;
    end generate;

    grant_index_priority_encoder: entity hdl_priority_encoder.priority_encoder generic map(OUTPUT_REGISTER => OUTPUT_REGISTER,
                                                                                           REQUEST_WIDTH   => REQUEST_WIDTH)
                                                                               port map(clk         => clk,
                                                                                        request     => request,
                                                                                        grant_index => grant_index);
end architecture;
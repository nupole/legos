library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

entity priority_encoder is
    generic(OUTPUT_REGISTER:   boolean  := true;
            REQUEST_WIDTH:     positive := 4;
            GRANT_INDEX_WIDTH: positive := log2(REQUEST_WIDTH));
    port(clk:         in  std_logic;
         request:     in  std_logic_vector((REQUEST_WIDTH-1) downto 0);
         grant_index: out unsigned((GRANT_INDEX_WIDTH-1) downto 0));
end entity;

architecture rtl of priority_encoder is
    signal grant_index_c: unsigned((GRANT_INDEX_WIDTH-1) downto 0);
begin
    process(all) begin
        grant_index_c <= (others => '0');
        for index in request'RANGE loop
            if(request(index)) then
                grant_index_c <= to_unsigned(index, GRANT_INDEX_WIDTH);
            end if;
        end loop;
    end process;

    generate_output: if(OUTPUT_REGISTER) generate
        process(clk) begin
            if(rising_edge(clk)) then
                grant_index <= grant_index_c;
            end if;
        end process;
    else generate
        grant_index <= grant_index_c;
    end generate;
end architecture;
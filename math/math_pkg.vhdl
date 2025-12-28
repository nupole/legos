library ieee;
use ieee.std_logic_1164.all;

package math_pkg is
    constant BYTE_WIDTH: positive := 8;

    function reverse_endianness(data: std_logic_vector) return std_logic_vector;
end package;

package body math_pkg is
    function reverse_endianness(data: std_logic_vector) return std_logic_vector is
        constant DATA_WIDTH:      positive := data'LENGTH;
        constant NUMBER_OF_BYTES: positive := DATA_WIDTH / BYTE_WIDTH;

        variable result: std_logic_vector(data'RANGE);
    begin
        for i in 0 to NUMBER_OF_BYTES-1 loop
            result((BYTE_WIDTH*(i+1)-1) downto BYTE_WIDTH*i) := data((DATA_WIDTH-BYTE_WIDTH*i-1) downto (DATA_WIDTH-BYTE_WIDTH*(i+1)));
        end loop;
        return result;
    end function;
end package body;
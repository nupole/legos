library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encoder is
    generic(UPSTREAM_WORD_WIDTH:         positive := 16;
            DOWNSTREAM_WORD_INDEX_WIDTH: positive := 8;
            DOWNSTREAM_WORD_BIT_OFFSET:  natural  := 0;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         upstream_word:         in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of encoder is
    constant WORD_INDEX: unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0) := to_unsigned(DOWNSTREAM_WORD_BIT_OFFSET / DOWNSTREAM_WORD_WIDTH, DOWNSTREAM_WORD_INDEX_WIDTH);

    constant BIT_OFFSET: natural := DOWNSTREAM_WORD_BIT_OFFSET mod DOWNSTREAM_WORD_WIDTH;

    signal downstream_word_c: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    process(all) begin
        downstream_word_c <= (others => '0');
        if(downstream_word_index = WORD_INDEX) then
            downstream_word_c((UPSTREAM_WORD_WIDTH+BIT_OFFSET-1) downto BIT_OFFSET) <= upstream_word;
        end if;
    end process;

    process(clk) begin
        if(rising_edge(clk)) then
            downstream_word <= downstream_word_c;
        end if;
    end process;
end architecture;
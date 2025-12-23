library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 8;
            UPSTREAM_WORD_BIT_OFFSET:  natural  := 0;
            UPSTREAM_WORD_WIDTH:       positive := 64;
            DOWNSTREAM_WORD_WIDTH:     positive := 16);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         downstream_word:     out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of decoder is
    constant WORD_INDEX: unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0) := to_unsigned(UPSTREAM_WORD_BIT_OFFSET / UPSTREAM_WORD_WIDTH, UPSTREAM_WORD_INDEX_WIDTH);

    constant BIT_OFFSET: natural := UPSTREAM_WORD_BIT_OFFSET mod UPSTREAM_WORD_WIDTH;

    signal downstream_word_c: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    process(all) begin
        downstream_word_c <= downstream_word;
        if(upstream_word_index = WORD_INDEX) then
            downstream_word_c <= upstream_word((DOWNSTREAM_WORD_WIDTH+BIT_OFFSET-1) downto BIT_OFFSET);
        end if;
    end process;

    process(clk) begin
        if(rising_edge(clk)) then
            downstream_word <= downstream_word_c;
        end if;
    end process;
end architecture;
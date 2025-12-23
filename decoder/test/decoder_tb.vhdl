library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_decoder;

entity decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH:  positive := 4;
            UPSTREAM_WORD_BIT_OFFSET:   natural  := 33;
            UPSTREAM_WORD_WIDTH:        positive := 4;
            DOWNSTREAM_WORD_WIDTH:      positive := 2);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         downstream_word:     out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of decoder_tb is
begin
    dut: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                UPSTREAM_WORD_BIT_OFFSET  => UPSTREAM_WORD_BIT_OFFSET,
                                                UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                DOWNSTREAM_WORD_WIDTH     => DOWNSTREAM_WORD_WIDTH)
                                    port map(clk                 => clk,
                                             upstream_word_index => upstream_word_index,
                                             upstream_word       => upstream_word,
                                             downstream_word     => downstream_word);
end architecture;
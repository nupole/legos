library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_encoder;

entity encoder_tb is
    generic(UPSTREAM_WORD_WIDTH:          positive := 2;
            DOWNSTREAM_WORD_INDEX_WIDTH:  positive := 4;
            DOWNSTREAM_WORD_BIT_OFFSET:   natural  := 33;
            DOWNSTREAM_WORD_WIDTH:        positive := 4);
    port(clk:                   in  std_logic;
         upstream_word:         in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         downstream_word_index: out unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of encoder_tb is
begin
    dut: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => UPSTREAM_WORD_WIDTH,
                                                DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                DOWNSTREAM_WORD_BIT_OFFSET  => DOWNSTREAM_WORD_BIT_OFFSET,
                                                DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                    port map(clk                   => clk,
                                             upstream_word         => upstream_word,
                                             downstream_word_index => downstream_word_index,
                                             downstream_word       => downstream_word);
end architecture;
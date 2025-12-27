library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_decoder;

library hdl_pcie_transaction_layer_packet_header_common_attr;
use hdl_pcie_transaction_layer_packet_header_common_attr.pcie_transaction_layer_packet_header_common_attr_pkg.all;

entity pcie_transaction_layer_packet_header_common_attr_decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         attr:                out pcie_transaction_layer_packet_header_common_attr_t;
         attr_error:          out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_attr_decoder is
begin
    attr_error <= '0';

    id_based_ordering_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                      UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_ID_BASED_ORDERING_BIT_OFFSET,
                                                                      UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                      DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_ID_BASED_ORDERING_WIDTH)
                                                          port map(clk                 => clk,
                                                                   upstream_word_index => upstream_word_index,
                                                                   upstream_word       => upstream_word,
                                                                   downstream_word(0)  => attr.id_based_ordering);

    relaxed_ordering_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                     UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_RELAXED_ORDERING_BIT_OFFSET,
                                                                     UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                     DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_RELAXED_ORDERING_WIDTH)
                                                         port map(clk                 => clk,
                                                                  upstream_word_index => upstream_word_index,
                                                                  upstream_word       => upstream_word,
                                                                  downstream_word(0)  => attr.relaxed_ordering);

    no_snoop_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                             UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_NO_SNOOP_BIT_OFFSET,
                                                             UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                             DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_NO_SNOOP_WIDTH)
                                                 port map(clk                 => clk,
                                                          upstream_word_index => upstream_word_index,
                                                          upstream_word       => upstream_word,
                                                          downstream_word(0)  => attr.no_snoop);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_encoder;

library hdl_pcie_transaction_layer_packet_header_common_attr;
use hdl_pcie_transaction_layer_packet_header_common_attr.pcie_transaction_layer_packet_header_common_attr_pkg.all;

entity pcie_transaction_layer_packet_header_common_attr_encoder is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         attr:                  in  pcie_transaction_layer_packet_header_common_attr_t;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_attr_encoder is
    signal id_based_ordering_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal relaxed_ordering_encoder_downstream_word:  std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal no_snoop_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    downstream_word <= (id_based_ordering_encoder_downstream_word or relaxed_ordering_encoder_downstream_word or no_snoop_encoder_downstream_word);

    id_based_ordering_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_ID_BASED_ORDERING_WIDTH,
                                                                      DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                      DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_ID_BASED_ORDERING_BIT_OFFSET,
                                                                      DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                          port map(clk                   => clk,
                                                                   upstream_word(0)      => attr.id_based_ordering,
                                                                   downstream_word_index => downstream_word_index,
                                                                   downstream_word       => id_based_ordering_encoder_downstream_word);

    relaxed_ordering_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_RELAXED_ORDERING_WIDTH,
                                                                     DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                     DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_RELAXED_ORDERING_BIT_OFFSET,
                                                                     DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                         port map(clk                   => clk,
                                                                  upstream_word(0)      => attr.relaxed_ordering,
                                                                  downstream_word_index => downstream_word_index,
                                                                  downstream_word       => relaxed_ordering_encoder_downstream_word);

    no_snoop_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_NO_SNOOP_WIDTH,
                                                             DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                             DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_NO_SNOOP_BIT_OFFSET,
                                                             DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                      port map(clk                   => clk,
                                                               upstream_word(0)      => attr.no_snoop,
                                                               downstream_word_index => downstream_word_index,
                                                               downstream_word       => no_snoop_encoder_downstream_word);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_encoder;

library hdl_pcie_transaction_layer_packet_header_common_fmt;
use hdl_pcie_transaction_layer_packet_header_common_fmt.pcie_transaction_layer_packet_header_common_fmt_pkg.all;

entity pcie_transaction_layer_packet_header_common_fmt_encoder is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         fmt:                   in  pcie_transaction_layer_packet_header_common_fmt_t;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_fmt_encoder is
    signal tlp_prefix_encoder_downstream_word:     std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal data_indicator_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal header_length_encoder_downstream_word:  std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    downstream_word <= (tlp_prefix_encoder_downstream_word or data_indicator_encoder_downstream_word or header_length_encoder_downstream_word);

    tlp_prefix_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_TLP_PREFIX_WIDTH,
                                                               DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                               DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_TLP_PREFIX_BIT_OFFSET,
                                                               DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                   port map(clk                   => clk,
                                                            upstream_word(0)      => fmt.tlp_prefix,
                                                            downstream_word_index => downstream_word_index,
                                                            downstream_word       => tlp_prefix_encoder_downstream_word);

    data_indicator_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_DATA_INDICATOR_WIDTH,
                                                                   DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                   DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_DATA_INDICATOR_BIT_OFFSET,
                                                                   DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                       port map(clk                   => clk,
                                                                upstream_word(0)      => fmt.data_indicator,
                                                                downstream_word_index => downstream_word_index,
                                                                downstream_word       => data_indicator_encoder_downstream_word);

    header_length_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_HEADER_LENGTH_WIDTH,
                                                                  DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                  DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_HEADER_LENGTH_BIT_OFFSET,
                                                                  DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                      port map(clk                   => clk,
                                                               upstream_word(0)      => fmt.header_length,
                                                               downstream_word_index => downstream_word_index,
                                                               downstream_word       => header_length_encoder_downstream_word);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_decoder;

library hdl_pcie_transaction_layer_packet_header_common_fmt;
use hdl_pcie_transaction_layer_packet_header_common_fmt.pcie_transaction_layer_packet_header_common_fmt_pkg.all;

entity pcie_transaction_layer_packet_header_common_fmt_decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         fmt:                 out pcie_transaction_layer_packet_header_common_fmt_t;
         fmt_error:           out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_fmt_decoder is
begin
    fmt_error <= fmt.tlp_prefix and (fmt.data_indicator or fmt.header_length);

    fmt_tlp_prefix_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                   UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_TLP_PREFIX_BIT_OFFSET,
                                                                   UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                   DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_TLP_PREFIX_WIDTH)
                                                       port map(clk                 => clk,
                                                                upstream_word_index => upstream_word_index,
                                                                upstream_word       => upstream_word,
                                                                downstream_word(0)  => fmt.tlp_prefix);

    fmt_data_indicator_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_DATA_INDICATOR_BIT_OFFSET,
                                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_DATA_INDICATOR_WIDTH)
                                                           port map(clk                 => clk,
                                                                    upstream_word_index => upstream_word_index,
                                                                    upstream_word       => upstream_word,
                                                                    downstream_word(0)  => fmt.data_indicator);

    fmt_header_length_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                      UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_HEADER_LENGTH_BIT_OFFSET,
                                                                      UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                      DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_HEADER_LENGTH_WIDTH)
                                                           port map(clk                 => clk,
                                                                    upstream_word_index => upstream_word_index,
                                                                    upstream_word       => upstream_word,
                                                                    downstream_word(0)  => fmt.header_length);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_encoder;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_fmt_encoder;

library hdl_pcie_transaction_layer_packet_header_common_attr_encoder;

entity pcie_transaction_layer_packet_header_common_encoder is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         common:                in  pcie_transaction_layer_packet_header_common_t;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_encoder is
    signal fmt_encoder_downstream_word:         std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal packet_type_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal tc_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal attr_encoder_downstream_word:        std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal th_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal td_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal ep_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal at_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal length_msb_encoder_downstream_word:  std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal length_lsb_encoder_downstream_word:  std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    downstream_word <= (fmt_encoder_downstream_word or packet_type_encoder_downstream_word or tc_encoder_downstream_word or attr_encoder_downstream_word or th_encoder_downstream_word or td_encoder_downstream_word or ep_encoder_downstream_word or at_encoder_downstream_word or length_msb_encoder_downstream_word or length_lsb_encoder_downstream_word);

    fmt_encoder: entity hdl_pcie_transaction_layer_packet_header_common_fmt_encoder.pcie_transaction_layer_packet_header_common_fmt_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                        DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                                            port map(clk                   => clk,
                                                                                                                                                     fmt                   => common.fmt,
                                                                                                                                                     downstream_word_index => downstream_word_index,
                                                                                                                                                     downstream_word       => fmt_encoder_downstream_word);

    packet_type_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH,
                                                                DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_BIT_OFFSET,
                                                                DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                    port map(clk                   => clk,
                                                             upstream_word         => common.packet_type,
                                                             downstream_word_index => downstream_word_index,
                                                             downstream_word       => packet_type_encoder_downstream_word);

    tc_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH,
                                                       DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                       DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_BIT_OFFSET,
                                                       DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                           port map(clk                   => clk,
                                                    upstream_word         => common.tc,
                                                    downstream_word_index => downstream_word_index,
                                                    downstream_word       => tc_encoder_downstream_word);

    attr_encoder: entity hdl_pcie_transaction_layer_packet_header_common_attr_encoder.pcie_transaction_layer_packet_header_common_attr_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                           DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                                               port map(clk                   => clk,
                                                                                                                                                        attr                  => common.attr,
                                                                                                                                                        downstream_word_index => downstream_word_index,
                                                                                                                                                        downstream_word       => attr_encoder_downstream_word);

    th_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TH_WIDTH,
                                                       DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                       DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TH_BIT_OFFSET,
                                                       DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                           port map(clk                   => clk,
                                                    upstream_word(0)      => common.th,
                                                    downstream_word_index => downstream_word_index,
                                                    downstream_word       => th_encoder_downstream_word);

    td_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TD_WIDTH,
                                                       DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                       DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TD_BIT_OFFSET,
                                                       DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                           port map(clk                   => clk,
                                                    upstream_word(0)      => common.td,
                                                    downstream_word_index => downstream_word_index,
                                                    downstream_word       => td_encoder_downstream_word);

    ep_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_EP_WIDTH,
                                                       DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                       DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_EP_BIT_OFFSET,
                                                       DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                           port map(clk                   => clk,
                                                    upstream_word(0)      => common.ep,
                                                    downstream_word_index => downstream_word_index,
                                                    downstream_word       => ep_encoder_downstream_word);

    at_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH,
                                                       DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                       DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_BIT_OFFSET,
                                                       DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                           port map(clk                   => clk,
                                                    upstream_word         => common.at,
                                                    downstream_word_index => downstream_word_index,
                                                    downstream_word       => at_encoder_downstream_word);

    length_msb_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_WIDTH,
                                                               DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                               DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_BIT_OFFSET,
                                                               DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                   port map(clk                   => clk,
                                                            upstream_word         => std_logic_vector(common.length((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_WIDTH+PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH-1) downto PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH)),
                                                            downstream_word_index => downstream_word_index,
                                                            downstream_word       => length_msb_encoder_downstream_word);

    length_lsb_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH,
                                                               DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                               DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_BIT_OFFSET,
                                                               DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                   port map(clk                   => clk,
                                                            upstream_word         => std_logic_vector(common.length((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH-1) downto 0)),
                                                            downstream_word_index => downstream_word_index,
                                                            downstream_word       => length_lsb_encoder_downstream_word);
end architecture;
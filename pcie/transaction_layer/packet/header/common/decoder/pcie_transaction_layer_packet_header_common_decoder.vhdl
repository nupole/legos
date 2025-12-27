library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_decoder;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_fmt_decoder;

library hdl_pcie_transaction_layer_packet_header_common_attr_decoder;

entity pcie_transaction_layer_packet_header_common_decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         common:              out pcie_transaction_layer_packet_header_common_t;
         common_error:        out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_decoder is
    signal length: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH-1) downto 0);

    signal fmt_error:  std_logic;
    signal attr_error: std_logic;
begin
    fmt_decoder: entity hdl_pcie_transaction_layer_packet_header_common_fmt_decoder.pcie_transaction_layer_packet_header_common_fmt_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                        UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                                            port map(clk                 => clk,
                                                                                                                                                     upstream_word_index => upstream_word_index,
                                                                                                                                                     upstream_word       => upstream_word,
                                                                                                                                                     fmt                 => common.fmt,
                                                                                                                                                     fmt_error           => fmt_error);

    packet_type_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_BIT_OFFSET,
                                                                UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                DOWNSTREAM_WORD_WIDTH      => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH)
                                                    port map(clk                 => clk,
                                                             upstream_word_index => upstream_word_index,
                                                             upstream_word       => upstream_word,
                                                             downstream_word     => common.packet_type);

    tc_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_BIT_OFFSET,
                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH)
                                                  port map(clk                 => clk,
                                                           upstream_word_index => upstream_word_index,
                                                           upstream_word       => upstream_word,
                                                           downstream_word     => common.tc);

    attr_decoder: entity hdl_pcie_transaction_layer_packet_header_common_attr_decoder.pcie_transaction_layer_packet_header_common_attr_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                           UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                                               port map(clk                 => clk,
                                                                                                                                                        upstream_word_index => upstream_word_index,
                                                                                                                                                        upstream_word       => upstream_word,
                                                                                                                                                        attr                => common.attr,
                                                                                                                                                        attr_error          => attr_error);

    th_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TH_BIT_OFFSET,
                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TH_WIDTH)
                                                  port map(clk                 => clk,
                                                           upstream_word_index => upstream_word_index,
                                                           upstream_word       => upstream_word,
                                                           downstream_word(0)  => common.th);

    td_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TD_BIT_OFFSET,
                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TD_WIDTH)
                                                  port map(clk                 => clk,
                                                           upstream_word_index => upstream_word_index,
                                                           upstream_word       => upstream_word,
                                                           downstream_word(0)  => common.td);

    ep_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_EP_BIT_OFFSET,
                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_EP_WIDTH)
                                                  port map(clk                 => clk,
                                                           upstream_word_index => upstream_word_index,
                                                           upstream_word       => upstream_word,
                                                           downstream_word(0)  => common.ep);

    at_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_BIT_OFFSET,
                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH)
                                                  port map(clk                 => clk,
                                                           upstream_word_index => upstream_word_index,
                                                           upstream_word       => upstream_word,
                                                           downstream_word     => common.at);

    length_msb_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                               UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_BIT_OFFSET,
                                                               UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                               DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_WIDTH)
                                                          port map(clk                 => clk,
                                                                   upstream_word_index => upstream_word_index,
                                                                   upstream_word       => upstream_word,
                                                                   downstream_word     => length((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_WIDTH+PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH-1) downto PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH));

    length_lsb_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                               UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_BIT_OFFSET,
                                                               UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                               DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH)
                                                          port map(clk                 => clk,
                                                                   upstream_word_index => upstream_word_index,
                                                                   upstream_word       => upstream_word,
                                                                   downstream_word     => length((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH-1) downto 0));

    common.length <= unsigned(length);
    common_error  <= fmt_error or attr_error;
end architecture;
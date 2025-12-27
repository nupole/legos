library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_decoder;

entity pcie_transaction_layer_packet_header_common_decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 8);
    port(clk:                           in  std_logic;
         upstream_word_index:           in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:                 in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         common_fmt_tlp_prefix:         out std_logic;
         common_fmt_data_indicator:     out std_logic;
         common_fmt_header_length:      out std_logic;
         common_packet_type:            out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH-1) downto 0);
         common_tc:                     out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH-1) downto 0);
         common_attr_id_based_ordering: out std_logic;
         common_attr_relaxed_ordering:  out std_logic;
         common_attr_no_snoop:          out std_logic;
         common_th:                     out std_logic;
         common_td:                     out std_logic;
         common_ep:                     out std_logic;
         common_at:                     out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH-1) downto 0);
         common_length:                 out unsigned((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH-1) downto 0);
         common_error:                  out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_decoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_common_decoder.pcie_transaction_layer_packet_header_common_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                        UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                            port map(clk                           => clk,
                                                                                                                                     upstream_word_index           => upstream_word_index,
                                                                                                                                     upstream_word                 => upstream_word,
                                                                                                                                     common.fmt.tlp_prefix         => common_fmt_tlp_prefix,
                                                                                                                                     common.fmt.data_indicator     => common_fmt_data_indicator,
                                                                                                                                     common.fmt.header_length      => common_fmt_header_length,
                                                                                                                                     common.packet_type            => common_packet_type,
                                                                                                                                     common.tc                     => common_tc,
                                                                                                                                     common.attr.id_based_ordering => common_attr_id_based_ordering,
                                                                                                                                     common.attr.relaxed_ordering  => common_attr_relaxed_ordering,
                                                                                                                                     common.attr.no_snoop          => common_attr_no_snoop,
                                                                                                                                     common.th                     => common_th,
                                                                                                                                     common.td                     => common_td,
                                                                                                                                     common.ep                     => common_ep,
                                                                                                                                     common.at                     => common_at,
                                                                                                                                     common.length                 => common_length,
                                                                                                                                     common_error                  => common_error);
end architecture;
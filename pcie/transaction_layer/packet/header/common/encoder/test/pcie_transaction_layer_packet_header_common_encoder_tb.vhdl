library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_encoder;

entity pcie_transaction_layer_packet_header_common_encoder_tb is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 8);
    port(clk:                           in  std_logic;
         common_fmt_tlp_prefix:         in  std_logic;
         common_fmt_data_indicator:     in  std_logic;
         common_fmt_header_length:      in  std_logic;
         common_packet_type:            in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH-1) downto 0);
         common_tc:                     in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH-1) downto 0);
         common_attr_id_based_ordering: in  std_logic;
         common_attr_relaxed_ordering:  in  std_logic;
         common_attr_no_snoop:          in  std_logic;
         common_th:                     in  std_logic;
         common_td:                     in  std_logic;
         common_ep:                     in  std_logic;
         common_at:                     in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH-1) downto 0);
         common_length:                 in  unsigned((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH-1) downto 0);
         downstream_word_index:         in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:               out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_encoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_common_encoder.pcie_transaction_layer_packet_header_common_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                        DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                            port map(clk                           => clk,
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
                                                                                                                                     downstream_word_index         => downstream_word_index,
                                                                                                                                     downstream_word               => downstream_word);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

library hdl_pcie_transaction_layer_packet_header_encoder;

entity pcie_transaction_layer_packet_header_encoder_tb is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 16);
    port(clk:                                  in  std_logic;
         header_common_fmt_tlp_prefix:         in  std_logic;
         header_common_fmt_data_indicator:     in  std_logic;
         header_common_fmt_header_length:      in  std_logic;
         header_common_packet_type:            in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH-1) downto 0);
         header_common_tc:                     in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH-1) downto 0);
         header_common_attr_id_based_ordering: in  std_logic;
         header_common_attr_relaxed_ordering:  in  std_logic;
         header_common_attr_no_snoop:          in  std_logic;
         header_common_th:                     in  std_logic;
         header_common_td:                     in  std_logic;
         header_common_ep:                     in  std_logic;
         header_common_at:                     in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH-1) downto 0);
         header_common_length:                 in  unsigned((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH-1) downto 0);
         header_request_requester_id:          in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);
         header_request_tag:                   in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH-1) downto 0);
         header_error:                         in  std_logic;
         downstream_word_index:                in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:                      out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_encoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_encoder.pcie_transaction_layer_packet_header_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                          DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                              port map(clk                                  => clk,
                                                                                                                       header.common.fmt.tlp_prefix         => header_common_fmt_tlp_prefix,
                                                                                                                       header.common.fmt.data_indicator     => header_common_fmt_data_indicator,
                                                                                                                       header.common.fmt.header_length      => header_common_fmt_header_length,
                                                                                                                       header.common.packet_type            => header_common_packet_type,
                                                                                                                       header.common.tc                     => header_common_tc,
                                                                                                                       header.common.attr.id_based_ordering => header_common_attr_id_based_ordering,
                                                                                                                       header.common.attr.relaxed_ordering  => header_common_attr_relaxed_ordering,
                                                                                                                       header.common.attr.no_snoop          => header_common_attr_no_snoop,
                                                                                                                       header.common.th                     => header_common_th,
                                                                                                                       header.common.td                     => header_common_td,
                                                                                                                       header.common.ep                     => header_common_ep,
                                                                                                                       header.common.at                     => header_common_at,
                                                                                                                       header.common.length                 => header_common_length,
                                                                                                                       header.request.requester_id          => header_request_requester_id,
                                                                                                                       header.request.tag                   => header_request_tag,
                                                                                                                       downstream_word_index                => downstream_word_index,
                                                                                                                       downstream_word                      => downstream_word);
end architecture;
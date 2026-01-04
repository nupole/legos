library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

library hdl_pcie_transaction_layer_packet_header_decoder;

entity pcie_transaction_layer_packet_header_decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 16);
    port(clk:                                  in  std_logic;
         upstream_word_index:                  in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:                        in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         header_common_fmt_tlp_prefix:         out std_logic;
         header_common_fmt_data_indicator:     out std_logic;
         header_common_fmt_header_length:      out std_logic;
         header_common_packet_type:            out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH-1) downto 0);
         header_common_tc:                     out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH-1) downto 0);
         header_common_attr_id_based_ordering: out std_logic;
         header_common_attr_relaxed_ordering:  out std_logic;
         header_common_attr_no_snoop:          out std_logic;
         header_common_th:                     out std_logic;
         header_common_td:                     out std_logic;
         header_common_ep:                     out std_logic;
         header_common_at:                     out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH-1) downto 0);
         header_common_length:                 out unsigned((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH-1) downto 0);
         header_request_requester_id:          out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);
         header_request_tag:                   out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH-1) downto 0);
         header_error:                         out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_decoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_decoder.pcie_transaction_layer_packet_header_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                          UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                              port map(clk                                  => clk,
                                                                                                                       upstream_word_index                  => upstream_word_index,
                                                                                                                       upstream_word                        => upstream_word,
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
                                                                                                                       header_error                         => header_error);
end architecture;
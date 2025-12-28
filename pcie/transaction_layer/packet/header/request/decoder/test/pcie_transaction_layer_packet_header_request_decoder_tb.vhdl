library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

library hdl_pcie_transaction_layer_packet_header_request_decoder;

entity pcie_transaction_layer_packet_header_request_decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 2;
            UPSTREAM_WORD_WIDTH:       positive := 16);
    port(clk:                  in  std_logic;
         upstream_word_index:  in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:        in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         request_requester_id: out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);
         request_tag:          out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH-1) downto 0);
         request_error:        out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_request_decoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_request_decoder.pcie_transaction_layer_packet_header_request_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                          UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                              port map(clk                  => clk,
                                                                                                                                       upstream_word_index  => upstream_word_index,
                                                                                                                                       upstream_word        => upstream_word,
                                                                                                                                       request.requester_id => request_requester_id,
                                                                                                                                       request.tag          => request_tag,
                                                                                                                                       request_error        => request_error);
end architecture;
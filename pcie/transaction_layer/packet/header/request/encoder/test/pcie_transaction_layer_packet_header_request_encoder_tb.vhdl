library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

library hdl_pcie_transaction_layer_packet_header_request_encoder;

entity pcie_transaction_layer_packet_header_request_encoder_tb is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 2;
            DOWNSTREAM_WORD_WIDTH:       positive := 16);
    port(clk:                   in  std_logic;
         request_requester_id:  in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);
         request_tag:           in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH-1) downto 0);
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_request_encoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_request_encoder.pcie_transaction_layer_packet_header_request_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                          DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                              port map(clk                   => clk,
                                                                                                                                       request.requester_id  => request_requester_id,
                                                                                                                                       request.tag           => request_tag,
                                                                                                                                       downstream_word_index => downstream_word_index,
                                                                                                                                       downstream_word       => downstream_word);
end architecture;
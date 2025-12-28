library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_decoder;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

entity pcie_transaction_layer_packet_header_request_decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         request:             out pcie_transaction_layer_packet_header_request_t;
         request_error:       out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_request_decoder is
    signal requester_id: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);
begin
    requester_id_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                 UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_BIT_OFFSET,
                                                                 UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                 DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH)
                                                     port map(clk                 => clk,
                                                              upstream_word_index => upstream_word_index,
                                                              upstream_word       => upstream_word,
                                                              downstream_word     => requester_id);

    request.requester_id <= reverse_endianness(requester_id);

    tag_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                        UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_BIT_OFFSET,
                                                        UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                        DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH)
                                            port map(clk                 => clk,
                                                     upstream_word_index => upstream_word_index,
                                                     upstream_word       => upstream_word,
                                                     downstream_word     => request.tag);

    request_error <= '0';
end architecture;
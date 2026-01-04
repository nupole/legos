library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_encoder;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

entity pcie_transaction_layer_packet_header_request_encoder is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         request:               in  pcie_transaction_layer_packet_header_request_t;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_request_encoder is
    signal requester_id: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);

    signal requester_id_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal tag_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    downstream_word <= requester_id_encoder_downstream_word or tag_encoder_downstream_word;

    requester_id_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH,
                                                                 DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                 DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_BIT_OFFSET,
                                                                 DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                     port map(clk                   => clk,
                                                              upstream_word         => requester_id,
                                                              downstream_word_index => downstream_word_index,
                                                              downstream_word       => requester_id_encoder_downstream_word);

    requester_id <= reverse_endianness(request.requester_id);

    tag_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH,
                                                        DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                        DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_BIT_OFFSET,
                                                        DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                            port map(clk                   => clk,
                                                     upstream_word         => request.tag,
                                                     downstream_word_index => downstream_word_index,
                                                     downstream_word       => tag_encoder_downstream_word);
end architecture;
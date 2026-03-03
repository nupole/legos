library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header;
use hdl_pcie_transaction_layer_packet_header.pcie_transaction_layer_packet_header_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_encoder;

library hdl_pcie_transaction_layer_packet_header_request_encoder;

entity pcie_transaction_layer_packet_header_encoder is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         header:                in  pcie_transaction_layer_packet_header_t;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_encoder is
    signal common_encoder_downstream_word:  std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal request_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    common_encoder: entity hdl_pcie_transaction_layer_packet_header_common_encoder.pcie_transaction_layer_packet_header_common_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                   DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                                       port map(clk                   => clk,
                                                                                                                                                common                => header.common,
                                                                                                                                                downstream_word_index => downstream_word_index,
                                                                                                                                                downstream_word       => common_encoder_downstream_word);

    request_encoder: entity hdl_pcie_transaction_layer_packet_header_request_encoder.pcie_transaction_layer_packet_header_request_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                      DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                                          port map(clk                   => clk,
                                                                                                                                                   request               => header.request,
                                                                                                                                                   downstream_word_index => downstream_word_index,
                                                                                                                                                   downstream_word       => request_encoder_downstream_word);

    downstream_word <= common_encoder_downstream_word or request_encoder_downstream_word;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header;
use hdl_pcie_transaction_layer_packet_header.pcie_transaction_layer_packet_header_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_decoder;

library hdl_pcie_transaction_layer_packet_header_request_decoder;

entity pcie_transaction_layer_packet_header_decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         header:              out pcie_transaction_layer_packet_header_t;
         header_error:        out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_decoder is
    signal common_error:  std_logic;
    signal request_error: std_logic;
begin
    common_decoder: entity hdl_pcie_transaction_layer_packet_header_common_decoder.pcie_transaction_layer_packet_header_common_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                   UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                                       port map(clk                 => clk,
                                                                                                                                                upstream_word_index => upstream_word_index,
                                                                                                                                                upstream_word       => upstream_word,
                                                                                                                                                common              => header.common,
                                                                                                                                                common_error        => common_error);

    request_decoder: entity hdl_pcie_transaction_layer_packet_header_request_decoder.pcie_transaction_layer_packet_header_request_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                      UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                                          port map(clk                 => clk,
                                                                                                                                                   upstream_word_index => upstream_word_index,
                                                                                                                                                   upstream_word       => upstream_word,
                                                                                                                                                   request             => header.request,
                                                                                                                                                   request_error       => request_error);

    header_error <= common_error or request_error;
end architecture;
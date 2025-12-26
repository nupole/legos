library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common_fmt_decoder;

entity pcie_transaction_layer_packet_header_common_fmt_decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 8);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         fmt_tlp_prefix:      out std_logic;
         fmt_data_indicator:  out std_logic;
         fmt_header_length:   out std_logic;
         fmt_error:           out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_fmt_decoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_common_fmt_decoder.pcie_transaction_layer_packet_header_common_fmt_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                                    port map(clk                 => clk,
                                                                                                                                             upstream_word_index => upstream_word_index,
                                                                                                                                             upstream_word       => upstream_word,
                                                                                                                                             fmt.tlp_prefix      => fmt_tlp_prefix,
                                                                                                                                             fmt.data_indicator  => fmt_data_indicator,
                                                                                                                                             fmt.header_length   => fmt_header_length,
                                                                                                                                             fmt_error           => fmt_error);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common_fmt_encoder;

entity pcie_transaction_layer_packet_header_common_fmt_encoder_tb is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 8);
    port(clk:                   in  std_logic;
         fmt_tlp_prefix:        in  std_logic;
         fmt_data_indicator:    in  std_logic;
         fmt_header_length:     in  std_logic;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_fmt_encoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_common_fmt_encoder.pcie_transaction_layer_packet_header_common_fmt_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                                    port map(clk                   => clk,
                                                                                                                                             fmt.tlp_prefix        => fmt_tlp_prefix,
                                                                                                                                             fmt.data_indicator    => fmt_data_indicator,
                                                                                                                                             fmt.header_length     => fmt_header_length,
                                                                                                                                             downstream_word_index => downstream_word_index,
                                                                                                                                             downstream_word       => downstream_word);
end architecture;
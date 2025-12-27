library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common_attr_decoder;

entity pcie_transaction_layer_packet_header_common_attr_decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 8);
    port(clk:                    in  std_logic;
         upstream_word_index:    in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:          in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         attr_id_based_ordering: out std_logic;
         attr_relaxed_ordering:  out std_logic;
         attr_no_snoop:          out std_logic;
         attr_error:             out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_attr_decoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_common_attr_decoder.pcie_transaction_layer_packet_header_common_attr_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                  UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                                      port map(clk                    => clk,
                                                                                                                                               upstream_word_index    => upstream_word_index,
                                                                                                                                               upstream_word          => upstream_word,
                                                                                                                                               attr.id_based_ordering => attr_id_based_ordering,
                                                                                                                                               attr.relaxed_ordering  => attr_relaxed_ordering,
                                                                                                                                               attr.no_snoop          => attr_no_snoop,
                                                                                                                                               attr_error             => attr_error);
end architecture;
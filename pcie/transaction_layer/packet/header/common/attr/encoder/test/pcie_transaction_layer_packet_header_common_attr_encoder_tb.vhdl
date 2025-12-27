library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common_attr_encoder;

entity pcie_transaction_layer_packet_header_common_attr_encoder_tb is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 8);
    port(clk:                    in  std_logic;
         attr_id_based_ordering: in  std_logic;
         attr_relaxed_ordering:  in  std_logic;
         attr_no_snoop:          in  std_logic;
         downstream_word_index:  in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:        out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_common_attr_encoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_common_attr_encoder.pcie_transaction_layer_packet_header_common_attr_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                                  DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                                      port map(clk                    => clk,
                                                                                                                                               attr.id_based_ordering => attr_id_based_ordering,
                                                                                                                                               attr.relaxed_ordering  => attr_relaxed_ordering,
                                                                                                                                               attr.no_snoop          => attr_no_snoop,
                                                                                                                                               downstream_word_index  => downstream_word_index,
                                                                                                                                               downstream_word        => downstream_word);
end architecture;
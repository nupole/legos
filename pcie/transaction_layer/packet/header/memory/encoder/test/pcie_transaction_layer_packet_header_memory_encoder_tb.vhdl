library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_memory;
use hdl_pcie_transaction_layer_packet_header_memory.pcie_transaction_layer_packet_header_memory_pkg.all;

library hdl_pcie_transaction_layer_packet_header_memory_encoder;

entity pcie_transaction_layer_packet_header_memory_encoder_tb is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 2;
            DOWNSTREAM_WORD_WIDTH:       positive := 32);
    port(clk:                   in  std_logic;
         memory_address:        in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_WIDTH-1) downto 0);
         memory_ph:             in  std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_WIDTH-1) downto 0);
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_memory_encoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_memory_encoder.pcie_transaction_layer_packet_header_memory_encoder generic map(DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                        DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                                                                                            port map(clk                   => clk,
                                                                                                                                     memory.address        => memory_address,
                                                                                                                                     memory.ph             => memory_ph,
                                                                                                                                     downstream_word_index => downstream_word_index,
                                                                                                                                     downstream_word       => downstream_word);
end architecture;
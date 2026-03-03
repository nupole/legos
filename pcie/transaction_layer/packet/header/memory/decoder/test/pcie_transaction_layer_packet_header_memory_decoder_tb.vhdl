library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_memory;
use hdl_pcie_transaction_layer_packet_header_memory.pcie_transaction_layer_packet_header_memory_pkg.all;

library hdl_pcie_transaction_layer_packet_header_memory_decoder;

entity pcie_transaction_layer_packet_header_memory_decoder_tb is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 2;
            UPSTREAM_WORD_WIDTH:       positive := 32);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         memory_address:      out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_WIDTH-1) downto 0);
         memory_ph:           out std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_WIDTH-1) downto 0);
         memory_error:        out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_memory_decoder_tb is
begin
    dut: entity hdl_pcie_transaction_layer_packet_header_memory_decoder.pcie_transaction_layer_packet_header_memory_decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                                                                                        UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH)
                                                                                                                            port map(clk                 => clk,
                                                                                                                                     upstream_word_index => upstream_word_index,
                                                                                                                                     upstream_word       => upstream_word,
                                                                                                                                     memory.address      => memory_address,
                                                                                                                                     memory.ph           => memory_ph,
                                                                                                                                     memory_error        => memory_error);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_decoder;

library hdl_pcie_transaction_layer_packet_header_memory;
use hdl_pcie_transaction_layer_packet_header_memory.pcie_transaction_layer_packet_header_memory_pkg.all;

entity pcie_transaction_layer_packet_header_memory_decoder is
    generic(UPSTREAM_WORD_INDEX_WIDTH: positive := 4;
            UPSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                 in  std_logic;
         upstream_word_index: in  unsigned((UPSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         upstream_word:       in  std_logic_vector((UPSTREAM_WORD_WIDTH-1) downto 0);
         memory:              out pcie_transaction_layer_packet_header_memory_t;
         memory_error:        out std_logic);
end entity;

architecture rtl of pcie_transaction_layer_packet_header_memory_decoder is
    signal address_msb: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_WIDTH-1) downto 0);
    signal address_lsb: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH-1) downto 0);
begin
    address_msb_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_BIT_OFFSET,
                                                                UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_WIDTH)
                                                    port map(clk                 => clk,
                                                             upstream_word_index => upstream_word_index,
                                                             upstream_word       => upstream_word,
                                                             downstream_word     => address_msb);

    address_lsb_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                                UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_BIT_OFFSET,
                                                                UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                                DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH)
                                                    port map(clk                 => clk,
                                                             upstream_word_index => upstream_word_index,
                                                             upstream_word       => upstream_word,
                                                             downstream_word     => address_lsb);

    memory.address <= reverse_endianness(address_msb) & address_lsb;

    ph_decoder: entity hdl_decoder.decoder generic map(UPSTREAM_WORD_INDEX_WIDTH => UPSTREAM_WORD_INDEX_WIDTH,
                                                       UPSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_BIT_OFFSET,
                                                       UPSTREAM_WORD_WIDTH       => UPSTREAM_WORD_WIDTH,
                                                       DOWNSTREAM_WORD_WIDTH     => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_WIDTH)
                                           port map(clk                 => clk,
                                                    upstream_word_index => upstream_word_index,
                                                    upstream_word       => upstream_word,
                                                    downstream_word     => memory.ph);

    memory_error <= '0';
end architecture;
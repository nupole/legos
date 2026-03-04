library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_math;
use hdl_math.math_pkg.all;

library hdl_encoder;

library hdl_pcie_transaction_layer_packet_header_memory;
use hdl_pcie_transaction_layer_packet_header_memory.pcie_transaction_layer_packet_header_memory_pkg.all;

entity pcie_transaction_layer_packet_header_memory_encoder is
    generic(DOWNSTREAM_WORD_INDEX_WIDTH: positive := 4;
            DOWNSTREAM_WORD_WIDTH:       positive := 64);
    port(clk:                   in  std_logic;
         memory:                in  pcie_transaction_layer_packet_header_memory_t;
         downstream_word_index: in  unsigned((DOWNSTREAM_WORD_INDEX_WIDTH-1) downto 0);
         downstream_word:       out std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0));
end entity;

architecture rtl of pcie_transaction_layer_packet_header_memory_encoder is
    signal address_msb: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_WIDTH-1) downto 0);

    signal address_msb_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal address_lsb_encoder_downstream_word: std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
    signal ph_encoder_downstream_word:          std_logic_vector((DOWNSTREAM_WORD_WIDTH-1) downto 0);
begin
    downstream_word <= (address_msb_encoder_downstream_word or address_lsb_encoder_downstream_word or ph_encoder_downstream_word);

    address_msb_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_WIDTH,
                                                                DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_BIT_OFFSET,
                                                                DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                    port map(clk                   => clk,
                                                             upstream_word         => reverse_endianness(address_msb),
                                                             downstream_word_index => downstream_word_index,
                                                             downstream_word       => address_msb_encoder_downstream_word);

    address_msb <= memory.address((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_WIDTH-1) downto PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH);

    address_lsb_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH,
                                                                DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                                DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_BIT_OFFSET,
                                                                DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                                    port map(clk                   => clk,
                                                             upstream_word         => memory.address((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH-1) downto 0),
                                                             downstream_word_index => downstream_word_index,
                                                             downstream_word       => address_lsb_encoder_downstream_word);

    ph_encoder: entity hdl_encoder.encoder generic map(UPSTREAM_WORD_WIDTH         => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_WIDTH,
                                                       DOWNSTREAM_WORD_INDEX_WIDTH => DOWNSTREAM_WORD_INDEX_WIDTH,
                                                       DOWNSTREAM_WORD_BIT_OFFSET  => PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_BIT_OFFSET,
                                                       DOWNSTREAM_WORD_WIDTH       => DOWNSTREAM_WORD_WIDTH)
                                           port map(clk                   => clk,
                                                    upstream_word         => memory.ph,
                                                    downstream_word_index => downstream_word_index,
                                                    downstream_word       => ph_encoder_downstream_word);
end architecture;
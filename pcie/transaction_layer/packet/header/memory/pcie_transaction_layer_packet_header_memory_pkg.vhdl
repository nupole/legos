library ieee;
use ieee.std_logic_1164.all;

package pcie_transaction_layer_packet_header_memory_pkg is
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_BIT_OFFSET: natural  := 64;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_WIDTH:      positive := 24;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_BIT_OFFSET: natural  := 90;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH:      positive := 6;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_WIDTH:          positive := PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_MSB_WIDTH + PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_LSB_WIDTH;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_BIT_OFFSET: natural  := 88;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_WIDTH:      positive := 2;

    type pcie_transaction_layer_packet_header_memory_t is record
        address: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_ADDRESS_WIDTH-1) downto 0);
        ph:      std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_MEMORY_PH_WIDTH-1) downto 0);
    end record;
end package;
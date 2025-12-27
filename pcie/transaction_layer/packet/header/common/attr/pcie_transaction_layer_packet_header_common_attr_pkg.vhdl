library ieee;
use ieee.std_logic_1164.all;

package pcie_transaction_layer_packet_header_common_attr_pkg is
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_ID_BASED_ORDERING_BIT_OFFSET: natural  := 10;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_ID_BASED_ORDERING_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_RELAXED_ORDERING_BIT_OFFSET: natural  := 21;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_RELAXED_ORDERING_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_NO_SNOOP_BIT_OFFSET: natural  := 20;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_ATTR_NO_SNOOP_WIDTH:      positive := 1;

    type pcie_transaction_layer_packet_header_common_attr_t is record
        id_based_ordering: std_logic;
        relaxed_ordering:  std_logic;
        no_snoop:          std_logic;
    end record;
end package;
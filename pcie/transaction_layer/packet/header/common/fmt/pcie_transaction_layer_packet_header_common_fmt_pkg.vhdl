library ieee;
use ieee.std_logic_1164.all;

package pcie_transaction_layer_packet_header_common_fmt_pkg is
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_TLP_PREFIX_BIT_OFFSET: natural  := 7;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_TLP_PREFIX_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_DATA_INDICATOR_BIT_OFFSET: natural  := 6;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_DATA_INDICATOR_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_HEADER_LENGTH_BIT_OFFSET: natural  := 5;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_FMT_HEADER_LENGTH_WIDTH:      positive := 1;

    type pcie_transaction_layer_packet_header_common_fmt_t is record
        tlp_prefix:     std_logic;
        data_indicator: std_logic;
        header_length:  std_logic;
    end record;
end package;
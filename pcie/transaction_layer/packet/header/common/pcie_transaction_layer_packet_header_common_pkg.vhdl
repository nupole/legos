library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_pcie_transaction_layer_packet_header_common_fmt;
use hdl_pcie_transaction_layer_packet_header_common_fmt.pcie_transaction_layer_packet_header_common_fmt_pkg.all;

library hdl_pcie_transaction_layer_packet_header_common_attr;
use hdl_pcie_transaction_layer_packet_header_common_attr.pcie_transaction_layer_packet_header_common_attr_pkg.all;

package pcie_transaction_layer_packet_header_common_pkg is
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_BIT_OFFSET: natural  := 0;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH:      positive := 5;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_BIT_OFFSET: natural  := 12;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH:      positive := 3;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TH_BIT_OFFSET: natural  := 8;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TH_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TD_BIT_OFFSET: natural  := 23;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TD_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_EP_BIT_OFFSET: natural  := 22;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_EP_WIDTH:      positive := 1;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_BIT_OFFSET: natural  := 18;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH:      positive := 2;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_BIT_OFFSET: natural  := 16;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_WIDTH:      positive := 2;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_BIT_OFFSET: natural  := 24;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH:      positive := 8;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH:          positive := PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_MSB_WIDTH + PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_LSB_WIDTH;

    type pcie_transaction_layer_packet_header_common_t is record
        fmt:         pcie_transaction_layer_packet_header_common_fmt_t;
        packet_type: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_PACKET_TYPE_WIDTH-1) downto 0);
        tc:          std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_TC_WIDTH-1) downto 0);
        attr:        pcie_transaction_layer_packet_header_common_attr_t;
        th:          std_logic;
        td:          std_logic;
        ep:          std_logic;
        at:          std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_AT_WIDTH-1) downto 0);
        length:      unsigned((PCIE_TRANSACTION_LAYER_PACKET_HEADER_COMMON_LENGTH_WIDTH-1) downto 0);
    end record;
end package;
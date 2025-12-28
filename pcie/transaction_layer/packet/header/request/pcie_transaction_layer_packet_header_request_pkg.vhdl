library ieee;
use ieee.std_logic_1164.all;

package pcie_transaction_layer_packet_header_request_pkg is
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_BIT_OFFSET: natural  := 32;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH:      positive := 16;

    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_BIT_OFFSET: natural  := 48;
    constant PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH:      positive := 8;

    type pcie_transaction_layer_packet_header_request_t is record
        requester_id: std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_REQUESTER_ID_WIDTH-1) downto 0);
        tag:          std_logic_vector((PCIE_TRANSACTION_LAYER_PACKET_HEADER_REQUEST_TAG_WIDTH-1) downto 0);
    end record;
end package;
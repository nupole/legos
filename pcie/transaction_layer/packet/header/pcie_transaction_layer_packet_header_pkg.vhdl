library ieee;
use ieee.std_logic_1164.all;

library hdl_pcie_transaction_layer_packet_header_common;
use hdl_pcie_transaction_layer_packet_header_common.pcie_transaction_layer_packet_header_common_pkg.all;

library hdl_pcie_transaction_layer_packet_header_request;
use hdl_pcie_transaction_layer_packet_header_request.pcie_transaction_layer_packet_header_request_pkg.all;

package pcie_transaction_layer_packet_header_pkg is
    type pcie_transaction_layer_packet_header_t is record
        common:  pcie_transaction_layer_packet_header_common_t;
        request: pcie_transaction_layer_packet_header_request_t;
    end record;
end package;
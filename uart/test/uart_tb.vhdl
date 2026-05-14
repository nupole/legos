library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_uart;

entity uart_tb is
    generic(CLK_FREQUENCY: positive := 4*115200;
            BAUD_RATE:     positive := 115200;
            FRAME_WIDTH:   positive := 8);
    port(clk:            in  std_logic;
         rst:            in  std_logic;
         tx:             out std_logic;
         ready_tx_frame: out std_logic;
         valid_tx_frame: in  std_logic;
         tx_frame:       in  std_logic_vector((FRAME_WIDTH-1) downto 0));
end entity;

architecture rtl of uart_tb is
begin
    dut: entity hdl_uart.uart generic map(CLK_FREQUENCY => CLK_FREQUENCY,
                                          BAUD_RATE     => BAUD_RATE,
                                          FRAME_WIDTH   => FRAME_WIDTH)
                              port map(clk            => clk,
                                       rst            => rst,
                                       tx             => tx,
                                       ready_tx_frame => ready_tx_frame,
                                       valid_tx_frame => valid_tx_frame,
                                       tx_frame       => tx_frame);
end architecture;
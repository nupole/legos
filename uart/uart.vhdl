library ieee;
use ieee.std_logic_1164.all;

library hdl_uart_encoder;

entity uart is
    generic(CLK_FREQUENCY: positive := 100000000;
            BAUD_RATE:     positive := 115200;
            FRAME_WIDTH:   positive := 8);
    port(clk:            in  std_logic;
         rst:            in  std_logic;
         tx:             out std_logic;
         ready_tx_frame: out std_logic;
         valid_tx_frame: in  std_logic;
         tx_frame:       in  std_logic_vector((FRAME_WIDTH-1) downto 0));
end entity;

architecture rtl of uart is
begin
    uart_encoder: entity hdl_uart_encoder.uart_encoder generic map(CLK_FREQUENCY => CLK_FREQUENCY,
                                                                   BAUD_RATE     => BAUD_RATE,
                                                                   FRAME_WIDTH   => FRAME_WIDTH)
                                                       port map(clk         => clk,
                                                                rst         => rst,
                                                                tx          => tx,
                                                                ready_frame => ready_tx_frame,
                                                                valid_frame => valid_tx_frame,
                                                                frame       => tx_frame);
end architecture;
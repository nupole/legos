library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library hdl_uart_encoder;

entity uart_encoder_tb is
    generic(CLK_FREQUENCY: positive := 4*115200;
            BAUD_RATE:     positive := 115200;
            FRAME_WIDTH:   positive := 2);
    port(clk:         in  std_logic;
         rst:         in  std_logic;
         tx:          out std_logic;
         ready_frame: out std_logic;
         valid_frame: in  std_logic;
         frame:       in  std_logic_vector((FRAME_WIDTH-1) downto 0));
end entity;

architecture rtl of uart_encoder_tb is
begin
    dut: entity hdl_uart_encoder.uart_encoder generic map(CLK_FREQUENCY => CLK_FREQUENCY,
                                                          BAUD_RATE     => BAUD_RATE,
                                                          FRAME_WIDTH   => FRAME_WIDTH)
                                              port map(clk         => clk,
                                                       rst         => rst,
                                                       tx          => tx,
                                                       ready_frame => ready_frame,
                                                       valid_frame => valid_frame,
                                                       frame       => frame);
end architecture;
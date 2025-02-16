----------------------------------------------------------------------------------
-- Company: Myway Plus Corporation 
-- Module Name: clk_gen
-- Target Devices: Kintex-7 xc7k70t
-- Tool Versions: Vivado 2016.4
-- Create Date: 2017/01/10
-- Revision: 1.0
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;


entity clk_gen is
    port (
        CLK50M_IN    : in std_logic;
        RESET_IN     : in std_logic;
        CLK50M_OUT  : out std_logic;
        CLK100M_OUT : out std_logic;
        CLK200M_OUT : out std_logic;
        PLL_LOCKED  : out std_logic
    );
end clk_gen;


architecture Behavioral of clk_gen is
    signal clk_in1     : std_logic;
    signal clkfb_out  : std_logic;
    signal clkfb_in    : std_logic; 
    signal clkout_0    : std_logic;
    signal clkout_1    : std_logic;
    signal clkout_2    : std_logic;


begin

    -- Input buffering
    clkin_buf : IBUFG
        port map (
            O => clk_in1,
            I => CLK50M_IN
        );


    -- Output buffering
    clkfb_buf : BUFG
        port map (
            O => clkfb_in,
            I => clkfb_out
        );

    clkout0_buf : BUFG
        port map (
            O => CLK50M_OUT,
            I => clkout_0
        );

    clkout1_buf : BUFG
        port map (
            O => CLK100M_OUT,
            I => clkout_1
        );

    clkout2_buf : BUFG
        port map (
            O => CLK200M_OUT,
            I => clkout_2
        );


    pll : PLLE2_BASE
        generic map (
            BANDWIDTH               => "OPTIMIZED",
            CLKFBOUT_MULT         => 16,      -- Multiply value for all CLKOUT,
            CLKFBOUT_PHASE       => 0.00,   -- Phase offset in degrees of CLKFB,
            CLKIN1_PERIOD         => 20.00,  -- Input clock period in ns 20ns is 50MHz
            CLKOUT0_DIVIDE        => 16,      -- Divide amount --50MHz
            CLKOUT0_PHASE         => 0.0,    -- Phase offset
            CLKOUT0_DUTY_CYCLE  => 0.50,  -- Duty cycle
            CLKOUT1_DIVIDE        => 8,      -- 100MHz
            CLKOUT1_PHASE         => 0.0,
            CLKOUT1_DUTY_CYCLE  => 0.50,
            CLKOUT2_DIVIDE        => 4,      -- 200MHz
            CLKOUT2_PHASE         => 0.0,
            CLKOUT2_DUTY_CYCLE  => 0.50,
            DIVCLK_DIVIDE          => 1,      -- Master division value
            REF_JITTER1             => 0.010, -- Reference input jitter
            STARTUP_WAIT           => "FALSE"
        )
        port map (
            CLKIN1 => clk_in1,
            CLKFBIN => clkfb_in,
            RST  => RESET_IN,
            PWRDWN => '0',
            CLKOUT0 => clkout_0,
            CLKOUT1 => clkout_1,
            CLKOUT2 => clkout_2,
            CLKOUT3 => open,
            CLKOUT4 => open,
            CLKOUT5 => open,
            CLKFBOUT => clkfb_out,
            LOCKED => PLL_LOCKED
        );


end Behavioral;



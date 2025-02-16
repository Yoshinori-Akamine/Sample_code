----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/11/18 14:29:22
-- Design Name: 
-- Module Name: peak_hold - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

entity peak_hold is
    Port (
        CLK_IN : in std_logic;
        RESET_IN : in std_logic;
        AD_A_DATA : in std_logic_vector(31 downto 0);
        AD_B_DATA : in std_logic_vector(31 downto 0);
        AD_A_DATA_PEAK : out std_logic_vector(31 downto 0);
        AD_B_DATA_PEAK : out std_logic_vector(31 downto 0)
        );
end peak_hold;

architecture behavioral of peak_hold is
    signal ad_0_data_crnt : std_logic_vector(31 downto 0);
    signal ad_0_data_prvs : std_logic_vector(31 downto 0);
    signal ad_0_data_peak : std_logic_vector(31 downto 0);
    signal ad_0_data_peak_tmp : std_logic_vector(31 downto 0);
    signal ad_1_data_crnt : std_logic_vector(31 downto 0);
    signal ad_1_data_prvs : std_logic_vector(31 downto 0);
    signal ad_1_data_peak : std_logic_vector(31 downto 0);
    signal ad_1_data_peak_tmp : std_logic_vector(31 downto 0);
    
    
--    attribute mark_debug : string;
--    attribute mark_debug of ad_0_data_crnt: signal is "true";
--    attribute mark_debug of ad_0_data_peak: signal is "true";
    
begin

    -- Peak Hold
    process(CLK_IN)
    begin
        if CLK_IN'event and CLK_IN = '1' then
            if RESET_IN = '1' then
                ad_0_data_crnt <= X"0000" & X"0000";
                ad_0_data_prvs <= X"0000" & X"0000";
                ad_1_data_crnt <= X"0000" & X"0000";
                ad_1_data_prvs <= X"0000" & X"0000";
            else
                ad_0_data_crnt <= AD_A_DATA;
                ad_0_data_prvs <= ad_0_data_crnt;
                ad_1_data_crnt <= AD_B_DATA;
                ad_1_data_prvs <= ad_1_data_crnt;
            end if;
        end if;
    end process;
    
    process(CLK_IN)
    begin
        if CLK_IN'event and CLK_IN = '1' then
            if RESET_IN = '1' then
                AD_A_DATA_PEAK <= X"0000" & X"0000";
                ad_0_data_peak_tmp <= X"0000" & X"0000";
            else
                if ad_0_data_crnt(31) = '0' and ad_0_data_prvs(31) = '0' then
                    if ad_0_data_crnt > ad_0_data_prvs then
                        ad_0_data_peak_tmp <= ad_0_data_crnt;
                    end if;
                elsif ad_0_data_crnt(31) = '1' and ad_0_data_prvs(31) = '0' then
                    AD_A_DATA_PEAK <= ad_0_data_peak_tmp;
                end if;
            end if;
        end if;
    end process;

    process(CLK_IN)
    begin
        if CLK_IN'event and CLK_IN = '1' then
            if RESET_IN = '1' then
                AD_B_DATA_PEAK <= X"0000" & X"0000";
                ad_1_data_peak_tmp <= X"0000" & X"0000";
            else
                if ad_1_data_crnt(31) = '0' and ad_1_data_prvs(31) = '0' then
                    if ad_1_data_crnt > ad_1_data_prvs then
                        ad_1_data_peak_tmp <= ad_1_data_crnt;
                    end if;
                elsif ad_1_data_crnt(31) = '1' and ad_1_data_prvs(31) = '0' then
                    AD_B_DATA_PEAK <= ad_1_data_peak_tmp;
                end if;
            end if;
        end if;
    end process;

end behavioral;


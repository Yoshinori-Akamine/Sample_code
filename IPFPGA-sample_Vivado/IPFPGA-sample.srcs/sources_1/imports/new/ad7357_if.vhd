----------------------------------------------------------------------------------
-- Company: Myway Plus Corporation 
-- Module Name: ad7357_if
-- Target Devices: Kintex-7 xc7k70t
-- Tool Versions: Vivado 2016.4
-- Create Date: 2017/01/10
-- Revision: 1.0
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

entity ad7357_if is
    Port (
        CLK_AD      : in std_logic;
        RESET_IN   : in std_logic;
        AD_A_100   : out std_logic_vector(31 downto 0);
        AD_B_100   : out std_logic_vector(31 downto 0);
        nAD_CS      : out std_logic;
        AD_SCLK    : out std_logic;
        AD_DO_A    : in std_logic;
        AD_DO_B    : in std_logic
    );
end ad7357_if;

architecture Behavioral of ad7357_if is

    signal ad_clk     : std_logic;
    signal ad_cs      : std_logic;
    signal ad_a        : std_logic_vector(13 downto 0);
    signal ad_b        : std_logic_vector(13 downto 0);
    signal ad_a_tmp : std_logic_vector(31 downto 0);
    signal ad_b_tmp : std_logic_vector(31 downto 0);
    signal ad_do_a_b : std_logic;
    signal ad_do_b_b : std_logic;
    signal ad_sra     : std_logic_vector(13 downto 0);
    signal ad_srb     : std_logic_vector(13 downto 0);
    signal cnt_adphase : std_logic_vector(5 downto 0);

begin
    ad_do_a_b <=  AD_DO_A;
    ad_do_b_b <=  AD_DO_B;
    nAD_CS      <=  not ad_cs;
    AD_SCLK    <=  ad_clk;
    AD_A_100   <= ad_a_tmp;
    AD_B_100   <= ad_b_tmp;

    process(CLK_AD)
    begin
        if CLK_AD'event and CLK_AD = '1' then
            if RESET_IN = '1' then
                cnt_adphase <= "00" & X"0";
                ad_cs          <= '1';
                ad_clk         <= '1';
                ad_a            <= "00" & X"000";
                ad_b            <= "00" & X"000";
            else
                cnt_adphase <= cnt_adphase + '1';
                case cnt_adphase is
                    when "000000" => ad_cs  <= '0';
                                            ad_clk <= '1';
                    when "000001" => ad_cs  <= '1';
                    when "000010" => ad_clk <= '0';
                    when "000011" => ad_clk <= '1';
                    when "000100" => ad_clk <= '0';
                    when "000101" => ad_clk <= '1';
                    when "000110" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "000111" => ad_clk <= '1';
                    when "001000" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "001001" => ad_clk <= '1';
                    when "001010" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "001011" => ad_clk <= '1';
                    when "001100" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "001101" => ad_clk <= '1';
                    when "001110" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "001111" => ad_clk <= '1';
                    when "010000" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "010001" => ad_clk <= '1';
                    when "010010" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "010011" => ad_clk <= '1';
                    when "010100" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "010101" => ad_clk <= '1';
                    when "010110" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "010111" => ad_clk <= '1';
                    when "011000" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "011001" => ad_clk <= '1';
                    when "011010" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "011011" => ad_clk <= '1';
                    when "011100" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "011101" => ad_clk <= '1';
                    when "011110" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "011111" => ad_clk <= '1';
                    when "100000" => ad_clk <= '0';
                                            ad_sra <= ad_sra(12 downto 0) & ad_do_a_b;
                                            ad_srb <= ad_srb(12 downto 0) & ad_do_b_b;
                    when "100001" => ad_clk <= '1';
                                            ad_a     <= ad_sra;
                                            ad_b     <= ad_srb;
                    when "100010" => ad_cs   <= '0';
                                            if ad_a(13)= '0' then --14bit AD DATA -> 32bit DATA  
                                                ad_a_tmp <= X"FFFF" & "111" & ad_a(12 downto 0);
                                            else
                                                ad_a_tmp <= X"0000" & "000" & ad_a(12 downto 0);
                                            end if;
                                            if ad_b(13)= '0' then
                                                ad_b_tmp <= X"FFFF" & "111" & ad_b(12 downto 0);
                                            else
                                                ad_b_tmp <= X"0000" & "000" & ad_b(12 downto 0);
                                            end if;
                    when "111010" => cnt_adphase <= "000000";
                    when others =>  null;
                end case;
            end if;
        end if;
    end process;
end Behavioral;



----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/11/18 20:59:50
-- Design Name: 
-- Module Name: simu - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simu is
--  Port ( );
end simu;

architecture Behavioral of simu is
    component mwpe4_ipfpga_top is 
    port (
        --== CLK & RESET & BDN ============================
        --50MHz Main Clock
        CLK50M_IN : in std_logic;
        CLK50M_2_IN : in std_logic; --Not used
        --Expert4 Reset signal
        nXRST_IN : in std_logic;
        --Board No. SW4 1-3
        BDN_IN : in std_logic_vector (2 downto 0);
        --External Function SW4 4
        EFN_IN : in std_logic;

        --== BUS BP <=> FPGA ==============================
        BPIFAD   : inout std_logic_vector (18 downto 1);
        BPIFD     : inout std_logic_vector (15 downto 0);
        BPIFCE_N : inout std_logic;
        BPIFWE_N : in std_logic;
        BPIFP     : inout std_logic_vector (1 downto 0);
        BPIFWAIT : out std_logic_vector (1 downto 0); 
        BPBOE_N  : out std_logic_vector (2 downto 0);
        BPBDR_N  : out std_logic_vector (2 downto 0);

        --== GPIO =========================================
        GPIO_16_23_OUT : out std_logic_vector (23 downto 16);
        GPIO_16_23_IN  : in std_logic_vector (23 downto 16);

        --== GPIO interrupt ================================
        GPIO_8_15_OUT : out std_logic_vector (15 downto 8);

        --== PWM Output ==================================
        --Optical Output "LOW ACTIVE" (Main Board)
        nPWM_UP_OUT : out std_logic; --nUSER_OPT_OUT(0)
        nPWM_UN_OUT : out std_logic; --nUSER_OPT_OUT(1)
        nPWM_VP_OUT : out std_logic; --nUSER_OPT_OUT(2)
        nPWM_VN_OUT : out std_logic; --nUSER_OPT_OUT(3)
        nPWM_WP_OUT : out std_logic; --nUSER_OPT_OUT(4)
        nPWM_WN_OUT : out std_logic; --nUSER_OPT_OUT(5)
        --Optical Output  "LOW ACTIVE" (SUB OPT Board)
        nUSER_OPT_OUT : out std_logic_vector (23 downto 6);

        --== ADC =========================================
        AD7357_1_SCLK_OUT : out std_logic;
        nAD7357_1_CS_OUT  : out std_logic;
        AD7357_1_DA_IN     : in std_logic;
        AD7357_1_DB_IN     : in std_logic;

        AD7357_2_SCLK_OUT : out std_logic;
        nAD7357_2_CS_OUT  : out std_logic;
        AD7357_2_DA_IN     : in std_logic;
        AD7357_2_DB_IN     : in std_logic;

        AD7357_3_SCLK_OUT : out std_logic;
        nAD7357_3_CS_OUT  : out std_logic;
        AD7357_3_DA_IN     : in std_logic;
        AD7357_3_DB_IN     : in std_logic;

        AD7357_4_SCLK_OUT : out std_logic;
        nAD7357_4_CS_OUT  : out std_logic;
        AD7357_4_DA_IN     : in std_logic;
        AD7357_4_DB_IN     : in std_logic;

        --== DIO =========================================
        DIN_IN    : in std_logic_vector(3 downto 0);
        DOUT_OUT : out std_logic_vector(3 downto 0);

        --== USER LED =====================================
        USER_LED_OUT : out std_logic_vector (2 downto 0);

        --== USER SW ======================================
        --SW3 1-8 USER DIP SW
        USER_SW_IN    : in std_logic_vector (7 downto 0);
        --RESET1 SW5
        nUSER_PSW1_IN : in std_logic; -- Use by ALL RESET
        --RESET2 SW6
        nUSER_PSW2_IN : in std_logic; -- Use by SYSTEM RESET

        --== EEPROM =======================================
        EEP_SCL : out std_logic;
        EEP_SDA : inout std_logic
    );
    end component;
    
        --50MHz Main Clock
        CLK50M_IN : in std_logic;
        CLK50M_2_IN : in std_logic; --Not used
        --Expert4 Reset signal
        nXRST_IN : in std_logic;
        --Board No. SW4 1-3
        BDN_IN : in std_logic_vector (2 downto 0);
        --External Function SW4 4
        EFN_IN : in std_logic;
    
begin


end Behavioral;

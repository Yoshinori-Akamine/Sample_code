----------------------------------------------------------------------------------
-- Company: Myway Plus Corporation 
-- Module Name: mwpe4_ipfpga_top
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

entity mwpe4_ipfpga_top is
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
end mwpe4_ipfpga_top;


architecture Behavioral of mwpe4_ipfpga_top is

    component clk_gen is
        port (
            CLK50M_IN    : in std_logic;
            RESET_IN     : in std_logic;
            CLK50M_OUT  : out std_logic;
            CLK100M_OUT : out std_logic;
            CLK200M_OUT : out std_logic;
            PLL_LOCKED  : out std_logic
        );
    end component; 

    component bp_if_wrap is
        port (
            CLK100M  : in std_logic;
            CLK200M  : in std_logic;
            RESET_IN : in std_logic;
            BDN_IN    : in std_logic_vector (2 downto 0);
            EFN_IN    : in std_logic;

            BPIFAD    : inout std_logic_vector (18 downto 1);
            BPIFD     : inout std_logic_vector (15 downto 0);
            BPIFCE_N : inout std_logic;
            BPIFWE_N : in std_logic;
            BPIFP     : inout std_logic_vector (1 downto 0);
            BPIFWAIT : out std_logic_vector (1 downto 0);
            BPBOE_N  : out std_logic_vector (2 downto 0);
            BPBDR_N  : out std_logic_vector (2 downto 0);

            ADDRESS       : out std_logic_vector (7 downto 0);
            WR_START     : out std_logic;
            RD_START     : out std_logic;
            RD_DATA_SET : in std_logic;
            WR_DATA       : out std_logic_vector (31 downto 0);
            RD_DATA       : in std_logic_vector (31 downto 0)
        );
    end component;

    component io_top is
         Port (
            CLK100M  : in std_logic;
            RESET_IN : in std_logic;

            ADDRESS       : in std_logic_vector (7 downto 0);
            WR_START     : in std_logic;
            RD_START     : in std_logic;
            RD_DATA_SET : out std_logic;
            WR_DATA       : in std_logic_vector (31 downto 0);
            RD_DATA       : out std_logic_vector (31 downto 0);

            GPIO_16_23_OUT : out std_logic_vector (23 downto 16);
            GPIO_16_23_IN  : in std_logic_vector (23 downto 16);
            GPIO_8_15_OUT : out std_logic_vector (15 downto 8);

            nPWM_UP_OUT : out std_logic; --nUSER_OPT_OUT(0)
            nPWM_UN_OUT : out std_logic; --nUSER_OPT_OUT(1)
            nPWM_VP_OUT : out std_logic; --nUSER_OPT_OUT(2)
            nPWM_VN_OUT : out std_logic; --nUSER_OPT_OUT(3)
            nPWM_WP_OUT : out std_logic; --nUSER_OPT_OUT(4)
            nPWM_WN_OUT : out std_logic; --nUSER_OPT_OUT(5)
            nUSER_OPT_OUT : out std_logic_vector (23 downto 6);

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

            DIN_IN    : in std_logic_vector(3 downto 0);
            DOUT_OUT : out std_logic_vector(3 downto 0);

            USER_LED_OUT : out std_logic_vector (2 downto 0);

            USER_SW_IN    : in std_logic_vector (7 downto 0);
            nUSER_PSW1_IN : in std_logic;
            nUSER_PSW2_IN : in std_logic
        );
     end component;

    signal reset_clk : std_logic; -- push switch reset
    signal reset_sys : std_logic;
    signal clk50m     : std_logic;
    signal clk100m    : std_logic;
    signal clk200m    : std_logic;
    signal pll_ok     :  std_logic;

    signal address_s       : std_logic_vector (7 downto 0);
    signal wr_start_s      : std_logic;
    signal rd_start_s      : std_logic;
    signal rd_data_set_s : std_logic;
    signal wr_data_s       : std_logic_vector (31 downto 0);
    signal rd_data_s       : std_logic_vector (31 downto 0);


begin

    u_clk_gen : clk_gen
        port map(
            CLK50M_IN    => CLK50M_IN,
            RESET_IN     => reset_clk,
            CLK50M_OUT  => clk50m,
            CLK100M_OUT => clk100m,
            CLK200M_OUT => clk200m,
            PLL_LOCKED  => pll_ok
        );

    reset_clk  <= (not nXRST_IN) or (not nUSER_PSW1_IN);
    reset_sys <= (not pll_ok) or (not nUSER_PSW2_IN);

    u_bp_if_wrap : bp_if_wrap
        port map(
            CLK100M   => clk100m,
            CLK200M   => clk200m,
            RESET_IN => reset_sys,
            BDN_IN    => BDN_IN,
            EFN_IN    => EFN_IN,

            BPIFAD    => BPIFAD,
            BPIFD      => BPIFD,
            BPIFCE_N => BPIFCE_N,
            BPIFWE_N => BPIFWE_N,
            BPIFP      => BPIFP,
            BPIFWAIT => BPIFWAIT,
            BPBOE_N  => BPBOE_N,
            BPBDR_N  => BPBDR_N,

            ADDRESS       => address_s,
            WR_START     => wr_start_s,
            RD_START     => rd_start_s,
            RD_DATA_SET => rd_data_set_s,
            WR_DATA       => wr_data_s,
            RD_DATA       => rd_data_s
        );

    u_io_top : io_top
        port map(
            CLK100M  =>clk100m,
            RESET_IN => reset_sys,

            ADDRESS       => address_s,
            WR_START     => wr_start_s,
            RD_START     => rd_start_s,
            RD_DATA_SET => rd_data_set_s,
            WR_DATA       => wr_data_s,
            RD_DATA       => rd_data_s,

            GPIO_16_23_OUT => GPIO_16_23_OUT,
            GPIO_16_23_IN  => GPIO_16_23_IN,
            GPIO_8_15_OUT => GPIO_8_15_OUT,

            nPWM_UP_OUT => nPWM_UP_OUT,
            nPWM_UN_OUT => nPWM_UN_OUT,
            nPWM_VP_OUT => nPWM_VP_OUT,
            nPWM_VN_OUT => nPWM_VN_OUT,
            nPWM_WP_OUT => nPWM_WP_OUT,
            nPWM_WN_OUT => nPWM_WN_OUT,
            nUSER_OPT_OUT => nUSER_OPT_OUT,

            AD7357_1_SCLK_OUT => AD7357_1_SCLK_OUT,
            nAD7357_1_CS_OUT  => nAD7357_1_CS_OUT,
            AD7357_1_DA_IN     => AD7357_1_DA_IN,
            AD7357_1_DB_IN     => AD7357_1_DB_IN,

            AD7357_2_SCLK_OUT => AD7357_2_SCLK_OUT,
            nAD7357_2_CS_OUT  => nAD7357_2_CS_OUT,
            AD7357_2_DA_IN     => AD7357_2_DA_IN,
            AD7357_2_DB_IN     => AD7357_2_DB_IN,

            AD7357_3_SCLK_OUT => AD7357_3_SCLK_OUT,
            nAD7357_3_CS_OUT  => nAD7357_3_CS_OUT,
            AD7357_3_DA_IN     => AD7357_3_DA_IN,
            AD7357_3_DB_IN     => AD7357_3_DB_IN,

            AD7357_4_SCLK_OUT => AD7357_4_SCLK_OUT,
            nAD7357_4_CS_OUT  => nAD7357_4_CS_OUT,
            AD7357_4_DA_IN     => AD7357_4_DA_IN,
            AD7357_4_DB_IN     => AD7357_4_DB_IN,

            DIN_IN    => DIN_IN,
            DOUT_OUT => DOUT_OUT,

            USER_LED_OUT => USER_LED_OUT,

            USER_SW_IN    => USER_SW_IN,
            nUSER_PSW1_IN => nUSER_PSW1_IN,
            nUSER_PSW2_IN => nUSER_PSW2_IN
        );

end Behavioral;

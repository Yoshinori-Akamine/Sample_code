----------------------------------------------------------------------------------
-- Company: Myway Plus Corporation 
-- Module Name: io_top
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

entity io_top is
    port (
        --== CLK, RESET,===================================
        CLK100M  : in std_logic;
        RESET_IN : in std_logic;

        --== IO module I/F ================================
        ADDRESS       : in std_logic_vector (7 downto 0);
        WR_START     : in std_logic;
        RD_START     : in std_logic;
        RD_DATA_SET : out std_logic;
        WR_DATA       : in std_logic_vector (31 downto 0);
        RD_DATA       : out std_logic_vector (31 downto 0);

        --== GPIO =========================================
        GPIO_16_23_OUT : out std_logic_vector (23 downto 16);
        GPIO_16_23_IN  : in std_logic_vector (23 downto 16);

        --== GPIO interrupt ================================
        GPIO_8_15_OUT : out std_logic_vector (15 downto 8);

        --== PWM Output ==================================
        nPWM_UP_OUT : out std_logic; --nUSER_OPT_OUT(0)
        nPWM_UN_OUT : out std_logic; --nUSER_OPT_OUT(1)
        nPWM_VP_OUT : out std_logic; --nUSER_OPT_OUT(2)
        nPWM_VN_OUT : out std_logic; --nUSER_OPT_OUT(3)
        nPWM_WP_OUT : out std_logic; --nUSER_OPT_OUT(4)
        nPWM_WN_OUT : out std_logic; --nUSER_OPT_OUT(5)
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
        nUSER_PSW1_IN : in std_logic; -- PSW1 is used by ALL RESET
        --RESET2 SW6
        nUSER_PSW2_IN : in std_logic -- PSW2 is used by SYSTEM RESET
    );
end io_top;

architecture Behavioral of io_top is

    component ad7357_if is
        port (
            CLK_AD      : in std_logic;
            RESET_IN   : in std_logic;
            AD_A_100   : out std_logic_vector(31 downto 0);
            AD_B_100   : out std_logic_vector(31 downto 0);
            nAD_CS      : out std_logic;
            AD_SCLK    : out std_logic;
            AD_DO_A    : in std_logic;
            AD_DO_B    : in std_logic
        );
    end component;

    component pwm_if is
        port (
            CLK_IN           : in std_logic;
            RESET_IN        : in std_logic;
            nPWM_UP_OUT    : out std_logic; --nUSER_OPT_OUT(0)
            nPWM_UN_OUT    : out std_logic; --nUSER_OPT_OUT(1)
            nPWM_VP_OUT    : out std_logic; --nUSER_OPT_OUT(2)
            nPWM_VN_OUT    : out std_logic; --nUSER_OPT_OUT(3)
            nPWM_WP_OUT    : out std_logic; --nUSER_OPT_OUT(4)
            nPWM_WN_OUT    : out std_logic; --nUSER_OPT_OUT(5)
            nUSER_OPT_OUT : out std_logic_vector (23 downto 6);

            UPDATE    : in std_logic;
            CARRIER   : in std_logic_vector (15 downto 0);
            U_REF      : in std_logic_vector (15 downto 0);
            V_REF      : in std_logic_vector (15 downto 0);
            W_REF      : in std_logic_vector (15 downto 0);
            DEADTIME : in std_logic_vector (12 downto 0);
            GATE_EN  : in std_logic
        );
    end component;

    signal address_b     : std_logic_vector (7 downto 0);
    signal wr_start_f    : std_logic;
    signal wr_start_ff   : std_logic;
    signal wr_data_b     : std_logic_vector (31 downto 0);
    signal rd_start_f    : std_logic;
    signal rd_start_ff   : std_logic;
    signal rd_start_fff : std_logic;
    signal rd_data_b     : std_logic_vector (31 downto 0); 
    signal test_reg      : std_logic_vector (31 downto 0);

    signal pwm_carrier_b   : std_logic_vector(15 downto 0);
    signal pwm_u_ref_b    : std_logic_vector(15 downto 0);
    signal pwm_v_ref_b    : std_logic_vector(15 downto 0);
    signal pwm_w_ref_b    : std_logic_vector(15 downto 0);
    signal pwm_deadtime_b : std_logic_vector(12 downto 0);
    signal pwm_gate_en_b  : std_logic;
    signal pwm_update_b    : std_logic;

    signal ad_update_f : std_logic;
    signal ad_0_data_b : std_logic_vector(31 downto 0);
    signal ad_1_data_b : std_logic_vector(31 downto 0);
    signal ad_2_data_b : std_logic_vector(31 downto 0);
    signal ad_3_data_b : std_logic_vector(31 downto 0);
    signal ad_4_data_b : std_logic_vector(31 downto 0);
    signal ad_5_data_b : std_logic_vector(31 downto 0);
    signal ad_6_data_b : std_logic_vector(31 downto 0);
    signal ad_7_data_b : std_logic_vector(31 downto 0);
    signal ad_0_data_s : std_logic_vector(31 downto 0);
    signal ad_1_data_s : std_logic_vector(31 downto 0);
    signal ad_2_data_s : std_logic_vector(31 downto 0);
    signal ad_3_data_s : std_logic_vector(31 downto 0);
    signal ad_4_data_s : std_logic_vector(31 downto 0);
    signal ad_5_data_s : std_logic_vector(31 downto 0);
    signal ad_6_data_s : std_logic_vector(31 downto 0);
    signal ad_7_data_s : std_logic_vector(31 downto 0);

    signal gpio_16_23_out_b  : std_logic_vector (7 downto 0);
    signal gpio_16_23_out_bb : std_logic_vector (7 downto 0) := X"00";
    signal gpio_16_23_in_b   : std_logic_vector (7 downto 0);
    signal gpio_8_15_out_b  : std_logic_vector (7 downto 0);
    signal gpio_8_15_out_bb : std_logic_vector (7 downto 0) := X"00";
    signal din_in_data_b       : std_logic_vector(3 downto 0);
    signal dout_out_data_b    : std_logic_vector(3 downto 0);
    signal dout_out_data_bb   : std_logic_vector(3 downto 0) := X"0";
    signal user_sw_in_data_b : std_logic_vector(7 downto 0);

    signal cnt_reg : std_logic_vector (26 downto 0) := B"000" & X"000000";
    signal led_reg : std_logic_vector (2 downto 0) := B"001";


begin

    -- Bus Interface ----------------------------------------------
    -- Access Timing
    process(CLK100M)
    begin
        if CLK100M'event and CLK100M = '1' then
            if RESET_IN = '1' then
                address_b     <= X"FF";
                wr_start_f    <= '0';
                wr_start_ff   <= '0';
                wr_data_b     <= X"0000" & X"0000";
                rd_start_f    <= '0';
                rd_start_ff  <= '0';
                rd_start_fff <= '0';
            elsif WR_START = '1' then
                address_b     <= ADDRESS;
                wr_start_f    <= WR_START;
                wr_data_b     <= WR_DATA;
            elsif RD_START = '1' then
                address_b     <= ADDRESS;
                rd_start_f    <= RD_START;
            else --RD_DATA_SET wait
                wr_start_f    <= WR_START;
                wr_start_ff   <= wr_start_f;
                rd_start_f    <= RD_START;
                rd_start_ff  <= rd_start_f;
                rd_start_fff <= rd_start_ff;
                RD_DATA_SET  <= rd_start_ff or rd_start_fff;
            end if;
        end if;
    end process;


    -- Write Access
    process(CLK100M)
    begin
        if CLK100M'event and CLK100M = '1' then
            if RESET_IN = '1' then
                test_reg <= X"ABCD" & X"ABCD";
                pwm_carrier_b <= X"1388";
                pwm_u_ref_b <= X"09C4";
                pwm_v_ref_b <= X"09C4";
                pwm_w_ref_b <= X"09C4";
                pwm_deadtime_b <= '0' & X"190";
                pwm_gate_en_b <= '0';
                pwm_update_b <= '0';
                gpio_16_23_out_b <= X"00";
                gpio_8_15_out_b <= X"00";
                dout_out_data_b <= X"0";
            elsif wr_start_f = '1' then
                case address_b is
                    when X"00" => test_reg <= wr_data_b;

                    when X"01" => pwm_carrier_b   <= wr_data_b(15 downto 0);
                    when X"02" => pwm_u_ref_b    <= wr_data_b(15 downto 0);
                    when X"03" => pwm_v_ref_b    <= wr_data_b(15 downto 0);
                    when X"04" => pwm_w_ref_b    <= wr_data_b(15 downto 0);
                    when X"05" => pwm_deadtime_b <= wr_data_b(12 downto 0);
                    when X"06" => pwm_gate_en_b  <= wr_data_b(0);
                    when X"07" => pwm_update_b   <= wr_data_b(0);
                    
                    when X"10" => gpio_16_23_out_b <= wr_data_b(7 downto 0);
                    when X"12" => gpio_8_15_out_b  <= wr_data_b(7 downto 0); 
                    when X"14" => dout_out_data_b  <= wr_data_b(3 downto 0);
                            
                    --when X"42" => hoge <= wr_data_b;
                    when others => null;
                end case;
            end if;
        end if;
    end process;


    -- Read Access
    process(CLK100M)
    begin
        if CLK100M'event and CLK100M = '1' then
            if rd_start_f = '1' then
                case address_b is
                    when X"00" => rd_data_b <= test_reg;

                    when X"01" => rd_data_b <= X"0000" & pwm_carrier_b;
                    when X"02" => rd_data_b <= X"0000" & pwm_u_ref_b;
                    when X"03" => rd_data_b <= X"0000" & pwm_v_ref_b;
                    when X"04" => rd_data_b <= X"0000" & pwm_w_ref_b;
                    when X"05" => rd_data_b <= X"0000" & B"000" & pwm_deadtime_b;
                    when X"06" => rd_data_b <= X"0000" & X"000" & B"000" & pwm_gate_en_b;
                    when X"07" => rd_data_b <= X"0000" & X"000" & B"000" & pwm_update_b;

                    when X"08" => rd_data_b <= ad_0_data_b;
                    when X"09" => rd_data_b <= ad_1_data_b;
                    when X"0A" => rd_data_b <= ad_2_data_b;
                    when X"0B" => rd_data_b <= ad_3_data_b;
                    when X"0C" => rd_data_b <= ad_4_data_b;
                    when X"0D" => rd_data_b <= ad_5_data_b;
                    when X"0E" => rd_data_b <= ad_6_data_b;
                    when X"0F" => rd_data_b <= ad_7_data_b;
                    
                    when X"10" => rd_data_b <= X"0000" & X"00" & gpio_16_23_out_b;
                    when X"11" => rd_data_b <= X"0000" & X"00" & gpio_16_23_in_b;
                    when X"12" => rd_data_b <= X"0000" & X"00" & gpio_8_15_out_b;
                    when X"14" => rd_data_b <= X"0000" & X"000" & dout_out_data_b;
                    when X"15" => rd_data_b <= X"0000" & X"000" & din_in_data_b;
                    when X"16" => rd_data_b <= X"0000" & X"00" & user_sw_in_data_b;

                    --when X"42" => rd_data_b <= hoge;
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    RD_DATA <= rd_data_b;


    -- ADC
    u_ad_0_1 : ad7357_if
        port map(
            CLK_AD      => CLK100M,
            RESET_IN   => RESET_IN,
            AD_A_100   => ad_0_data_s,
            AD_B_100   => ad_1_data_s,
            nAD_CS      => nAD7357_1_CS_OUT,
            AD_SCLK    => AD7357_1_SCLK_OUT,
            AD_DO_A    => AD7357_1_DA_IN,
            AD_DO_B    => AD7357_1_DB_IN
        );

    u_ad_2_3 : ad7357_if
        port map(
            CLK_AD      => CLK100M,
            RESET_IN   => RESET_IN,
            AD_A_100   => ad_2_data_s,
            AD_B_100   => ad_3_data_s,
            nAD_CS      => nAD7357_2_CS_OUT,
            AD_SCLK    => AD7357_2_SCLK_OUT,
            AD_DO_A    => AD7357_2_DA_IN,
            AD_DO_B    => AD7357_2_DB_IN
        );

    u_ad_4_5 : ad7357_if
        port map(
            CLK_AD      => CLK100M,
            RESET_IN   => RESET_IN,
            AD_A_100   => ad_4_data_s,
            AD_B_100   => ad_5_data_s,
            nAD_CS      => nAD7357_3_CS_OUT,
            AD_SCLK    => AD7357_3_SCLK_OUT,
            AD_DO_A    => AD7357_3_DA_IN,
            AD_DO_B    => AD7357_3_DB_IN
        );

    u_ad_6_7 : ad7357_if
        port map(
            CLK_AD      => CLK100M,
            RESET_IN   => RESET_IN,
            AD_A_100   => ad_6_data_s,
            AD_B_100   => ad_7_data_s,
            nAD_CS      => nAD7357_4_CS_OUT,
            AD_SCLK    => AD7357_4_SCLK_OUT,
            AD_DO_A    => AD7357_4_DA_IN,
            AD_DO_B    => AD7357_4_DB_IN
        );

    process(CLK100M)
    begin --All AD data latch when read ad_0.
        if CLK100M'event and CLK100M = '1' then
            if RESET_IN = '1' then
                ad_0_data_b <= X"0000" & X"0000";
                ad_1_data_b <= X"0000" & X"0000";
                ad_2_data_b <= X"0000" & X"0000";
                ad_3_data_b <= X"0000" & X"0000";
                ad_4_data_b <= X"0000" & X"0000";
                ad_5_data_b <= X"0000" & X"0000";
                ad_6_data_b <= X"0000" & X"0000";
                ad_7_data_b <= X"0000" & X"0000";
            elsif RD_START = '1' and ADDRESS = X"08" then
                ad_0_data_b <= ad_0_data_s;
                ad_1_data_b <= ad_1_data_s;
                ad_2_data_b <= ad_2_data_s;
                ad_3_data_b <= ad_3_data_s;
                ad_4_data_b <= ad_4_data_s;
                ad_5_data_b <= ad_5_data_s;
                ad_6_data_b <= ad_6_data_s;
                ad_7_data_b <= ad_7_data_s;
            end if;
        end if;
    end process;


    --PWM
    u_pwm_if : pwm_if
        port map(
            CLK_IN           => CLK100M,
            RESET_IN        => RESET_IN,
            nPWM_UP_OUT    => nPWM_UP_OUT,
            nPWM_UN_OUT    => nPWM_UN_OUT,
            nPWM_VP_OUT    => nPWM_VP_OUT,
            nPWM_VN_OUT    => nPWM_VN_OUT,
            nPWM_WP_OUT    => nPWM_WP_OUT,
            nPWM_WN_OUT    => nPWM_WN_OUT,
            nUSER_OPT_OUT => nUSER_OPT_OUT,

            --UPDATE    => pwm_update_b, -- Manual update
            UPDATE    => wr_start_ff, -- Automatic update
            CARRIER   => pwm_carrier_b,
            U_REF    => pwm_u_ref_b,
            V_REF    => pwm_v_ref_b,
            W_REF    => pwm_w_ref_b,
            DEADTIME => pwm_deadtime_b,
            GATE_EN  => pwm_gate_en_b
        );


    -- GPIO
    process(CLK100M)
    begin
        if CLK100M'event and CLK100M = '1' then
            if RESET_IN = '1' then
                gpio_16_23_in_b <= X"00";
            else
                gpio_16_23_out_bb <= gpio_16_23_out_b;
                gpio_8_15_out_bb  <= gpio_8_15_out_b;
                gpio_16_23_in_b    <= GPIO_16_23_IN;
            end if;
        end if;
    end process;

    GPIO_16_23_OUT  <= gpio_16_23_out_bb;
    GPIO_8_15_OUT   <= gpio_8_15_out_bb;


    -- USER IO
    process(CLK100M)
    begin
        if CLK100M'event and CLK100M = '1' then
            if RESET_IN = '1' then
                din_in_data_b       <= X"0";
                user_sw_in_data_b <= X"00";
            else
                dout_out_data_bb  <= dout_out_data_b;
                din_in_data_b       <= DIN_IN;
                user_sw_in_data_b <= USER_SW_IN;
            end if;
        end if;
    end process;

    DOUT_OUT <= dout_out_data_bb;


    -- USER LED test
    process(CLK100M)
    begin
        if(CLK100M'event and CLK100M = '1') then
            if RESET_IN = '1'then
                cnt_reg    <= B"000" & X"000000";  
                led_reg    <= "001";
            elsif cnt_reg(26) = '1' then 
                cnt_reg    <= B"000" & X"000000";
                led_reg(2) <= led_reg(1);
                led_reg(1) <= led_reg(0);
                led_reg(0) <= led_reg(2);
            else
                cnt_reg    <= cnt_reg + '1';
            end if;
        end if;
    end process;

    USER_LED_OUT <= led_reg;

end Behavioral;

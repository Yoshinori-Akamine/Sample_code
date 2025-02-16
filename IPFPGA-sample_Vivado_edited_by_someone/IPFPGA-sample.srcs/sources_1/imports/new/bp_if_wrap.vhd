----------------------------------------------------------------------------------
-- Company: Myway Plus Corporation 
-- Module Name: bp_if_wrap
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

entity bp_if_wrap is
    port (
        --== CLK, RESET, BDN, EFN ==========================
        CLK100M  : in std_logic;
        CLK200M  : in std_logic;
        RESET_IN : in std_logic;
        BDN_IN    : in std_logic_vector (2 downto 0);
        EFN_IN    : in std_logic;

        --== BUS BP <=> FPGA ==============================
        BPIFAD    : inout std_logic_vector (18 downto 1);--bit 18 is used as WAIT
        BPIFD     : inout std_logic_vector (15 downto 0);
        BPIFCE_N : inout std_logic;
        BPIFWE_N : in std_logic;
        BPIFP     : inout std_logic_vector (1 downto 0);
        BPIFWAIT : out std_logic_vector (1 downto 0); -- THIS WAIT is NOT USED!
        BPBOE_N  : out std_logic_vector (2 downto 0);  --BP Buffer Output Enable
        BPBDR_N  : out std_logic_vector (2 downto 0);

        --== I/F for IO module ============================
        ADDRESS       : out std_logic_vector (7 downto 0);
        WR_START     : out std_logic;
        RD_START     : out std_logic;
        RD_DATA_SET : in std_logic;
        WR_DATA       : out std_logic_vector (31 downto 0);
        RD_DATA       : in std_logic_vector (31 downto 0)
    );
end bp_if_wrap;

architecture Behavioral of bp_if_wrap is

    component bp_if_top is
        port (
            CLK100M  : in std_logic;
            CLK200M  : in std_logic;
            RESET_IN : in std_logic;
            BDN_IN    : in std_logic_vector (2 downto 0);
            EFN_IN    : in std_logic;

            BPIFAD_IN     : in std_logic_vector (18 downto 1);
            BPIFAD_OUT    : out std_logic_vector (18 downto 1);
            BPIFD_IN       : in std_logic_vector (15 downto 0);
            BPIFD_OUT     : out std_logic_vector (15 downto 0);
            BPIFCE_N_IN  : in std_logic;
            BPIFCE_N_OUT : out std_logic;
            BPIFWE_N       : in std_logic;
            BPIFP_IN       : in std_logic_vector (1 downto 0);
            BPIFP_OUT     : out std_logic_vector (1 downto 0);
            BPIFWAIT       : out std_logic_vector (1 downto 0);
            BPBOE_N        : out std_logic_vector (2 downto 0);
            BPBDR_N        : out std_logic_vector (2 downto 0);
            OUTPUT_EN     : out std_logic;

            ADDRESS       : out std_logic_vector (7 downto 0);
            WR_START     : out std_logic;
            RD_START     : out std_logic;
            RD_DATA_SET : in std_logic;
            WR_DATA       : out std_logic_vector (31 downto 0);
            RD_DATA       : in std_logic_vector (31 downto 0)
        );
    end component;
    
    attribute box_type : string;
    attribute box_type of bp_if_top : component is "black_box";

    signal bpifad_in_s      : std_logic_vector (18 downto 1);
    signal bpifad_out_s    : std_logic_vector (18 downto 1);
    signal bpifd_in_s       : std_logic_vector (15 downto 0);
    signal bpifd_out_s      : std_logic_vector (15 downto 0);
    signal bpifce_n_in_s   : std_logic;
    signal bpifce_n_out_s : std_logic;
    signal output_en_s      : std_logic;
    signal bpifp_in_s       : std_logic_vector (1 downto 0);
    signal bpifp_out_s     : std_logic_vector (1 downto 0);

begin

BPIFAD(17 downto 1) <= bpifad_out_s(17 downto 1)
                                          when (output_en_s = '1') else "ZZZZZZZZZZZZZZZZZ";
BPIFD        <= bpifd_out_s        when (output_en_s = '1') else "ZZZZZZZZZZZZZZZZ";
BPIFP        <= bpifp_out_s        when (output_en_s = '1') else "ZZ";
BPIFCE_N   <=  bpifce_n_out_s    when (output_en_s = '1') else 'Z';
BPIFAD(18) <=  bpifad_out_s(18) when (output_en_s = '1') else 'Z';

bpifad_in_s    <= BPIFAD;
bpifd_in_s      <= BPIFD;
bpifce_n_in_s <= BPIFCE_N;
bpifp_in_s      <= BPIFP;


u_bp_if_top : bp_if_top
    port map (
            CLK100M  => CLK100M,
            CLK200M  => CLK200M,
            RESET_IN => RESET_IN,
            BDN_IN    => BDN_IN,
            EFN_IN    => EFN_IN,

            BPIFAD_IN     => bpifad_in_s,
            BPIFAD_OUT    => bpifad_out_s,
            BPIFD_IN       => bpifd_in_s,
            BPIFD_OUT     => bpifd_out_s,
            BPIFCE_N_IN  => bpifce_n_in_s,
            BPIFCE_N_OUT => bpifce_n_out_s,
            BPIFWE_N       => BPIFWE_N,
            BPIFP_IN       => bpifp_in_s,
            BPIFP_OUT     => bpifp_out_s,
            BPIFWAIT       => BPIFWAIT,
            BPBOE_N        => BPBOE_N,
            BPBDR_N        => BPBDR_N,
            OUTPUT_EN     => output_en_s,

            ADDRESS       => ADDRESS,
            WR_START     => WR_START,
            RD_START     => RD_START,
            RD_DATA_SET => RD_DATA_SET,
            WR_DATA       => WR_DATA,
            RD_DATA       => RD_DATA
    );


end Behavioral;

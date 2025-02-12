----------------------------------------------------------------------------------
-- Company: Myway Plus Corporation 
-- Module Name: pwm_if
-- Target Devices: Kintex-7 xc7k70t
-- Tool Versions: Vivado 2016.4
-- Create Date: 2017/01/10
-- Revision: 1.0
----------------------------------------------------------------------------------

library ieee; --���낢��include
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

--���o�͐錾
entity pwm_if is
    port (
        CLK_IN         : in std_logic;
        RESET_IN       : in std_logic;
        nPWM_UP_OUT    : out std_logic; --nUSER_OPT_OUT(0)
        nPWM_UN_OUT    : out std_logic; --nUSER_OPT_OUT(1)
        nPWM_VP_OUT    : out std_logic; --nUSER_OPT_OUT(2)
        nPWM_VN_OUT    : out std_logic; --nUSER_OPT_OUT(3)
        nPWM_WP_OUT    : out std_logic; --nUSER_OPT_OUT(4)
        nPWM_WN_OUT    : out std_logic; --nUSER_OPT_OUT(5)
        nUSER_OPT_OUT  : out std_logic_vector (23 downto 6);

        UPDATE   : in std_logic;
        CARRIER  : in std_logic_vector (15 downto 0);
        U_REF    : in std_logic_vector (15 downto 0);
        V_REF    : in std_logic_vector (15 downto 0);
        W_REF    : in std_logic_vector (15 downto 0);
        DEADTIME : in std_logic_vector (12 downto 0);
        GATE_EN  : in std_logic;
        
        AD_SYNC_REF : in std_logic_vector (31 downto 0)
        
    );
end pwm_if;

architecture Behavioral of pwm_if is

    --�f�b�h�^�C���̓R���|�[�l���g�Ƃ��ČĂяo��
    component deadtime_if is
        Port (
            CLK_IN     : in std_logic;
            RESET_IN   : in std_logic;
            DT         : in std_logic_vector(12 downto 0);
            G_IN       : in std_logic;
            G_OUT      : out std_logic
        );
    end component;
    
    --�����Q�Ƃ̂��߂̓����M���錾
    signal carrier_cnt_max_b  : std_logic_vector (15 downto 0);
    signal carrier_cnt_max_bb : std_logic_vector (15 downto 0);
    signal carrier_cnt        : std_logic_vector (15 downto 0);
    signal carrier_up_down    : std_logic;
    signal u_ref_b            : std_logic_vector (15 downto 0);
    signal v_ref_b            : std_logic_vector (15 downto 0);
    signal w_ref_b            : std_logic_vector (15 downto 0);
    signal u_ref_bb           : std_logic_vector (15 downto 0);
    signal v_ref_bb           : std_logic_vector (15 downto 0);
    signal w_ref_bb           : std_logic_vector (15 downto 0);
    signal pwm_up             : std_logic;
    signal pwm_un             : std_logic;
    signal pwm_vp             : std_logic;
    signal pwm_vn             : std_logic;
    signal pwm_wp             : std_logic;
    signal pwm_wn             : std_logic;
    signal pwm_up_dt          : std_logic := '0';
    signal pwm_un_dt          : std_logic := '0';
    signal pwm_vp_dt          : std_logic := '0';
    signal pwm_vn_dt          : std_logic := '0';
    signal pwm_wp_dt          : std_logic := '0';
    signal pwm_wn_dt          : std_logic := '0';
    signal dt_b               : std_logic_vector (12 downto 0);
    signal dt_bb              : std_logic_vector (12 downto 0);
    signal gate_en_b          : std_logic := '0';
    
    signal sync_judge         : std_logic;
    signal sync_judge_tmp     : std_logic;
    signal sync_cnt_reset_flag: std_logic;
    signal sync_cnt_ref       : std_logic_vector (15 downto 0);
    signal carrier_reset_cnt  : std_logic_vector (15 downto 0);
    signal ad_current  : std_logic_vector (31 downto 0);
    
    signal sync_cnt_tmp : std_logic_vector (15 downto 0);
    signal sync_cnt_max : std_logic_vector (15 downto 0);
    signal sync_cnt_error : std_logic_vector (15 downto 0);
    signal sync_cnt_reset_judge: std_logic;
    signal sync_cnt_reset_conf: std_logic;
    
    attribute mark_debug : string;
    attribute mark_debug of sync_cnt_ref: signal is "true";
    attribute mark_debug of sync_judge: signal is "true";
    attribute mark_debug of carrier_cnt: signal is "true";
    attribute mark_debug of carrier_up_down: signal is "true";
    attribute mark_debug of u_ref_b: signal is "true";
    attribute mark_debug of sync_cnt_reset_flag: signal is "true";
    attribute mark_debug of pwm_up_dt: signal is "true";
    attribute mark_debug of pwm_un_dt: signal is "true";    
    attribute mark_debug of pwm_vp_dt: signal is "true"; 
    attribute mark_debug of pwm_vn_dt: signal is "true";
begin

    process(CLK_IN)
    begin
        if CLK_IN'event and CLK_IN = '1' then --�N���b�N�������オ������
            if RESET_IN = '1' then            --���Z�b�g�M������������
                gate_en_b <= '0';             --�Q�[�g�M�����u���b�N
            else                              --����ȊO
                gate_en_b <= GATE_EN;         --�Q�[�g�M��������
            end if;

            if RESET_IN = '1' then             --���Z�b�g�M������������
                carrier_cnt_max_b  <= X"024C"; -- 85kHz 024C(16) 588(10)
                carrier_cnt        <= X"0000"; --�J�E���g�̏����l��0
                u_ref_b <= X"0126";            --09C4(16)=2500(10)�F�f���[�e�B��0.5
                v_ref_b <= X"0126"; 
                w_ref_b <= X"0126"; 
                dt_b <= '0' & X"032";          --�f�b�h�^�C���w��@190(16)=400(10):4us�Cdt_b==[0400] 500ns
            elsif UPDATE = '1' then            --Update�M�������������C�e�l�̃��W�X�^���X�V����
                carrier_cnt_max_b <= CARRIER;  --�L�����A���g������
                u_ref_b <= U_REF;
                v_ref_b <= V_REF;
                w_ref_b <= W_REF;
                dt_b <= DEADTIME;              --���X�̎w�ߒl����
            end if;       
            
            
            if RESET_IN = '1' then
                sync_cnt_ref <= X"0000";
                carrier_reset_cnt <= X"026E";  -- bb/2    294-260 +  588
                sync_judge <= '0';  
                sync_judge_tmp <= '0';   
                ad_current <= X"0000" & X"0000"; 
            else
                sync_cnt_ref <= sync_cnt_ref + 1;
                sync_judge_tmp <= sync_judge;
                sync_judge <= not AD_SYNC_REF(31);
                ad_current <= AD_SYNC_REF; 
            end if;    
            
            if RESET_IN = '1' then
                sync_cnt_tmp <= X"0000";
                sync_cnt_reset_judge <= '0';
                sync_cnt_max <= X"0498";
                sync_cnt_error <= X"0024";
                sync_cnt_reset_conf <= '0';
            elsif sync_cnt_reset_conf = '1' then
            
            elsif sync_cnt_tmp < sync_cnt_max then
                sync_cnt_reset_conf <= '1';
                if (sync_cnt_max - sync_cnt_tmp) > sync_cnt_error then
                    sync_cnt_reset_judge <= '1';
                else
                    sync_cnt_reset_judge <= '0';
                end if;
            else
                if (sync_cnt_tmp - sync_cnt_max) > sync_cnt_error then
                    sync_cnt_reset_judge <= '1';
                else
                    sync_cnt_reset_judge <= '0';
                end if;
            end if;
            
            if RESET_IN = '1' then
                sync_cnt_reset_flag <= '0';            
            elsif sync_judge /= sync_judge_tmp and sync_judge = '1' then
                sync_cnt_tmp <= sync_cnt_ref;
                sync_cnt_ref <= X"0000";
                sync_cnt_reset_flag <= '0';
            elsif sync_cnt_ref = carrier_reset_cnt and sync_cnt_reset_judge = '1' then --a_n/4�̂Ƃ���                
                sync_cnt_reset_flag <= '1';
                sync_cnt_reset_conf <= '0';
                sync_cnt_reset_judge <= '0';
            elsif sync_cnt_reset_flag = '1' then
                sync_cnt_reset_flag <= '0';            
            end if;
                
            if RESET_IN = '1' then             --���Z�b�g�M������������
                carrier_up_down <= '1';        --
                carrier_cnt_max_bb  <= X"024C"; -- 85kHz   
            elsif sync_cnt_reset_flag = '1' then --a_n/4�̂Ƃ���
                carrier_up_down <= '1'; 
            elsif carrier_cnt = X"0001" and carrier_up_down = '0' then --�J�E���g�A�b�v�ֈڍs
                carrier_up_down <= '1';
            elsif carrier_cnt >= (carrier_cnt_max_bb -1) and carrier_up_down = '1' then --�J�E���g�_�E���ֈڍs
                carrier_up_down <= '0';
                carrier_cnt_max_bb <= carrier_cnt_max_b;
            end if;

            if RESET_IN = '1' then              --���Z�b�g�M������������
                carrier_cnt <= X"0000";         --�L�����A�J�E���g��0��
            elsif sync_cnt_reset_flag = '1' then
                carrier_cnt <= X"0000";         --�L�����A�J�E���g��0��
            elsif carrier_up_down = '1' then
                carrier_cnt <= carrier_cnt + 1; --�J�E���g�A�b�v
            else
                carrier_cnt <= carrier_cnt - 1; --�J�E���g�_�E��
            end if; 


        end if;
    end process;

    process(CLK_IN)
    begin
        if CLK_IN'event and CLK_IN = '1' then --�N���b�N�������オ������
            if RESET_IN = '1' then            --���Z�b�g�M������������
                u_ref_bb <= X"0126";          --09C4(16)=2500(10)�F�f���[�e�B��̏����l��0.5
                v_ref_bb <= X"0126";
                w_ref_bb <= X"0126";
            elsif carrier_cnt = (carrier_cnt_max_bb -1) and carrier_up_down = '1' then
                --�w�ߒl�̍X�V�����܂��s���Ȃ������Ƃ��̏����H
                --�J�E���g�A�b�v���}�b�N�X�ɂȂ钼�O�Ŏw�ߒl���X�V
                u_ref_bb <= u_ref_b;
                v_ref_bb <= v_ref_b;
                w_ref_bb <= w_ref_b;          --���X�̎w�ߒl����
            end if;

            --U��
            if RESET_IN = '1' then             --���Z�b�g�M������������
                pwm_up <= '0';
                pwm_un <= '0';
            elsif carrier_cnt >= u_ref_bb then --�L�����A�Ǝw�ߒl���r�C�L�����A�̂ق����傫���Ƃ�
                pwm_up <= '0';
                pwm_un <= '1';
            else                               --�L�����A�Ǝw�ߒl���r�C�w�ߒl�̂ق����傫���Ƃ�
                pwm_up <= '1';
                pwm_un <= '0';
            end if;

            --V��
            if RESET_IN = '1' then             --���Z�b�g�M������������
                pwm_vp <= '0';
                pwm_vn <= '0';
            elsif carrier_cnt >= v_ref_bb then --���_��
                pwm_vp <= '1';
                pwm_vn <= '0';
            else
                pwm_vp <= '0';
                pwm_vn <= '1';
            end if;

            --W��
            if RESET_IN = '1' then             --���Z�b�g�M������������
                pwm_wp <= '0';
                pwm_wn <= '0';
            elsif carrier_cnt >= w_ref_bb then
                pwm_wp <= '0';
                pwm_wn <= '1';
            else
                pwm_wp <= '1';
                pwm_wn <= '0';
            end if;

        end if;
    end process;

    process(CLK_IN)
    begin
        if CLK_IN'event and CLK_IN = '1' then              --�N���b�N�������オ������
            if RESET_IN = '1' then                           --���Z�b�g�M������������
                dt_bb <= '0' & X"032";                       --�f�b�h�^�C����4us��
            elsif carrier_cnt = (carrier_cnt_max_bb -1) then --
                dt_bb <= dt_b;                               --�f�b�h�^�C����ݒ�
            end if;
        end if;
    end process;

    dt_up : deadtime_if port map (CLK_IN => CLK_IN, RESET_IN => RESET_IN, DT => dt_bb, G_IN => pwm_up, G_OUT => pwm_up_dt);
    dt_un : deadtime_if port map (CLK_IN => CLK_IN, RESET_IN => RESET_IN, DT => dt_bb, G_IN => pwm_un, G_OUT => pwm_un_dt);
    dt_vp : deadtime_if port map (CLK_IN => CLK_IN, RESET_IN => RESET_IN, DT => dt_bb, G_IN => pwm_vp, G_OUT => pwm_vp_dt);
    dt_vn : deadtime_if port map (CLK_IN => CLK_IN, RESET_IN => RESET_IN, DT => dt_bb, G_IN => pwm_vn, G_OUT => pwm_vn_dt);
    dt_wp : deadtime_if port map (CLK_IN => CLK_IN, RESET_IN => RESET_IN, DT => dt_bb, G_IN => pwm_wp, G_OUT => pwm_wp_dt);
    dt_wn : deadtime_if port map (CLK_IN => CLK_IN, RESET_IN => RESET_IN, DT => dt_bb, G_IN => pwm_wn, G_OUT => pwm_wn_dt);

    --�Q�[�g��ON/OFF�𐧌�
--    nPWM_UP_OUT <= sync_judge;
    nPWM_UP_OUT <= not (pwm_up_dt and gate_en_b);
    nPWM_UN_OUT <= not (pwm_un_dt and gate_en_b);
    nPWM_VP_OUT <= not (pwm_vp_dt and gate_en_b);
    nPWM_VN_OUT <= not (pwm_vn_dt and gate_en_b);
    nPWM_WP_OUT <= not (pwm_wp_dt and gate_en_b);
    nPWM_WN_OUT <= not (pwm_wn_dt and gate_en_b);

    --SUB�{�[�h(OUT6~OUT23)�ɑS������U,V,W���o�́i�m�F�p�j
    nUSER_OPT_OUT(6)  <= not (pwm_up_dt and gate_en_b);
    nUSER_OPT_OUT(7)  <= not (pwm_un_dt and gate_en_b);
    nUSER_OPT_OUT(8)  <= not (pwm_vp_dt and gate_en_b);
    nUSER_OPT_OUT(9)  <= not (pwm_vn_dt and gate_en_b);
    nUSER_OPT_OUT(10) <= not (pwm_wp_dt and gate_en_b);
    nUSER_OPT_OUT(11) <= not (pwm_wn_dt and gate_en_b);
    nUSER_OPT_OUT(12) <= not (pwm_up_dt and gate_en_b);
    nUSER_OPT_OUT(13) <= not (pwm_un_dt and gate_en_b);
    nUSER_OPT_OUT(14) <= not (pwm_vp_dt and gate_en_b);
    nUSER_OPT_OUT(15) <= not (pwm_vn_dt and gate_en_b);
    nUSER_OPT_OUT(16) <= not (pwm_wp_dt and gate_en_b);
    nUSER_OPT_OUT(17) <= not (pwm_wn_dt and gate_en_b);
    nUSER_OPT_OUT(18) <= not (pwm_up_dt and gate_en_b);
    nUSER_OPT_OUT(19) <= not (pwm_un_dt and gate_en_b);
    nUSER_OPT_OUT(20) <= not (pwm_vp_dt and gate_en_b);
    nUSER_OPT_OUT(21) <= not (pwm_vn_dt and gate_en_b);
    nUSER_OPT_OUT(22) <= not (pwm_wp_dt and gate_en_b);
    nUSER_OPT_OUT(23) <= not (pwm_wn_dt and gate_en_b);

end Behavioral;


----------------------------------------------------------------------------------
--Deadtime module
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

entity deadtime_if is
    Port (
        CLK_IN     : in std_logic;
        RESET_IN   : in std_logic;
        DT         : in std_logic_vector(12 downto 0);
        G_IN       : in std_logic;
        G_OUT      : out std_logic
        );
end deadtime_if;

architecture behavioral of deadtime_if is
signal d_g_in : std_logic;
signal cnt    : std_logic_vector(12 downto 0);
signal gate   : std_logic;

begin

    process(CLK_IN)
    begin
        if (CLK_IN'event and CLK_IN='1') then        --�N���b�N�������オ������
            if RESET_IN = '1' then                   --���Z�b�g�M������������
                d_g_in <= '0';                       --�Q�[�g�M�����u���b�N
            else
                d_g_in <= G_IN;                      --�Q�[�g�M����ON
            end if;

            if RESET_IN = '1' then                   --���Z�b�g�M������������
                cnt   <= "0000000000001";            --�J�E���g��1��
                gate <= '0';                         --�Q�[�g�M�����u���b�N
            elsif (d_g_in = '0' and G_IN = '1') then --PWM�M���̗����オ������o���ă��Z�b�g
                cnt   <= "0000000000001";            --�J�E���g��1��
                gate <= '0';                         --�Q�[�g�M�����u���b�N
            elsif (cnt >= DT) then                   --�f�b�h�^�C���̈�ȊO�ł�
                cnt   <= "1111111111111";            --�o�O��Ȃ��悤�ɃJ�E���g��MAX��
                gate <= d_g_in;                      --�Q�[�g�M����ON
            elsif (cnt /= "1111111111111") then      --�f�b�h�^�C���̈�̒��ł�
                cnt   <= cnt + 1;                    --�J�E���g���C���N�������g
                gate <= '0';                         --�Q�[�g�M�����u���b�N
            else
                gate <= d_g_in;                      --�悤�킩��Ȃ��Ƃ��͂Ƃ肠�����Q�[�g�M����ON
            end if;
        end if;
    end process;

    G_OUT <= gate;

end behavioral;
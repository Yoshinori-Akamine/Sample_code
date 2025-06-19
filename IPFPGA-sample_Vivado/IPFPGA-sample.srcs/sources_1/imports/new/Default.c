#include <mwio4.h> // PE-Expert4専用ライブラリを利用するためのヘッダファイル

// FPGAのボード番号
#define BDN_FPGA 1 // FPGAボード (FPGAの制御)

// // 固定の定数
// #define INV_FREQ 85000.0 // キャリア周波数を浮動小数点に変更

// タイマー設定（単位: マイクロ秒）
#define TIMER0_INTERVAL 100000   // タイマー0の間隔（100 ms）

// 書き換え可能な変数（PE-Viewで後から変更可能）
// volatile int variable = number; // 使用したい変数
volatile int freq_cnt = 588;     // 周波数のカウンタの値 11.76us → 1176*10ns → 三角波の波光値=1176/2=588
volatile int dt = 50;           // デッドタイム（10ns単位）
volatile int enable = 1;         // 有効化
// volatile int Duty = 950; // デューティ比 times 1000 


// FPGAレジスタのアドレス
#define addr_freq_cnt  0x01 // FPGAのアドレス (周波数のカウンタ)
#define addr_uref 0x02
#define addr_deadtime  0x05 // FPGAのアドレス (デッドタイム)
#define addr_enable  0x06 // FPGAのアドレス (有効化)
#define addr_Duty 0x24 // デューティ比


// 計算専用の変数（内部計算のみで更新）
int internal_variableA;
float internal_variableB;  

// 計算専用変数を再計算する関数
// タイマーで定期的に呼び出す（割り込み）
void update_calculated_values(void)
{
  // 計算
  // 例：a = b + c;
  // 例：internal_variableA = variable * 100;
}

// FPGAに計算済みの値を書き込む関数
interrupt void write_to_fpga(void)
{
    // タイマー0のイベントフラグをクリアし、次の割り込みを有効化
    C6657_timer0_clear_eventflag();

    // 再計算を実施
    update_calculated_values();

    // Write FPGA
    // 例：IPFPGA_write(BDN_FPGA, addr_variable, variable);
    IPFPGA_write(BDN_FPGA, addr_freq_cnt, freq_cnt);
    IPFPGA_write(BDN_FPGA, addr_uref, uref);
    IPFPGA_write(BDN_FPGA, addr_deadtime, dt);
    IPFPGA_write(BDN_FPGA, addr_enable, enable);
    // IPFPGA_write(BDN_FPGA, addr_Duty, Duty);
}

void initialize(void)
{
    // 割り込みを一時無効化
    int_disable();

    // タイマー0の初期化
    C6657_timer0_init(TIMER0_INTERVAL);
    C6657_timer0_init_vector(write_to_fpga, (CSL_IntcVectId)6);
    C6657_timer0_start();
    C6657_timer0_enable_int();
    // 周波数をFPGAに書き込む
    // 割り込みを再度有効化
    int_enable();
}

// メイン関数
int MW_main(void)
{
    // 初期化処理（タイマーの設定）
    initialize();

    // 無限ループ
    while (1)
    {
        // 必要なら追加処理をここに記述
    }

    return 0; // 実際には到達しない
}

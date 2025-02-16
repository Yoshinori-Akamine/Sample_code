#---!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!---
#---!!! Do NOT rewrite this file !!!---
#---!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!---


#-- Config. Rate ---------------------------------------------
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


#-- Timing Setting --------------------------------------------
#-- 50MHz Clock Input --
#create_clock -period (20.000ns(50MHz)) -name CLK50M_IN -waveform {0.000 10.000(Duty 50%)} [get_ports CLK50M_IN]
create_clock -period 20.000 -name CLK50M_IN -waveform {0.000 10.000} [get_ports CLK50M_IN]
create_clock -period 20.000 -name CLK50M_2_IN -waveform {0.000 10.000} [get_ports CLK50M_2_IN]

set_false_path -from [get_clocks [list [get_clocks -of_objects [get_pins u_clk_gen/pll/CLKOUT1]] [get_clocks -of_objects [get_pins u_clk_gen/pll/CLKOUT2]]]] -to [get_clocks [list [get_clocks -of_objects [get_pins u_clk_gen/pll/CLKOUT1]] [get_clocks -of_objects [get_pins u_clk_gen/pll/CLKOUT2]]]]


#-- Input Delay --

#set_input_delay


#-- Output Delay --

#set_output_delay


#-- CLK, XRST, BDN ----------------------------------------------
set_property PACKAGE_PIN E18 [get_ports CLK50M_IN]
set_property IOSTANDARD LVCMOS33 [get_ports CLK50M_IN]

set_property PACKAGE_PIN F17 [get_ports CLK50M_2_IN]
set_property IOSTANDARD LVCMOS33 [get_ports CLK50M_2_IN]

set_property PACKAGE_PIN M20 [get_ports nXRST_IN]
set_property IOSTANDARD LVCMOS33 [get_ports nXRST_IN]

set_property PACKAGE_PIN L19 [get_ports {BDN_IN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BDN_IN[0]}]

set_property PACKAGE_PIN J20 [get_ports {BDN_IN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BDN_IN[1]}]

set_property PACKAGE_PIN L20 [get_ports {BDN_IN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BDN_IN[2]}]

set_property PACKAGE_PIN K20 [get_ports EFN_IN]
set_property IOSTANDARD LVCMOS33 [get_ports EFN_IN]


#-- BUS BP <=> FPGA ------------------------------------------
# --Backplane Interface Address--
set_property PACKAGE_PIN H24 [get_ports {BPIFAD[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[1]}]

set_property PACKAGE_PIN J23 [get_ports {BPIFAD[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[2]}]

set_property PACKAGE_PIN K22 [get_ports {BPIFAD[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[3]}]

set_property PACKAGE_PIN K23 [get_ports {BPIFAD[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[4]}]

set_property PACKAGE_PIN J26 [get_ports {BPIFAD[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[5]}]

set_property PACKAGE_PIN J25 [get_ports {BPIFAD[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[6]}]

set_property PACKAGE_PIN J24 [get_ports {BPIFAD[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[7]}]

set_property PACKAGE_PIN H26 [get_ports {BPIFAD[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[8]}]

set_property PACKAGE_PIN G26 [get_ports {BPIFAD[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[9]}]

set_property PACKAGE_PIN G25 [get_ports {BPIFAD[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[10]}]

set_property PACKAGE_PIN G24 [get_ports {BPIFAD[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[11]}]

set_property PACKAGE_PIN E26 [get_ports {BPIFAD[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[12]}]

set_property PACKAGE_PIN E25 [get_ports {BPIFAD[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[13]}]

set_property PACKAGE_PIN D26 [get_ports {BPIFAD[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[14]}]

set_property PACKAGE_PIN D25 [get_ports {BPIFAD[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[15]}]

set_property PACKAGE_PIN D24 [get_ports {BPIFAD[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[16]}]

set_property PACKAGE_PIN C26 [get_ports {BPIFAD[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[17]}]

set_property PACKAGE_PIN B26 [get_ports {BPIFAD[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFAD[18]}]


#--Backplane Interface Data--
set_property PACKAGE_PIN A20 [get_ports {BPIFD[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[0]}]

set_property PACKAGE_PIN B20 [get_ports {BPIFD[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[1]}]

set_property PACKAGE_PIN B21 [get_ports {BPIFD[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[2]}]

set_property PACKAGE_PIN C21 [get_ports {BPIFD[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[3]}]

set_property PACKAGE_PIN C22 [get_ports {BPIFD[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[4]}]

set_property PACKAGE_PIN E23 [get_ports {BPIFD[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[5]}]

set_property PACKAGE_PIN D21 [get_ports {BPIFD[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[6]}]

set_property PACKAGE_PIN D23 [get_ports {BPIFD[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[7]}]

set_property PACKAGE_PIN E21 [get_ports {BPIFD[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[8]}]

set_property PACKAGE_PIN E22 [get_ports {BPIFD[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[9]}]

set_property PACKAGE_PIN F22 [get_ports {BPIFD[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[10]}]

set_property PACKAGE_PIN F23 [get_ports {BPIFD[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[11]}]

set_property PACKAGE_PIN G21 [get_ports {BPIFD[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[12]}]

set_property PACKAGE_PIN G22 [get_ports {BPIFD[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[13]}]

set_property PACKAGE_PIN H22 [get_ports {BPIFD[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[14]}]

set_property PACKAGE_PIN H23 [get_ports {BPIFD[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFD[15]}]


#--BPIF_EN--
set_property PACKAGE_PIN M22 [get_ports BPIFCE_N]
set_property IOSTANDARD LVCMOS33 [get_ports BPIFCE_N]

set_property PACKAGE_PIN N22 [get_ports BPIFWE_N]
set_property IOSTANDARD LVCMOS33 [get_ports BPIFWE_N]


#--BPIFP--
set_property PACKAGE_PIN A24 [get_ports {BPIFP[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFP[0]}]

set_property PACKAGE_PIN A23 [get_ports {BPIFP[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFP[1]}]


#--BPIFWAIT--
set_property PACKAGE_PIN F24 [get_ports {BPIFWAIT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFWAIT[0]}]

set_property PACKAGE_PIN F25 [get_ports {BPIFWAIT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPIFWAIT[1]}]


#--BPBOE_N--
#F_UPP0OE#
set_property PACKAGE_PIN T22 [get_ports {BPBOE_N[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPBOE_N[0]}]

#F_UPP0CNT_OE#
set_property PACKAGE_PIN T23 [get_ports {BPBOE_N[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPBOE_N[1]}]

#F_UPP1OE#
set_property PACKAGE_PIN R23 [get_ports {BPBOE_N[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPBOE_N[2]}]


#--BPBDR_N--
#F_UPP0DIR
set_property PACKAGE_PIN P23 [get_ports {BPBDR_N[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPBDR_N[0]}]

#F_UPP0CNT_DIR
set_property PACKAGE_PIN T24 [get_ports {BPBDR_N[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPBDR_N[1]}]

#F_UPP1DIR
set_property PACKAGE_PIN P21 [get_ports {BPBDR_N[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BPBDR_N[2]}]





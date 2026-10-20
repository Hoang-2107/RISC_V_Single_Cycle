## ============================================================================
## Rang buoc chan cho RISCV_ArtyA7 tren board Digilent Arty A7-100T
## FPGA: xc7a100tcsg324-1
## ============================================================================

## ---------- Clock 100 MHz ----------
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports CLK100MHZ]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports CLK100MHZ]

## ---------- Cong tac SW0..SW3 ----------
set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33 } [get_ports {sw[0]}]
set_property -dict { PACKAGE_PIN C11  IOSTANDARD LVCMOS33 } [get_ports {sw[1]}]
set_property -dict { PACKAGE_PIN C10  IOSTANDARD LVCMOS33 } [get_ports {sw[2]}]
set_property -dict { PACKAGE_PIN A10  IOSTANDARD LVCMOS33 } [get_ports {sw[3]}]

## ---------- Nut nhan BTN0..BTN3 ----------
set_property -dict { PACKAGE_PIN D9   IOSTANDARD LVCMOS33 } [get_ports {btn[0]}]
set_property -dict { PACKAGE_PIN C9   IOSTANDARD LVCMOS33 } [get_ports {btn[1]}]
set_property -dict { PACKAGE_PIN B9   IOSTANDARD LVCMOS33 } [get_ports {btn[2]}]
set_property -dict { PACKAGE_PIN B8   IOSTANDARD LVCMOS33 } [get_ports {btn[3]}]

## ---------- 4 LED xanh LD4..LD7 ----------
set_property -dict { PACKAGE_PIN H5   IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN J5   IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN T9   IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN T10  IOSTANDARD LVCMOS33 } [get_ports {led[3]}]

## ---------- LED RGB (chi dung mot so mau) ----------
set_property -dict { PACKAGE_PIN F6   IOSTANDARD LVCMOS33 } [get_ports led0_g]
set_property -dict { PACKAGE_PIN G3   IOSTANDARD LVCMOS33 } [get_ports led1_r]
set_property -dict { PACKAGE_PIN H6   IOSTANDARD LVCMOS33 } [get_ports led3_g]
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 } [get_ports led3_b]

## ---------- Nut nhan / cong tac la tin hieu bat dong bo ----------
set_false_path -from [get_ports {btn[*]}]
set_false_path -from [get_ports {sw[*]}]

## ---------- Clock CPU (qua BUFGCE, chi co 1 xung moi 0.5s hoac moi lan bam nut) ----------
## CPU don chu ky co duong to hop dai (PC -> ROM -> RegFile -> ALU -> DMEM -> RegFile).
## Hai canh cpu_clk lien tiep luon cach nhau rat xa, nen cho phep duong nay dai toi
## 8 chu ky 100 MHz (80 ns) thay vi 10 ns.
create_generated_clock -name cpu_clk -source [get_pins bufgce_cpu/I] -divide_by 1 [get_pins bufgce_cpu/O]
set_multicycle_path -setup 8 -from [get_clocks cpu_clk] -to [get_clocks cpu_clk]
set_multicycle_path -hold  7 -from [get_clocks cpu_clk] -to [get_clocks cpu_clk]

## ---------- Cau hinh ----------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

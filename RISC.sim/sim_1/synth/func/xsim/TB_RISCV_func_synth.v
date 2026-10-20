// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Oct  9 01:55:12 2026
// Host        : DESKTOP-SAPCC4D running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               D:/RISC/RISC.sim/sim_1/synth/func/xsim/TB_RISCV_func_synth.v
// Design      : RISCV_ArtyA7
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* DEB_CNT = "1000000" *) (* TICK_DIV = "50000000" *) 
(* NotValidForBitStream *)
module RISCV_ArtyA7
   (CLK100MHZ,
    btn,
    sw,
    led,
    led0_g,
    led1_r,
    led3_g,
    led3_b);
  input CLK100MHZ;
  input [3:0]btn;
  input [3:0]sw;
  output [3:0]led;
  output led0_g;
  output led1_r;
  output led3_g;
  output led3_b;

  wire CLK100MHZ;
  wire CLK100MHZ_IBUF;
  wire CLK100MHZ_IBUF_BUFG;
  wire [3:0]btn;
  wire [1:0]btn_IBUF;
  wire cpu_ce;
  wire cpu_clk;
  wire [19:1]data0;
  wire [19:0]deb;
  wire \deb[19]_i_1_n_0 ;
  wire \deb[19]_i_3_n_0 ;
  wire \deb[19]_i_5_n_0 ;
  wire \deb[19]_i_6_n_0 ;
  wire \deb[19]_i_7_n_0 ;
  wire \deb[19]_i_8_n_0 ;
  wire \deb[19]_i_9_n_0 ;
  wire \deb_reg[12]_i_2_n_0 ;
  wire \deb_reg[12]_i_2_n_1 ;
  wire \deb_reg[12]_i_2_n_2 ;
  wire \deb_reg[12]_i_2_n_3 ;
  wire \deb_reg[16]_i_2_n_0 ;
  wire \deb_reg[16]_i_2_n_1 ;
  wire \deb_reg[16]_i_2_n_2 ;
  wire \deb_reg[16]_i_2_n_3 ;
  wire \deb_reg[19]_i_4_n_2 ;
  wire \deb_reg[19]_i_4_n_3 ;
  wire \deb_reg[4]_i_2_n_0 ;
  wire \deb_reg[4]_i_2_n_1 ;
  wire \deb_reg[4]_i_2_n_2 ;
  wire \deb_reg[4]_i_2_n_3 ;
  wire \deb_reg[8]_i_2_n_0 ;
  wire \deb_reg[8]_i_2_n_1 ;
  wire \deb_reg[8]_i_2_n_2 ;
  wire \deb_reg[8]_i_2_n_3 ;
  wire \deb_reg_n_0_[0] ;
  wire \deb_reg_n_0_[10] ;
  wire \deb_reg_n_0_[11] ;
  wire \deb_reg_n_0_[12] ;
  wire \deb_reg_n_0_[13] ;
  wire \deb_reg_n_0_[14] ;
  wire \deb_reg_n_0_[15] ;
  wire \deb_reg_n_0_[16] ;
  wire \deb_reg_n_0_[17] ;
  wire \deb_reg_n_0_[18] ;
  wire \deb_reg_n_0_[19] ;
  wire \deb_reg_n_0_[1] ;
  wire \deb_reg_n_0_[2] ;
  wire \deb_reg_n_0_[3] ;
  wire \deb_reg_n_0_[4] ;
  wire \deb_reg_n_0_[5] ;
  wire \deb_reg_n_0_[6] ;
  wire \deb_reg_n_0_[7] ;
  wire \deb_reg_n_0_[8] ;
  wire \deb_reg_n_0_[9] ;
  wire [0:0]div_cnt;
  wire \div_cnt[25]_i_1_n_0 ;
  wire \div_cnt[25]_i_3_n_0 ;
  wire \div_cnt[25]_i_4_n_0 ;
  wire \div_cnt[25]_i_5_n_0 ;
  wire \div_cnt[25]_i_6_n_0 ;
  wire \div_cnt[25]_i_7_n_0 ;
  wire \div_cnt[25]_i_8_n_0 ;
  wire \div_cnt_reg[12]_i_1_n_0 ;
  wire \div_cnt_reg[12]_i_1_n_1 ;
  wire \div_cnt_reg[12]_i_1_n_2 ;
  wire \div_cnt_reg[12]_i_1_n_3 ;
  wire \div_cnt_reg[12]_i_1_n_4 ;
  wire \div_cnt_reg[12]_i_1_n_5 ;
  wire \div_cnt_reg[12]_i_1_n_6 ;
  wire \div_cnt_reg[12]_i_1_n_7 ;
  wire \div_cnt_reg[16]_i_1_n_0 ;
  wire \div_cnt_reg[16]_i_1_n_1 ;
  wire \div_cnt_reg[16]_i_1_n_2 ;
  wire \div_cnt_reg[16]_i_1_n_3 ;
  wire \div_cnt_reg[16]_i_1_n_4 ;
  wire \div_cnt_reg[16]_i_1_n_5 ;
  wire \div_cnt_reg[16]_i_1_n_6 ;
  wire \div_cnt_reg[16]_i_1_n_7 ;
  wire \div_cnt_reg[20]_i_1_n_0 ;
  wire \div_cnt_reg[20]_i_1_n_1 ;
  wire \div_cnt_reg[20]_i_1_n_2 ;
  wire \div_cnt_reg[20]_i_1_n_3 ;
  wire \div_cnt_reg[20]_i_1_n_4 ;
  wire \div_cnt_reg[20]_i_1_n_5 ;
  wire \div_cnt_reg[20]_i_1_n_6 ;
  wire \div_cnt_reg[20]_i_1_n_7 ;
  wire \div_cnt_reg[24]_i_1_n_0 ;
  wire \div_cnt_reg[24]_i_1_n_1 ;
  wire \div_cnt_reg[24]_i_1_n_2 ;
  wire \div_cnt_reg[24]_i_1_n_3 ;
  wire \div_cnt_reg[24]_i_1_n_4 ;
  wire \div_cnt_reg[24]_i_1_n_5 ;
  wire \div_cnt_reg[24]_i_1_n_6 ;
  wire \div_cnt_reg[24]_i_1_n_7 ;
  wire \div_cnt_reg[25]_i_2_n_7 ;
  wire \div_cnt_reg[4]_i_1_n_0 ;
  wire \div_cnt_reg[4]_i_1_n_1 ;
  wire \div_cnt_reg[4]_i_1_n_2 ;
  wire \div_cnt_reg[4]_i_1_n_3 ;
  wire \div_cnt_reg[4]_i_1_n_4 ;
  wire \div_cnt_reg[4]_i_1_n_5 ;
  wire \div_cnt_reg[4]_i_1_n_6 ;
  wire \div_cnt_reg[4]_i_1_n_7 ;
  wire \div_cnt_reg[8]_i_1_n_0 ;
  wire \div_cnt_reg[8]_i_1_n_1 ;
  wire \div_cnt_reg[8]_i_1_n_2 ;
  wire \div_cnt_reg[8]_i_1_n_3 ;
  wire \div_cnt_reg[8]_i_1_n_4 ;
  wire \div_cnt_reg[8]_i_1_n_5 ;
  wire \div_cnt_reg[8]_i_1_n_6 ;
  wire \div_cnt_reg[8]_i_1_n_7 ;
  wire \div_cnt_reg_n_0_[0] ;
  wire \div_cnt_reg_n_0_[10] ;
  wire \div_cnt_reg_n_0_[11] ;
  wire \div_cnt_reg_n_0_[12] ;
  wire \div_cnt_reg_n_0_[13] ;
  wire \div_cnt_reg_n_0_[14] ;
  wire \div_cnt_reg_n_0_[15] ;
  wire \div_cnt_reg_n_0_[16] ;
  wire \div_cnt_reg_n_0_[17] ;
  wire \div_cnt_reg_n_0_[18] ;
  wire \div_cnt_reg_n_0_[19] ;
  wire \div_cnt_reg_n_0_[1] ;
  wire \div_cnt_reg_n_0_[20] ;
  wire \div_cnt_reg_n_0_[21] ;
  wire \div_cnt_reg_n_0_[22] ;
  wire \div_cnt_reg_n_0_[23] ;
  wire \div_cnt_reg_n_0_[24] ;
  wire \div_cnt_reg_n_0_[25] ;
  wire \div_cnt_reg_n_0_[2] ;
  wire \div_cnt_reg_n_0_[3] ;
  wire \div_cnt_reg_n_0_[4] ;
  wire \div_cnt_reg_n_0_[5] ;
  wire \div_cnt_reg_n_0_[6] ;
  wire \div_cnt_reg_n_0_[7] ;
  wire \div_cnt_reg_n_0_[8] ;
  wire \div_cnt_reg_n_0_[9] ;
  wire [3:0]led;
  wire led0_g;
  wire led0_g_OBUF;
  wire led1_r;
  wire led1_r_OBUF;
  wire led3_b;
  wire led3_b_OBUF;
  wire led3_g;
  wire led3_g_OBUF;
  wire p_0_in;
  wire [3:0]p_0_in__0;
  wire [3:0]pwm_reg__0;
  wire reset;
  wire \rst_sync_reg_n_0_[0] ;
  wire step_prev;
  wire step_stable_i_1_n_0;
  wire step_stable_reg_n_0;
  wire \step_sync_reg_n_0_[0] ;
  wire [3:0]sw;
  wire [3:0]sw_IBUF;
  wire tick_reg_n_0;
  wire [3:2]\NLW_deb_reg[19]_i_4_CO_UNCONNECTED ;
  wire [3:3]\NLW_deb_reg[19]_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_div_cnt_reg[25]_i_2_CO_UNCONNECTED ;
  wire [3:1]\NLW_div_cnt_reg[25]_i_2_O_UNCONNECTED ;

  BUFG CLK100MHZ_IBUF_BUFG_inst
       (.I(CLK100MHZ_IBUF),
        .O(CLK100MHZ_IBUF_BUFG));
  IBUF CLK100MHZ_IBUF_inst
       (.I(CLK100MHZ),
        .O(CLK100MHZ_IBUF));
  IBUF \btn_IBUF[0]_inst 
       (.I(btn[0]),
        .O(btn_IBUF[0]));
  IBUF \btn_IBUF[1]_inst 
       (.I(btn[1]),
        .O(btn_IBUF[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFGCE" *) 
  (* XILINX_TRANSFORM_PINMAP = "CE:CE0 I:I0" *) 
  BUFGCTRL #(
    .CE_TYPE_CE0("SYNC"),
    .CE_TYPE_CE1("SYNC"),
    .INIT_OUT(0),
    .PRESELECT_I0("TRUE"),
    .PRESELECT_I1("FALSE")) 
    bufgce_cpu
       (.CE0(cpu_ce),
        .CE1(1'b0),
        .I0(CLK100MHZ_IBUF),
        .I1(1'b1),
        .IGNORE0(1'b0),
        .IGNORE1(1'b1),
        .O(cpu_clk),
        .S0(1'b1),
        .S1(1'b0));
  LUT5 #(
    .INIT(32'hEAEAEFEA)) 
    bufgce_cpu_i_1
       (.I0(reset),
        .I1(tick_reg_n_0),
        .I2(sw_IBUF[0]),
        .I3(step_stable_reg_n_0),
        .I4(step_prev),
        .O(cpu_ce));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \deb[0]_i_1 
       (.I0(\deb_reg_n_0_[0] ),
        .O(deb[0]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[10]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[10]),
        .O(deb[10]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[11]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[11]),
        .O(deb[11]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[12]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[12]),
        .O(deb[12]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[13]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[13]),
        .O(deb[13]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[14]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[14]),
        .O(deb[14]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[15]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[15]),
        .O(deb[15]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[16]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[16]),
        .O(deb[16]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[17]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[17]),
        .O(deb[17]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[18]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[18]),
        .O(deb[18]));
  LUT2 #(
    .INIT(4'h9)) 
    \deb[19]_i_1 
       (.I0(p_0_in),
        .I1(step_stable_reg_n_0),
        .O(\deb[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[19]_i_2 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[19]),
        .O(deb[19]));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \deb[19]_i_3 
       (.I0(\deb[19]_i_5_n_0 ),
        .I1(\deb[19]_i_6_n_0 ),
        .I2(\deb[19]_i_7_n_0 ),
        .I3(\deb[19]_i_8_n_0 ),
        .I4(\deb[19]_i_9_n_0 ),
        .O(\deb[19]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \deb[19]_i_5 
       (.I0(\deb_reg_n_0_[1] ),
        .I1(\deb_reg_n_0_[0] ),
        .I2(\deb_reg_n_0_[3] ),
        .I3(\deb_reg_n_0_[2] ),
        .O(\deb[19]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \deb[19]_i_6 
       (.I0(\deb_reg_n_0_[13] ),
        .I1(\deb_reg_n_0_[12] ),
        .I2(\deb_reg_n_0_[14] ),
        .I3(\deb_reg_n_0_[15] ),
        .O(\deb[19]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \deb[19]_i_7 
       (.I0(\deb_reg_n_0_[17] ),
        .I1(\deb_reg_n_0_[16] ),
        .I2(\deb_reg_n_0_[19] ),
        .I3(\deb_reg_n_0_[18] ),
        .O(\deb[19]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFFFD)) 
    \deb[19]_i_8 
       (.I0(\deb_reg_n_0_[9] ),
        .I1(\deb_reg_n_0_[8] ),
        .I2(\deb_reg_n_0_[11] ),
        .I3(\deb_reg_n_0_[10] ),
        .O(\deb[19]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'hFFF7)) 
    \deb[19]_i_9 
       (.I0(\deb_reg_n_0_[5] ),
        .I1(\deb_reg_n_0_[4] ),
        .I2(\deb_reg_n_0_[7] ),
        .I3(\deb_reg_n_0_[6] ),
        .O(\deb[19]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[1]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[1]),
        .O(deb[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[2]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[2]),
        .O(deb[2]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[3]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[3]),
        .O(deb[3]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[4]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[4]),
        .O(deb[4]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[5]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[5]),
        .O(deb[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \deb[6]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[6]),
        .O(deb[6]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[7]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[7]),
        .O(deb[7]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[8]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[8]),
        .O(deb[8]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \deb[9]_i_1 
       (.I0(\deb[19]_i_3_n_0 ),
        .I1(data0[9]),
        .O(deb[9]));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[0]),
        .Q(\deb_reg_n_0_[0] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[10] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[10]),
        .Q(\deb_reg_n_0_[10] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[11] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[11]),
        .Q(\deb_reg_n_0_[11] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[12] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[12]),
        .Q(\deb_reg_n_0_[12] ),
        .R(\deb[19]_i_1_n_0 ));
  CARRY4 \deb_reg[12]_i_2 
       (.CI(\deb_reg[8]_i_2_n_0 ),
        .CO({\deb_reg[12]_i_2_n_0 ,\deb_reg[12]_i_2_n_1 ,\deb_reg[12]_i_2_n_2 ,\deb_reg[12]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[12:9]),
        .S({\deb_reg_n_0_[12] ,\deb_reg_n_0_[11] ,\deb_reg_n_0_[10] ,\deb_reg_n_0_[9] }));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[13] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[13]),
        .Q(\deb_reg_n_0_[13] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[14] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[14]),
        .Q(\deb_reg_n_0_[14] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[15] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[15]),
        .Q(\deb_reg_n_0_[15] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[16] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[16]),
        .Q(\deb_reg_n_0_[16] ),
        .R(\deb[19]_i_1_n_0 ));
  CARRY4 \deb_reg[16]_i_2 
       (.CI(\deb_reg[12]_i_2_n_0 ),
        .CO({\deb_reg[16]_i_2_n_0 ,\deb_reg[16]_i_2_n_1 ,\deb_reg[16]_i_2_n_2 ,\deb_reg[16]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[16:13]),
        .S({\deb_reg_n_0_[16] ,\deb_reg_n_0_[15] ,\deb_reg_n_0_[14] ,\deb_reg_n_0_[13] }));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[17] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[17]),
        .Q(\deb_reg_n_0_[17] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[18] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[18]),
        .Q(\deb_reg_n_0_[18] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[19] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[19]),
        .Q(\deb_reg_n_0_[19] ),
        .R(\deb[19]_i_1_n_0 ));
  CARRY4 \deb_reg[19]_i_4 
       (.CI(\deb_reg[16]_i_2_n_0 ),
        .CO({\NLW_deb_reg[19]_i_4_CO_UNCONNECTED [3:2],\deb_reg[19]_i_4_n_2 ,\deb_reg[19]_i_4_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_deb_reg[19]_i_4_O_UNCONNECTED [3],data0[19:17]}),
        .S({1'b0,\deb_reg_n_0_[19] ,\deb_reg_n_0_[18] ,\deb_reg_n_0_[17] }));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[1]),
        .Q(\deb_reg_n_0_[1] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[2]),
        .Q(\deb_reg_n_0_[2] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[3]),
        .Q(\deb_reg_n_0_[3] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[4] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[4]),
        .Q(\deb_reg_n_0_[4] ),
        .R(\deb[19]_i_1_n_0 ));
  CARRY4 \deb_reg[4]_i_2 
       (.CI(1'b0),
        .CO({\deb_reg[4]_i_2_n_0 ,\deb_reg[4]_i_2_n_1 ,\deb_reg[4]_i_2_n_2 ,\deb_reg[4]_i_2_n_3 }),
        .CYINIT(\deb_reg_n_0_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[4:1]),
        .S({\deb_reg_n_0_[4] ,\deb_reg_n_0_[3] ,\deb_reg_n_0_[2] ,\deb_reg_n_0_[1] }));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[5] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[5]),
        .Q(\deb_reg_n_0_[5] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[6] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[6]),
        .Q(\deb_reg_n_0_[6] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[7] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[7]),
        .Q(\deb_reg_n_0_[7] ),
        .R(\deb[19]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[8] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[8]),
        .Q(\deb_reg_n_0_[8] ),
        .R(\deb[19]_i_1_n_0 ));
  CARRY4 \deb_reg[8]_i_2 
       (.CI(\deb_reg[4]_i_2_n_0 ),
        .CO({\deb_reg[8]_i_2_n_0 ,\deb_reg[8]_i_2_n_1 ,\deb_reg[8]_i_2_n_2 ,\deb_reg[8]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[8:5]),
        .S({\deb_reg_n_0_[8] ,\deb_reg_n_0_[7] ,\deb_reg_n_0_[6] ,\deb_reg_n_0_[5] }));
  FDRE #(
    .INIT(1'b0)) 
    \deb_reg[9] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(deb[9]),
        .Q(\deb_reg_n_0_[9] ),
        .R(\deb[19]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \div_cnt[0]_i_1 
       (.I0(\div_cnt_reg_n_0_[0] ),
        .O(div_cnt));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \div_cnt[25]_i_1 
       (.I0(\div_cnt[25]_i_3_n_0 ),
        .I1(\div_cnt[25]_i_4_n_0 ),
        .I2(\div_cnt[25]_i_5_n_0 ),
        .I3(\div_cnt[25]_i_6_n_0 ),
        .I4(\div_cnt[25]_i_7_n_0 ),
        .I5(\div_cnt[25]_i_8_n_0 ),
        .O(\div_cnt[25]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \div_cnt[25]_i_3 
       (.I0(\div_cnt_reg_n_0_[15] ),
        .I1(\div_cnt_reg_n_0_[14] ),
        .I2(\div_cnt_reg_n_0_[17] ),
        .I3(\div_cnt_reg_n_0_[16] ),
        .O(\div_cnt[25]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hDFFF)) 
    \div_cnt[25]_i_4 
       (.I0(\div_cnt_reg_n_0_[19] ),
        .I1(\div_cnt_reg_n_0_[18] ),
        .I2(\div_cnt_reg_n_0_[21] ),
        .I3(\div_cnt_reg_n_0_[20] ),
        .O(\div_cnt[25]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFD)) 
    \div_cnt[25]_i_5 
       (.I0(\div_cnt_reg_n_0_[6] ),
        .I1(\div_cnt_reg_n_0_[7] ),
        .I2(\div_cnt_reg_n_0_[9] ),
        .I3(\div_cnt_reg_n_0_[8] ),
        .O(\div_cnt[25]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hEFFF)) 
    \div_cnt[25]_i_6 
       (.I0(\div_cnt_reg_n_0_[11] ),
        .I1(\div_cnt_reg_n_0_[10] ),
        .I2(\div_cnt_reg_n_0_[13] ),
        .I3(\div_cnt_reg_n_0_[12] ),
        .O(\div_cnt[25]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \div_cnt[25]_i_7 
       (.I0(\div_cnt_reg_n_0_[3] ),
        .I1(\div_cnt_reg_n_0_[2] ),
        .I2(\div_cnt_reg_n_0_[5] ),
        .I3(\div_cnt_reg_n_0_[4] ),
        .O(\div_cnt[25]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hBFFFFFFFFFFFFFFF)) 
    \div_cnt[25]_i_8 
       (.I0(\div_cnt_reg_n_0_[24] ),
        .I1(\div_cnt_reg_n_0_[25] ),
        .I2(\div_cnt_reg_n_0_[22] ),
        .I3(\div_cnt_reg_n_0_[23] ),
        .I4(\div_cnt_reg_n_0_[1] ),
        .I5(\div_cnt_reg_n_0_[0] ),
        .O(\div_cnt[25]_i_8_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(div_cnt),
        .Q(\div_cnt_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[10] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[12]_i_1_n_6 ),
        .Q(\div_cnt_reg_n_0_[10] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[11] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[12]_i_1_n_5 ),
        .Q(\div_cnt_reg_n_0_[11] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[12] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[12]_i_1_n_4 ),
        .Q(\div_cnt_reg_n_0_[12] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[12]_i_1 
       (.CI(\div_cnt_reg[8]_i_1_n_0 ),
        .CO({\div_cnt_reg[12]_i_1_n_0 ,\div_cnt_reg[12]_i_1_n_1 ,\div_cnt_reg[12]_i_1_n_2 ,\div_cnt_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\div_cnt_reg[12]_i_1_n_4 ,\div_cnt_reg[12]_i_1_n_5 ,\div_cnt_reg[12]_i_1_n_6 ,\div_cnt_reg[12]_i_1_n_7 }),
        .S({\div_cnt_reg_n_0_[12] ,\div_cnt_reg_n_0_[11] ,\div_cnt_reg_n_0_[10] ,\div_cnt_reg_n_0_[9] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[13] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[16]_i_1_n_7 ),
        .Q(\div_cnt_reg_n_0_[13] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[14] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[16]_i_1_n_6 ),
        .Q(\div_cnt_reg_n_0_[14] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[15] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[16]_i_1_n_5 ),
        .Q(\div_cnt_reg_n_0_[15] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[16] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[16]_i_1_n_4 ),
        .Q(\div_cnt_reg_n_0_[16] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[16]_i_1 
       (.CI(\div_cnt_reg[12]_i_1_n_0 ),
        .CO({\div_cnt_reg[16]_i_1_n_0 ,\div_cnt_reg[16]_i_1_n_1 ,\div_cnt_reg[16]_i_1_n_2 ,\div_cnt_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\div_cnt_reg[16]_i_1_n_4 ,\div_cnt_reg[16]_i_1_n_5 ,\div_cnt_reg[16]_i_1_n_6 ,\div_cnt_reg[16]_i_1_n_7 }),
        .S({\div_cnt_reg_n_0_[16] ,\div_cnt_reg_n_0_[15] ,\div_cnt_reg_n_0_[14] ,\div_cnt_reg_n_0_[13] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[17] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[20]_i_1_n_7 ),
        .Q(\div_cnt_reg_n_0_[17] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[18] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[20]_i_1_n_6 ),
        .Q(\div_cnt_reg_n_0_[18] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[19] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[20]_i_1_n_5 ),
        .Q(\div_cnt_reg_n_0_[19] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[4]_i_1_n_7 ),
        .Q(\div_cnt_reg_n_0_[1] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[20] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[20]_i_1_n_4 ),
        .Q(\div_cnt_reg_n_0_[20] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[20]_i_1 
       (.CI(\div_cnt_reg[16]_i_1_n_0 ),
        .CO({\div_cnt_reg[20]_i_1_n_0 ,\div_cnt_reg[20]_i_1_n_1 ,\div_cnt_reg[20]_i_1_n_2 ,\div_cnt_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\div_cnt_reg[20]_i_1_n_4 ,\div_cnt_reg[20]_i_1_n_5 ,\div_cnt_reg[20]_i_1_n_6 ,\div_cnt_reg[20]_i_1_n_7 }),
        .S({\div_cnt_reg_n_0_[20] ,\div_cnt_reg_n_0_[19] ,\div_cnt_reg_n_0_[18] ,\div_cnt_reg_n_0_[17] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[21] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[24]_i_1_n_7 ),
        .Q(\div_cnt_reg_n_0_[21] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[22] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[24]_i_1_n_6 ),
        .Q(\div_cnt_reg_n_0_[22] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[23] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[24]_i_1_n_5 ),
        .Q(\div_cnt_reg_n_0_[23] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[24] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[24]_i_1_n_4 ),
        .Q(\div_cnt_reg_n_0_[24] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[24]_i_1 
       (.CI(\div_cnt_reg[20]_i_1_n_0 ),
        .CO({\div_cnt_reg[24]_i_1_n_0 ,\div_cnt_reg[24]_i_1_n_1 ,\div_cnt_reg[24]_i_1_n_2 ,\div_cnt_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\div_cnt_reg[24]_i_1_n_4 ,\div_cnt_reg[24]_i_1_n_5 ,\div_cnt_reg[24]_i_1_n_6 ,\div_cnt_reg[24]_i_1_n_7 }),
        .S({\div_cnt_reg_n_0_[24] ,\div_cnt_reg_n_0_[23] ,\div_cnt_reg_n_0_[22] ,\div_cnt_reg_n_0_[21] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[25] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[25]_i_2_n_7 ),
        .Q(\div_cnt_reg_n_0_[25] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[25]_i_2 
       (.CI(\div_cnt_reg[24]_i_1_n_0 ),
        .CO(\NLW_div_cnt_reg[25]_i_2_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_div_cnt_reg[25]_i_2_O_UNCONNECTED [3:1],\div_cnt_reg[25]_i_2_n_7 }),
        .S({1'b0,1'b0,1'b0,\div_cnt_reg_n_0_[25] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[4]_i_1_n_6 ),
        .Q(\div_cnt_reg_n_0_[2] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[4]_i_1_n_5 ),
        .Q(\div_cnt_reg_n_0_[3] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[4] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[4]_i_1_n_4 ),
        .Q(\div_cnt_reg_n_0_[4] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[4]_i_1 
       (.CI(1'b0),
        .CO({\div_cnt_reg[4]_i_1_n_0 ,\div_cnt_reg[4]_i_1_n_1 ,\div_cnt_reg[4]_i_1_n_2 ,\div_cnt_reg[4]_i_1_n_3 }),
        .CYINIT(\div_cnt_reg_n_0_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\div_cnt_reg[4]_i_1_n_4 ,\div_cnt_reg[4]_i_1_n_5 ,\div_cnt_reg[4]_i_1_n_6 ,\div_cnt_reg[4]_i_1_n_7 }),
        .S({\div_cnt_reg_n_0_[4] ,\div_cnt_reg_n_0_[3] ,\div_cnt_reg_n_0_[2] ,\div_cnt_reg_n_0_[1] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[5] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[8]_i_1_n_7 ),
        .Q(\div_cnt_reg_n_0_[5] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[6] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[8]_i_1_n_6 ),
        .Q(\div_cnt_reg_n_0_[6] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[7] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[8]_i_1_n_5 ),
        .Q(\div_cnt_reg_n_0_[7] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[8] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[8]_i_1_n_4 ),
        .Q(\div_cnt_reg_n_0_[8] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  CARRY4 \div_cnt_reg[8]_i_1 
       (.CI(\div_cnt_reg[4]_i_1_n_0 ),
        .CO({\div_cnt_reg[8]_i_1_n_0 ,\div_cnt_reg[8]_i_1_n_1 ,\div_cnt_reg[8]_i_1_n_2 ,\div_cnt_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\div_cnt_reg[8]_i_1_n_4 ,\div_cnt_reg[8]_i_1_n_5 ,\div_cnt_reg[8]_i_1_n_6 ,\div_cnt_reg[8]_i_1_n_7 }),
        .S({\div_cnt_reg_n_0_[8] ,\div_cnt_reg_n_0_[7] ,\div_cnt_reg_n_0_[6] ,\div_cnt_reg_n_0_[5] }));
  FDRE #(
    .INIT(1'b0)) 
    \div_cnt_reg[9] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt_reg[12]_i_1_n_7 ),
        .Q(\div_cnt_reg_n_0_[9] ),
        .R(\div_cnt[25]_i_1_n_0 ));
  OBUF led0_g_OBUF_inst
       (.I(led0_g_OBUF),
        .O(led0_g));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00010000)) 
    led0_g_OBUF_inst_i_1
       (.I0(pwm_reg__0[0]),
        .I1(pwm_reg__0[1]),
        .I2(pwm_reg__0[2]),
        .I3(pwm_reg__0[3]),
        .I4(sw_IBUF[0]),
        .O(led0_g_OBUF));
  OBUF led1_r_OBUF_inst
       (.I(led1_r_OBUF),
        .O(led1_r));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00010000)) 
    led1_r_OBUF_inst_i_1
       (.I0(pwm_reg__0[0]),
        .I1(pwm_reg__0[1]),
        .I2(pwm_reg__0[2]),
        .I3(pwm_reg__0[3]),
        .I4(reset),
        .O(led1_r_OBUF));
  OBUF led3_b_OBUF_inst
       (.I(led3_b_OBUF),
        .O(led3_b));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00010000)) 
    led3_b_OBUF_inst_i_1
       (.I0(pwm_reg__0[0]),
        .I1(pwm_reg__0[1]),
        .I2(pwm_reg__0[2]),
        .I3(pwm_reg__0[3]),
        .I4(sw_IBUF[3]),
        .O(led3_b_OBUF));
  OBUF led3_g_OBUF_inst
       (.I(led3_g_OBUF),
        .O(led3_g));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    led3_g_OBUF_inst_i_1
       (.I0(pwm_reg__0[0]),
        .I1(pwm_reg__0[1]),
        .I2(pwm_reg__0[2]),
        .I3(pwm_reg__0[3]),
        .I4(sw_IBUF[3]),
        .O(led3_g_OBUF));
  OBUF \led_OBUF[0]_inst 
       (.I(1'b0),
        .O(led[0]));
  OBUF \led_OBUF[1]_inst 
       (.I(1'b0),
        .O(led[1]));
  OBUF \led_OBUF[2]_inst 
       (.I(1'b0),
        .O(led[2]));
  OBUF \led_OBUF[3]_inst 
       (.I(1'b0),
        .O(led[3]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \pwm[0]_i_1 
       (.I0(pwm_reg__0[0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \pwm[1]_i_1 
       (.I0(pwm_reg__0[0]),
        .I1(pwm_reg__0[1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \pwm[2]_i_1 
       (.I0(pwm_reg__0[1]),
        .I1(pwm_reg__0[0]),
        .I2(pwm_reg__0[2]),
        .O(p_0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \pwm[3]_i_1 
       (.I0(pwm_reg__0[0]),
        .I1(pwm_reg__0[1]),
        .I2(pwm_reg__0[2]),
        .I3(pwm_reg__0[3]),
        .O(p_0_in__0[3]));
  FDRE #(
    .INIT(1'b0)) 
    \pwm_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_in__0[0]),
        .Q(pwm_reg__0[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \pwm_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_in__0[1]),
        .Q(pwm_reg__0[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \pwm_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_in__0[2]),
        .Q(pwm_reg__0[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \pwm_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_in__0[3]),
        .Q(pwm_reg__0[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \rst_sync_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(btn_IBUF[0]),
        .Q(\rst_sync_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \rst_sync_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\rst_sync_reg_n_0_[0] ),
        .Q(reset),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    step_prev_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(step_stable_reg_n_0),
        .Q(step_prev),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hCA)) 
    step_stable_i_1
       (.I0(p_0_in),
        .I1(step_stable_reg_n_0),
        .I2(\deb[19]_i_3_n_0 ),
        .O(step_stable_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    step_stable_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(step_stable_i_1_n_0),
        .Q(step_stable_reg_n_0),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \step_sync_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(btn_IBUF[1]),
        .Q(\step_sync_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \step_sync_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\step_sync_reg_n_0_[0] ),
        .Q(p_0_in),
        .R(1'b0));
  IBUF \sw_IBUF[0]_inst 
       (.I(sw[0]),
        .O(sw_IBUF[0]));
  IBUF \sw_IBUF[3]_inst 
       (.I(sw[3]),
        .O(sw_IBUF[3]));
  FDRE #(
    .INIT(1'b0)) 
    tick_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\div_cnt[25]_i_1_n_0 ),
        .Q(tick_reg_n_0),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif

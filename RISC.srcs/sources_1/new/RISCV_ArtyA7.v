`timescale 1ns / 1ps
// ============================================================================
// RISCV_ArtyA7 - Module top de nap len board Digilent Arty A7-100T
//                FPGA: xc7a100tcsg324-1
//
//  Arty A7 KHONG co LED 7 doan, chi co 4 LED xanh + 4 LED RGB,
//  nen ket qua duoc xem tung "nibble" (4 bit) mot tren 4 LED xanh.
//
//  NUT NHAN
//    btn[0] (BTN0) : reset CPU
//    btn[1] (BTN1) : chay 1 lenh (khi o che do tung buoc, sw[0] = 0)
//  CONG TAC
//    sw[0]  : 1 = tu dong chay ~2 lenh/giay, 0 = chay tung buoc bang BTN1
//    sw[2:1]: chon nibble hien thi: 00 = bit[3:0], 01 = bit[7:4],
//                                   10 = bit[11:8], 11 = bit[15:12]
//    sw[3]  : 0 = hien thi gia tri cuoi ghi vao thanh ghi, 1 = hien thi PC
//  LED
//    led[3:0] : nibble dang chon
//    LD0 xanh la : dang o che do tu dong chay
//    LD1 do      : dang reset
//    LD3         : xanh la = dang xem DU LIEU, xanh duong = dang xem PC
// ============================================================================
module RISCV_ArtyA7 #(
    parameter TICK_DIV = 50_000_000,   // 100 MHz / 50e6 = 2 lenh/giay
    parameter DEB_CNT  = 1_000_000     // chong doi nut nhan 10 ms
)(
    input        CLK100MHZ,
    input  [3:0] btn,
    input  [3:0] sw,
    output [3:0] led,
    output       led0_g,
    output       led1_r,
    output       led3_g,
    output       led3_b
);
    wire clk = CLK100MHZ;

    // ---------- Dong bo nut reset ----------
    reg [1:0] rst_sync = 2'b11;
    always @(posedge clk) rst_sync <= {rst_sync[0], btn[0]};
    wire reset = rst_sync[1];

    // ---------- Dong bo + chong doi BTN1, tao 1 xung khi nhan ----------
    reg [1:0]  step_sync = 2'b00;
    reg        step_stable = 1'b0, step_prev = 1'b0;
    reg [19:0] deb = 0;
    always @(posedge clk) begin
        step_sync <= {step_sync[0], btn[1]};
        if (step_sync[1] != step_stable) begin
            if (deb == DEB_CNT - 1) begin
                step_stable <= step_sync[1];
                deb <= 0;
            end else
                deb <= deb + 1'b1;
        end else
            deb <= 0;
        step_prev <= step_stable;
    end
    wire step_pulse = step_stable & ~step_prev;

    // ---------- Xung tick cho che do tu dong chay ----------
    reg [25:0] div_cnt = 0;
    reg        tick    = 1'b0;
    always @(posedge clk) begin
        if (div_cnt == TICK_DIV - 1) begin
            div_cnt <= 0;
            tick    <= 1'b1;
        end else begin
            div_cnt <= div_cnt + 1'b1;
            tick    <= 1'b0;
        end
    end

    // Khi reset luon cho clock qua de PC (reset dong bo) ve 0
    wire cpu_ce = reset | (sw[0] ? tick : step_pulse);

    // ---------- Clock cho CPU (BUFGCE: clock enable tren mang clock toan cuc) ----------
    wire cpu_clk;
    BUFGCE bufgce_cpu (
        .I (clk),
        .CE(cpu_ce),
        .O (cpu_clk)
    );

    // ---------- CPU ----------
    wire [31:0] pc_out, wb_data;
    wire        wb_en;
    RISCV_TOP #(.MEM_FILE("D:/RISC/rv32i_test.hex")) 
    cpu (
        .clk    (cpu_clk),
        .reset  (reset),
        .pc_out (pc_out),
        .wb_data(wb_data),
        .wb_en  (wb_en)
    );

    // ---------- Giu lai gia tri cuoi cung ghi vao thanh ghi ----------
    reg [31:0] last_wb = 32'd0;
    always @(posedge cpu_clk) begin
        if (reset)      last_wb <= 32'd0;
        else if (wb_en) last_wb <= wb_data;
    end

    // ---------- Chon gia tri va nibble hien thi ----------
    wire [15:0] show = sw[3] ? pc_out[15:0] : last_wb[15:0];
    assign led = show[sw[2:1]*4 +: 4];

    // ---------- LED RGB (lam mo bang PWM 1/16 vi LED RGB rat choi) ----------
    reg [3:0] pwm = 0;
    always @(posedge clk) pwm <= pwm + 1'b1;
    wire dim = (pwm == 4'd0);

    assign led0_g = dim & sw[0];
    assign led1_r = dim & reset;
    assign led3_g = dim & ~sw[3];
    assign led3_b = dim &  sw[3];

endmodule
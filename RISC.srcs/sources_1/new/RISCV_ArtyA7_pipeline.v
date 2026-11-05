`timescale 1ns / 1ps
module RISCV_ArtyA7_pipeline #(
    parameter TICK_DIV = 50_000_000,
    parameter DEB_CNT  = 1_000_000
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

    reg [1:0] rst_sync = 2'b11;
    always @(posedge clk) rst_sync <= {rst_sync[0], btn[0]};
    wire reset = rst_sync[1];

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

    wire cpu_ce = reset | (sw[0] ? tick : step_pulse);

    wire cpu_clk;
    BUFGCE bufgce_cpu (
        .I (clk),
        .CE(cpu_ce),
        .O (cpu_clk)
    );

    wire [31:0] pc_out, wb_data;
    wire        wb_en;
    RISCV_PIPELINE #(.MEM_FILE("D:/RISC/sw/build/imem.hex"))
    cpu (
        .clk    (cpu_clk),
        .reset  (reset),
        .pc_out (pc_out),
        .wb_data(wb_data),
        .wb_en  (wb_en)
    );

    reg [31:0] last_wb = 32'd0;
    always @(posedge cpu_clk) begin
        if (reset)      last_wb <= 32'd0;
        else if (wb_en) last_wb <= wb_data;
    end

    wire [15:0] show = sw[3] ? pc_out[15:0] : last_wb[15:0];
    assign led = show[sw[2:1]*4 +: 4];

    reg [3:0] pwm = 0;
    always @(posedge clk) pwm <= pwm + 1'b1;
    wire dim = (pwm == 4'd0);

    assign led0_g = dim & sw[0];
    assign led1_r = dim & reset;
    assign led3_g = dim & ~sw[3];
    assign led3_b = dim &  sw[3];

endmodule

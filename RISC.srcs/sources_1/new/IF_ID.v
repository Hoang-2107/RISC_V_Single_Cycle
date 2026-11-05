`timescale 1ns / 1ps
module IF_ID(
    clk, rst, stall, flush,
    if_pc, if_pc4, if_inst,
    id_pc, id_pc4, id_inst
    );
    input clk, rst;
    input stall;
    input flush;
    input [31:0] if_pc;
    input [31:0] if_pc4;
    input [31:0] if_inst;
    output reg [31:0] id_pc;
    output reg [31:0] id_pc4;
    output reg [31:0] id_inst;

    localparam NOP = 32'h00000013;

    always @(posedge clk) begin
        if (rst || flush) begin
            id_pc   <= 32'd0;
            id_pc4  <= 32'd0;
            id_inst <= NOP;
        end
        else if (!stall) begin
            id_pc   <= if_pc;
            id_pc4  <= if_pc4;
            id_inst <= if_inst;
        end
    end

endmodule

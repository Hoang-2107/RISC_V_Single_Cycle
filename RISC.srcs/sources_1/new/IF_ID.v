`timescale 1ns / 1ps
// =====================================================================
// Module: IF_ID
// Chuc nang: Thanh ghi pipeline giua tang IF (nap lenh) va ID (giai ma)
//            - Moi canh len clock chot PC, PC+4 va ma lenh tu tang IF
//            - stall = 1 : giu nguyen gia tri cu (load-use)
//            - flush = 1 : xoa thanh nop (nhanh nhay, jal, jalr)
//            - rst   = 1 : xoa thanh nop, PC = 0
//            Thu tu uu tien: rst/flush > stall > binh thuong
//
//   Tuong ung so do ben trong (moi bit):
//     if_x -> [MUX stall] -> [MUX flush] -> D [FF] Q -> id_x
//              ^ 1 = Q (hoi tiep)  ^ 1 = nop / 0
// =====================================================================
module IF_ID(
    clk, rst, stall, flush,
    if_pc, if_pc4, if_inst,
    id_pc, id_pc4, id_inst
    );
    input clk, rst;
    input stall;                 // tu Hazard_Unit
    input flush;                 // tu Hazard_Unit
    input [31:0] if_pc;          // PC cua lenh dang nap
    input [31:0] if_pc4;         // PC + 4
    input [31:0] if_inst;        // ma lenh tu Instruction_Mem
    output reg [31:0] id_pc;     // PC sang tang ID
    output reg [31:0] id_pc4;    // PC + 4 sang tang ID
    output reg [31:0] id_inst;   // ma lenh sang tang ID

    localparam NOP = 32'h00000013;   // addi x0, x0, 0

    always @(posedge clk) begin
        if (rst || flush) begin          // MUX flush: chon nop / 0
            id_pc   <= 32'd0;
            id_pc4  <= 32'd0;
            id_inst <= NOP;
        end
        else if (!stall) begin           // MUX stall = 0: nhan lenh moi
            id_pc   <= if_pc;
            id_pc4  <= if_pc4;
            id_inst <= if_inst;
        end
        // stall = 1: khong gan -> giu gia tri cu (chinh la day hoi tiep Q)
    end

endmodule

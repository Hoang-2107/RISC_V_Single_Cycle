`timescale 1ns / 1ps
// Module: alu
// Chuc nang: Don vi so hoc - logic (ALU) 32-bit
//            Ho tro cac phep toan R-type: ADD, SUB, AND, OR, XOR,
//            SLL, SRL, SRA, SLT, SLTU
// Ma alu_ctrl duoc sinh ra tu khoi ALU Control (ket hop ALUOp + funct3/funct7)
// =====================================================================
module ALU(
    A, B, zero, alu_result, alu_ctrl
    );
    input wire[31:0] A, B;//read data1, read data 2
    input wire [3:0] alu_ctrl;// dieu khien phep toan
    output reg [31:0] alu_result; // ket qua
    output wire zero;// co Zero: =1 khi alu_result = 0
    
    localparam alu_sub = 4'b0001;
    localparam alu_add = 4'b0000;
    localparam alu_and = 4'b0010;
    localparam alu_or = 4'b0011;
    localparam alu_xor = 4'b0100;
    localparam alu_sll = 4'b0101; // shift left logical
    localparam alu_sra = 4'b0111; // shift right arithmetic
    localparam alu_srl = 4'b0110;  // shift right logical
    localparam alu_slt = 4'b1000; // set less than
    localparam alu_sltu = 4'b1001;// set less tahn
    
        wire [4:0] shamt = B[4:0];
    always @(*)
    begin
        case (alu_ctrl)
            alu_add: alu_result = A + B;
            alu_sub: alu_result = A - B;
            alu_and: alu_result = A & B;
            alu_or: alu_result = A | B;
            alu_xor: alu_result = A ^ B;
            alu_sll: alu_result = A << shamt;
            alu_srl: alu_result = A >> shamt;
            alu_sra: alu_result = $signed(A) >>> shamt;
            alu_slt: alu_result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            alu_sltu: alu_result = ( A < B ) ? 32'b1 : 32'b0;
            default: alu_result = 32'b0;
        endcase
    end
        assign zero = (alu_result == 32'b0);
    
    endmodule

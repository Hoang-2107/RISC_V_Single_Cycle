`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2026 07:34:05 PM
// Design Name: 
// Module Name: tb_ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_ALU( );
    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  alu_ctrl;
 
    wire [31:0] alu_result;
    wire        zero;
 
    integer error_count;
ALU ALU(
    .A(A),
    .B(B),
    .zero(zero),
    .alu_result(alu_result),
    .alu_ctrl(alu_ctrl)
    );
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
       // ---- Task kiem tra 1 phep toan va so sanh ket qua mong doi ----
    task check;
        input [127:0] name;      // ten phep toan (de in ra)
        input [31:0]  expected;
        input         expected_zero;
        begin
            #1; // cho to hop on dinh
            if (alu_result !== expected || zero !== expected_zero) begin
                $display("FAIL [%0s] a=%0d b=%0d ctrl=%b -> result=%0d (expect %0d), zero=%b (expect %b)",
                          name, $signed(A), $signed(B), alu_ctrl,
                          alu_result, expected, zero, expected_zero);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] a=%0d b=%0d -> result=%0d, zero=%b",
                          name, $signed(A), $signed(B), alu_result, zero);
            end
        end
    endtask
 
    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong ALU ===");
 
        // ---- ADD: 15 + 4 = 19 ----
        A = 32'd15; B = 32'd4; alu_ctrl = alu_add;
        check("ADD", 32'd19, 1'b0);
 
        // ---- ADD dan den zero: 5 + (-5) = 0 ----
        A = 32'd5; B = -32'd5; alu_ctrl = alu_add;
        check("ADD->0", 32'd0, 1'b1);
 
        // ---- SUB: 15 - 4 = 11 ----
        A = 32'd15; B = 32'd4; alu_ctrl = alu_sub;
        check("SUB", 32'd11, 1'b0);
 
        // ---- SUB bang nhau -> zero=1 (dung cho lenh beq) ----
        A = 32'd7; B = 32'd7; alu_ctrl = alu_sub;
        check("SUB->0", 32'd0, 1'b1);
 
        // ---- AND: 15 & 4 = 4 ----
        A = 32'd15; B = 32'd4; alu_ctrl = alu_and;
        check("AND", 32'd4, 1'b0);
 
        // ---- OR: 15 | 4 = 15 ----
        A = 32'd15; B = 32'd4; alu_ctrl =alu_or;
        check("OR", 32'd15, 1'b0);
 
        // ---- XOR: 15 ^ 4 = 11 ----
        A = 32'd15; B = 32'd4; alu_ctrl = alu_xor;
        check("XOR", 32'd11, 1'b0);
 
        // ---- SLL: 1 << 4 = 16 ----
       A = 32'd1; B = 32'd4; alu_ctrl = alu_sll;
        check("SLL", 32'd16, 1'b0);
 
        // ---- SRL: 16 >> 2 = 4 (logic, khong quan tam dau) ----
        A = 32'd16; B = 32'd2; alu_ctrl = alu_srl;
        check("SRL", 32'd4, 1'b0);
 
        // ---- SRA: -16 >>> 2 = -4 (arithmetic, giu dau) ----
        A = -32'd16; B = 32'd2; alu_ctrl = alu_sra;
        check("SRA", -32'd4, 1'b0);
 
        // ---- SLT: -1 < 1 (signed) -> 1 ----
        A = -32'd1; B = 32'd1; alu_ctrl = alu_slt;
        check("SLT(signed)", 32'd1, 1'b0);
 
        // ---- SLTU: -1 (unsigned = so rat lon) < 1 -> 0 ----
       A = -32'd1; B = 32'd1; alu_ctrl = alu_sltu;
        check("SLTU(unsigned)", 32'd0, 1'b1);
 
        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);
 
        $finish;
    end
 
endmodule

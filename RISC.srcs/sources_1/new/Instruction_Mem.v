`timescale 1ns / 1ps
// Chuc nang: Bo nho lenh (Instruction Memory) - CHI DOC (read-only)
//            - Nhan dia chi tu PC (Read address)
//            - Tra ve ma lenh 32-bit (Instruction[31:0])
//            - Doc bat dong bo (async read), khong can clock/reset vi
//              day la ROM, khong thay doi trong luc chuong trinh chay
//            - Co the nap noi dung tu file .hex/.bin bang $readmemh
//
// Nap chuong trinh:
//   - MEM_FILE = "duong/dan.hex" -> nap file hex (moi dong 1 lenh 32-bit,
//                                   dong dau = dia chi 0x00, cho phep chu thich //)
//   - MEM_FILE = ""              -> dung chuong trinh 16 lenh viet san ben duoi
//   Cac file co san:
//     D:/RISC/rv32i_test.hex  : test day du RV32I (nhanh, jal/jalr, lui/auipc, lb..sh)
module Instruction_Mem#(
        parameter ADDR_WIDTH = 10, // 2^10 = 1024 word lenh
        parameter MEM_FILE = "D:/RISC/rv32i_test.hex" // duong dan file .hex ("" = chuong trinh viet san)
)(
    read_address, instruction
    );

 input [31:0] read_address;
 output [31:0] instruction;
 // PC la dia chi BYTE, moi lenh 4 byte -> bo 2 bit thap de ra chi so word
 reg [31:0] Memory [0:(1<<ADDR_WIDTH)-1];
 

 integer k;
 wire [ADDR_WIDTH-1:0] word_addr = read_address[ADDR_WIDTH+1:2];
 assign instruction = Memory[word_addr];
  initial begin
   for (k = 0; k < (1<<ADDR_WIDTH); k = k + 1)
            Memory[k] = 32'h00000013;    // nop (addi x0,x0,0)
   if (MEM_FILE != "") begin
            $readmemh(MEM_FILE, Memory);   // nap lenh tu file hex
   end else begin
        //      Nay chuyen sang nhanh else: chi dung khi KHONG co file hex.
        //  chi so     ma lenh           PC     lenh
        Memory[0]  = 32'h00f00093;    // 0x00  addi x1,  x0, 15
        Memory[1]  = 32'h00300113;    // 0x04  addi x2,  x0, 3
        Memory[2]  = 32'hff800193;    // 0x08  addi x3,  x0, -8
        Memory[3]  = 32'h00200213;    // 0x0C  addi x4,  x0, 2
        Memory[4]  = 32'h002082b3;    // 0x10  add  x5,  x1, x2
        Memory[5]  = 32'h40208333;    // 0x14  sub  x6,  x1, x2
        Memory[6]  = 32'h0020f3b3;    // 0x18  and  x7,  x1, x2
        Memory[7]  = 32'h0020e433;    // 0x1C  or   x8,  x1, x2
        Memory[8]  = 32'h0020c4b3;    // 0x20  xor  x9,  x1, x2
        Memory[9]  = 32'h00409533;    // 0x24  sll  x10, x1, x4
        Memory[10] = 32'h0041d5b3;    // 0x28  srl  x11, x3, x4
        Memory[11] = 32'h4041d633;    // 0x2C  sra  x12, x3, x4
        Memory[12] = 32'h0011a6b3;    // 0x30  slt  x13, x3, x1
        Memory[13] = 32'h0011b733;    // 0x34  sltu x14, x3, x1
        Memory[14] = 32'h00208033;    // 0x38  add  x0,  x1, x2
        Memory[15] = 32'h006287b3;    // 0x3C  add  x15, x5, x6
        Memory[16] = 32'h0000006f;    // 0x40  jal  x0, 0  -> nhay tai cho (dung chuong trinh)
        
   end
  end

endmodule

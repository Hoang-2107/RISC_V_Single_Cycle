`timescale 1ns / 1ps
module Instruction_Mem#(
        parameter ADDR_WIDTH = 10,
        parameter MEM_FILE = "D:/RISC/sw/hex/rv32i_test.hex"
)(
    read_address, instruction
    );

 input [31:0] read_address;
 output [31:0] instruction;
 reg [31:0] Memory [0:(1<<ADDR_WIDTH)-1];

 integer k;
 wire [ADDR_WIDTH-1:0] word_addr = read_address[ADDR_WIDTH+1:2];
 assign instruction = Memory[word_addr];
  initial begin
   for (k = 0; k < (1<<ADDR_WIDTH); k = k + 1)
            Memory[k] = 32'h00000013;
   if (MEM_FILE != "") begin
            $readmemh(MEM_FILE, Memory);
   end else begin
        Memory[0]  = 32'h00f00093;
        Memory[1]  = 32'h00300113;
        Memory[2]  = 32'hff800193;
        Memory[3]  = 32'h00200213;
        Memory[4]  = 32'h002082b3;
        Memory[5]  = 32'h40208333;
        Memory[6]  = 32'h0020f3b3;
        Memory[7]  = 32'h0020e433;
        Memory[8]  = 32'h0020c4b3;
        Memory[9]  = 32'h00409533;
        Memory[10] = 32'h0041d5b3;
        Memory[11] = 32'h4041d633;
        Memory[12] = 32'h0011a6b3;
        Memory[13] = 32'h0011b733;
        Memory[14] = 32'h00208033;
        Memory[15] = 32'h006287b3;
        Memory[16] = 32'h0000006f;

   end
  end

endmodule

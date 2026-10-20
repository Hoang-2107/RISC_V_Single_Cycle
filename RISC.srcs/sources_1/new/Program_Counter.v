`timescale 1ns / 1ps
module Program_Counter(
    clk, rst, PC_in, PC_out
    );
  input clk, rst;
  input [31:0] PC_in;
  output reg [31:0] PC_out;
  
always @ (posedge clk) 
begin
    if (rst) 
    PC_out <= 32'h00000000;
    else 
    PC_out <= PC_in;
end
endmodule

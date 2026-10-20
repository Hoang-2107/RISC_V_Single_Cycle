`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2026 07:01:52 AM
// Design Name: 
// Module Name: Adder_sum
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


module Adder_sum(
    PC_plus, Shift, Sum
    );
    input [31:0] PC_plus;
    input [31:0] Shift;
    output [31:0] Sum;
    assign Sum = PC_plus + Shift;
        
endmodule

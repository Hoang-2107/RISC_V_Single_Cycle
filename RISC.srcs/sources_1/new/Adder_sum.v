`timescale 1ns / 1ps

module Adder_sum(
    PC_plus, Shift, Sum
    );
    input [31:0] PC_plus;
    input [31:0] Shift;
    output [31:0] Sum;
    assign Sum = PC_plus + Shift;

endmodule

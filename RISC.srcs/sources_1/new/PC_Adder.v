`timescale 1ns / 1ps
module PC_Adder(
    input  [31:0] From_PC,
    output [31:0] PC_plus
);

    assign PC_plus = From_PC + 32'h4;

endmodule

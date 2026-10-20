`timescale 1ns / 1ps
module Mux_2to1(
        d0, d1, sel, y
    );
    input [31:0] d0, d1;
    input sel;
    output [31:0] y;
    assign y = sel ? d1 : d0;
    
endmodule

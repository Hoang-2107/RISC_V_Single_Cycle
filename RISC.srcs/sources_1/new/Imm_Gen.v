`timescale 1ns / 1ps
 module Imm_Gen(Inst_in, Inst_out
    );
    input wire [31:0] Inst_in;
    output reg [31:0] Inst_out;

    always @(*) begin
        case(Inst_in[6:0])
            7'b0000011, 7'b0010011, 7'b1100111: begin
                Inst_out = {{20{Inst_in[31]}}, Inst_in[31:20]};
            end

            7'b0100011: begin
                Inst_out = {{20{Inst_in[31]}}, Inst_in[31:25], Inst_in[11:7]};
            end

            7'b1100011: begin
                Inst_out = {{19{Inst_in[31]}}, Inst_in[31], Inst_in[7], Inst_in[30:25], Inst_in[11:8], 1'b0};
            end

            7'b0110111, 7'b0010111: begin
                Inst_out = {Inst_in[31:12], 12'b0};
            end

            7'b1101111: begin
                Inst_out = {{11{Inst_in[31]}}, Inst_in[31], Inst_in[19:12], Inst_in[20], Inst_in[30:21], 1'b0};
            end

            default: begin
                Inst_out = 32'b0;
            end
        endcase
    end

endmodule

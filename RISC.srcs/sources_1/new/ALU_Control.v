`timescale 1ns / 1ps

module ALU_Control(
    ALUOp_in, funct7, funct3, ALU_ctrl
    );
    input [1:0] ALUOp_in;
    input [6:0] funct7;
    input [2:0] funct3;

    output reg [3:0] ALU_ctrl;
always @(*)
begin
    case (ALUOp_in)
        2'b00: ALU_ctrl = 4'b0000;
        2'b01: ALU_ctrl = 4'b0001;
        2'b10: begin
            case(funct3)
                3'b000: ALU_ctrl = (funct7[5]) ? 4'b0001 : 4'b0000;
                3'b111: ALU_ctrl = 4'b0010;
                3'b110: ALU_ctrl = 4'b0011;
                3'b100: ALU_ctrl = 4'b0100;
                3'b001: ALU_ctrl = 4'b0101;
                3'b101: ALU_ctrl = (funct7[5]) ? 4'b0111 : 4'b0110;
                3'b010: ALU_ctrl = 4'b1000;
                3'b011: ALU_ctrl = 4'b1001;
                default: ALU_ctrl = 4'b0000;
             endcase
             end
        2'b11: begin
            case(funct3)
                3'b000: ALU_ctrl = 4'b0000;
                3'b111: ALU_ctrl = 4'b0010;
                3'b110: ALU_ctrl = 4'b0011;
                3'b100: ALU_ctrl = 4'b0100;
                3'b001: ALU_ctrl = 4'b0101;
                3'b101: ALU_ctrl = (funct7[5]) ? 4'b0111 : 4'b0110;
                3'b010: ALU_ctrl = 4'b1000;
                3'b011: ALU_ctrl = 4'b1001;
                default: ALU_ctrl = 4'b0000;
             endcase
            end
                default: ALU_ctrl = 4'b0000;
           endcase

end
endmodule

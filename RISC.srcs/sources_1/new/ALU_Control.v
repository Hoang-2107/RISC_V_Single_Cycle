`timescale 1ns / 1ps

module ALU_Control(
    ALUOp_in, funct7, funct3, ALU_ctrl
    );
    input [1:0] ALUOp_in;// 00: lw/sw (add), 01: branch (sub), 10: R-type
    input [6:0] funct7;
    input [2:0] funct3;

    output reg [3:0] ALU_ctrl;
    // dong localparame
always @(*)
begin
    case (ALUOp_in) 
        2'b00: ALU_ctrl = 4'b0000;// lw/sw -> ADD (tinh dia chi)
        2'b01: ALU_ctrl = 4'b0001; // branch -> SUB (so sanh bang nhau)
        2'b10: begin // R-type: dua theo funct3 + funct7
            case(funct3)
                3'b000: ALU_ctrl = (funct7[5]) ? 4'b0001 : 4'b0000; //SUB : ADD
                3'b111: ALU_ctrl = 4'b0010;//AND
                3'b110: ALU_ctrl = 4'b0011;//or
                3'b100: ALU_ctrl = 4'b0100;//xor
                3'b001: ALU_ctrl = 4'b0101;//SLL
                3'b101: ALU_ctrl = (funct7[5]) ? 4'b0111 : 4'b0110; // SRA : SRl
                3'b010: ALU_ctrl = 4'b1000; //SLT
                3'b011: ALU_ctrl = 4'b1001;//SLTU
                default: ALU_ctrl = 4'b0000;
             endcase
             end
        2'b11: begin // I-type: addi, andi, ori, xori, slli, srli, srai, slti, sltiu
            case(funct3)
                3'b000: ALU_ctrl = 4'b0000; //ADDI
                3'b111: ALU_ctrl = 4'b0010; //ANDI
                3'b110: ALU_ctrl = 4'b0011; //ORI
                3'b100: ALU_ctrl = 4'b0100; //XORI
                3'b001: ALU_ctrl = 4'b0101; //SLL
                3'b101: ALU_ctrl = (funct7[5]) ? 4'b0111 : 4'b0110; // SRAI : SRLI     
                3'b010: ALU_ctrl = 4'b1000; //SLTI
                3'b011: ALU_ctrl = 4'b1001; //SLTIU
                default: ALU_ctrl = 4'b0000;
             endcase    
            end
                default: ALU_ctrl = 4'b0000;
           endcase
        
                
    
end
endmodule

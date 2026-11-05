`timescale 1ns / 1ps

module Control_unit(OPcode,branch, mem_read, mem_to_reg, mem_write,ALU_src, reg_write, ALUop_out,
    jal, jalr, ALU_a_sel
    );
    input [6:0] OPcode;
    output reg branch, mem_read, mem_to_reg, mem_write,ALU_src, reg_write;
    output reg [1:0] ALUop_out;
    output reg jal;
    output reg jalr;
    output reg [1:0] ALU_a_sel;
    localparam R_type = 7'b0110011;
    localparam LOAD = 7'b0000011;
    localparam STORE = 7'b0100011;
    localparam BRANCH = 7'b1100011;
    localparam I_type = 7'b0010011;
    localparam JAL    = 7'b1101111;
    localparam JALR   = 7'b1100111;
    localparam LUI    = 7'b0110111;
    localparam AUIPC  = 7'b0010111;
    always @ (*) begin
    branch = 1'b0;
    mem_read = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    ALU_src = 1'b0;
    reg_write = 1'b0;
    ALUop_out = 2'b00;
    jal = 1'b0;
    jalr = 1'b0;
    ALU_a_sel = 2'b00;
    case(OPcode)
    R_type: begin
            ALUop_out     = 2'b10;
            reg_write  = 1'b1;
            end
    I_type: begin
            ALUop_out = 2'b11;
            ALU_src   = 1'b1;
            reg_write = 1'b1;
            end
    LOAD: begin
            ALU_src     = 1'b1;
            mem_to_reg  = 1'b1;
            reg_write   = 1'b1;
            mem_read    = 1'b1;
            ALUop_out    = 2'b00;
            end
    STORE: begin
            ALU_src     = 1'b1;
            mem_write   = 1'b1;
            ALUop_out    = 2'b00;
            end
    BRANCH: begin
            ALUop_out    = 2'b01;
            branch      = 1'b1;
            end
    JAL: begin
            jal         = 1'b1;
            reg_write   = 1'b1;
            end
    JALR: begin
            jalr        = 1'b1;
            ALU_src     = 1'b1;
            ALUop_out   = 2'b00;
            reg_write   = 1'b1;
            end
    LUI: begin
            ALU_a_sel   = 2'b10;
            ALU_src     = 1'b1;
            ALUop_out   = 2'b00;
            reg_write   = 1'b1;
            end
    AUIPC: begin
            ALU_a_sel   = 2'b01;
            ALU_src     = 1'b1;
            ALUop_out   = 2'b00;
            reg_write   = 1'b1;
            end
    default: begin
             branch = 1'b0;
             mem_read = 1'b0;
             mem_to_reg = 1'b0;
             mem_write = 1'b0;
             ALU_src = 1'b0;
             reg_write = 1'b0;
             ALUop_out = 2'b00;
             end

    endcase

    end

endmodule

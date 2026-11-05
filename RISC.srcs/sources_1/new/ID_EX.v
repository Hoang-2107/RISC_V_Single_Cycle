`timescale 1ns / 1ps
module ID_EX(
    input clk, rst,
    input flush,

    input            id_alu_src,
    input      [1:0] id_alu_op,
    input      [1:0] id_alu_a_sel,
    input            id_branch,
    input            id_jal,
    input            id_jalr,
    input            id_mem_read,
    input            id_mem_write,
    input            id_reg_write,
    input            id_mem_to_reg,

    input     [31:0] id_pc,
    input     [31:0] id_pc4,
    input     [31:0] id_rs1_data,
    input     [31:0] id_rs2_data,
    input     [31:0] id_imm,
    input      [4:0] id_rs1,
    input      [4:0] id_rs2,
    input      [4:0] id_rd,
    input      [2:0] id_funct3,
    input      [6:0] id_funct7,

    output reg       ex_alu_src,
    output reg [1:0] ex_alu_op,
    output reg [1:0] ex_alu_a_sel,
    output reg       ex_branch,
    output reg       ex_jal,
    output reg       ex_jalr,
    output reg       ex_mem_read,
    output reg       ex_mem_write,
    output reg       ex_reg_write,
    output reg       ex_mem_to_reg,

    output reg [31:0] ex_pc,
    output reg [31:0] ex_pc4,
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [31:0] ex_imm,
    output reg  [4:0] ex_rs1,
    output reg  [4:0] ex_rs2,
    output reg  [4:0] ex_rd,
    output reg  [2:0] ex_funct3,
    output reg  [6:0] ex_funct7
);

    always @(posedge clk) begin
        if (rst || flush) begin
            ex_alu_src    <= 1'b0;
            ex_alu_op     <= 2'b00;
            ex_alu_a_sel  <= 2'b00;
            ex_branch     <= 1'b0;
            ex_jal        <= 1'b0;
            ex_jalr       <= 1'b0;
            ex_mem_read   <= 1'b0;
            ex_mem_write  <= 1'b0;
            ex_reg_write  <= 1'b0;
            ex_mem_to_reg <= 1'b0;
            ex_pc       <= 32'd0;
            ex_pc4      <= 32'd0;
            ex_rs1_data <= 32'd0;
            ex_rs2_data <= 32'd0;
            ex_imm      <= 32'd0;
            ex_rs1      <= 5'd0;
            ex_rs2      <= 5'd0;
            ex_rd       <= 5'd0;
            ex_funct3   <= 3'd0;
            ex_funct7   <= 7'd0;
        end
        else begin
            ex_alu_src    <= id_alu_src;
            ex_alu_op     <= id_alu_op;
            ex_alu_a_sel  <= id_alu_a_sel;
            ex_branch     <= id_branch;
            ex_jal        <= id_jal;
            ex_jalr       <= id_jalr;
            ex_mem_read   <= id_mem_read;
            ex_mem_write  <= id_mem_write;
            ex_reg_write  <= id_reg_write;
            ex_mem_to_reg <= id_mem_to_reg;

            ex_pc       <= id_pc;
            ex_pc4      <= id_pc4;
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_imm      <= id_imm;
            ex_rs1      <= id_rs1;
            ex_rs2      <= id_rs2;
            ex_rd       <= id_rd;
            ex_funct3   <= id_funct3;
            ex_funct7   <= id_funct7;
        end
    end

endmodule

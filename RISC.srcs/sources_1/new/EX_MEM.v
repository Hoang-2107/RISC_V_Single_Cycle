`timescale 1ns / 1ps
module EX_MEM(
    input clk, rst,

    input  ex_mem_read,
    input  ex_mem_write,
    input  ex_mem_to_reg,
    input  ex_reg_write,

    input [31:0] ex_result,
    input [31:0] ex_store_data,
    input [4:0] ex_rd,
    input [2:0] ex_funct3,

    output reg  mem_mem_read,
    output reg  mem_mem_write,
    output reg  mem_reg_write, mem_mem_to_reg,
    output reg [31:0] mem_result, mem_store_data,
    output reg [4:0] mem_rd,
    output reg [2:0] mem_funct3
);

always @(posedge clk) begin
    if (rst) begin
        mem_mem_read <= 0;
        mem_mem_write <= 0;
        mem_reg_write <= 0;
        mem_mem_to_reg <= 0;
        mem_result <= 0;
        mem_store_data <= 0;
        mem_rd <= 0;
        mem_funct3 <= 0;
    end else begin
        mem_mem_read <= ex_mem_read;
        mem_mem_write <= ex_mem_write;
        mem_reg_write <= ex_reg_write;
        mem_mem_to_reg <= ex_mem_to_reg;
        mem_result <= ex_result;
        mem_store_data <= ex_store_data;
        mem_rd <= ex_rd;
        mem_funct3 <= ex_funct3;
    end
end
endmodule

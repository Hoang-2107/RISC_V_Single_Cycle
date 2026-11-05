`timescale 1ns / 1ps
module forwarding_unit(
    input [4:0] ex_rs1,
    input [4:0] ex_rs2,

    input [4:0] mem_rd,
    input mem_reg_write,

    input [4:0] wb_rd,
    input wb_reg_write,

    output reg [1:0] fwdA,
    output reg [1:0] fwdB
);

localparam FWD_REG = 2'b00;
localparam FWD_MEM = 2'b10;
localparam FWD_WB  = 2'b01;

always @(*) begin
    if(mem_reg_write && (mem_rd != 5'd0) && (mem_rd == ex_rs1)) begin
        fwdA = FWD_MEM;
    end 
    else if(wb_reg_write && (wb_rd != 5'd0) && (wb_rd == ex_rs1)) begin
        fwdA = FWD_WB;
    end 
    else  fwdA = FWD_REG;
    if(mem_reg_write && (mem_rd != 5'd0) && (mem_rd == ex_rs2)) begin
        fwdB = FWD_MEM;
    end 
    else if(wb_reg_write && (wb_rd != 5'd0) && (wb_rd == ex_rs2)) begin
        fwdB = FWD_WB;
    end 
    else begin
        fwdB = FWD_REG;
    end

end
endmodule 
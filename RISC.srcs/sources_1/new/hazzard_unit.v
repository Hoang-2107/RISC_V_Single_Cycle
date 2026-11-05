`timescale 1ns / 1ps
module hazzard_unit(
    input  [4:0] id_rs1,
    input  [4:0] id_rs2,
    input  [4:0] ex_rd,
    input        ex_mem_read,
    input        ex_branch_take,
    input        ex_jal,
    input        ex_jalr,
    output       pc_stall,
    output       if_id_stall,
    output       if_id_flush,
    output       id_ex_flush
);

    //kiểm tra xem có lệnh tải không
    wire load_use = ex_mem_read && (ex_rd != 5'd0) &&
                    ((ex_rd == id_rs1) || (ex_rd == id_rs2));

    wire redirect = ex_branch_take | ex_jal | ex_jalr;

    assign pc_stall    = load_use & ~redirect;
    assign if_id_stall = load_use & ~redirect;
    assign if_id_flush = redirect;
    assign id_ex_flush = load_use | redirect;

endmodule

`timescale 1ns / 1ps
module RISCV_PIPELINE
 #(parameter MEM_FILE = "D:/RISC/sw/hex/rv32i_test.hex")
(
    input         clk, reset,
    output [31:0] pc_out,
    output [31:0] wb_data,
    output        wb_en
);
    wire rst_n = ~reset;

    wire        pc_stall, if_id_stall, if_id_flush, id_ex_flush;
    wire        redirect;
    wire [31:0] redirect_pc;

    wire [31:0] if_pc, if_pc4, if_inst, pc_next;

    assign pc_next = redirect ? redirect_pc :
                     pc_stall ? if_pc       : if_pc4;

    Program_Counter Program_Counter(
        .clk   (clk),
        .rst   (reset),
        .PC_in (pc_next),
        .PC_out(if_pc)
    );

    PC_Adder PC_Adder(
        .From_PC(if_pc),
        .PC_plus(if_pc4)
    );

    Instruction_Mem #(
        .ADDR_WIDTH(10),
        .MEM_FILE  (MEM_FILE)
    ) Instruction_Mem (
        .read_address(if_pc),
        .instruction (if_inst)
    );

    wire [31:0] id_pc, id_pc4, id_inst;

    IF_ID IF_ID(
        .clk    (clk),
        .rst    (reset),
        .stall  (if_id_stall),
        .flush  (if_id_flush),
        .if_pc  (if_pc),
        .if_pc4 (if_pc4),
        .if_inst(if_inst),
        .id_pc  (id_pc),
        .id_pc4 (id_pc4),
        .id_inst(id_inst)
    );

    wire [4:0] id_rs1 = id_inst[19:15];
    wire [4:0] id_rs2 = id_inst[24:20];
    wire [4:0] id_rd  = id_inst[11:7];

    wire       id_branch, id_mem_read, id_mem_to_reg, id_mem_write;
    wire       id_alu_src, id_reg_write, id_jal, id_jalr;
    wire [1:0] id_alu_op, id_alu_a_sel;

    Control_unit Control_unit(
        .OPcode    (id_inst[6:0]),
        .branch    (id_branch),
        .mem_read  (id_mem_read),
        .mem_to_reg(id_mem_to_reg),
        .mem_write (id_mem_write),
        .ALU_src   (id_alu_src),
        .reg_write (id_reg_write),
        .ALUop_out (id_alu_op),
        .jal       (id_jal),
        .jalr      (id_jalr),
        .ALU_a_sel (id_alu_a_sel)
    );

    wire        wb_reg_write;
    wire [4:0]  wb_rd;
    wire [31:0] rf_rd1, rf_rd2;

    Register_file Register_file(
        .clk       (clk),
        .rst_n     (rst_n),
        .read_reg1 (id_rs1),
        .read_reg2 (id_rs2),
        .write_reg (wb_rd),
        .write_data(wb_data),
        .reg_write (wb_reg_write),
        .read_data1(rf_rd1),
        .read_data2(rf_rd2)
    );

    wire wb_hit_rs1 = wb_reg_write && (wb_rd != 5'd0) && (wb_rd == id_rs1);
    wire wb_hit_rs2 = wb_reg_write && (wb_rd != 5'd0) && (wb_rd == id_rs2);
    wire [31:0] id_rs1_data = wb_hit_rs1 ? wb_data : rf_rd1;
    wire [31:0] id_rs2_data = wb_hit_rs2 ? wb_data : rf_rd2;

    wire [31:0] id_imm;

    Imm_Gen Imm_Gen(
        .Inst_in (id_inst),
        .Inst_out(id_imm)
    );

    wire       ex_alu_src, ex_branch, ex_jal, ex_jalr;
    wire       ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg;
    wire [1:0] ex_alu_op, ex_alu_a_sel;
    wire [31:0] ex_pc, ex_pc4, ex_rs1_data, ex_rs2_data, ex_imm;
    wire [4:0]  ex_rs1, ex_rs2, ex_rd;
    wire [2:0]  ex_funct3;
    wire [6:0]  ex_funct7;

    ID_EX ID_EX(
        .clk          (clk),
        .rst          (reset),
        .flush        (id_ex_flush),
        .id_alu_src   (id_alu_src),
        .id_alu_op    (id_alu_op),
        .id_alu_a_sel (id_alu_a_sel),
        .id_branch    (id_branch),
        .id_jal       (id_jal),
        .id_jalr      (id_jalr),
        .id_mem_read  (id_mem_read),
        .id_mem_write (id_mem_write),
        .id_reg_write (id_reg_write),
        .id_mem_to_reg(id_mem_to_reg),
        .id_pc        (id_pc),
        .id_pc4       (id_pc4),
        .id_rs1_data  (id_rs1_data),
        .id_rs2_data  (id_rs2_data),
        .id_imm       (id_imm),
        .id_rs1       (id_rs1),
        .id_rs2       (id_rs2),
        .id_rd        (id_rd),
        .id_funct3    (id_inst[14:12]),
        .id_funct7    (id_inst[31:25]),
        .ex_alu_src   (ex_alu_src),
        .ex_alu_op    (ex_alu_op),
        .ex_alu_a_sel (ex_alu_a_sel),
        .ex_branch    (ex_branch),
        .ex_jal       (ex_jal),
        .ex_jalr      (ex_jalr),
        .ex_mem_read  (ex_mem_read),
        .ex_mem_write (ex_mem_write),
        .ex_reg_write (ex_reg_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_pc        (ex_pc),
        .ex_pc4       (ex_pc4),
        .ex_rs1_data  (ex_rs1_data),
        .ex_rs2_data  (ex_rs2_data),
        .ex_imm       (ex_imm),
        .ex_rs1       (ex_rs1),
        .ex_rs2       (ex_rs2),
        .ex_rd        (ex_rd),
        .ex_funct3    (ex_funct3),
        .ex_funct7    (ex_funct7)
    );

    wire        mem_reg_write;
    wire [4:0]  mem_rd;
    wire [31:0] mem_result;
    wire [1:0]  fwdA, fwdB;

    forwarding_unit forwarding_unit(
        .ex_rs1       (ex_rs1),
        .ex_rs2       (ex_rs2),
        .mem_rd       (mem_rd),
        .mem_reg_write(mem_reg_write),
        .wb_rd        (wb_rd),
        .wb_reg_write (wb_reg_write),
        .fwdA         (fwdA),
        .fwdB         (fwdB)
    );

    wire [31:0] fwd_a = (fwdA == 2'b10) ? mem_result :
                        (fwdA == 2'b01) ? wb_data    : ex_rs1_data;
    wire [31:0] fwd_b = (fwdB == 2'b10) ? mem_result :
                        (fwdB == 2'b01) ? wb_data    : ex_rs2_data;

    wire [31:0] alu_a = (ex_alu_a_sel == 2'b01) ? ex_pc :
                        (ex_alu_a_sel == 2'b10) ? 32'd0 : fwd_a;
    wire [31:0] alu_b;

    Mux_2to1 Mux_ALU_src(
        .d0 (fwd_b),
        .d1 (ex_imm),
        .sel(ex_alu_src),
        .y  (alu_b)
    );

    wire [3:0]  alu_ctrl;
    wire [31:0] alu_result;
    wire        alu_zero;

    ALU_Control ALU_Control(
        .ALUOp_in(ex_alu_op),
        .funct7  (ex_funct7),
        .funct3  (ex_funct3),
        .ALU_ctrl(alu_ctrl)
    );

    ALU ALU(
        .A         (alu_a),
        .B         (alu_b),
        .zero      (alu_zero),
        .alu_result(alu_result),
        .alu_ctrl  (alu_ctrl)
    );

    wire ex_branch_take;

    Branch_Comp Branch_Comp(
        .rs1   (fwd_a),
        .rs2   (fwd_b),
        .funct3(ex_funct3),
        .branch(ex_branch),
        .take  (ex_branch_take)
    );

    wire [31:0] ex_target;

    Adder_sum Adder_sum(
        .PC_plus(ex_pc),
        .Shift  (ex_imm),
        .Sum    (ex_target)
    );

    assign redirect    = ex_branch_take | ex_jal | ex_jalr;
    assign redirect_pc = ex_jalr ? {alu_result[31:1], 1'b0} : ex_target;

    wire [31:0] ex_result;

    Mux_2to1 Mux_EX_result(
        .d0 (alu_result),
        .d1 (ex_pc4),
        .sel(ex_jal | ex_jalr),
        .y  (ex_result)
    );

    hazzard_unit hazzard_unit(
        .id_rs1        (id_rs1),
        .id_rs2        (id_rs2),
        .ex_rd         (ex_rd),
        .ex_mem_read   (ex_mem_read),
        .ex_branch_take(ex_branch_take),
        .ex_jal        (ex_jal),
        .ex_jalr       (ex_jalr),
        .pc_stall      (pc_stall),
        .if_id_stall   (if_id_stall),
        .if_id_flush   (if_id_flush),
        .id_ex_flush   (id_ex_flush)
    );

    wire        mem_mem_read, mem_mem_write, mem_mem_to_reg;
    wire [31:0] mem_store_data;
    wire [2:0]  mem_funct3;

    EX_MEM EX_MEM(
        .clk           (clk),
        .rst           (reset),
        .ex_mem_read   (ex_mem_read),
        .ex_mem_write  (ex_mem_write),
        .ex_mem_to_reg (ex_mem_to_reg),
        .ex_reg_write  (ex_reg_write),
        .ex_result     (ex_result),
        .ex_store_data (fwd_b),
        .ex_rd         (ex_rd),
        .ex_funct3     (ex_funct3),
        .mem_mem_read  (mem_mem_read),
        .mem_mem_write (mem_mem_write),
        .mem_reg_write (mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_result    (mem_result),
        .mem_store_data(mem_store_data),
        .mem_rd        (mem_rd),
        .mem_funct3    (mem_funct3)
    );

    wire [31:0] mem_read_data;

    Data_memory #(
        .ADDR_WIDTH(10)
    ) Data_memory (
        .clk       (clk),
        .rst_n     (rst_n),
        .mem_write (mem_mem_write),
        .mem_read  (mem_mem_read),
        .funct3    (mem_funct3),
        .address   (mem_result),
        .write_data(mem_store_data),
        .read_data (mem_read_data)
    );

    wire        wb_mem_to_reg;
    wire [31:0] wb_result, wb_read_data;

    MEM_WB MEM_WB(
        .clk          (clk),
        .rst          (reset),
        .mem_reg_write(mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_result   (mem_result),
        .mem_read_data(mem_read_data),
        .mem_rd       (mem_rd),
        .wb_reg_write (wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg),
        .wb_result    (wb_result),
        .wb_read_data (wb_read_data),
        .wb_rd        (wb_rd)
    );

    Mux_2to1 Mux_WB(
        .d0 (wb_result),
        .d1 (wb_read_data),
        .sel(wb_mem_to_reg),
        .y  (wb_data)
    );

    assign pc_out = if_pc;
    assign wb_en  = wb_reg_write & (wb_rd != 5'd0);

endmodule

`timescale 1ns / 1ps

module RISCV_TOP
 #(parameter MEM_FILE = "D:/RISC/rv32i_test.hex")
(
   input clk, reset,
   output [31:0] wb_data,
   output [31:0] pc_out,
   output       wb_en
    );
   wire [31:0] PC_out_Top,PC_adder,sum_out,shift_out;
   wire [31:0] read_data_top,instruction_out_top,mux3, mux2, mux1, data1_out,data2_out, alu_out;
   wire reg_write_top,zero_top,mem_read_top,mem_write_top,
   mem_to_reg_top,branch_top,alu_src_top;
   wire [31:0] im_gen_top;
   wire [1:0] ALUOp_top;
   wire [3:0] control_out;
   // --- Cap 1 (RV32I day du): jal/jalr/lui/auipc + 6 lenh nhanh ---
   wire        jal_top, jalr_top, branch_take;
   wire [1:0]  alu_a_sel_top;
   wire [31:0] alu_a;      // dau vao A cua ALU (rs1 / PC / 0)
   wire [31:0] mux4;       // du lieu ghi nguoc cuoi cung (mux3 / PC+4)
   wire [31:0] pc_next;    // dia chi lenh ke tiep
    //chuong trinh
   Program_Counter Program_Counter(
    .clk(clk),
    .rst(reset),
    .PC_in(pc_next),
    .PC_out(PC_out_Top)
    );
      // 5. PC Adder
    PC_Adder PC_Adder(
    .From_PC(PC_out_Top),
    .PC_plus(PC_adder)
    );
    // Bo cong tinh dia chi nhanh: Branch target = PC + offset
    //  - PC_plus phai la PC HIEN TAI (PC_out_Top), KHONG phai PC+4.
    //  - Shift lay thang im_gen_top vi Imm_Gen da gan san bit 0 (da x2).
    //    Neu sua Imm_Gen theo sach (bo 1'b0) thi doi thanh .Shift(shift_out).
       Adder_sum Adder_sum(
     .PC_plus(PC_out_Top),
     .Shift(im_gen_top),
    .Sum(sum_out)
    );
    
    Instruction_Mem#(.ADDR_WIDTH(10),
    .MEM_FILE(MEM_FILE)
    )Instruction_Mem(
    //.reset(reset),
    .read_address(PC_out_Top),
    .instruction(instruction_out_top)
    );
    // 3. Register File
    wire rst_n = ~reset;
    Register_file Register_file(
     .clk(clk),
     .rst_n(rst_n), 
     .read_reg1(instruction_out_top[19:15]),
     .read_reg2(instruction_out_top[24:20]),
     .write_reg(instruction_out_top[11:7]),
     .write_data(mux4),
     .reg_write(reg_write_top),
     .read_data1(data1_out),
     .read_data2(data2_out)
    );
    // 4. Immediate Generator
    // MUX dau vao A cua ALU: 00 = rs1 (binh thuong), 01 = PC (auipc), 10 = 0 (lui)
    assign alu_a = (alu_a_sel_top == 2'b01) ? PC_out_Top :
                   (alu_a_sel_top == 2'b10) ? 32'd0      : data1_out;
    ALU ALU(
    .A(alu_a),
    .B(mux2),
    .zero(zero_top),
    .alu_result(alu_out),
    .alu_ctrl(control_out)
    );
    
    Data_memory#(.ADDR_WIDTH(10)
    //.MEM_FILE("D:/RISC/rv32i_test.hex")
    ) Data_memory(
    .clk(clk),
    .rst_n(rst_n),
    .mem_write(mem_write_top),
    .mem_read(mem_read_top),
    .funct3(instruction_out_top[14:12]),   // lb/lh/lw/lbu/lhu, sb/sh/sw
    .address(alu_out),
    .write_data(data2_out),
    .read_data(read_data_top)
    );
    // 4. ALU Control
    ALU_Control ALU_Control(
    .ALUOp_in(ALUOp_top),
    .funct7(instruction_out_top[31:25]),
    .funct3(instruction_out_top[14:12]),
    .ALU_ctrl(control_out)
    );
   
    // 6. Control Unit
    Control_unit Control_unit(
    .OPcode(instruction_out_top[6:0]),
    .branch(branch_top),
    .mem_read(mem_read_top),
    .mem_to_reg(mem_to_reg_top),
    .mem_write(mem_write_top),
    .ALU_src(alu_src_top),
    .reg_write(reg_write_top),
    .ALUop_out(ALUOp_top),
    .jal(jal_top),
    .jalr(jalr_top),
    .ALU_a_sel(alu_a_sel_top)
    );
    //7.MUX
    Mux_2to1 Mux_ALU_DataMemmory(
    .d0(alu_out),
    .d1(read_data_top),
    .sel(mem_to_reg_top),
    .y(mux3)
    );
    // jal/jalr: ghi dia chi tra ve PC+4 vao rd
    Mux_2to1 Mux_WB_Link(
    .d0(mux3),
    .d1(PC_adder),
    .sel(jal_top | jalr_top),
    .y(mux4)
    );

    
    
    Imm_Gen Imm_Gen(
    .Inst_in(instruction_out_top), 
    .Inst_out(im_gen_top)
    );
    
    Mux_2to1 Mux_ALU(
    .d1(im_gen_top),
    .sel(alu_src_top),
    .d0(data2_out),
    .y(mux2)
    );
    
    // PC + imm khi nhanh duoc nhay HOAC jal, nguoc lai PC + 4
    Mux_2to1 Mux_PC(
    .d0(PC_adder),
    .sel(branch_take | jal_top),
    .d1(sum_out),
    .y(mux1)
    );
    // jalr: PC <- (rs1 + imm) voi bit 0 xoa ve 0 (theo chuan RISC-V)
    Mux_2to1 Mux_PC_JALR(
    .d0(mux1),
    .d1({alu_out[31:1], 1'b0}),
    .sel(jalr_top),
    .y(pc_next)
    );
    
    // Thay And_zero (chi lam duoc beq) bang Branch_Comp (du 6 lenh nhanh)
    Branch_Comp Branch_Comp(
    .rs1(data1_out),
    .rs2(data2_out),
    .funct3(instruction_out_top[14:12]),
    .branch(branch_top),
    .take(branch_take)
    );
    assign wb_data = mux4;
    assign pc_out = PC_out_Top;
    assign wb_en = reg_write_top & (instruction_out_top[11:7] != 5'd0);
endmodule

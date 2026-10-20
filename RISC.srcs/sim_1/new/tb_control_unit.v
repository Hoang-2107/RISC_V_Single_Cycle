`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Kiem chung rieng module control_unit: kiem tra bo tin hieu dieu khien
// sinh ra ung voi tung loai opcode (R-type, load, store, branch,
// va opcode khong xac dinh).
//////////////////////////////////////////////////////////////////////////////////


module tb_control_unit(

    );
    reg  [6:0] opcode;
 
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    wire [1:0] alu_op;
 
    integer error_count;
 
    // ---- Instance module can test ----
    Control_unit dut (
        .OPcode     (opcode),
        .branch     (branch),
        .mem_read   (mem_read),
        .mem_to_reg (mem_to_reg),
        .ALUop_out     (alu_op),
        .mem_write  (mem_write),
        .ALU_src    (alu_src),
        .reg_write  (reg_write)
    );
 
    // ---- Task kiem tra toan bo bus tin hieu dieu khien ----
    task check;
        input [127:0] name;
        input         exp_branch;
        input         exp_mem_read;
        input         exp_mem_to_reg;
        input  [1:0]  exp_alu_op;
        input         exp_mem_write;
        input         exp_alu_src;
        input         exp_reg_write;
        begin
            #1;
            if (branch     !== exp_branch     || mem_read  !== exp_mem_read  ||
                mem_to_reg !== exp_mem_to_reg || alu_op    !== exp_alu_op    ||
                mem_write  !== exp_mem_write  || alu_src   !== exp_alu_src   ||
                reg_write  !== exp_reg_write) begin
                $display("FAIL [%0s] opcode=%b -> branch=%b memRead=%b memToReg=%b aluOp=%b memWrite=%b aluSrc=%b regWrite=%b",
                          name, opcode, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
                $display("      (expect  branch=%b memRead=%b memToReg=%b aluOp=%b memWrite=%b aluSrc=%b regWrite=%b)",
                          exp_branch, exp_mem_read, exp_mem_to_reg, exp_alu_op, exp_mem_write, exp_alu_src, exp_reg_write);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] opcode=%b -> branch=%b memRead=%b memToReg=%b aluOp=%b memWrite=%b aluSrc=%b regWrite=%b",
                          name, opcode, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
            end
        end
    endtask
 
    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong Control Unit ===");
 
        // ---- Test 1: R-type (add/sub/and/or...) ----
        opcode = 7'b0110011;
        check("R-TYPE", 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);
 
        // ---- Test 2: I-type load (lw) ----
        opcode = 7'b0000011;
        check("LOAD (lw)", 1'b0, 1'b1, 1'b1, 2'b00, 1'b0, 1'b1, 1'b1);
 
        // ---- Test 3: S-type store (sw) ----
        opcode = 7'b0100011;
        check("STORE (sw)", 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0);
 
        // ---- Test 4: B-type branch (beq) ----
        opcode = 7'b1100011;
        check("BRANCH (beq)", 1'b1, 1'b0, 1'b0, 2'b01, 1'b0, 1'b0, 1'b0);
 
        // ---- Test 5: opcode khong xac dinh -> tat ca tin hieu ve an toan (0) ----
        opcode = 7'b1111111;
        check("UNKNOWN OPCODE", 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);
 
        // ---- Test 6: chuyen doi lien tuc giua cac opcode (kiem tra to hop thuan tuy) ----
        opcode = 7'b0110011; // R-type
        #1;
        opcode = 7'b1100011; // doi ngay sang branch, khong can clock
        check("CHUYEN NHANH R-type->BRANCH", 1'b1, 1'b0, 1'b0, 2'b01, 1'b0, 1'b0, 1'b0);
 
        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);
 
        $finish;
    end
endmodule

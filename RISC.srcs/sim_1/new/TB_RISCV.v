`timescale 1ns / 1ps
// ============================================================================
// Testbench: tb_RISCV_TOP (ban cap nhat)
//   - Chuong trinh nap tu program.hex (giong het khi chay tren board)
//   - 4 lenh addi tao gia tri ban dau, roi 12 lenh R-type
//   - Kiem tra PC tang 4 moi chu ky va gia tri cuoi cua thanh ghi
// ============================================================================
module TB_RISCV;

    reg clk;
    reg reset;
    integer errors, cycle;
    reg [31:0] pc_prev;

    wire [31:0] pc_out, wb_data;
    wire        wb_en;

    localparam N_INST = 16;

    RISCV_TOP //#(.MEM_FILE("D:/RISC/RISC.srcs/sim_1/new/program.hex")) 
    dut (
        .clk    (clk),
        .reset  (reset),
        .pc_out (pc_out),
        .wb_data(wb_data),
        .wb_en  (wb_en)
    );
    initial clk = 1'b1;
    always #5 clk = ~clk;
    integer i;
  
      // ---------------- Nap chuong trinh vao Instruction Memory ----------------
    initial begin
        #1;   // cho Instruction_Mem nap file hex xong roi moi ghi de chuong trinh rieng
        for (i = 0; i < 1024; i = i + 1)
            dut.Instruction_Mem.Memory[i] = 32'h00000000;

        dut.Instruction_Mem.Memory[0]  = 32'h00f00093; // 0: addi x1, x0, 15
        dut.Instruction_Mem.Memory[1]  = 32'h00300113; // 1: addi x2, x0, 3
        dut.Instruction_Mem.Memory[2]  = 32'hff800193; // 2: addi x3, x0, -8
        dut.Instruction_Mem.Memory[3]  = 32'h00200213; // 3: addi x4, x0, 2
        dut.Instruction_Mem.Memory[4]  = 32'h002082b3; // 4: add  x5, x1, x2
        dut.Instruction_Mem.Memory[5]  = 32'h40208333; // 5: sub  x6, x1, x2
        dut.Instruction_Mem.Memory[6]  = 32'h0020f3b3; // 6: and  x7, x1, x2
        dut.Instruction_Mem.Memory[7]  = 32'h0020e433; // 7: or   x8, x1, x2
        dut.Instruction_Mem.Memory[8]  = 32'h0020c4b3; // 8: xor  x9, x1, x2
        dut.Instruction_Mem.Memory[9]  = 32'h00409533; // 9: sll  x10, x1, x4
        dut.Instruction_Mem.Memory[10] = 32'h0041d5b3; // 10: srl x11, x3, x4
        dut.Instruction_Mem.Memory[11] = 32'h4041d633; // 11: sra x12, x3, x4
        dut.Instruction_Mem.Memory[12] = 32'h0011a6b3; // 12: slt x13, x3, x1
        dut.Instruction_Mem.Memory[13] = 32'h0011b733; // 13: sltu x14, x3, x1
        dut.Instruction_Mem.Memory[14] = 32'h00208033; // 14: add x0, x1, x2 (x0 lu�n gi? gi� tr? 0)
        dut.Instruction_Mem.Memory[15] = 32'h006287b3; // 15: add x15, x5, x6

    end
    initial begin
        $dumpfile("TB_RISCV.vcd");
        $dumpvars(0, TB_RISCV);
    end

    // In trang thai moi chu ky
    always @(posedge clk) begin
        if (!reset && cycle < N_INST)
            $display("cyc %2d | PC=%h INST=%h | ALUctrl=%b ALU=%h | wb_en=%b -> x%0d = %h",
                cycle, pc_out, dut.instruction_out_top, dut.control_out,
                dut.alu_out, wb_en, dut.instruction_out_top[11:7], wb_data);
    end

    // Kiem tra PC tang 4
    always @(posedge clk) begin
        if (!reset) begin
            #1;
            if (pc_out !== pc_prev + 32'd4) begin
                $display("  FAIL: PC = %h, mong doi %h", pc_out, pc_prev + 32'd4);
                errors = errors + 1;
            end
            pc_prev = pc_out;
            cycle   = cycle + 1;
        end
    end

    task check_reg(input [4:0] idx, input [31:0] expected, input [8*20-1:0] name);
        begin
            if (dut.Register_file.registers[idx] === expected)
                $display("  PASS  %-16s x%-2d = %h", name, idx, dut.Register_file.registers[idx]);
            else begin
                $display("  FAIL  %-16s x%-2d = %h  (mong doi %h)", name, idx,
                         dut.Register_file.registers[idx], expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors  = 0;
        cycle   = 0;
        pc_prev = 32'd0;

        reset = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        $display("\n========== BAT DAU CHAY CHUONG TRINH ==========");
        repeat (N_INST) @(posedge clk);
        #2;

        $display("\n================== KET QUA ===================");
        check_reg(1,  32'd15,        "addi");
        check_reg(2,  32'd3,         "addi");
        check_reg(3,  32'hFFFFFFF8,  "addi am (-8)");
        check_reg(4,  32'd2,         "addi");
        check_reg(5,  32'd18,        "add");
        check_reg(6,  32'd12,        "sub");
        check_reg(7,  32'd3,         "and");
        check_reg(8,  32'd15,        "or");
        check_reg(9,  32'd12,        "xor");
        check_reg(10, 32'd60,        "sll");
        check_reg(11, 32'h3FFFFFFE,  "srl");
        check_reg(12, 32'hFFFFFFFE,  "sra");
        check_reg(13, 32'd1,         "slt (-8<15)");
        check_reg(14, 32'd0,         "sltu");
        check_reg(15, 32'd30,        "add phu thuoc");
        check_reg(0,  32'd0,         "ghi vao x0");

        if (errors == 0) $display("\n>>> TAT CA TEST PASS <<<\n");
        else             $display("\n>>> CO %0d LOI <<<\n", errors);
        $finish;
    end

    initial begin
        #3000;
        $display("TIMEOUT!");
        $finish;
    end
endmodule
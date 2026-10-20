`timescale 1ns / 1ps
// ============================================================================
// Testbench: tb_RISCV_TOP
// Viet theo dung code hien tai cua ban:
//   - Control_unit hien CHI ho tro R-type (opcode 0110011)
//   - Vi vay testbench:
//       + Nap lenh truc tiep vao dut.Instruction_Mem.Memory (KHONG can file .hex)
//       + Nap san gia tri ban dau cho thanh ghi x1..x4 (vi chua co addi)
//       + Chay 12 lenh R-type kiem tra du 10 phep toan cua ALU
//       + Kiem tra PC tang 4 moi chu ky va tu so sanh ket qua (PASS/FAIL)
// ============================================================================
module tb_RISCV_TOP;

    reg clk;
    reg reset;
    integer i, errors, cycle;
    reg [31:0] pc_prev;
    wire [31:0] pc_out;
    wire [31:0] wb_data;
    wire wb_en;

    localparam N_INST = 12;

    // ---------------- DUT ----------------
    RISCV_TOP dut (
        .clk  (clk),
        .reset(reset), 
        .pc_out(pc_out),
        .wb_data(wb_data),
        .wb_en(wb_en)
    );

    // ---------------- Clock: chu ky 10ns ----------------
   
    initial clk = 1'b0;
   
    always #5 clk = ~clk;
     
    // ---------------- Waveform ----------------
    
    initial begin
        $dumpfile("tb_RISCV_TOP.vcd");
        $dumpvars(0, tb_RISCV_TOP);
    end
   
    // ---------------- Nap chuong trinh vao Instruction Memory ----------------
    initial begin
        #1;
        for (i = 0; i < 1024; i = i + 1)
            dut.Instruction_Mem.Memory[i] = 32'h00000013;

        dut.Instruction_Mem.Memory[0]  = 32'h002082b3; // add  x5,  x1, x2
        dut.Instruction_Mem.Memory[1]  = 32'h40208333; // sub  x6,  x1, x2
        dut.Instruction_Mem.Memory[2]  = 32'h0020f3b3; // and  x7,  x1, x2
        dut.Instruction_Mem.Memory[3]  = 32'h0020e433; // or   x8,  x1, x2
        dut.Instruction_Mem.Memory[4]  = 32'h0020c4b3; // xor  x9,  x1, x2
        dut.Instruction_Mem.Memory[5]  = 32'h00409533; // sll  x10, x1, x4
        dut.Instruction_Mem.Memory[6]  = 32'h0041d5b3; // srl  x11, x3, x4
        dut.Instruction_Mem.Memory[7]  = 32'h4041d633; // sra  x12, x3, x4
        dut.Instruction_Mem.Memory[8]  = 32'h0011a6b3; // slt  x13, x3, x1
        dut.Instruction_Mem.Memory[9]  = 32'h0011b733; // sltu x14, x3, x1
        dut.Instruction_Mem.Memory[10] = 32'h00208033; // add  x0,  x1, x2  (x0 phai giu = 0)
        dut.Instruction_Mem.Memory[11] = 32'h006287b3; // add  x15, x5, x6  (dung ket qua lenh truoc)
    end

    // ---------------- In trang thai moi chu ky ----------------
    always @(posedge clk) begin
        if (!reset && cycle < N_INST) begin
            $display("cyc %2d | PC=%h INST=%h | rs1=x%0d(%h) rs2=x%0d(%h) | ALUctrl=%b ALU=%h | RegWrite=%b -> x%0d",
                cycle, dut.PC_out_Top, dut.instruction_out_top,
                dut.instruction_out_top[19:15], dut.data1_out,
                dut.instruction_out_top[24:20], dut.mux2,
                dut.control_out, dut.alu_out,
                dut.reg_write_top, dut.instruction_out_top[11:7]);
        end
    end

    // ---------------- Kiem tra PC tang 4 moi chu ky ----------------
    always @(posedge clk) begin
        if (!reset) begin
            #1;
            if (dut.PC_out_Top !== pc_prev + 32'd4) begin
                $display("  FAIL: PC = %h, mong doi %h", dut.PC_out_Top, pc_prev + 32'd4);
                errors = errors + 1;
            end
            pc_prev = dut.PC_out_Top;
            cycle   = cycle + 1;
        end
    end

    // ---------------- Task kiem tra thanh ghi ----------------
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

    // ---------------- Kich ban chinh ----------------
    initial begin
        errors  = 0;
        cycle   = 0;
        pc_prev = 32'd0;

        // 1. Reset 2 chu ky
        reset = 1'b1;
        repeat (2) @(posedge clk);

        // 2. Nha reset o canh xuong, roi nap gia tri ban dau cho thanh ghi
        @(negedge clk);
        reset = 1'b0;
        dut.Register_file.registers[1] = 32'd15;          // x1 = 15
        dut.Register_file.registers[2] = 32'd3;           // x2 = 3
        dut.Register_file.registers[3] = 32'hFFFFFFF8;    // x3 = -8
        dut.Register_file.registers[4] = 32'd2;           // x4 = 2

        $display("\n========== BAT DAU CHAY CHUONG TRINH ==========");

        // 3. Chay N_INST lenh
        repeat (N_INST) @(posedge clk);
        #2;

        // 4. Kiem tra ket qua
        $display("\n================== KET QUA ===================");
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
        if (dut.Register_file.registers[0] === 32'd0)
            $display("  PASS  %-16s x0  = 0", "ghi vao x0");
        else begin
            $display("  FAIL  ghi vao x0: x0 = %h", dut.Register_file.registers[0]);
            errors = errors + 1;
        end

        if (errors == 0) $display("\n>>> TAT CA TEST PASS <<<\n");
        else             $display("\n>>> CO %0d LOI <<<\n", errors);
        $finish;
    end

    // Timeout an toan
    initial begin
        #2000;
        $display("TIMEOUT!");
        $finish;
    end

endmodule
`timescale 1ns / 1ps
// ============================================================================
// Testbench: tb_RV32I_full - kiem tra DU 37 lenh RV32I, TUNG LENH MOT
//   - Chuong trinh nap tu file D:/RISC/rv32i_full.hex (qua parameter MEM_FILE
//     cua RISCV_TOP -> Instruction_Mem dung $readmemh).
//   - Bang "mong doi" liet ke tung lenh DUOC THUC THI theo dung thu tu:
//       PC, co ghi thanh ghi hay khong, thanh ghi dich, gia tri ghi.
//     Lenh bi nhanh bo qua (vd 0x14) KHONG co trong bang -> neu CPU nhay sai
//     thi PC se lech bang va bao FAIL ngay tai lenh do.
//   - Moi canh len clock: so PC / wb_en / rd / wb_data voi dong tiep theo.
//   - Cuoi cung: kiem tra CPU dung o vong halt (PC = 0xD8) va gia tri cuoi
//     cua cac thanh ghi.
// ============================================================================
module tb_RV32I_full;

    reg clk;
    reg reset;
    integer errors, idx, n_exp, k;

    wire [31:0] pc_out, wb_data;
    wire        wb_en;

    localparam HALT_PC = 32'h000000D8;
    localparam MAX_EXP = 64;

    RISCV_TOP #(.MEM_FILE("D:/RISC/rv32i_full.hex")) dut (
        .clk    (clk),
        .reset  (reset),
        .pc_out (pc_out),
        .wb_data(wb_data),
        .wb_en  (wb_en)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_RV32I_full.vcd");
        $dumpvars(0, tb_RV32I_full);
    end

    // ---------------- Bang mong doi ----------------
    reg [31:0]     exp_pc   [0:MAX_EXP-1];
    reg            exp_we   [0:MAX_EXP-1];
    reg [4:0]      exp_rd   [0:MAX_EXP-1];
    reg [31:0]     exp_val  [0:MAX_EXP-1];
    reg [8*20-1:0] exp_name [0:MAX_EXP-1];

    // Them 1 dong vao bang (we = 0: lenh khong ghi thanh ghi -> bo qua rd/val)
    task e(input [31:0] pc, input we, input [4:0] rd, input [31:0] val,
           input [8*20-1:0] name);
        begin
            exp_pc[n_exp]   = pc;
            exp_we[n_exp]   = we;
            exp_rd[n_exp]   = rd;
            exp_val[n_exp]  = val;
            exp_name[n_exp] = name;
            n_exp = n_exp + 1;
        end
    endtask

    initial begin
        n_exp = 0;
        //    PC     we rd  gia tri         lenh
        e(32'h00, 1,  1, 32'hFFFFFFFB, "addi");
        e(32'h04, 1,  2, 32'h00000007, "addi");
        e(32'h08, 1,  3, 32'h12345000, "lui");
        e(32'h0C, 1,  4, 32'h0000100C, "auipc");
        e(32'h10, 0,  0, 0,            "bne  (nhay)");
        e(32'h18, 0,  0, 0,            "blt  (nhay)");
        e(32'h20, 0,  0, 0,            "bge  (nhay)");
        e(32'h28, 0,  0, 0,            "bltu (nhay)");
        e(32'h30, 0,  0, 0,            "bgeu (nhay)");
        e(32'h38, 0,  0, 0,            "beq  (khong nhay)");
        e(32'h3C, 1,  5, 32'h00000001, "addi");
        e(32'h40, 0,  0, 0,            "bne  (khong nhay)");
        e(32'h44, 1,  6, 32'h00000001, "addi");
        e(32'h48, 1,  7, 32'h0000004C, "jal");
        e(32'h50, 1,  8, 32'h00000060, "addi");
        e(32'h54, 1,  9, 32'h00000058, "jalr");
        e(32'h64, 1, 10, 32'h00000040, "addi");
        e(32'h68, 1, 11, 32'h80818000, "lui");
        e(32'h6C, 1, 11, 32'h80818283, "addi");
        e(32'h70, 0,  0, 0,            "sw");
        e(32'h74, 1, 12, 32'hFFFFFF83, "lb");
        e(32'h78, 1, 13, 32'h00000082, "lbu");
        e(32'h7C, 1, 14, 32'hFFFF8081, "lh");
        e(32'h80, 1, 15, 32'h00008283, "lhu");
        e(32'h84, 0,  0, 0,            "sb");
        e(32'h88, 0,  0, 0,            "sh");
        e(32'h8C, 1, 16, 32'h00070783, "lw (sau sb+sh)");
        e(32'h90, 1, 17, 32'h00000001, "slti");
        e(32'h94, 1, 18, 32'h00000083, "andi");
        e(32'h98, 1, 19, 32'hFFFFFFFD, "srai");
        e(32'h9C, 1, 20, 32'hFFFFFFF8, "xori");
        e(32'hA0, 1, 21, 32'h00000002, "add");
        e(32'hA4, 1, 22, 32'h0000000C, "sub");
        e(32'hA8, 1, 23, 32'h00000380, "sll");
        e(32'hAC, 1, 24, 32'h00000001, "slt");
        e(32'hB0, 1, 25, 32'h00000000, "sltu");
        e(32'hB4, 1, 26, 32'hFFFFFFFC, "xor");
        e(32'hB8, 1, 27, 32'h01010305, "srl");
        e(32'hBC, 1, 28, 32'hFF010305, "sra");
        e(32'hC0, 1, 29, 32'hFFFFFFFF, "or");
        e(32'hC4, 1, 30, 32'h00000003, "and");
        e(32'hC8, 1,  5, 32'h00000000, "sltiu");
        e(32'hCC, 1,  6, 32'h000000F7, "ori");
        e(32'hD0, 1,  8, 32'h70000000, "slli");
        e(32'hD4, 1, 10, 32'h0000000F, "srli");
    end

    // ---------------- Kiem tra tung lenh moi canh len clock ----------------
    // Tai canh len, tin hieu van la cua lenh hien tai (truoc khi ghi).
    reg ok;
    always @(posedge clk) begin
        if (!reset && idx < n_exp) begin
            ok = (pc_out === exp_pc[idx]) && (wb_en === exp_we[idx]);
            if (exp_we[idx])
                ok = ok && (dut.instruction_out_top[11:7] === exp_rd[idx])
                        && (wb_data === exp_val[idx]);

            if (ok) begin
                if (exp_we[idx])
                    $display("  PASS  %2d  PC=%h  %-18s x%-2d = %h", idx + 1, pc_out,
                             exp_name[idx], exp_rd[idx], wb_data);
                else
                    $display("  PASS  %2d  PC=%h  %-18s (khong ghi)", idx + 1, pc_out,
                             exp_name[idx]);
            end else begin
                $display("  FAIL  %2d  %-18s : PC=%h wb_en=%b x%0d=%h | mong doi PC=%h wb_en=%b x%0d=%h",
                         idx + 1, exp_name[idx],
                         pc_out, wb_en, dut.instruction_out_top[11:7], wb_data,
                         exp_pc[idx], exp_we[idx], exp_rd[idx], exp_val[idx]);
                errors = errors + 1;
            end
            idx = idx + 1;
        end
    end

    // ---------------- Kiem tra gia tri cuoi cua thanh ghi ----------------
    task check_reg(input [4:0] r, input [31:0] expected);
        begin
            if (dut.Register_file.registers[r] !== expected) begin
                $display("  FAIL  x%-2d = %h  (mong doi %h)", r,
                         dut.Register_file.registers[r], expected);
                errors = errors + 1;
            end
        end
    endtask

    // ---------------- Kich ban chinh ----------------
    initial begin
        errors = 0;
        idx    = 0;
        reset  = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        $display("\n========== KIEM TRA TUNG LENH (rv32i_full.hex) ==========");

        // Chay het bang, roi them vai chu ky o vong halt
        wait (idx == n_exp);
        repeat (3) @(posedge clk);
        #2;

        $display("\n========== KIEM TRA CUOI ==========");
        if (pc_out === HALT_PC)
            $display("  PASS  dung o vong halt PC = %h", pc_out);
        else begin
            $display("  FAIL  dung o vong halt: PC = %h (mong doi %h)", pc_out, HALT_PC);
            errors = errors + 1;
        end

        // Gia tri cuoi cung cua tat ca thanh ghi
        check_reg( 0, 32'h00000000);
        check_reg( 1, 32'hFFFFFFFB);  check_reg( 2, 32'h00000007);
        check_reg( 3, 32'h12345000);  check_reg( 4, 32'h0000100C);
        check_reg( 5, 32'h00000000);  check_reg( 6, 32'h000000F7);
        check_reg( 7, 32'h0000004C);  check_reg( 8, 32'h70000000);
        check_reg( 9, 32'h00000058);  check_reg(10, 32'h0000000F);
        check_reg(11, 32'h80818283);  check_reg(12, 32'hFFFFFF83);
        check_reg(13, 32'h00000082);  check_reg(14, 32'hFFFF8081);
        check_reg(15, 32'h00008283);  check_reg(16, 32'h00070783);
        check_reg(17, 32'h00000001);  check_reg(18, 32'h00000083);
        check_reg(19, 32'hFFFFFFFD);  check_reg(20, 32'hFFFFFFF8);
        check_reg(21, 32'h00000002);  check_reg(22, 32'h0000000C);
        check_reg(23, 32'h00000380);  check_reg(24, 32'h00000001);
        check_reg(25, 32'h00000000);  check_reg(26, 32'hFFFFFFFC);
        check_reg(27, 32'h01010305);  check_reg(28, 32'hFF010305);
        check_reg(29, 32'hFFFFFFFF);  check_reg(30, 32'h00000003);
        check_reg(31, 32'h00000000);  // x31 = 0 -> moi lenh nhanh/nhay deu dung
        $display("  Da kiem tra gia tri cuoi cua x0..x31");

        $display("\n  So lenh da kiem tra: %0d/%0d (37 lenh RV32I khac nhau)", idx, n_exp);
        if (errors == 0) $display("\n>>> TAT CA TEST PASS <<<\n");
        else             $display("\n>>> CO %0d LOI <<<\n", errors);
        $finish;
    end

    // Timeout an toan (vd CPU nhay lac, khong bao gio het bang)
    initial begin
        #5000;
        $display("TIMEOUT! Moi kiem tra duoc %0d/%0d lenh", idx, n_exp);
        $finish;
    end

endmodule

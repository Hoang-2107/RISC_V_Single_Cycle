`timescale 1ns / 1ps
module tb_RISCV_pipeline;

    reg clk, reset;
    integer errors, idx, n_exp, cycles, extra;

    wire [31:0] pc_out, wb_data;
    wire        wb_en;

    localparam MAX_EXP = 64;

    RISCV_PIPELINE #(.MEM_FILE("D:/RISC/sw/hex/rv32i_full.hex")) dut (
        .clk    (clk),
        .reset  (reset),
        .pc_out (pc_out),
        .wb_data(wb_data),
        .wb_en  (wb_en)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    reg [4:0]      exp_rd   [0:MAX_EXP-1];
    reg [31:0]     exp_val  [0:MAX_EXP-1];
    reg [8*20-1:0] exp_name [0:MAX_EXP-1];

    task e(input [4:0] rd, input [31:0] val, input [8*20-1:0] name);
        begin
            exp_rd[n_exp]   = rd;
            exp_val[n_exp]  = val;
            exp_name[n_exp] = name;
            n_exp = n_exp + 1;
        end
    endtask

    initial begin
        n_exp = 0;
        e( 1, 32'hFFFFFFFB, "addi");
        e( 2, 32'h00000007, "addi");
        e( 3, 32'h12345000, "lui");
        e( 4, 32'h0000100C, "auipc");
        e( 5, 32'h00000001, "addi");
        e( 6, 32'h00000001, "addi");
        e( 7, 32'h0000004C, "jal");
        e( 8, 32'h00000060, "addi");
        e( 9, 32'h00000058, "jalr");
        e(10, 32'h00000040, "addi");
        e(11, 32'h80818000, "lui");
        e(11, 32'h80818283, "addi");
        e(12, 32'hFFFFFF83, "lb");
        e(13, 32'h00000082, "lbu");
        e(14, 32'hFFFF8081, "lh");
        e(15, 32'h00008283, "lhu");
        e(16, 32'h00070783, "lw (sau sb+sh)");
        e(17, 32'h00000001, "slti");
        e(18, 32'h00000083, "andi");
        e(19, 32'hFFFFFFFD, "srai");
        e(20, 32'hFFFFFFF8, "xori");
        e(21, 32'h00000002, "add");
        e(22, 32'h0000000C, "sub");
        e(23, 32'h00000380, "sll");
        e(24, 32'h00000001, "slt");
        e(25, 32'h00000000, "sltu");
        e(26, 32'hFFFFFFFC, "xor");
        e(27, 32'h01010305, "srl");
        e(28, 32'hFF010305, "sra");
        e(29, 32'hFFFFFFFF, "or");
        e(30, 32'h00000003, "and");
        e( 5, 32'h00000000, "sltiu");
        e( 6, 32'h000000F7, "ori");
        e( 8, 32'h70000000, "slli");
        e(10, 32'h0000000F, "srli");
    end

    always @(posedge clk) begin
        if (!reset) begin
            cycles = cycles + 1;
            if (wb_en) begin
                if (idx >= n_exp) begin
                    $display("  FAIL  ghi thua sau khi het bang: x%0d = %h (chu ky %0d)", dut.wb_rd, wb_data, cycles);
                    errors = errors + 1;
                    extra = extra + 1;
                end
                else if (dut.wb_rd === exp_rd[idx] && wb_data === exp_val[idx]) begin
                    $display("  PASS  %2d  chu ky %3d  %-16s x%-2d = %h", idx + 1, cycles, exp_name[idx], dut.wb_rd, wb_data);
                    idx = idx + 1;
                end
                else begin
                    $display("  FAIL  %2d  chu ky %3d  %-16s : x%0d = %h | mong doi x%0d = %h", idx + 1, cycles,
                             exp_name[idx], dut.wb_rd, wb_data, exp_rd[idx], exp_val[idx]);
                    errors = errors + 1;
                    idx = idx + 1;
                end
            end
        end
    end

    task check_reg(input [4:0] r, input [31:0] expected);
        begin
            if (dut.Register_file.registers[r] !== expected) begin
                $display("  FAIL  x%-2d = %h  (mong doi %h)", r, dut.Register_file.registers[r], expected);
                errors = errors + 1;
            end
        end
    endtask

    integer done_cycle;

    initial begin
        errors = 0; idx = 0; cycles = 0; extra = 0;
        reset  = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        $display("\n===== PIPELINE: THU TU GHI THANH GHI O TANG WB (rv32i_full.hex) =====");
        wait (idx == n_exp);
        done_cycle = cycles;
        repeat (20) @(posedge clk);
        #2;

        $display("\n===== KIEM TRA CUOI =====");
        if (pc_out >= 32'hD8 && pc_out <= 32'hE0)
            $display("  PASS  CPU dang o vong halt (PC = %h)", pc_out);
        else begin
            $display("  FAIL  PC = %h, khong o vong halt 0xD8", pc_out);
            errors = errors + 1;
        end

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
        check_reg(31, 32'h00000000);
        $display("  Da kiem tra gia tri cuoi cua x0..x31");
        $display("  Lenh ghi thanh ghi cuoi cung xong o chu ky %0d", done_cycle);

        if (errors == 0) $display("\n>>> TAT CA TEST PASS <<<\n");
        else             $display("\n>>> CO %0d LOI <<<\n", errors);
        $finish;
    end

    initial begin
        #20000;
        $display("TIMEOUT! Moi ghi dung %0d/%0d lenh", idx, n_exp);
        $finish;
    end

endmodule

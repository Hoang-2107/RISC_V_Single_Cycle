`timescale 1ns / 1ps
// ============================================================================
// Testbench: tb_C_program - chay chuong trinh C da bien dich bang GCC
//   - Nap sw/build/imem.hex vao Instruction_Mem, sw/build/dmem.hex vao Data_memory
//     (doi file bang plusarg: +IMEM=<file> +DMEM=<file>)
//   - Chay toi khi crt0.S ghi co "xong" (sw 1 -> 0x1004)
//   - In ket qua main() (crt0.S ghi vao 0x1000), so chu ky
//   - +EXPECT=<so> : so sanh ket qua voi gia tri mong doi -> PASS/FAIL
//   Bat lenh store o datapath (mem_write + alu_out) nen KHONG phu thuoc kich thuoc DMEM.
//   Cach chay nhanh: mo file .c trong VS Code -> Ctrl+Shift+B (xem sw/run_c.ps1)
// ============================================================================
module tb_C_program;

    localparam MAX_CYCLES = 200000;
    localparam TOHOST     = 32'h00001000;

    reg clk, reset;
    wire [31:0] pc_out, wb_data;
    wire        wb_en;

    RISCV_TOP dut (
        .clk    (clk),
        .reset  (reset),
        .pc_out (pc_out),
        .wb_data(wb_data),
        .wb_en  (wb_en)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    reg [8*256-1:0] imem_file, dmem_file;
    integer i, cycles, expect_val, has_expect;
    reg [31:0] result;
    reg        done;

    // ---------------- Nap chuong trinh (sau #1 de ghi de ROM mac dinh) ----------------
    initial begin
        if (!$value$plusargs("IMEM=%s", imem_file)) imem_file = "D:/RISC/sw/build/imem.hex";
        if (!$value$plusargs("DMEM=%s", dmem_file)) dmem_file = "D:/RISC/sw/build/dmem.hex";
        has_expect = $value$plusargs("EXPECT=%d", expect_val);
        #1;
        for (i = 0; i < 1024; i = i + 1)
            dut.Instruction_Mem.Memory[i] = 32'h00000013;   // nop
        $readmemh(imem_file, dut.Instruction_Mem.Memory);
        $readmemh(dmem_file, dut.Data_memory.Dmemory);
    end

    // ---------------- Bat lenh store vao vung tohost ----------------
    always @(posedge clk) begin
        if (!reset) begin
            cycles = cycles + 1;
            if (dut.mem_write_top && dut.alu_out == TOHOST)
                result = dut.data2_out;
            if (dut.mem_write_top && dut.alu_out == TOHOST + 4 && dut.data2_out == 32'd1)
                done = 1'b1;
            if (pc_out >= 32'h00001000) begin
                $display("[LOI] PC = %h chay ra ngoai IMEM (chu ky %0d)", pc_out, cycles);
                $finish;
            end
        end
    end

    initial begin
        $dumpfile("tb_C_program.vcd");
        $dumpvars(0, tb_C_program);
    end

    initial begin
        cycles = 0;
        done   = 1'b0;
        result = 32'hxxxxxxxx;
        reset  = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        wait (done || cycles >= MAX_CYCLES);
        @(negedge clk);

        $display("\n================ CHUONG TRINH C ================");
        if (!done) begin
            $display("  TIMEOUT: chua xong sau %0d chu ky (PC = %h)", cycles, pc_out);
            $display("\n>>> CO LOI <<<\n");
        end else begin
            $display("  main() tra ve : %0d (0x%h)", $signed(result), result);
            $display("  So chu ky     : %0d", cycles);
            if (!has_expect)
                $display("\n>>> XONG (khong co EXPECT de so sanh) <<<\n");
            else if (result === expect_val)
                $display("  Mong doi      : %0d\n\n>>> TAT CA TEST PASS <<<\n", expect_val);
            else
                $display("  Mong doi      : %0d\n\n>>> CO LOI <<<\n", expect_val);
        end
        $finish;
    end

endmodule

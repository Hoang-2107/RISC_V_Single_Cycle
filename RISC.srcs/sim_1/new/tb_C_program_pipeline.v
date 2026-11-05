`timescale 1ns / 1ps
module tb_C_program_pipeline;

    localparam MAX_CYCLES = 200000;
    localparam TOHOST     = 32'h00001000;

    reg clk, reset;
    wire [31:0] pc_out, wb_data;
    wire        wb_en;

    RISCV_PIPELINE dut (
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

    initial begin
        if (!$value$plusargs("IMEM=%s", imem_file)) imem_file = "D:/RISC/sw/build/imem.hex";
        if (!$value$plusargs("DMEM=%s", dmem_file)) dmem_file = "D:/RISC/sw/build/dmem.hex";
        has_expect = $value$plusargs("EXPECT=%d", expect_val);
        #1;
        for (i = 0; i < 1024; i = i + 1)
            dut.Instruction_Mem.Memory[i] = 32'h00000013;
        $readmemh(imem_file, dut.Instruction_Mem.Memory);
        $readmemh(dmem_file, dut.Data_memory.Dmemory);
    end

    always @(posedge clk) begin
        if (!reset) begin
            cycles = cycles + 1;
            if (dut.mem_mem_write && dut.mem_result == TOHOST)
                result = dut.mem_store_data;
            if (dut.mem_mem_write && dut.mem_result == TOHOST + 4 && dut.mem_store_data == 32'd1)
                done = 1'b1;
            if (pc_out >= 32'h00001000) begin
                $display("[LOI] PC = %h chay ra ngoai IMEM (chu ky %0d)", pc_out, cycles);
                $finish;
            end
        end
    end

    initial begin
        $dumpfile("tb_C_program_pipeline.vcd");
        $dumpvars(0, tb_C_program_pipeline);
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

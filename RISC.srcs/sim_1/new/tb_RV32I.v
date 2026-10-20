`timescale 1ns / 1ps
// ============================================================================
// Testbench: tb_RV32I - kiem tra CAP 1 (cac lenh moi cua RV32I)
//   - lui, auipc
//   - 6 lenh nhanh: beq, bne, blt, bge, bltu, bgeu (ca truong hop nhay/khong nhay)
//   - jal, jalr (dia chi tra ve + dia chi dich)
//   - lb, lh, lbu, lhu, sb, sh (truy cap byte / halfword)
//   - slti, andi, srai, xori (I-type ALU)
//
//   Moi lenh nhanh/nhay DUNG se bo qua lenh "addi x31, x31, 1" ngay sau no.
//   -> Cuoi chuong trinh x31 phai = 0, neu khac 0 la co lenh nhay sai.
//   Chuong trinh ket thuc bang "jal x0, 0" (nhay tai cho) o PC = 0xA0.
// ============================================================================
module tb_RV32I;

    reg clk;
    reg reset;
    integer errors;

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

    initial begin
        $dumpfile("tb_RV32I.vcd");
        $dumpvars(0, tb_RV32I);
    end

    // ---------------- Nap chuong trinh ----------------
    // [MOI] Chuong trinh duoc Instruction_Mem nap tu file D:/RISC/rv32i_test.hex
    //       (parameter MEM_FILE) -> testbench nay kiem tra luon viec doc file hex.
`ifdef NAP_TRONG_TB
    initial begin
        #1;
        dut.Instruction_Mem.Memory[ 0] = 32'hffb00093; // 0x00  addi x1, x0, -5
        dut.Instruction_Mem.Memory[ 1] = 32'h00700113; // 0x04  addi x2, x0, 7
        dut.Instruction_Mem.Memory[ 2] = 32'h123451b7; // 0x08  lui  x3, 0x12345
        dut.Instruction_Mem.Memory[ 3] = 32'h00001217; // 0x0C  auipc x4, 1
        dut.Instruction_Mem.Memory[ 4] = 32'h00209463; // 0x10  bne  x1, x2, +8   (nhay)
        dut.Instruction_Mem.Memory[ 5] = 32'h001f8f93; // 0x14  addi x31, x31, 1  (bi bo qua)
        dut.Instruction_Mem.Memory[ 6] = 32'h0020c463; // 0x18  blt  x1, x2, +8   (nhay: -5 < 7)
        dut.Instruction_Mem.Memory[ 7] = 32'h001f8f93; // 0x1C  addi x31, x31, 1
        dut.Instruction_Mem.Memory[ 8] = 32'h00115463; // 0x20  bge  x2, x1, +8   (nhay: 7 >= -5)
        dut.Instruction_Mem.Memory[ 9] = 32'h001f8f93; // 0x24  addi x31, x31, 1
        dut.Instruction_Mem.Memory[10] = 32'h00116463; // 0x28  bltu x2, x1, +8   (nhay: 7 < 0xFFFFFFFB)
        dut.Instruction_Mem.Memory[11] = 32'h001f8f93; // 0x2C  addi x31, x31, 1
        dut.Instruction_Mem.Memory[12] = 32'h0020f463; // 0x30  bgeu x1, x2, +8   (nhay)
        dut.Instruction_Mem.Memory[13] = 32'h001f8f93; // 0x34  addi x31, x31, 1
        dut.Instruction_Mem.Memory[14] = 32'h00208a63; // 0x38  beq  x1, x2, bad1 (KHONG nhay)
        dut.Instruction_Mem.Memory[15] = 32'h00100293; // 0x3C  addi x5, x0, 1
        dut.Instruction_Mem.Memory[16] = 32'h00109663; // 0x40  bne  x1, x1, bad1 (KHONG nhay)
        dut.Instruction_Mem.Memory[17] = 32'h00100313; // 0x44  addi x6, x0, 1
        dut.Instruction_Mem.Memory[18] = 32'h008003ef; // 0x48  jal  x7, +8       (x7 = 0x4C)
        dut.Instruction_Mem.Memory[19] = 32'h001f8f93; // 0x4C  bad1: addi x31, x31, 1
        dut.Instruction_Mem.Memory[20] = 32'h06000413; // 0x50  addi x8, x0, 0x60
        dut.Instruction_Mem.Memory[21] = 32'h004404e7; // 0x54  jalr x9, 4(x8)    (x9 = 0x58, nhay 0x64)
        dut.Instruction_Mem.Memory[22] = 32'h001f8f93; // 0x58  addi x31, x31, 1
        dut.Instruction_Mem.Memory[23] = 32'h001f8f93; // 0x5C  addi x31, x31, 1
        dut.Instruction_Mem.Memory[24] = 32'h001f8f93; // 0x60  addi x31, x31, 1
        dut.Instruction_Mem.Memory[25] = 32'h04000513; // 0x64  addi x10, x0, 0x40
        dut.Instruction_Mem.Memory[26] = 32'h808185b7; // 0x68  lui  x11, 0x80818
        dut.Instruction_Mem.Memory[27] = 32'h28358593; // 0x6C  addi x11, x11, 0x283  (x11 = 0x80818283)
        dut.Instruction_Mem.Memory[28] = 32'h00b52023; // 0x70  sw   x11, 0(x10)
        dut.Instruction_Mem.Memory[29] = 32'h00050603; // 0x74  lb   x12, 0(x10)
        dut.Instruction_Mem.Memory[30] = 32'h00154683; // 0x78  lbu  x13, 1(x10)
        dut.Instruction_Mem.Memory[31] = 32'h00251703; // 0x7C  lh   x14, 2(x10)
        dut.Instruction_Mem.Memory[32] = 32'h00055783; // 0x80  lhu  x15, 0(x10)
        dut.Instruction_Mem.Memory[33] = 32'h002500a3; // 0x84  sb   x2, 1(x10)
        dut.Instruction_Mem.Memory[34] = 32'h00251123; // 0x88  sh   x2, 2(x10)
        dut.Instruction_Mem.Memory[35] = 32'h00052803; // 0x8C  lw   x16, 0(x10)
        dut.Instruction_Mem.Memory[36] = 32'h0000a893; // 0x90  slti x17, x1, 0
        dut.Instruction_Mem.Memory[37] = 32'h0ff5f913; // 0x94  andi x18, x11, 0xFF
        dut.Instruction_Mem.Memory[38] = 32'h4010d993; // 0x98  srai x19, x1, 1
        dut.Instruction_Mem.Memory[39] = 32'hfff14a13; // 0x9C  xori x20, x2, -1
        dut.Instruction_Mem.Memory[40] = 32'h0000006f; // 0xA0  halt: jal x0, halt
    end
`endif

    // ---------------- In moi lenh duoc thuc thi ----------------
    always @(posedge clk) begin
        if (!reset)
            $display("PC=%h INST=%h | wb_en=%b x%0d <- %h", pc_out, dut.instruction_out_top,
                     wb_en, dut.instruction_out_top[11:7], wb_data);
    end

    task check_reg(input [4:0] idx, input [31:0] expected, input [8*24-1:0] name);
        begin
            if (dut.Register_file.registers[idx] === expected)
                $display("  PASS  %-22s x%-2d = %h", name, idx, dut.Register_file.registers[idx]);
            else begin
                $display("  FAIL  %-22s x%-2d = %h  (mong doi %h)", name, idx,
                         dut.Register_file.registers[idx], expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        reset  = 1'b1;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 1'b0;

        repeat (45) @(posedge clk);   // 34 lenh thuc thi + vai chu ky o vong halt
        #2;

        $display("\n================== KET QUA ===================");
        check_reg(1,  32'hFFFFFFFB, "addi -5");
        check_reg(2,  32'h00000007, "addi 7");
        check_reg(3,  32'h12345000, "lui");
        check_reg(4,  32'h0000100C, "auipc (0x0C+0x1000)");
        check_reg(31, 32'h00000000, "5 nhanh NHAY dung");
        check_reg(5,  32'h00000001, "beq KHONG nhay");
        check_reg(6,  32'h00000001, "bne KHONG nhay");
        check_reg(7,  32'h0000004C, "jal  rd = PC+4");
        check_reg(8,  32'h00000060, "addi");
        check_reg(9,  32'h00000058, "jalr rd = PC+4");
        check_reg(11, 32'h80818283, "lui + addi");
        check_reg(12, 32'hFFFFFF83, "lb  (mo rong dau)");
        check_reg(13, 32'h00000082, "lbu (byte 1)");
        check_reg(14, 32'hFFFF8081, "lh  (half cao)");
        check_reg(15, 32'h00008283, "lhu");
        check_reg(16, 32'h00070783, "sb + sh + lw");
        check_reg(17, 32'h00000001, "slti");
        check_reg(18, 32'h00000083, "andi");
        check_reg(19, 32'hFFFFFFFD, "srai");
        check_reg(20, 32'hFFFFFFF8, "xori -1 (not)");

        if (pc_out === 32'h000000A0)
            $display("  PASS  %-22s PC  = %h", "dung o vong halt", pc_out);
        else begin
            $display("  FAIL  dung o vong halt: PC = %h (mong doi 000000a0)", pc_out);
            errors = errors + 1;
        end

        if (errors == 0) $display("\n>>> TAT CA TEST PASS <<<\n");
        else             $display("\n>>> CO %0d LOI <<<\n", errors);
        $finish;
    end

    initial begin
        #5000;
        $display("TIMEOUT!");
        $finish;
    end

endmodule

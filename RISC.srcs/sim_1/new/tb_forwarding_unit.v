`timescale 1ns / 1ps
module tb_forwarding_unit();
    reg [4:0] ex_rs1, ex_rs2, mem_rd, wb_rd;
    reg       mem_reg_write, wb_reg_write;
    wire [1:0] fwdA, fwdB;

    forwarding_unit dut(
        .ex_rs1(ex_rs1),               .ex_rs2(ex_rs2),
        .mem_rd(mem_rd),               .mem_reg_write(mem_reg_write),
        .wb_rd(wb_rd),                 .wb_reg_write(wb_reg_write),
        .fwdA(fwdA),                   .fwdB(fwdB)
    );

    localparam REG = 2'b00;
    localparam WB  = 2'b01;
    localparam MEM = 2'b10;

    integer error_count = 0;

    task check;
        input [255:0] name;
        input [1:0]   exp_a, exp_b;
        begin
            if (fwdA !== exp_a || fwdB !== exp_b) begin
                $display("FAIL [%0s]: fwdA=%b fwdB=%b mong doi %b %b (rs1=%0d rs2=%0d mem_rd=%0d mw=%b wb_rd=%0d ww=%b)",
                    name, fwdA, fwdB, exp_a, exp_b, ex_rs1, ex_rs2, mem_rd, mem_reg_write, wb_rd, wb_reg_write);
                error_count = error_count + 1;
            end
            else
                $display("PASS [%0s]: fwdA=%b fwdB=%b", name, fwdA, fwdB);
        end
    endtask

    task apply;
        input [4:0] rs1, rs2, mrd;
        input       mw;
        input [4:0] wrd;
        input       ww;
        begin
            ex_rs1 = rs1; ex_rs2 = rs2;
            mem_rd = mrd; mem_reg_write = mw;
            wb_rd  = wrd; wb_reg_write  = ww;
            #1;
        end
    endtask

    function [1:0] model;
        input [4:0] rs, mrd;
        input       mw;
        input [4:0] wrd;
        input       ww;
        reg hit_mem, hit_wb;
        begin
            hit_mem = mw & (|mrd) & (mrd == rs);
            hit_wb  = ww & (|wrd) & (wrd == rs);
            model   = hit_mem ? MEM : {1'b0, hit_wb};
        end
    endfunction

    integer a, b, c, e, k, n;
    reg [4:0] v [0:2];

    initial begin
        $display("=== Testbench forwarding_unit ===");
        apply ( 1,  2,  3,    1, 4,    1);  check("khong phu thuoc",   REG, REG);
        apply ( 5,  3,  5,    1, 0,    0);  check("EX/MEM -> rs1",     MEM, REG);
        apply ( 3,  5,  5,    1, 0,    0);  check("EX/MEM -> rs2",     REG, MEM);
        apply ( 5,  5,  5,    1, 0,    0);  check("EX/MEM -> ca 2",    MEM, MEM);
        apply ( 5,  3,  0,    0, 5,    1);  check("MEM/WB -> rs1",     WB,  REG);
        apply ( 3,  5,  0,    0, 5,    1);  check("MEM/WB -> rs2",     REG, WB);
        apply ( 5,  3,  5,    1, 5,    1);  check("uu tien EX/MEM",    MEM, REG);
        apply ( 5,  6,  6,    1, 5,    1);  check("A tu WB, B tu MEM", WB,  MEM);
        apply ( 0,  3,  0,    1, 0,    0);  check("mem_rd = x0",       REG, REG);
        apply ( 0,  3,  0,    0, 0,    1);  check("wb_rd = x0",        REG, REG);
        apply ( 5,  3,  5,    0, 0,    0);  check("MEM khong ghi",     REG, REG);
        apply ( 5,  3,  0,    0, 5,    0);  check("WB khong ghi",      REG, REG);
        apply ( 5,  3,  5,    0, 5,    1);  check("MEM khong ghi->WB", WB,  REG);
        apply ( 6,  7,  6,    0, 6,    1);  check("load o WB",         WB,  REG);

        v[0] = 0; v[1] = 5; v[2] = 6;
        n = 0;
        for (a = 0; a < 3; a = a + 1)
          for (b = 0; b < 3; b = b + 1)
            for (c = 0; c < 3; c = c + 1)
              for (e = 0; e < 3; e = e + 1)
                for (k = 0; k < 4; k = k + 1) begin
                    apply(v[a], v[b], v[c], k[1], v[e], k[0]);
                    if (fwdA !== model(v[a], v[c], k[1], v[e], k[0]) ||
                        fwdB !== model(v[b], v[c], k[1], v[e], k[0])) begin
                        if (n < 5)
                            $display("FAIL [vet can]: rs1=%0d rs2=%0d mem_rd=%0d mw=%b wb_rd=%0d ww=%b -> %b %b, mong doi %b %b",
                                v[a], v[b], v[c], k[1], v[e], k[0], fwdA, fwdB,
                                model(v[a], v[c], k[1], v[e], k[0]), model(v[b], v[c], k[1], v[e], k[0]));
                        n = n + 1;
                    end
                end
        if (n == 0) $display("PASS [vet can]: 324/324 to hop khop mo hinh");
        else begin
            $display("FAIL [vet can]: %0d/324 to hop sai", n);
            error_count = error_count + 1;
        end

        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;
    end
endmodule

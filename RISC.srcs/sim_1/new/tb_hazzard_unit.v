`timescale 1ns / 1ps
module tb_hazzard_unit();
    reg [4:0] id_rs1, id_rs2, ex_rd;
    reg       ex_mem_read, ex_branch_take, ex_jal, ex_jalr;
    wire pc_stall, if_id_stall, if_id_flush, id_ex_flush;

    hazzard_unit dut(
        .id_rs1(id_rs1),               .id_rs2(id_rs2),
        .ex_rd(ex_rd),                 .ex_mem_read(ex_mem_read),
        .ex_branch_take(ex_branch_take),
        .ex_jal(ex_jal),               .ex_jalr(ex_jalr),
        .pc_stall(pc_stall),           .if_id_stall(if_id_stall),
        .if_id_flush(if_id_flush),     .id_ex_flush(id_ex_flush)
    );

    wire [3:0] out = {pc_stall, if_id_stall, if_id_flush, id_ex_flush};
    localparam NONE  = 4'b0000;
    localparam STALL = 4'b1101;
    localparam FLUSH = 4'b0011;

    integer error_count = 0;

    task check;
        input [127:0] name;
        input [3:0]   expected;
        begin
            if (out !== expected) begin
                $display("FAIL [%0s]: out=%b mong doi=%b (rs1=%0d rs2=%0d rd=%0d mr=%b take=%b jal=%b jalr=%b)",
                    name, out, expected, id_rs1, id_rs2, ex_rd,
                    ex_mem_read, ex_branch_take, ex_jal, ex_jalr);
                error_count = error_count + 1;
            end
            else
                $display("PASS [%0s]: out=%b", name, out);
        end
    endtask

    task apply;
        input [4:0] rs1, rs2, rd;
        input       mr, take, jal, jalr;
        begin
            id_rs1 = rs1; id_rs2 = rs2; ex_rd = rd;
            ex_mem_read = mr; ex_branch_take = take; ex_jal = jal; ex_jalr = jalr;
            #1;
        end
    endtask

    function [3:0] model;
        input [4:0] rs1, rs2, rd;
        input       mr, take, jal, jalr;
        begin
            if (take || jal || jalr)                                  model = FLUSH;
            else if (mr && rd != 0 && (rd == rs1 || rd == rs2))       model = STALL;
            else                                                      model = NONE;
        end
    endfunction

    integer a, b, c, k, n;
    reg [4:0] v [0:2];

    initial begin
        $display("=== Testbench hazzard_unit ===");
        apply ( 0,  0,  0, 0, 0,   0,  0);   check("khong xung dot", NONE);
        apply ( 6,  7,  6, 1, 0,   0,  0);   check("load-use rs1",   STALL);
        apply ( 7,  6,  6, 1, 0,   0,  0);   check("load-use rs2",   STALL);
        apply ( 6,  6,  6, 1, 0,   0,  0);   check("load-use ca 2",  STALL);
        apply ( 7,  8,  6, 1, 0,   0,  0);   check("load, rd khac",  NONE);
        apply ( 0,  7,  0, 1, 0,   0,  0);   check("load rd = x0",   NONE);
        apply ( 6,  7,  6, 0, 0,   0,  0);   check("khong phai load",NONE);
        apply ( 1,  2,  3, 0, 1,   0,  0);   check("nhanh nhay",     FLUSH);
        apply ( 1,  2,  3, 0, 0,   0,  0);   check("nhanh khong nhay",NONE);
        apply ( 1,  2,  1, 0, 0,   1,  0);   check("jal",            FLUSH);
        apply ( 1,  2,  1, 0, 0,   0,  1);   check("jalr",           FLUSH);
        apply ( 6,  7,  6, 1, 1,   0,  0);   check("load-use + nhay",FLUSH);

        v[0] = 0; v[1] = 5; v[2] = 6;
        n = 0;
        for (a = 0; a < 3; a = a + 1)
          for (b = 0; b < 3; b = b + 1)
            for (c = 0; c < 3; c = c + 1)
              for (k = 0; k < 16; k = k + 1) begin
                  apply(v[a], v[b], v[c], k[3], k[2], k[1], k[0]);
                  if (out !== model(v[a], v[b], v[c], k[3], k[2], k[1], k[0])) begin
                      if (n < 5)
                          $display("FAIL [vet can]: rs1=%0d rs2=%0d rd=%0d mr=%b take=%b jal=%b jalr=%b out=%b mong doi=%b",
                              v[a], v[b], v[c], k[3], k[2], k[1], k[0], out,
                              model(v[a], v[b], v[c], k[3], k[2], k[1], k[0]));
                      n = n + 1;
                  end
              end
        if (n == 0) $display("PASS [vet can]: 432/432 to hop khop mo hinh");
        else begin
            $display("FAIL [vet can]: %0d/432 to hop sai", n);
            error_count = error_count + 1;
        end

        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;
    end
endmodule

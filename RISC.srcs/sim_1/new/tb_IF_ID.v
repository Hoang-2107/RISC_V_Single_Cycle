`timescale 1ns / 1ps
// =====================================================================
// Testbench: tb_IF_ID
// Kiem tra thanh ghi pipeline IF/ID:
//   1. rst            -> xoa thanh nop, PC = 0
//   2. Binh thuong    -> chot PC, PC+4, inst o canh len clock
//   3. Chua toi canh  -> dau ra KHONG doi khi dau vao doi
//   4. stall = 1      -> giu nguyen gia tri cu (nhieu chu ky)
//   5. flush = 1      -> xoa thanh nop
//   6. Uu tien        -> flush > stall, rst > stall
// Cach lam: doi dau vao o canh xuong, kiem tra sau canh len 1ns
// =====================================================================

module tb_IF_ID();
    reg clk, rst, stall, flush;
    reg [31:0] if_pc, if_pc4, if_inst;
    wire [31:0] id_pc, id_pc4, id_inst;
    localparam NOP = 32'h00000013;   // addi x0, x0, 0
    IF_ID dut(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .flush(flush),
        .if_pc(if_pc),
        .if_pc4(if_pc4),
        .if_inst(if_inst),
        .id_pc(id_pc),
        .id_pc4(id_pc4),
        .id_inst(id_inst)
    );

    //clock chu ky 10ns
    integer error_count = 0;
    initial clk = 0;
    always #5 clk = ~clk;

    // --- so sanh  dau ra voi gia tri mong doi
    task check;
        input [127:0] name;
        input [31:0] exp_pc, exp_pc4, exp_inst;
        begin
            if (id_pc !== exp_pc || id_pc4 !== exp_pc4 || id_inst !== exp_inst) begin
                $display("FAIL [%0s] t=%0t: id_pc=%h, id_pc4=%h, id_inst=%h (exp: %h, %h, %h)",
                    name, $time, id_pc, id_pc4, id_inst, exp_pc, exp_pc4, exp_inst);
                error_count = error_count + 1;
            end
            else begin
                $display("PASS [%0s] t=%0t: id_pc=%h, id_pc4=%h, id_inst=%h",
                    name, $time, id_pc, id_pc4, id_inst);
            end
        
        
        end
    endtask
    // -- dat dau vao o canh xuong, cho qua canh len roi kiem tra dau ra
    task step;
        input  r, s, f;
        input [31:0] pc, inst;
        begin
            @(negedge clk);
            rst = r; stall = s; flush = f;
            if_pc = pc; if_pc4 = pc + 4; if_inst = inst;
            @(posedge clk); #1;
        end
    endtask

    initial begin
        error_count = 0;
        rst = 0; stall = 0; flush = 0;
        if_pc = 0; if_pc4 = 0; if_inst = 0;
        $display("=== Testbench IF_ID ===");
        //1 reset bang 1
        // dung PC khac 0 de chac chan reset da xoa (khong phai chot if_pc = 0)
        step (1, 0, 0, 32'h0000_0040, 32'hDEAD_BEEF);
        check("reset", 32'h0, 32'h0, NOP);
        //2 reset bang 0, binh thuong
        step (0, 0, 0, 32'h0000_0000, 32'h12345678);
        check("load inst0", 32'h0, 32'h4, 32'h12345678);
        step (0, 0, 0, 32'h0000_0004, 32'h0030_0113);   // addi x2, x0, 3
        check("load inst1", 32'h4, 32'h8, 32'h0030_0113);

        //3 doi dau vao giua chu ky -> dau ra chua doi (la thanh ghi)
        @(negedge clk);
        if_pc = 32'h0000_0008; if_pc4 = 32'h0000_000C; if_inst = 32'h0020_81B3;
        #2;
        check("no edge yet", 32'h4, 32'h8, 32'h0030_0113);
        @(posedge clk); #1;
        check("load inst2", 32'h8, 32'hC, 32'h0020_81B3);

        //4 stall 3 chu ky: dau vao doi nhung dau ra giu nguyen
        step (0, 1, 0, 32'h0000_000C, 32'h1111_1111);
        check("stall 1", 32'h8, 32'hC, 32'h0020_81B3);
        step (0, 1, 0, 32'h0000_0010, 32'h2222_2222);
        check("stall 2", 32'h8, 32'hC, 32'h0020_81B3);
        step (0, 1, 0, 32'h0000_0014, 32'h3333_3333);
        check("stall 3", 32'h8, 32'hC, 32'h0020_81B3);
        // het stall -> nhan lenh moi
        step (0, 0, 0, 32'h0000_000C, 32'h4020_8233);
        check("after stall", 32'hC, 32'h10, 32'h4020_8233);

        //5 flush -> nop
        step (0, 0, 1, 32'h0000_0010, 32'h5555_5555);
        check("flush", 32'h0, 32'h0, NOP);
        // het flush -> nhan lenh moi
        step (0, 0, 0, 32'h0000_0020, 32'h0000_0463);
        check("after flush", 32'h20, 32'h24, 32'h0000_0463);

        //6 uu tien: flush > stall, rst > stall
        step (0, 1, 1, 32'h0000_0024, 32'h6666_6666);
        check("flush>stall", 32'h0, 32'h0, NOP);
        step (0, 0, 0, 32'h0000_0028, 32'h0010_0093);
        check("reload", 32'h28, 32'h2C, 32'h0010_0093);
        step (1, 1, 0, 32'h0000_002C, 32'h7777_7777);
        check("rst>stall", 32'h0, 32'h0, NOP);

        // tong ket
        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;
    end
endmodule
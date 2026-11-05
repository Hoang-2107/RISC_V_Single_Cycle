`timescale 1ns / 1ps
// =====================================================================
// Testbench: tb_ID_EX
// Kiem tra thanh ghi pipeline ID/EX:
//   1. rst            -> xoa het ve 0
//   2. Binh thuong    -> chot dieu khien + du lieu o canh len clock
//                        (dung lenh that: add, lw, sw, beq, addi, lui)
//   3. Chua toi canh  -> dau ra KHONG doi khi dau vao doi
//   4. flush = 1      -> bubble: tat ca ve 0 (ca khi flush nhieu chu ky)
//   5. Load-use       -> lw, bubble, roi lenh phu thuoc vao lai
//   6. Uu tien        -> rst + flush cung luc, rst thang du lieu moi
// Cach lam: doi dau vao o canh xuong, kiem tra sau canh len 1ns
// =====================================================================

module tb_ID_EX();
    reg clk, rst, flush;

    // ---------- 12 tin hieu dieu khien gom vao 1 bus cho gon ----------
    // thu tu: {alu_src, alu_op[1:0], alu_a_sel[1:0],
    //          branch, jal, jalr, mem_read, mem_write, reg_write, mem_to_reg}
    reg  [11:0] in_ctrl;
    wire [11:0] out_ctrl;

    // ---------- Du lieu dau vao ----------
    reg [31:0] id_pc, id_pc4, id_rs1_data, id_rs2_data, id_imm;
    reg  [4:0] id_rs1, id_rs2, id_rd;
    reg  [2:0] id_funct3;
    reg  [6:0] id_funct7;

    // ---------- Dau ra ----------
    wire       ex_alu_src, ex_branch, ex_jal, ex_jalr;
    wire       ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg;
    wire [1:0] ex_alu_op, ex_alu_a_sel;
    wire [31:0] ex_pc, ex_pc4, ex_rs1_data, ex_rs2_data, ex_imm;
    wire  [4:0] ex_rs1, ex_rs2, ex_rd;
    wire  [2:0] ex_funct3;
    wire  [6:0] ex_funct7;

    // Gia tri dieu khien that do Control_unit sinh ra cho tung loai lenh
    //                        src op  asel b j jr mr mw rw m2r
    localparam CTRL_R     = 12'b0_10_00_0_0_0_0_0_1_0;   // add, sub...
    localparam CTRL_ADDI  = 12'b1_11_00_0_0_0_0_0_1_0;   // addi...
    localparam CTRL_LW    = 12'b1_00_00_0_0_0_1_0_1_1;   // lw
    localparam CTRL_SW    = 12'b1_00_00_0_0_0_0_1_0_0;   // sw
    localparam CTRL_BEQ   = 12'b0_01_00_1_0_0_0_0_0_0;   // beq...
    localparam CTRL_JAL   = 12'b0_00_00_0_1_0_0_0_1_0;   // jal
    localparam CTRL_LUI   = 12'b1_00_10_0_0_0_0_0_1_0;   // lui

    ID_EX dut(
        .clk(clk),
        .rst(rst),
        .flush(flush),
        // dieu khien: tach bus in_ctrl ra tung chan
        .id_alu_src   (in_ctrl[11]),
        .id_alu_op    (in_ctrl[10:9]),
        .id_alu_a_sel (in_ctrl[8:7]),
        .id_branch    (in_ctrl[6]),
        .id_jal       (in_ctrl[5]),
        .id_jalr      (in_ctrl[4]),
        .id_mem_read  (in_ctrl[3]),
        .id_mem_write (in_ctrl[2]),
        .id_reg_write (in_ctrl[1]),
        .id_mem_to_reg(in_ctrl[0]),
        // du lieu
        .id_pc(id_pc),
        .id_pc4(id_pc4),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_imm(id_imm),
        .id_rs1(id_rs1),
        .id_rs2(id_rs2),
        .id_rd(id_rd),
        .id_funct3(id_funct3),
        .id_funct7(id_funct7),
        // dau ra
        .ex_alu_src(ex_alu_src),
        .ex_alu_op(ex_alu_op),
        .ex_alu_a_sel(ex_alu_a_sel),
        .ex_branch(ex_branch),
        .ex_jal(ex_jal),
        .ex_jalr(ex_jalr),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_reg_write(ex_reg_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_pc(ex_pc),
        .ex_pc4(ex_pc4),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_imm(ex_imm),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rd(ex_rd),
        .ex_funct3(ex_funct3),
        .ex_funct7(ex_funct7)
    );

    // gom dau ra dieu khien lai thanh bus cung thu tu voi in_ctrl
    assign out_ctrl = {ex_alu_src, ex_alu_op, ex_alu_a_sel,
                       ex_branch, ex_jal, ex_jalr,
                       ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg};

    // gom TAT CA dau vao / dau ra thanh 1 vector 197 bit de so sanh 1 lan
    //   12 (ctrl) + 5 x 32 (pc, pc4, rs1_data, rs2_data, imm) + 3 x 5 + 3 + 7
    wire [196:0] in_all  = {in_ctrl, id_pc, id_pc4, id_rs1_data, id_rs2_data,
                            id_imm, id_rs1, id_rs2, id_rd, id_funct3, id_funct7};
    wire [196:0] out_all = {out_ctrl, ex_pc, ex_pc4, ex_rs1_data, ex_rs2_data,
                            ex_imm, ex_rs1, ex_rs2, ex_rd, ex_funct3, ex_funct7};

    //clock chu ky 10ns
    integer error_count = 0;
    initial clk = 0;
    always #5 clk = ~clk;

    reg [196:0] latched;   // gia tri dau vao tai canh len vua roi (dap an dung)
    reg [196:0] out_old;    // dau ra truoc khi doi dau vao (cho test 3)

    // --- in dau ra de doc tren console
    task show;
        input [127:0] tag;
        input [127:0] name;
        begin
            $display("%0s [%0s] t=%0t: ctrl=%b pc=%h rs1d=%h rs2d=%h imm=%h rs1=%0d rs2=%0d rd=%0d f3=%b f7=%b",
                tag, name, $time, out_ctrl, ex_pc, ex_rs1_data, ex_rs2_data, ex_imm,
                ex_rs1, ex_rs2, ex_rd, ex_funct3, ex_funct7);
        end
    endtask

    // --- so sanh dau ra voi gia tri mong doi
    task check;
        input [127:0] name;
        input [196:0] expected;
        begin
            if (out_all !== expected) begin
                show("FAIL", name);
                error_count = error_count + 1;
            end
            else show("PASS", name);
        end
    endtask

    // -- dat dau vao o canh xuong, cho qua canh len roi kiem tra dau ra
    task step;
        input r, f;
        input [11:0] ctrl;
        input [31:0] pc, rs1_data, rs2_data, imm;
        input  [4:0] rs1, rs2, rd;
        input  [2:0] funct3;
        input  [6:0] funct7;
        begin
            @(negedge clk);
            rst = r; flush = f;
            in_ctrl = ctrl;
            id_pc = pc; id_pc4 = pc + 4;
            id_rs1_data = rs1_data; id_rs2_data = rs2_data; id_imm = imm;
            id_rs1 = rs1; id_rs2 = rs2; id_rd = rd;
            id_funct3 = funct3; id_funct7 = funct7;
            latched = in_all;            // dau ra dung = dau vao vua gan
            @(posedge clk); #1;
        end
    endtask

    initial begin
        error_count = 0;
        rst = 0; flush = 0;
        in_ctrl = 0;
        id_pc = 0; id_pc4 = 0; id_rs1_data = 0; id_rs2_data = 0; id_imm = 0;
        id_rs1 = 0; id_rs2 = 0; id_rd = 0; id_funct3 = 0; id_funct7 = 0;
        $dumpfile("tb_ID_EX.vcd");
        $dumpvars(0, tb_ID_EX);
        $display("=== Testbench ID_EX ===");

        //1 reset bang 1
        // dau vao khac 0 de chac chan reset da xoa (khong phai chot so 0)
        //    r  f  ctrl     pc            rs1_data      rs2_data      imm       rs1 rs2 rd  f3      f7
        step (1, 0, CTRL_R,  32'h0000_0040, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'd0,    6,  7,  5,  3'b000, 7'b0000000);
        check("reset", 197'd0);

        //2 binh thuong: chot lenh moi o moi canh len
        // add x5, x6, x7
        step (0, 0, CTRL_R,  32'h0000_0000, 32'h1111_1111, 32'h2222_2222, 32'd0,    6,  7,  5,  3'b000, 7'b0000000);
        check("add x5,x6,x7", latched);
        // lw x8, 12(x2)
        step (0, 0, CTRL_LW, 32'h0000_0004, 32'h0000_1000, 32'h0000_0000, 32'd12,   2, 12,  8,  3'b010, 7'b0000000);
        check("lw x8,12(x2)", latched);

        //3 doi dau vao giua chu ky -> dau ra chua doi (la thanh ghi)
        out_old = out_all;
        @(negedge clk);
        // sw x8, 8(x2)
        in_ctrl = CTRL_SW; id_pc = 32'h0000_0008; id_pc4 = 32'h0000_000C;
        id_rs1_data = 32'h0000_1000; id_rs2_data = 32'h1234_5678; id_imm = 32'd8;
        id_rs1 = 2; id_rs2 = 8; id_rd = 8; id_funct3 = 3'b010; id_funct7 = 7'b0000000;
        latched = in_all;
        #2;
        check("no edge yet", out_old);
        @(posedge clk); #1;
        check("sw x8,8(x2)", latched);

        // beq x5, x8, +16
        step (0, 0, CTRL_BEQ, 32'h0000_000C, 32'h0000_0005, 32'h0000_0005, 32'd16,  5,  8, 16,  3'b000, 7'b0000000);
        check("beq x5,x8,16", latched);

        //4 flush -> bubble (tat ca ve 0), dau vao la jal van bi xoa
        step (0, 1, CTRL_JAL, 32'h0000_0010, 32'h0,        32'h0,         32'd64,  0,  0,  1,  3'b000, 7'b0000000);
        check("flush 1", 197'd0);
        // flush 2 chu ky lien tiep
        step (0, 1, CTRL_ADDI,32'h0000_0014, 32'h0000_0007, 32'h0,        32'd1,   1,  1,  1,  3'b000, 7'b0000000);
        check("flush 2", 197'd0);
        // het flush -> nhan lenh moi: addi x1, x1, 1
        step (0, 0, CTRL_ADDI,32'h0000_0050, 32'h0000_0007, 32'h0,        32'd1,   1,  1,  1,  3'b000, 7'b0000000);
        check("addi x1,x1,1", latched);

        //5 load-use: lw x9,0(x3) -> bubble -> add x10,x9,x1 vao lai
        step (0, 0, CTRL_LW, 32'h0000_0054, 32'h0000_1004, 32'h0,         32'd0,   3,  0,  9,  3'b010, 7'b0000000);
        check("lw x9,0(x3)", latched);
        // Hazard_Unit phat hien load-use: IF_ID giu add, ID_EX bi flush
        step (0, 1, CTRL_R,  32'h0000_0058, 32'h0,         32'h0000_0001, 32'd0,   9,  1, 10,  3'b000, 7'b0000000);
        check("bubble", 197'd0);
        // chu ky sau: add (van dang o ID) moi vao EX
        step (0, 0, CTRL_R,  32'h0000_0058, 32'hCAFE_0000, 32'h0000_0001, 32'd0,   9,  1, 10,  3'b000, 7'b0000000);
        check("add x10,x9,x1", latched);

        //6 uu tien: rst + flush cung luc -> 0; rst thang du lieu moi
        step (1, 1, CTRL_SW, 32'h0000_005C, 32'h1,         32'h2,         32'd4,   4,  5,  4,  3'b010, 7'b0000000);
        check("rst+flush", 197'd0);
        // lui x11, 0x12345 de co du lieu khac 0 truoc khi reset
        step (0, 0, CTRL_LUI,32'h0000_0060, 32'h0,         32'h0,         32'h1234_5000, 0, 5, 11, 3'b101, 7'b0001001);
        check("lui x11", latched);
        step (1, 0, CTRL_R,  32'h0000_0064, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 32'd0,  31, 31, 31,  3'b111, 7'b0100000);
        check("rst > normal", 197'd0);

        // tong ket
        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;
    end
endmodule

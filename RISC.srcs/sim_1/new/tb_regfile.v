// =====================================================================
// Testbench: tb_regfile
// Kiem chung rieng module regfile:
//   - Reset dua tat ca thanh ghi ve 0
//   - Ghi dong bo (chi ghi khi reg_write=1, canh len clock)
//   - Doc bat dong bo (doc ngay lap tuc, khong can clock)
//   - Thanh ghi x0 luon = 0, khong the ghi de
//   - Doc va ghi cung dia chi trong 1 chu ky (write-then-read / hazard)
//
// LUU Y VE RACE CONDITION:
// Sau moi @(posedge clk), phai cho #1 (mot khoang tre nho) TRUOC KHI
// doi cac tin hieu dieu khien (vd reg_write=0). Neu doi ngay lap tuc,
// tien trinh testbench va tien trinh always trong DUT cung duoc kich
// hoat tai CUNG mot thoi diem mo phong, thu tu thuc thi giua chung
// khong duoc dam bao (NBA/race) -> DUT co the "thay" gia tri MOI
// (0) thay vi gia tri CU (1) ngay tai canh clock do, dan den ghi sai.
// =====================================================================
`timescale 1ns/1ps

module tb_regfile;

    reg         clk;
    reg         rst_n;
    reg  [4:0]  read_reg1, read_reg2, write_reg;
    reg  [31:0] write_data;
    reg         reg_write;

    wire [31:0] read_data1, read_data2;

    integer error_count;

    // ---- Instance module can test ----
    Register_file dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .read_reg1  (read_reg1),
        .read_reg2  (read_reg2),
        .write_reg  (write_reg),
        .write_data (write_data),
        .reg_write  (reg_write),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

    // ---- Sinh xung clock 10ns ----
    initial clk = 0;
    always #5 clk = ~clk;

    // ---- Task kiem tra read_data1/read_data2 ----
    task check;
        input [127:0] name;
        input [31:0]  exp_data1;
        input [31:0]  exp_data2;
        begin
            #1;
            if (read_data1 !== exp_data1 || read_data2 !== exp_data2) begin
                $display("FAIL [%0s] read_data1=%0d (expect %0d), read_data2=%0d (expect %0d)",
                          name, read_data1, exp_data1, read_data2, exp_data2);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] read_data1=%0d, read_data2=%0d",
                          name, read_data1, read_data2);
            end
        end
    endtask

    // ---- Task thuc hien 1 lan ghi thanh ghi an toan (khong race) ----
    task do_write;
        input [4:0]  reg_addr;
        input [31:0] data;
        begin
            write_reg  = reg_addr;
            write_data = data;
            reg_write  = 1;
            @(posedge clk);
            #1;               // cho DUT chot gia tri xong roi moi doi tin hieu
            reg_write  = 0;
        end
    endtask

    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong Register File ===");

        // ---- Khoi tao / reset ----
        rst_n      = 0;
        reg_write  = 0;
        write_reg  = 5'd0;
        write_data = 32'd0;
        read_reg1  = 5'd1;
        read_reg2  = 5'd2;
        #12;
        rst_n = 1;

        // ---- Test 1: sau reset, moi thanh ghi phai = 0 ----
        check("SAU RESET", 32'd0, 32'd0);

        // ---- Test 2: ghi x1 = 100 ----
        do_write(5'd1, 32'd100);
        check("GHI x1=100", 32'd100, 32'd0);

        // ---- Test 3: ghi x2 = 250 ----
        do_write(5'd2, 32'd250);
        check("GHI x2=250", 32'd100, 32'd250);

        // ---- Test 4: reg_write=0 thi khong duoc ghi, du co du lieu moi ----
        write_reg  = 5'd1;
        write_data = 32'd999;
        reg_write  = 0;              // KHONG bat reg_write
        @(posedge clk);
        #1;
        check("KHONG GHI (reg_write=0)", 32'd100, 32'd250); // x1 van la 100

        // ---- Test 5: khong the ghi vao x0 (luon phai =0) ----
        do_write(5'd0, 32'd777);
        read_reg1 = 5'd0;
        read_reg2 = 5'd1;
        check("x0 LUON = 0", 32'd0, 32'd100);

        // ---- Test 6: doc 2 thanh ghi khac nhau cung luc ----
        read_reg1 = 5'd1;  // x1 = 100
        read_reg2 = 5'd2;  // x2 = 250
        check("DOC DONG THOI x1,x2", 32'd100, 32'd250);

        // ---- Test 7: ghi va doc cung dia chi trong cung 1 canh clock ----
        // Gia tri doc duoc phai la gia tri CU (vi doc la async truoc khi
        // gia tri moi duoc chot vao thanh ghi o canh len ke tiep)
        write_reg  = 5'd1;
        write_data = 32'd555;
        reg_write  = 1;
        read_reg1  = 5'd1;
        check("DOC TRUOC KHI GHI (gia tri cu)", 32'd100, 32'd250);
        @(posedge clk);
        #1;
        reg_write  = 0;
        check("SAU KHI GHI (gia tri moi)", 32'd555, 32'd250);

        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);

        $finish;
    end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Kiem chung rieng module data_mem:
//   - Reset dua toan bo bo nho ve 0
//   - Ghi dong bo khi mem_write=1 (canh len clock)
//   - Doc bat dong bo khi mem_read=1
//   - Khi mem_read=0, read_data phai = 0 (khong doc)
//   - Khi mem_write=0, du co du lieu/dia chi moi cung khong duoc ghi
//   - Ghi/doc dung dia chi word (address chia 4)
//
// LUU Y VE RACE CONDITION:
// Sau moi @(posedge clk), phai cho #1 TRUOC KHI doi mem_write ve 0.
// Neu doi ngay lap tuc, tien trinh testbench va tien trinh always
// trong DUT cung kich hoat cung thoi diem mo phong -> thu tu khong
// dam bao -> DUT co the thay mem_write=0 ngay tai canh clock do va
// KHONG ghi du lieu, du testbench "tuong" da ghi thanh cong.
//////////////////////////////////////////////////////////////////////////////////


module tb_Data_memory(

    );
     reg         clk;
    reg         rst_n;
    reg  [31:0] address;
    reg  [31:0] write_data;
    reg         mem_read;
    reg         mem_write;
 
    wire [31:0] read_data;
 
    integer error_count;
 
    // ---- Instance module can test (dung mac dinh ADDR_WIDTH=10) ----
    Data_memory dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .address    (address),
        .write_data (write_data),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .read_data  (read_data)
    );
 
    // ---- Sinh xung clock 10ns ----
    initial clk = 0;
    always #5 clk = ~clk;
 
    // ---- Task kiem tra read_data ----
    task check;
        input [127:0] name;
        input [31:0]  expected;
        begin
            #1;
            if (read_data !== expected) begin
                $display("FAIL [%0s] address=%0d -> read_data=%0d (expect %0d)",
                          name, address, read_data, expected);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] address=%0d -> read_data=%0d",
                          name, address, read_data);
            end
        end
    endtask
 
    // ---- Task thuc hien 1 lan ghi bo nho an toan (khong race) ----
    task do_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            mem_read   = 0;
            mem_write  = 1;
            address    = addr;
            write_data = data;
            @(posedge clk);
            #1;               // cho DUT chot gia tri xong roi moi doi tin hieu
            mem_write  = 0;
        end
    endtask
 
    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong Data Memory ===");
 
        // ---- Khoi tao / reset ----
        rst_n      = 0;
        mem_read   = 0;
        mem_write  = 0;
        address    = 32'd0;
        write_data = 32'd0;
        #12;
        rst_n = 1;
 
        // ---- Test 1: sau reset, doc dia chi 0 phai = 0 ----
        mem_read = 1;
        address  = 32'd0;
        check("SAU RESET (addr=0)", 32'd0);
 
        // ---- Test 2+3: ghi 123 vao addr=0 (sw), doc lai (lw) ----
        do_write(32'd0, 32'd123);
        mem_read = 1;
        address  = 32'd0;
        check("DOC LAI addr=0", 32'd123);
 
        // ---- Test 4: ghi 456 vao dia chi 8 (word thu 2) ----
        do_write(32'd8, 32'd456);
        mem_read = 1;
        address  = 32'd8;
        check("DOC addr=8", 32'd456);
 
        // ---- Test 5: dia chi 0 khong bi anh huong boi ghi o dia chi 8 ----
        address = 32'd0;
        check("addr=0 KHONG DOI", 32'd123);
 
        // ---- Test 6: mem_read=0 thi read_data phai = 0 du bo nho co du lieu ----
        mem_read = 0;
        address  = 32'd0; // bo nho van co 123 nhung khong duoc doc ra
        check("mem_read=0 -> read_data=0", 32'd0);
 
        // ---- Test 7: mem_write=0 thi du co du lieu/dia chi moi cung khong ghi ----
        mem_write  = 0;
        address    = 32'd0;
        write_data = 32'd999;    // KHONG duoc ghi vi mem_write=0
        @(posedge clk);
        #1;
        mem_read = 1;
        address  = 32'd0;
        check("KHONG GHI (mem_write=0)", 32'd123); // van la 123, khong phai 999
 
        // ---- Test 8: ghi de gia tri cu bang gia tri moi tai cung dia chi ----
        do_write(32'd0, 32'd789);
        mem_read = 1;
        address  = 32'd0;
        check("GHI DE addr=0 = 789", 32'd789);
 
        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);
 
        $finish;
    end
endmodule

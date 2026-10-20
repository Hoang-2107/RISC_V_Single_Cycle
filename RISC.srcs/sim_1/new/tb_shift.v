`timescale 1ns / 1ps
// Kiem chung rieng module shift_left voi 2 cau hinh:
//   - SHIFT_AMOUNT = 1 (dung cho RISC-V: nhan 2)
//   - SHIFT_AMOUNT = 2 (dung cho MIPS: nhan 4)
// Kiem tra ca gia tri duong, gia tri co bit cao bi day ra ngoai (tran),
// va gia tri 0.
//////////////////////////////////////////////////////////////////////////////////


module tb_shift(

    );
   
 
    integer error_count;
 
    // =================== Nhom test: SHIFT_AMOUNT = 1 (RISC-V) ===================
    reg  [31:0] data_in_1;
    wire [31:0] data_out_1;
 
    Shift_barek #(.WIDTH(32), .SHIFT_AMOUNT(1)) dut_shift1 (
        .Shift_in  (data_in_1),
        .Shift_out (data_out_1)
    );
 
    task check_shift1;
        input [127:0] name;
        input [31:0]  expected;
        begin
            #1;
            if (data_out_1 !== expected) begin
                $display("FAIL [%0s] data_in=%0d -> data_out=%0d (expect %0d)",
                          name, data_in_1, data_out_1, expected);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] data_in=%0d -> data_out=%0d",
                          name, data_in_1, data_out_1);
            end
        end
    endtask
 
    // =================== Nhom test: SHIFT_AMOUNT = 2 (MIPS) ===================
    reg  [31:0] data_in_2;
    wire [31:0] data_out_2;
 
    Shift_barek #(.WIDTH(32), .SHIFT_AMOUNT(2)) dut_shift2 (
        .Shift_in  (data_in_2),
        .Shift_out (data_out_2)
    );
 
    task check_shift2;
        input [127:0] name;
        input [31:0]  expected;
        begin
            #1;
            if (data_out_2 !== expected) begin
                $display("FAIL [%0s] data_in=%0d -> data_out=%0d (expect %0d)",
                          name, data_in_2, data_out_2, expected);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] data_in=%0d -> data_out=%0d",
                          name, data_in_2, data_out_2);
            end
        end
    endtask
 
    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong Shift Left ===");
 
        // ---- Nhom SHIFT_AMOUNT = 1 (RISC-V: nhan 2) ----
        data_in_1 = 32'd0;
        check_shift1("SA=1, data=0", 32'd0);
 
        data_in_1 = 32'd1;
        check_shift1("SA=1, data=1", 32'd2);
 
        data_in_1 = 32'd20;
        check_shift1("SA=1, data=20", 32'd40);
 
        data_in_1 = 32'h7FFFFFFF; // bit cao nhat = 0, sau dich van vua du 32-bit
        check_shift1("SA=1, tran mot phan", (32'h7FFFFFFF << 1)); // = 0xFFFFFFFE
 
        // ---- Nhom SHIFT_AMOUNT = 2 (MIPS: nhan 4) ----
        data_in_2 = 32'd0;
        check_shift2("SA=2, data=0", 32'd0);
 
        data_in_2 = 32'd1;
        check_shift2("SA=2, data=1", 32'd4);
 
        data_in_2 = 32'd10;
        check_shift2("SA=2, data=10", 32'd40);
 
        data_in_2 = 32'd100;
        check_shift2("SA=2, data=100", 32'd400);
 
        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);
 
        $finish;
    end
endmodule

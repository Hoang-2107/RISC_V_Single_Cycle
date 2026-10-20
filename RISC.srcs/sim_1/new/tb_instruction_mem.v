`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Kiem chung rieng module instruction_mem:
//   - Doc dung lenh tai cac dia chi khac nhau (dia chi la boi cua 4)
//   - Doc bat dong bo, khong can clock
//   - Cac dia chi chua duoc nap van doc duoc (gia tri mac dinh cua mo phong)
//   - Kiem tra viec anh xa dia chi byte -> chi so word (address >> 2)
//////////////////////////////////////////////////////////////////////////////////


module tb_instruction_mem(  );
    reg  [31:0] read_address;
    wire [31:0] instruction;
 
    integer error_count;
 
    // ---- Instance module can test ----
    Instruction_Mem dut (
        .read_address (read_address),
        .instruction  (instruction)
    );
 
    // ---- Task kiem tra instruction doc duoc ----
    task check;
        input [127:0] name;
        input [31:0]  expected;
        begin
            #1;
            if (instruction !== expected) begin
                $display("FAIL [%0s] addr=%0d -> instruction=%h (expect %h)",
                          name, read_address, instruction, expected);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] addr=%0d -> instruction=%h",
                          name, read_address, instruction);
            end
        end
    endtask
 
    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong Instruction Memory ===");
 
        // ---- Nap truoc mot vai lenh mau vao bo nho de test ----
        // (thay the cho viec doc tu file .hex bang $readmemh)
        #1;   // cho Instruction_Mem nap file hex xong roi moi ghi de
        dut.Memory[0] = 32'h00A28293; // lenh tai dia chi byte 0  (word 0)
        dut.Memory[1] = 32'hDEADBEEF; // lenh tai dia chi byte 4  (word 1)
        dut.Memory[2] = 32'h00000013; // lenh tai dia chi byte 8  (word 2) - NOP (addi x0,x0,0)
        dut.Memory[5] = 32'h12345678; // lenh tai dia chi byte 20 (word 5)
 
        // ---- Test 1: doc dia chi 0 ----
        read_address = 32'd0;
        check("addr=0", 32'h00A28293);
 
        // ---- Test 2: doc dia chi 4 (lenh thu 2) ----
        read_address = 32'd4;
        check("addr=4", 32'hDEADBEEF);
 
        // ---- Test 3: doc dia chi 8 (lenh thu 3) ----
        read_address = 32'd8;
        check("addr=8", 32'h00000013);
 
        // ---- Test 4: doc dia chi 20 (word thu 5) - kiem tra anh xa dung ----
        read_address = 32'd20;
        check("addr=20", 32'h12345678);
 
        // ---- Test 5: doc dia chi chua nap gia tri -> phai la 'x (chua khoi tao) ----
        // Icarus mac dinh gia tri chua gan la 'x, ta chi kiem tra no KHAC
        // voi cac gia tri da nap o tren (khong trung du lieu ngau nhien)
        read_address = 32'd100;
        #1;
        if (instruction === 32'h00A28293 || instruction === 32'hDEADBEEF) begin
            $display("FAIL [addr=100 chua nap] doc nham du lieu cua o khac: %h", instruction);
            error_count = error_count + 1;
        end else begin
            $display("PASS [addr=100 chua nap] instruction=%h (chua duoc nap, gia tri mac dinh)", instruction);
        end
 
        // ---- Test 6: doc lai dia chi 0 - dam bao doc on dinh, lap lai dung ----
        read_address = 32'd0;
        check("doc lai addr=0", 32'h00A28293);
 
        // ---- Test 7: thay doi dia chi lien tuc (khong can clock) - doc async ----
        read_address = 32'd4;
        #1;
        read_address = 32'd8;
        check("doi dia chi lien tuc -> addr=8", 32'h00000013);
 
        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);
 
        $finish;
    end
 

endmodule

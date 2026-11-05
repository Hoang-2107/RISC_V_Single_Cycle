`timescale 1ns / 1ps
module tb_EX_MEM();
    // khai bao tin hieu
    reg clk, rst;
    // dau vao

    reg ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg;
    reg [31:0] ex_result, ex_store_data;
    reg [4:0] ex_rd;
    reg [2:0] ex_funct3;

    // dau ra
    wire mem_mem_read, mem_mem_write, mem_reg_write, mem_mem_to_reg;
    wire [31:0] mem_result, mem_store_data;
    wire [4:0] mem_rd;
    wire [2:0] mem_funct3;

    // GOI DUT
    EX_MEM dut(
        .clk(clk),
        .rst(rst),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_reg_write(ex_reg_write),
        .ex_mem_to_reg(ex_mem_to_reg),
        .ex_result(ex_result),
        .ex_store_data(ex_store_data),
        .ex_rd(ex_rd),
        .ex_funct3(ex_funct3),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_reg_write(mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_result(mem_result),
        .mem_store_data(mem_store_data),
        .mem_rd(mem_rd),
        .mem_funct3(mem_funct3)
    );
    //tao clock
    initial clk = 0;
    always #5 clk = ~clk;

    wire [75:0] in_all  = {ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg,
                           ex_result, ex_store_data, ex_rd, ex_funct3};
    wire [75:0] out_all = {mem_mem_read, mem_mem_write, mem_reg_write, mem_mem_to_reg,
                           mem_result, mem_store_data, mem_rd, mem_funct3};

    // bit dieu khien
    localparam CTRL_ADD = 4'b0010; // R type, I type,
    localparam CTRL_SW  = 4'b0100; // S type
    localparam CTRL_LW  = 4'b1011; // Load
    localparam CTRL_JAL = 4'b0010; // jal
    // task check
    integer error_count = 0;

    task check;
        input [127:0] name;
        input [75:0] expected;
        begin
            if (out_all !== expected) begin
                $display("FAIL [%0s] t=%0t: ctrl=%b result=%h store=%h rd=%0d f3=%b",
                    name, $time, out_all[75:72], mem_result, mem_store_data, mem_rd, mem_funct3);
                $display("        mong doi: ctrl=%b result=%h store=%h rd=%0d f3=%b",
                    expected[75:72], expected[71:40], expected[39:8],
                    expected[7:3], expected[2:0]);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] t=%0t: ctrl=%b result=%h store=%h rd=%0d f3=%b",
                    name, $time, out_all[75:72], mem_result, mem_store_data, mem_rd, mem_funct3);
            end
        end
    endtask

    reg [75:0] latched;
    reg [75:0] out_old;

    task step;
        input        r;
        input  [3:0] ctrl;
        input [31:0] result, store_data;
        input  [4:0] rd;
        input  [2:0] funct3;
        begin
            @(negedge clk);
            rst = r;
            {ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg} = ctrl;
            ex_result = result;  ex_store_data = store_data;
            ex_rd = rd;          ex_funct3 = funct3;
            latched = in_all;
            @(posedge clk); #1;
        end
    endtask
    // khoi initial tong ket

    initial begin
        rst = 0;
        {ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg} = 4'b0;
        ex_result = 0; ex_store_data = 0; ex_rd = 0; ex_funct3 = 0;
        $dumpfile("tb_EX_MEM.vcd");            // ghi dang song (tuy chon)
        $dumpvars(0, tb_EX_MEM);
        $display("=== Testbench EX_MEM ===");
        step (1, 4'b1111,  32'hFFFF_FFFF, 32'hFFFF_FFFF, 31, 3'b111);
        check("reset", 76'd0);

        //2 binh thuong
        step (0, CTRL_ADD, 32'h0000_1010, 32'h0000_0010,  5, 3'b000);  // add x5,x1,x2
        check("add x5", latched);
        step (0, CTRL_SW,  32'h0000_1018, 32'h0000_CAFE,  8, 3'b010);  // sw x3,8(x5)
        check("sw x3", latched);

        //3 doi dau vao giua chu ky -> dau ra chua doi
        out_old = out_all;
        @(negedge clk);
        {ex_mem_read, ex_mem_write, ex_reg_write, ex_mem_to_reg} = CTRL_LW;
        ex_result = 32'h0000_1014; ex_store_data = 0; ex_rd = 6; ex_funct3 = 3'b010;
        latched = in_all;
        #2;
        check("no edge yet", out_old);
        @(posedge clk); #1;
        check("lw x6", latched);

        step (0, CTRL_JAL, 32'h0000_0010, 32'h0000_0000,  1, 3'b000);  // jal x1,16
        check("jal x1", latched);

        step (0, 4'b1111,  32'hFFFF_FFFF, 32'hFFFF_FFFF, 31, 3'b111);
        check("all ones", latched);

        step (1, CTRL_SW,  32'hDEAD_BEEF, 32'hCAFE_BABE, 12, 3'b010);
        check("rst mid-run", 76'd0);

        step (0, CTRL_LW,  32'h0000_1020, 32'h1234_5678, 10, 3'b100);  // lbu x10
        check("lbu x10", latched);

        step (0, 4'b0000,  32'h0000_0000, 32'h0000_0000,  0, 3'b000);
        check("all zeros", latched);

        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;                               // thieu dong nay mo phong chay mai
    end
endmodule

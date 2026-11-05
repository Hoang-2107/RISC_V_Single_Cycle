`timescale 1ns / 1ps
module tb_MEM_WB();
    reg clk, rst;
    reg mem_reg_write, mem_mem_to_reg;
    reg [31:0] mem_result;
    reg [31:0] mem_read_data;
    reg [4:0] mem_rd;

    wire wb_reg_write, wb_mem_to_reg;
    wire [31:0] wb_result;
    wire [31:0] wb_read_data;
    wire [4:0] wb_rd;

    MEM_WB uut(
        .clk(clk),
        .rst(rst),
        .mem_reg_write(mem_reg_write),
        .mem_mem_to_reg(mem_mem_to_reg),
        .mem_result(mem_result),
        .mem_read_data(mem_read_data),
        .mem_rd(mem_rd),
        .wb_reg_write(wb_reg_write),
        .wb_mem_to_reg(wb_mem_to_reg),
        .wb_result(wb_result),
        .wb_read_data(wb_read_data),
        .wb_rd(wb_rd)
    );

    localparam CTRL_ADD = 2'b10;   // R-type, I-type: ghi result
    localparam CTRL_SW  = 2'b00;   // store, branch: khong ghi
    localparam CTRL_LW  = 2'b11;   // load: ghi read_data
    localparam CTRL_JAL = 2'b10;   // jal/jalr: ghi result (= PC+4)\

        //   2 (ctrl) + 32 (result) + 32 (read_data) + 5 (rd) = 71
    wire [70:0] in_all  = {mem_reg_write, mem_mem_to_reg, mem_result, mem_read_data, mem_rd};
    wire [70:0] out_all = {wb_reg_write,  wb_mem_to_reg,  wb_result,  wb_read_data,  wb_rd};
 
    integer error_count = 0;
    reg [70:0] latched;    // dap an dung = dau vao vua gan
    reg [70:0] out_old;    // dau ra cu (cho test "chua toi canh")
 
    initial clk = 0;
    always #5 clk = ~clk;  // chu ky 10ns
 
    task check;
        input [127:0] name;
        input [70:0]  expected;
        begin
            if (out_all !== expected) begin
                $display("FAIL [%0s] t=%0t: ctrl=%b result=%h read_data=%h rd=%0d",
                    name, $time, out_all[70:69], wb_result, wb_read_data, wb_rd);
                $display("        mong doi: ctrl=%b result=%h read_data=%h rd=%0d",
                    expected[70:69], expected[68:37], expected[36:5], expected[4:0]);
                error_count = error_count + 1;
            end
            else
                $display("PASS [%0s] t=%0t: ctrl=%b result=%h read_data=%h rd=%0d",
                    name, $time, out_all[70:69], wb_result, wb_read_data, wb_rd);
        end
    endtask
 
    task step;
        input        r;
        input  [1:0] ctrl;
        input [31:0] result, read_data;
        input  [4:0] rd;
        begin
            @(negedge clk);
            rst = r;
            {mem_reg_write, mem_mem_to_reg} = ctrl;
            mem_result = result;  mem_read_data = read_data;
            mem_rd = rd;
            latched = in_all;
            @(posedge clk); #1;
        end
    endtask
 
    initial begin
        rst = 0;
        {mem_reg_write, mem_mem_to_reg} = 2'b0;
        mem_result = 0; mem_read_data = 0; mem_rd = 0;
        $dumpfile("tb_MEM_WB.vcd");
        $dumpvars(0, tb_MEM_WB);
        $display("=== Testbench MEM_WB ===");
 
        //1 reset: dau vao toan bit 1 de chac reset da xoa
        //    r  ctrl      result         read_data      rd
        step (1, 2'b11,    32'hFFFF_FFFF, 32'hFFFF_FFFF, 31);
        check("reset", 71'd0);
 
        //2 binh thuong
        step (0, CTRL_ADD, 32'h0000_1010, 32'h0000_0000,  5);   // add x5,x1,x2
        check("add x5", latched);
        step (0, CTRL_SW,  32'h0000_1018, 32'h0000_0000,  8);   // sw x3,8(x5)
        check("sw x3", latched);
 
        //3 doi dau vao giua chu ky -> dau ra chua doi
        out_old = out_all;
        @(negedge clk);
        {mem_reg_write, mem_mem_to_reg} = CTRL_LW;              // lw x6,4(x5)
        mem_result = 32'h0000_1014; mem_read_data = 32'h0000_ABCD; mem_rd = 6;
        latched = in_all;
        #2;
        check("no edge yet", out_old);
        @(posedge clk); #1;
        check("lw x6", latched);
 
        step (0, CTRL_JAL, 32'h0000_0010, 32'h0000_0000,  1);   // jal x1,16
        check("jal x1", latched);
 
        //4 moi bit deu len 1 duoc (bat loi khai bao thieu bit)
        step (0, 2'b11,    32'hFFFF_FFFF, 32'hFFFF_FFFF, 31);
        check("all ones", latched);
 
        //5 reset giua chung: dau ra DANG toan bit 1 -> phai ve 0
        step (1, CTRL_ADD, 32'hDEAD_BEEF, 32'hCAFE_BABE, 12);
        check("rst mid-run", 71'd0);
        // chay lai sau reset: lb x7 doc byte 0x80, Data_memory da mo rong dau
        step (0, CTRL_LW,  32'h0000_1020, 32'hFFFF_FF80,  7);   // lb x7
        check("lb x7", latched);
        // moi bit deu xuong 0 duoc (dau ra dang khac 0)
        step (0, 2'b00,    32'h0000_0000, 32'h0000_0000,  0);
        check("all zeros", latched);
 
        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;
    end
endmodule
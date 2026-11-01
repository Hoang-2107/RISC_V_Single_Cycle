`timescale 1ps/1ps
module tb_Branch_Comp();

// 1.khai bao dau vao la reg, dau ra là wire
reg [31:0] rs1, rs2;
reg [2:0] funct3;
reg       branch;
wire        take;

integer error_count;

//2. goi module can test

Branch_Comp dut(
    .rs1(rs1),
    .rs2(rs2),
    .funct3(funct3),
    .branch(branch),
    .take(take)
);

// 3. dat ten cho funct 3 
localparam BEQ  = 3'b000, 
           BNE  = 3'b001, 
           BLT  = 3'b100, 
           BGE  = 3'b101, 
           BLTU = 3'b110, 
           BGEU = 3'b111;

//4 Task: gan dau vao -> cho -> so sanh 
task check;
    input [127:0] name;
    input [31:0] a, b;
    input [2:0] f3;
    input       br;
    input      expected;

    begin
        rs1 = a; rs2 = b; funct3 = f3; branch = br;
        #1;
        if (take != expected) begin
            $display("FAIL [%0s] rs1=%0d rs2=%0d funct3=%b branch=%b -> take=%b (expected=%b)", 
                    name, $signed(a), $signed(b), f3, br, take, expected);
            error_count = error_count + 1;
        end else begin
            $display("PASS [%0s] rs1=%0d rs2=%0d funct3=%b branch=%b -> take=%b", 
                    name, $signed(a), $signed(b), f3, br, take);
        end
    end
endtask

initial begin
        error_count = 0;
        $display("== Test Branch_Comp ==");

        //---branch = 0: luon khong nhay --

        check("BEQ branch=0", 32'd5, 32'd5, BEQ, 1'b0, 1'b0);
        check("BNE branch=0", 32'd5, 32'd6, BNE, 1'b0, 1'b0);

        //-- BEQ --
        check("BEQ equal", 32'd10, 32'd10, BEQ, 1'b1, 1'b1);
        check("BEQ not equal", 32'd10, 32'd20, BEQ, 1'b1, 1'b0);

        //-- BNE --
        check("BNE equal", 32'd10, 32'd10, BNE, 1'b1, 1'b0);
        check("BNE not equal", 32'd10, 32'd20, BNE, 1'b1, 1'b1);

        // -- BLT --
        check  ("BLT 3<5", 32'd3, 32'd5, BLT, 1'b1, 1'b1);
        check  ("BLT 5<3", 32'd5, 32'd3, BLT, 1'b1, 1'b0);
        check  ("BLT -1<0", -32'd1, 32'd0, BLT, 1'b1, 1'b1);
        check  ("BLT 0<-1", 32'd0, -32'd1, BLT, 1'b1, 1'b0);        
        check ("BLT equal", 32'd7, 32'd7, BLT, 1'b1, 1'b0);
        check ("BLT min<max", 32'h80000000, 32'h7FFFFFFF, BLT, 1'b1, 1'b1);
        // -- BGE (co dau) --
        check  ("BGE 3>=5", 32'd3, 32'd5, BGE, 1'b1, 1'b0);
        check  ("BGE 5>=3", 32'd5, 32'd 3, BGE, 1'b1, 1'b1);
        check  ("BGE -1>=0", -32'd1, 32'd   0, BGE, 1'b1, 1'b0);
        check  ("BGE equal", 32'd7, 32'd7, BGE, 1'b1, 1'b1);
        // -- BLTU (khong dau) --
        check  ("BLTU 3<5", 32'd3, 32'd5, BLTU, 1'b1, 1'b1);
        check  ("BLTU 5<3", 32'd5, 32'd3, BLTU, 1'b1, 1'b0);
        check ("BLTU 1<FFFF", 32'd1, 32'hFFFFFFFF, BLTU, 1'b1, 1'b1);
        check ("BLTU 8000<7FFF", 32'h80000000, 32'h7FFFFFFF, BLTU, 1'b1, 1'b0);
        // -- BGEU (khong dau) --   
        check("BGEU FFFF>=1", -32'd1, 32'd1, BGEU, 1'b1, 1'b1);
        check("BGEU equal",   32'd0,  32'd0, BGEU, 1'b1, 1'b1);
        check("BGEU 1>=FFFF", 32'd1, -32'd1, BGEU, 1'b1, 1'b0);

        // --- funct3 khong hop le ---
        check("f3=010", 32'd1, 32'd1, 3'b010, 1'b1, 1'b0);
        check("f3=011", 32'd1, 32'd1, 3'b011, 1'b1, 1'b0);

        // 5. Tong ket
        if (error_count == 0) $display("=== TAT CA PASS ===");
        else                  $display("=== CO %0d LOI ===", error_count);
        $finish;
    end
endmodule

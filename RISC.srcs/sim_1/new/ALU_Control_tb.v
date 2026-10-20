`timescale 1ns/1ps

module ALU_Control_tb;

    reg  [1:0]  ALUOp_in;
    reg  [6:0] funct7;
    reg  [2:0] funct3;
    wire [3:0]  ALU_ctrl;

    ALU_Control uut (
        .ALUOp_in(ALUOp_in),
        .funct7(funct7),
        .funct3(funct3),
        .ALU_ctrl(ALU_ctrl)
    );

    integer error_count;
    
    localparam alu_sub = 4'b0001;
    localparam alu_add = 4'b0000;
    localparam alu_and = 4'b0010;
    localparam alu_or = 4'b0011;
    localparam alu_xor = 4'b0100;
    localparam alu_sll = 4'b0101;
    localparam alu_sra = 4'b0111;
    localparam alu_srl = 4'b0110;
    localparam alu_slt = 4'b1000;
    localparam alu_sltu = 4'b1001;
    
         // ---- Task kiem tra va so sanh ket qua mong doi ----
    task check;
        input [127:0] name;
        input [3:0]   expected;
        begin
            #1;
            if (ALU_ctrl !== expected) begin
                $display("FAIL [%0s] ALUOp_in=%b funct3=%b funct7=%b -> ALU_ctrl=%b (expect %b)",
                          name, ALUOp_in, funct3, funct7, ALU_ctrl, expected);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%0s] ALUOp_in=%b funct3=%b funct7=%b -> ALU_ctrl=%b",
                          name, ALUOp_in, funct3, funct7, ALU_ctrl);
            end
        end
    endtask
 
    initial begin
        error_count = 0;
        $display("=== Bat dau mo phong ALU Control ===");
 
        // ---- Truong hop lw/sw: ALUOp_in = 00 -> luon la ADD ----
        ALUOp_in = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000;
        check("LW/SW", alu_add);
 
        // ---- Truong hop branch (beq): ALUOp_in    = 01 -> luon la SUB ----
        ALUOp_in = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000;
        check("BRANCH", alu_sub);
 
        // ---- R-type: add (funct3=000, funct7=0000000) ----
        ALUOp_in = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000;
        check("R-type ADD", alu_add);
 
        // ---- R-type: sub (funct3=000, funct7=0100000, bit 5 =1) ----
        ALUOp_in = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000;
        check("R-type SUB", alu_sub);
 
        // ---- R-type: and (funct3=111) ----
        ALUOp_in = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000;
        check("R-type AND", alu_and);
 
        // ---- R-type: or (funct3=110) ----
        ALUOp_in = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000;
        check("R-type OR", alu_or);
 
        // ---- R-type: xor (funct3=100) ----
        ALUOp_in = 2'b10; funct3 = 3'b100; funct7 = 7'b0000000;
        check("R-type XOR", alu_xor);
 
        // ---- R-type: sll (funct3=001) ----
        ALUOp_in = 2'b10; funct3 = 3'b001; funct7 = 7'b0000000;
        check("R-type SLL", alu_sll);
 
        // ---- R-type: srl (funct3=101, funct7 bit5=0) ----
        ALUOp_in = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000;
        check("R-type SRL", alu_srl);
 
        // ---- R-type: sra (funct3=101, funct7 bit5=1) ----
        ALUOp_in = 2'b10; funct3 = 3'b101; funct7 = 7'b0100000;
        check("R-type SRA", alu_sra);
 
        // ---- R-type: slt (funct3=010) ----
        ALUOp_in = 2'b10; funct3 = 3'b010; funct7 = 7'b0000000;
        check("R-type SLT", alu_slt);
 
        // ---- R-type: sltu (funct3=011) ----
        ALUOp_in = 2'b10; funct3 = 3'b011; funct7 = 7'b0000000;
        check("R-type SLTU", alu_sltu);
 
        // ---- Tong ket ----
        if (error_count == 0)
            $display("=== TAT CA TEST PASS ===");
        else
            $display("=== CO %0d TEST FAIL ===", error_count);
 
        $finish;
    end   
endmodule
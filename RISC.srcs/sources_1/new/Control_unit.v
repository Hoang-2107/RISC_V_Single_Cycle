`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module: control_unit
// Chuc nang: Giai ma truong Opcode (Instruction[6:0] theo RISC-V) va
//            sinh ra toan bo tin hieu dieu khien cho datapath.
//
// Cac lenh ho tro (RISC-V co ban):
//   - R-type      (add, sub, and, or, xor, slt...) : opcode = 0110011
//   - I-type load (lw)                              : opcode = 0000011
//   - S-type store (sw)                             : opcode = 0100011
//   - B-type branch (beq, bne...)                   : opcode = 1100011
//   - I-type ALU  (addi, andi, slli...)             : opcode = 0010011
//   - J-type jal                                    : opcode = 1101111
//   - I-type jalr                                   : opcode = 1100111
//   - U-type lui / auipc                            : opcode = 0110111 / 0010111
//////////////////////////////////////////////////////////////////////////////////


module Control_unit(OPcode,branch, mem_read, mem_to_reg, mem_write,ALU_src, reg_write, ALUop_out,
    jal, jalr, ALU_a_sel
    );
    input [6:0] OPcode;
    output reg branch, mem_read, mem_to_reg, mem_write,ALU_src, reg_write;
    output reg [1:0] ALUop_out;
    output reg jal;              // 1 = lenh JAL : PC <- PC + imm,           rd <- PC + 4
    output reg jalr;             // 1 = lenh JALR: PC <- (rs1 + imm) & ~1,  rd <- PC + 4
    output reg [1:0] ALU_a_sel;  // dau vao A cua ALU: 00 = rs1, 01 = PC (auipc), 10 = 0 (lui)
    localparam R_type = 7'b0110011;
    localparam LOAD = 7'b0000011;
    localparam STORE = 7'b0100011;
    localparam BRANCH = 7'b1100011;
    localparam I_type = 7'b0010011;
    localparam JAL    = 7'b1101111;
    localparam JALR   = 7'b1100111;
    localparam LUI    = 7'b0110111;
    localparam AUIPC  = 7'b0010111;
    always @ (*) begin
    //gia tri mac dinh de trach latch
    branch = 1'b0;
    mem_read = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    ALU_src = 1'b0;
    reg_write = 1'b0;
    ALUop_out = 2'b00;
    jal = 1'b0;
    jalr = 1'b0;
    ALU_a_sel = 2'b00;
    case(OPcode)
    R_type: begin
            ALUop_out     = 2'b10;  // bao ALU Control giai ma theo funct3/funct7
            reg_write  = 1'b1;   // co ghi ket qua vao thanh ghi
            end
    I_type: begin 
            ALUop_out = 2'b11;   // ALU_Control -> ADDI
            ALU_src   = 1'b1;    // dung immediate
            reg_write = 1'b1;
            end
    LOAD: begin
            ALU_src     = 1'b1;
            mem_to_reg  = 1'b1;
            reg_write   = 1'b1;
            mem_read    = 1'b1;
            ALUop_out    = 2'b00;  // ADD tinh dia chi
            end
    STORE: begin
            ALU_src     = 1'b1;
            mem_write   = 1'b1;
            ALUop_out    = 2'b00;  // ALU_Control -> ADD
            end
    BRANCH: begin
            ALUop_out    = 2'b01;  // SUB (dieu kien nhay do Branch_Comp quyet dinh)
            branch      = 1'b1;
            end
    JAL: begin
            jal         = 1'b1;    // PC <- PC + imm (Adder_sum)
            reg_write   = 1'b1;    // rd <- PC + 4
            end
    JALR: begin
            jalr        = 1'b1;    // PC <- ALU = rs1 + imm
            ALU_src     = 1'b1;
            ALUop_out   = 2'b00;   // ADD
            reg_write   = 1'b1;    // rd <- PC + 4
            end
    LUI: begin
            ALU_a_sel   = 2'b10;   // A = 0  -> ALU = 0 + imm
            ALU_src     = 1'b1;
            ALUop_out   = 2'b00;
            reg_write   = 1'b1;
            end
    AUIPC: begin
            ALU_a_sel   = 2'b01;   // A = PC -> ALU = PC + imm
            ALU_src     = 1'b1;
            ALUop_out   = 2'b00;
            reg_write   = 1'b1;
            end
    default: begin
             branch = 1'b0;
             mem_read = 1'b0;
             mem_to_reg = 1'b0;
             mem_write = 1'b0;
             ALU_src = 1'b0;
             reg_write = 1'b0;
             ALUop_out = 2'b00;
             end

    endcase
    
    end

    
endmodule

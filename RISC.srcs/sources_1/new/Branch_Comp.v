`timescale 1ns / 1ps
// Module: Branch_Comp
// Chuc nang: Quyet dinh CO NHAY hay KHONG cho 6 lenh nhanh cua RV32I.
//            Thay the khoi And_zero (chi lam duoc beq vi chi dua vao co Zero).
//            So sanh truc tiep rs1, rs2 theo funct3:
//              000 beq  : rs1 == rs2
//              001 bne  : rs1 != rs2
//              100 blt  : rs1 <  rs2 (co dau)
//              101 bge  : rs1 >= rs2 (co dau)
//              110 bltu : rs1 <  rs2 (khong dau)
//              111 bgeu : rs1 >= rs2 (khong dau)
//            take = 1 chi khi dang la lenh nhanh (branch = 1) VA dieu kien dung.
module Branch_Comp(
    input  [31:0] rs1, rs2,     // Read data 1, Read data 2
    input  [2:0]  funct3,       // Instruction[14:12]
    input         branch,       // tu Control_unit
    output        take          // 1 = PC <- PC + offset
);
    reg cond;
    always @(*) begin
        case (funct3)
            3'b000:  cond = (rs1 == rs2);                    // BEQ
            3'b001:  cond = (rs1 != rs2);                    // BNE
            3'b100:  cond = ($signed(rs1) <  $signed(rs2));  // BLT
            3'b101:  cond = ($signed(rs1) >= $signed(rs2));  // BGE
            3'b110:  cond = (rs1 <  rs2);                    // BLTU
            3'b111:  cond = (rs1 >= rs2);                    // BGEU
            default: cond = 1'b0;                            // 010, 011 khong ton tai
        endcase
    end
    assign take = branch & cond;
endmodule

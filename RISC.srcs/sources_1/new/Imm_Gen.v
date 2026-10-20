`timescale 1ns / 1ps
// Chuc nang: Bo sinh gia tri tuc thoi (Immediate Generator) cho RISC-V.
//            Cac bit immediate nam RAI RAC o nhieu vi tri khac nhau
//            trong ma lenh 32-bit, tuy theo TUNG DANG LENH (format).
//            Khoi nay can cu vao Opcode (Instruction[6:0]) de biet dang
//            lenh nao, gom cac bit ve dung thu tu, roi MO RONG DAU
//            (sign-extend) thanh gia tri 32-bit hoan chinh.
//
// 5 dang lenh co ban cua RISC-V (RV32I):
//   I-type (addi, lw, jalr...) : imm[11:0]  = Instruction[31:20]
//   S-type (sw, sb, sh...)     : imm[11:5]  = Instruction[31:25]
//                                 imm[4:0]   = Instruction[11:7]
//   B-type (beq, bne, blt...)  : imm[12]    = Instruction[31]
//                                 imm[11]    = Instruction[7]
//                                 imm[10:5]  = Instruction[30:25]
//                                 imm[4:1]   = Instruction[11:8]
//                                 imm[0]     = 0  (dia chi luon chan)
//   U-type (lui, auipc)        : imm[31:12] = Instruction[31:12]
//                                 imm[11:0]  = 0
//   J-type (jal)               : imm[20]    = Instruction[31]
//                                 imm[19:12] = Instruction[19:12]
//                                 imm[11]    = Instruction[20]
//                                 imm[10:1]  = Instruction[30:21]
//                                 imm[0]     = 0
//
// Luu y: B-type va J-type co bit thap nhat luon =0 vi dia chi lenh
// RISC-V (khong nen) luon la boi cua 2 -> tiet kiem 1 bit ma hoa,
// day chinh la ly do khoi "Shift left 1" o sau can dich lai.
// => Trong SACH: ImmGen KHONG gan bit 0, khoi Shift left 1 gan bit 0 do.
// => Trong CODE NAY: ImmGen DA gan bit 0 (1'b0 o cuoi B/J-type),
//    nen KHONG can (va KHONG duoc) dich them lan nua.
 module Imm_Gen(Inst_in, Inst_out
    );
    input wire [31:0] Inst_in;
    output reg [31:0] Inst_out;
    
    always @(*) begin
        case(Inst_in[6:0])
            // I-type (Loads, ALU immediate, JALR)
            7'b0000011, 7'b0010011, 7'b1100111: begin
                Inst_out = {{20{Inst_in[31]}}, Inst_in[31:20]};
            end
            
            // S-type (Store)
            7'b0100011: begin 
                Inst_out = {{20{Inst_in[31]}}, Inst_in[31:25], Inst_in[11:7]};
            end
            
            // B-type (Branch)
            // LUU Y: bit 1'b0 o cuoi = DA DICH TRAI 1 BIT ngay tai day,
            //        nen Inst_out la offset theo BYTE, cong thang vao PC duoc.
            //        -> KHONG dua qua Shift_barek nua (neu khong se bi x2 hai lan).
            // Neu muon lam GIONG SO DO SACH (ImmGen -> Shift left 1 -> Add):
            //        bo 1'b0 o cuoi va doi {19{..}} thanh {20{..}}:
            //        Inst_out = {{20{Inst_in[31]}}, Inst_in[31], Inst_in[7], Inst_in[30:25], Inst_in[11:8]};
            //        roi noi Adder_sum.Shift = shift_out trong RISCV_TOP.
            // Vi du: beq x1,x2,+8 -> Inst_out = 8 (code nay) / = 4 (kieu sach, sau shift = 8)
            7'b1100011: begin
                Inst_out = {{19{Inst_in[31]}}, Inst_in[31], Inst_in[7], Inst_in[30:25], Inst_in[11:8], 1'b0};
            end
            
            // U-type (LUI, AUIPC)
            7'b0110111, 7'b0010111: begin 
                Inst_out = {Inst_in[31:12], 12'b0};
            end
            
            // J-type (JAL)
            // Tuong tu B-type: 1'b0 o cuoi = da dich trai 1 bit san.
            7'b1101111: begin
                Inst_out = {{11{Inst_in[31]}}, Inst_in[31], Inst_in[19:12], Inst_in[20], Inst_in[30:21], 1'b0};
            end
            
            default: begin
                Inst_out = 32'b0;
            end
        endcase
    end     
    

    
endmodule

`timescale 1ns / 1ps
// Chuc nang: Khoi "Shift left 1" trong so do datapath cua sach
//            (Patterson & Hennessy, RISC-V edition): dich trai offset
//            1 bit (nhan 2) truoc khi cong voi PC de tinh dia chi nhanh.
//
// Vi sao can dich trai:
//   Offset cua lenh nhanh (beq) luon la so CHAN, nen RISC-V KHONG luu
//   bit 0 trong ma lenh (tiet kiem 1 bit -> nhay xa gap doi).
//   Trong sach, ImmGen chi lay 12 bit imm[12:1] roi mo rong dau
//   -> gia tri = offset/2. Khoi nay gan lai bit 0 = 0 -> offset theo byte.
//   (Trong MIPS, dia chi luon la boi cua 4 -> dich trai 2 bit, tuc SHIFT LEFT 2)
//
// !!! LUU Y VOI PROJECT NAY !!!
//   Imm_Gen.v cua project DA gan san bit 0 (1'b0 o cuoi B-type), tuc la
//   da dich trai roi. Vi vay trong RISCV_TOP, Adder_sum dang lay thang
//   im_gen_top, KHONG lay shift_out -> khoi nay hien KHONG duoc dung.
//   Chi dung khoi nay KHI sua Imm_Gen bo 1'b0 (lam giong het sach).
//   TUYET DOI khong dung ca hai cung luc: offset bi gap doi -> nhay sai
//   (vi du beq +8 se nhay +16).
//
// Day la mot bo dich CUNG (hardwired shifter), khong phai ALU-shift:
// chi la ghep day day (wire), khong dung phep toan, nen khong ton logic,
// khong ton chu ky - hoan toan la to hop thuan tuy (combinational).
module Shift_barek#(    
    parameter WIDTH = 32,
    parameter SHIFT_AMOUNT = 1
)(
    Shift_in, Shift_out
    );
    input  wire [WIDTH-1:0] Shift_in;
    output wire [WIDTH-1:0] Shift_out;
    assign Shift_out = {Shift_in[WIDTH-1-SHIFT_AMOUNT:0],{SHIFT_AMOUNT{1'b0}}} ;
     // Dich trai bang cach noi them SHIFT_AMOUNT bit '0' vao ben phai
    // va bo bot SHIFT_AMOUNT bit cao nhat ben trai (giu nguyen do rong).
    // Vi day chi la NOI DAY (wire), khong ton phan cung thuc su.
endmodule

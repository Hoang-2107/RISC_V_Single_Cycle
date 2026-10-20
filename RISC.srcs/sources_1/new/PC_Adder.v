`timescale 1ns / 1ps
// Chuc nang: Bo cong 32-bit don gian, dung CHUNG cho ca hai vi tri
//            "Add" trong so do datapath:
//              1) Add ben trai  : PC + 4          -> dia chi lenh ke tiep
//              2) Add ben phai  : PC + (offset<<1) -> dia chi dich nhanh
//            Day chi la mot bo cong thuan tuy, khong biet no dang duoc
//            dung cho muc dich nao - muc dich duoc quyet dinh boi TIN
//            HIEU NAO duoc noi vao input_b luc ghep noi (wiring) o cap
//            datapath phia tren, khong phai do ban than module nay.
module PC_Adder(
    input  [31:0] From_PC,
    output [31:0] PC_plus
);

    assign PC_plus = From_PC + 32'h4;

endmodule

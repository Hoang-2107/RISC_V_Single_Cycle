`timescale 1ns / 1ps
module Branch_Comp(
    input  [31:0] rs1, rs2,
    input  [2:0]  funct3,
    input         branch,
    output        take
);
localparam BEQ  = 3'b000,
           BNE  = 3'b001,
           BLT  = 3'b100,
           BGE  = 3'b101,
           BLTU = 3'b110,
           BGEU = 3'b111;
    reg cond;
    always @(*) begin
        case (funct3)
            BEQ:  cond = (rs1 == rs2);
            BNE:  cond = (rs1 != rs2);
            BLT:  cond = ($signed(rs1) <  $signed(rs2));
            BGE:  cond = ($signed(rs1) >= $signed(rs2));
            BLTU:  cond = (rs1 <  rs2);
            BGEU:  cond = (rs1 >= rs2);
            default: cond = 1'b0;
        endcase
    end
    assign take = branch & cond;
endmodule

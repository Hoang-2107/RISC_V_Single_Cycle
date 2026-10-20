`timescale 1ns / 1ps
// =====================================================================
// Module: regfile
// Chuc nang: Tep thanh ghi (Register File) 32 thanh ghi x 32-bit
//            - 2 cong doc dong bo-async (doc ngay trong cung chu ky)
//            - 1 cong ghi dong bo (ghi tai canh len clock)
//            - Thanh ghi x0 luon bang 0 (chuan RISC-V)
// =====================================================================
module Register_file (
    input  wire        clk,
    input  wire        rst_n,      // reset tich cuc muc thap

    input  wire [4:0]  read_reg1,  // Instruction[19:15] -> rs1
    input  wire [4:0]  read_reg2,  // Instruction[24:20] -> rs2
    input  wire [4:0]  write_reg,  // Instruction[11:7]  -> rd

    input  wire [31:0] write_data, // du lieu ghi vao (tu Mux MemtoReg)
    input  wire         reg_write,  // tin hieu dieu khien RegWrite (tu Control)

    output wire [31:0] read_data1, // Read data 1
    output wire [31:0] read_data2  // Read data 2
);

    // Mang 32 thanh ghi, moi thanh ghi 32-bit
    reg [31:0] registers [0:31];

    integer i;

    // ---- Doc du lieu (async read - to hop) ----
    // x0 luon tra ve 0, khong phu thuoc vao noi dung mang registers
    assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 : registers[read_reg2];

    // ---- Ghi du lieu (sync write - canh len clock) ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset toan bo thanh ghi ve 0
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else if (reg_write && (write_reg != 5'd0)) begin
            // Chi ghi khi RegWrite = 1 va dich khong phai x0
            registers[write_reg] <= write_data;
        end
    end

endmodule
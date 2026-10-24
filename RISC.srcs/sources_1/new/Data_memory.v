`timescale 1ns / 1ps
// Module: data_mem
// Chuc nang: Bo nho du lieu (Data Memory)
//            - Doc bat dong bo (async read) khi mem_read = 1
//            - Ghi dong bo (sync write, canh len clock) khi mem_write = 1
//            - Voi lenh R-type: mem_read = mem_write = 0
//              (ALU result di thang qua Mux MemtoReg, khong dung khoi nay)
//            - Ho tro truy cap byte / halfword / word theo funct3:
//                LOAD : 000 lb, 001 lh, 010 lw, 100 lbu, 101 lhu
//                STORE: 000 sb, 001 sh, 010 sw
//              (neu khong noi funct3 -> mac dinh la word, giong ban cu)
module Data_memory #(parameter ADDR_WIDTH = 5, 
                    parameter MEM_FILE = ""
                    )(
    clk, rst_n, mem_write, mem_read, funct3, address, write_data, read_data
    );
    input clk, rst_n, mem_write, mem_read;
    input [2:0] funct3;          // Instruction[14:12]
    input [31:0] address, write_data;
    output [31:0] read_data;

         // Bo nho: moi phan tu 32-bit (1 word), dia chi tinh theo word
    reg [31:0] Dmemory [0:(1<<ADDR_WIDTH)-1];
      // Lay chi so word tu dia chi byte (chia 4, bo 2 bit thap)
    wire [ADDR_WIDTH-1:0] word_addr = address[ADDR_WIDTH+1:2];
      // 2 bit thap = vi tri byte trong word -> so bit can dich = byte * 8
    wire [4:0] byte_shift = {address[1:0], 3'b000};
    wire [31:0] mem_word  = Dmemory[word_addr];

    // ---- Doc du lieu (to hop, chi hop le khi mem_read = 1) ----
    // Dich byte/halfword can doc xuong bit thap nhat, roi cat + mo rong dau
    wire [31:0] shifted = mem_word >> byte_shift;
    reg  [31:0] load_val;
    always @(*) begin
        case (funct3)
            3'b000:  load_val = {{24{shifted[7]}},  shifted[7:0]};   // LB  (co dau)
            3'b001:  load_val = {{16{shifted[15]}}, shifted[15:0]};  // LH  (co dau)
            3'b100:  load_val = {24'd0, shifted[7:0]};               // LBU (khong dau)
            3'b101:  load_val = {16'd0, shifted[15:0]};              // LHU (khong dau)
            default: load_val = mem_word;                            // LW
        endcase
    end
    assign read_data = (mem_read) ? load_val : 32'd0;

    // ---- Ghi du lieu theo tung byte (byte-enable) ----
    // we[i] = 1 -> ghi byte i cua word. Vivado nhan dang duoc mau nay la RAM.
    reg [3:0]  we;
    reg [31:0] wdata;
    always @(*) begin
        case (funct3[1:0])
            2'b00:   begin we = 4'b0001 << address[1:0];              wdata = {4{write_data[7:0]}};  end // SB
            2'b01:   begin we = address[1] ? 4'b1100 : 4'b0011;      wdata = {2{write_data[15:0]}}; end // SH
            default: begin we = 4'b1111;                              wdata = write_data;            end // SW
        endcase
    end

    always @(posedge clk) begin
        if (mem_write) begin
            if (we[0]) Dmemory[word_addr][ 7: 0] <= wdata[ 7: 0];
            if (we[1]) Dmemory[word_addr][15: 8] <= wdata[15: 8];
            if (we[2]) Dmemory[word_addr][23:16] <= wdata[23:16];
            if (we[3]) Dmemory[word_addr][31:24] <= wdata[31:24];
        end
    end

    // Khoi tao bo nho (thay cho reset ve 0)
    integer k;
    initial begin
        for (k = 0; k < (1<<ADDR_WIDTH); k = k + 1)
            Dmemory[k] = 32'h0;
        if (MEM_FILE != "")
            $readmemh(MEM_FILE, Dmemory);
    end
endmodule

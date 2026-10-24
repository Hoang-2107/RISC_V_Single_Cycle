`timescale 1ns / 1ps
// Chuc nang: Khoi truyen UART (UART Transmitter) - truyen 1 byte (8 bit) theo
//            giao thuc UART (1 start bit, 8 data bit, 1 stop bit).
//            - Baud rate = 115200, clock = 100MHz -> CLKS_PER_BIT = 100_000_000 / 115200 = 868     



module uart_tx #(parameter CLKS_PER_BIT = 868)(
    input clk, rst, tx_start,
    input [7:0] tx_data,    
    output  reg tx, 
    output  tx_busy

);
    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
    reg [1:0] state;
    reg [15:0] clk_cnt;
    reg [2:0] bit_idx;
    reg [7:0] data_r;


    assign tx_busy = (state != IDLE);
    
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            state <= IDLE;
            tx <= 1'b1;
            clk_cnt <= 0;
            bit_idx <= 0;
            data_r <= 0;
        end
        else case (state)
            IDLE : begin
                tx <= 1'b1;
                clk_cnt <= 0;
                bit_idx <= 0;
                if (tx_start) begin
                        state <= START;
                        data_r <= tx_data;
                    end
                end
                START : begin 
                    tx <= 1'b0;
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state <= DATA;
                    end
                end
                DATA : begin
                    tx <= data_r[bit_idx];
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <=0;
                        if (bit_idx <7) begin
                            bit_idx <= bit_idx + 1;
                        end else begin
                            bit_idx <= 0;
                            state <= STOP;
                        end
                
                end
            end
                STOP : begin
                 tx <= 1'b1;
                    if (clk_cnt < CLKS_PER_BIT - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end

    endmodule
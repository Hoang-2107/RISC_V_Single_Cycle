`timescale 1ns / 1ps
// Module: uart_rx
// Chuc nang: UART receiver (8N1)
//            - Doc du lieu tu UART, luu vao thanh ghi rx_data
//            - Khi co du lieu moi -> dat flag rx_ready = 1
//            - Khi CPU doc du lieu (rx_read = 1) -> dat flag rx_ready = 0
//            - rx_done: xung 1 chu ky khi nhan xong 1 byte hop le
//            - Baudrate = 115200, clock = 100MHz -> 1 bit = 868 clock
module uart_rx #(parameter CLK_PER_BIT = 868) (
    input            clk, rst_n, rx,
    input            rx_read,          // CPU doc xong -> xoa rx_ready
    output reg [7:0] rx_data,
    output reg       rx_done,          // xung 1 chu ky khi nhan xong 1 byte
    output reg       rx_ready          // giu 1 cho toi khi CPU doc
);

localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;
reg [1:0]  state;
reg [15:0] clk_cnt;
reg [2:0]  bit_index;
reg [7:0]  shift;                      // thanh ghi tam, chi chep ra rx_data khi nhan xong

// dong bo 2 tang FF (chong metastable) cho tin hieu vao rx
reg rx_s1, rx_s2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rx_s1 <= 1'b1;
        rx_s2 <= 1'b1;
    end else begin
        rx_s1 <= rx;
        rx_s2 <= rx_s1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state     <= IDLE;
        clk_cnt   <= 0;
        bit_index <= 0;
        shift     <= 0;
        rx_data   <= 0;
        rx_done   <= 1'b0;
        rx_ready  <= 1'b0;
    end else begin
        rx_done <= 1'b0;
        if (rx_read) rx_ready <= 1'b0;

        case (state)
        IDLE: begin
            clk_cnt   <= 0;
            bit_index <= 0;
            if (rx_s2 == 1'b0) state <= START;   // phat hien canh xuong start bit
        end

        START: begin
            // doi toi giua start bit roi kiem tra lai
            if (clk_cnt == (CLK_PER_BIT-1)/2) begin
                clk_cnt <= 0;
                if (rx_s2 == 1'b0) state <= DATA;
                else               state <= IDLE; // nhieu, khong phai start bit
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end

        DATA: begin
            // lay mau o giua moi bit du lieu (LSB truoc)
            if (clk_cnt < CLK_PER_BIT-1) begin
                clk_cnt <= clk_cnt + 1;
            end else begin
                clk_cnt <= 0;
                shift[bit_index] <= rx_s2;
                if (bit_index == 3'd7) begin
                    bit_index <= 0;
                    state     <= STOP;
                end else begin
                    bit_index <= bit_index + 1;
                end
            end
        end

        STOP: begin
            if (clk_cnt < CLK_PER_BIT-1) begin
                clk_cnt <= clk_cnt + 1;
            end else begin
                clk_cnt <= 0;
                if (rx_s2 == 1'b1) begin          // stop bit hop le
                    rx_data  <= shift;
                    rx_done  <= 1'b1;
                    rx_ready <= 1'b1;
                end
                state <= IDLE;                    // ve IDLE o giua stop bit
            end
        end

        default: state <= IDLE;
        endcase
    end
end

endmodule

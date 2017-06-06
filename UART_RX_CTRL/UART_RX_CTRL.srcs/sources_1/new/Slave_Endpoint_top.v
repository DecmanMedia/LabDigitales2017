`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2017 16:52:51
// Design Name: 
// Module Name: Slave_Endpoint_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Slave_Endpoint_top(
    input rx, CLK100MHZ, rst,
    output [3:0] LED
    );
    
    wire [7:0] rx_data, tx_data;
    wire rx_ready,tx_start,trigger;
    //uart
        uart_basic #(
            .CLK_FREQUENCY(100_000_000),
            .BAUD_RATE(115200)
        ) uart_basic_inst (
            .clk(CLK100MHZ),
            .reset(rst),
            .rx(rx),
            .rx_data(rx_data),
            .rx_ready(rx_ready),
            .tx(),
            .tx_start(),
            .tx_data(tx_data),
            .tx_busy()
        );
        
        UART_RX_CTRL UART_RX_CTRL_inst(
            .rx_data(rx_data),
            .rx_ready(rx_ready),
            .rst(rst),
            .clk(CLK100MHZ),
            .tx_notice_me(tx_start),
            .tx_operador1(),
            .tx_operador2(),
            .tx_ALU_ctrl(),
            .LED(LED),
            .trigger(trigger)
            );
            
endmodule

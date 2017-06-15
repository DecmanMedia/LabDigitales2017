`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2017 19:59:41
// Design Name: 
// Module Name: Top_modulept1
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


module Top_modulept1(
    input CLK100MHZ,
    input CPU_RESETN,
    input JA1,
    output[3:0] LED
    );
    wire [7:0] rxt;
    wire rx_redy;
    uart_basic r1(.clk(CLK100MHZ),
            .reset(),
            .rx(JA1),
            .rx_data(rxt),
            .rx_ready(rx_redy),
            .tx(),
            .tx_start(),
            .tx_data(),
            .tx_busy());
    wire [3:0] estado;
    UART_RX_CTRL( .clk(CLK100MHZ),
                  .rst(CPU_RESETN),                    
                  .rx(rxt),
                  .rx_ready(rx_redy),
                  .op1(),
                  .op2(),
                  .cmd(),
                  .estado(estado),
                  .tx_result());
    assign LED = estado;
    
endmodule

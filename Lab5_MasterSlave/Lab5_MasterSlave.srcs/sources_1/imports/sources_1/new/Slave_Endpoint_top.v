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
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output tx,
    output [7:0] LED
    );
    
       
    wire [7:0] rx_data, tx_data;
    wire rx_ready,tx_start,trigger, tx_busy, ready;
    wire [15:0] operador1, operador2, resultado;
    wire [2:0] ALU_ctrl;
    wire state_ALU;
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
            .tx(tx),
            .tx_start(tx_start),
            .tx_data(tx_data),
            .tx_busy()
        ); 
        
        UART_RX_CTRL UART_RX_CTRL_inst(
            .rx_data(rx_data),
            .rx_ready(rx_ready),
            .rst(rst),
            .clk(CLK100MHZ),
            .tx_operador1(operador1),
            .tx_operador2(operador2),
            .tx_ALU_ctrl(ALU_ctrl),
            .state_alu(state_ALU),
            .state(LED[7:4])
            );
            
        lab_4 ALU_DISPLAY(
            .operando1(operador1),
            .operando2(operador2),
            .ALU_ctrl(ALU_ctrl),
            .CLK100MHZ(CLK100MHZ),
            .CPU_RESETN(~rst),
            .state(state_ALU),
            .salida(resultado),
            .ready(ready),
            .AN(AN),
            .CA(CA),
            .CB(CB),
            .CC(CC),
            .CD(CD), 
            .CE(CE),
            .CF(CF), 
            .CG(CG), 
            .DP(DP),
            .estado_actual(LED[2:0])           
            );
       
    reg [15:0] resultado_p = 16'h8;        
    TX_CTRL TX_CTRL_inst(
        .rst(~rst),
        .resultOut16(resultado),
        .ready(ready),
        .clk(CLK100MHZ),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_busy(tx_busy)
        
        );
            
endmodule

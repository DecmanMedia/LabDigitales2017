`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 15:59:03
// Design Name: 
// Module Name: Puto_Dios
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


module Puto_Dios(
    input              clk_100M,
	input              reset_n,	
	
	//input              button_c,
	//input  [15:0]      switches,
	input              uart_rx, 
	//output [1:0]       leds,
	
	output [7:0]       ss_value,
    output [7:0]       ss_select,
    
    output [3:0] leds,
    output ld,
    output              uart_tx
    );
    
  //  wire uart_rx, uart_tx, uart_tx_busy;
    wire [7:0] AN, SEG, LED;
    
   /* master_endpoint_top masterchefcito (
    .clk_100M(clk_100M),
    .reset_n(reset_n),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .uart_tx_busy(uart_tx_busy),
    .uart_tx_usb(),
    .button_c(button_c),
    .switches(switches),
    .leds(leds),
    .ss_select(ss_select),
    .ss_value(ss_value)
);*/
    
    Slave_Endpoint_top slavecito(
    .rx(uart_rx),
    .CLK100MHZ(clk_100M),
    .rst(~reset_n),
    .AN(ss_select),
    .SEG(ss_value),
    .tx(uart_tx),
    .LED(LED),
    .ld(ld),
    .state_rx(leds)
);

endmodule

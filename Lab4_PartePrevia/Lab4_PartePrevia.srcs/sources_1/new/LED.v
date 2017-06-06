`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2017 14:30:33
// Design Name: 
// Module Name: LED
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


module LED(
    input BTNC, BTNU, BTND, BTNL, BTNR,
    input [7:0] result,
    output [7:0] LED
    );
    
    assign LED = ({BTNC, BTNU, BTND, BTNL, BTNR} == 5'b00010 | {BTNC, BTNU, BTND, BTNL, BTNR} == 5'b00001)?
                 result[7:0]:8'd0;
                 
endmodule

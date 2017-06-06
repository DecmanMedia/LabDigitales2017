`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2017 14:54:34
// Design Name: 
// Module Name: ejercicio_1
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


module ejercicio_1(
    output [15:0]LOL,
    input [15:0] SW
    );
    
    assign LOL = ~SW;
endmodule

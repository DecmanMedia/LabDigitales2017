`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2017 14:37:32
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [7:0] A,
    input [7:0] B,
    input BTNC, BTNU, BTND, BTNL, BTNR, 
    output [31:0] result
    );
    
    reg [31:0] result_temp;
    
    always@(*)
    begin
        case({BTNC, BTNU, BTND, BTNL, BTNR})
            5'b10000: result_temp = {24'd0,A} + {24'd0,B};
            5'b01000: result_temp = {24'd0,A} * {24'd0,B};
            5'b00100: result_temp = {24'd0,A} - {24'd0,B};
            5'b00010:
                begin
                    result_temp = {24'd0,A} | {24'd0,B};
                end
            5'b00001:
                begin
                    result_temp = {24'd0,A} & {24'd0,B}; 
                end
            default: result_temp = 32'h0000_0000;
        endcase
    end
    assign result = result_temp;
    
    
    
    
endmodule

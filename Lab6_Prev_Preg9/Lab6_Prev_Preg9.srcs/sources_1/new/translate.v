`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2017 03:51:42
// Design Name: 
// Module Name: translate
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


module translate(
    input [2:0] position_x,
    input [1:0] position_y,
    output reg [3:0] hex,
    output reg [2:0] control,  
    output reg type, //1 control, 0 hex
    output exe, ce 
    );
    
    assign exe = (position_x == 3'd4 & position_y == 2'd3);
    assign ce = (position_x == 3'd5 & position_y == 2'd2);
    
    always@(*)
        case({position_x,position_y})
            {3'd4,2'd0},{3'd4,2'd1},{3'd4,2'd2},{3'd5,2'd0},{3'd5,2'd1}: type = 1'b1;
            default: type = 1'b0;
        endcase
    
    always@(*)
        case({position_x,position_y})
            {3'd0,2'd0}: hex = 4'h0;
            {3'd0,2'd1}: hex = 4'h4;
            {3'd0,2'd2}: hex = 4'h8;
            {3'd0,2'd3}: hex = 4'hC;
            {3'd1,2'd0}: hex = 4'h1;
            {3'd1,2'd1}: hex = 4'h5;
            {3'd1,2'd2}: hex = 4'h9;
            {3'd1,2'd3}: hex = 4'hD;
            {3'd2,2'd0}: hex = 4'h2;
            {3'd2,2'd1}: hex = 4'h6;
            {3'd2,2'd2}: hex = 4'hA;
            {3'd2,2'd3}: hex = 4'hE;
            {3'd3,2'd0}: hex = 4'h3;
            {3'd3,2'd1}: hex = 4'h7;
            {3'd3,2'd2}: hex = 4'hB;
            {3'd3,2'd3}: hex = 4'hF;
            {3'd4,2'd0}: control = 3'd1; //SUMA
            {3'd4,2'd1}: control = 3'd3; // multiplicacion
            {3'd4,2'd2}: control = 3'd4; // and
            {3'd5,2'd0}: control = 3'd2; // resta
            {3'd5,2'd1}: control = 3'd5; // or
            default:
            begin
                hex = 4'h0;
                control = 3'd1;
            end
        endcase
endmodule

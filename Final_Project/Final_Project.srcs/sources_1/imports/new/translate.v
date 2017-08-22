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
    output reg send, sample, reset, grid, sample_time
    );
   
    always@(*)
    begin
        grid = 1'b0;
        sample_time = 1'b0;
        sample = 1'b0;
        send = 1'b0;
        reset = 1'b0; 
        case({position_x,position_y})
            {3'd1,2'd1}: grid = 1'b1;
            {3'd2,2'd1}: sample_time = 1'b1;
            {3'd1,2'd2}: sample = 1'b1;
            {3'd2,2'd2}: send = 1'b1;
            {3'd3,2'd2}: reset = 1'b1;
        endcase
    end
endmodule

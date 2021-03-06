`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2017 22:05:02
// Design Name: 
// Module Name: decodificador_7s
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


module decodificador_7s(
    input [3:0] hex,
    output reg [7:0] SEG
    );
always @(*) 
    begin
        case(hex)
            4'd0: SEG = 8'b00000011;
            4'd1: SEG = 8'b10011111; 
            4'd2: SEG = 8'b00100101;
            4'd3: SEG = 8'b00001101;
            4'd4: SEG = 8'b10011001;
            4'd5: SEG = 8'b01001001;
            4'd6: SEG = 8'b01000001;
            4'd7: SEG = 8'b00011111;
            4'd8: SEG = 8'b00000001;
            4'd9: SEG = 8'b00001001;
            4'd10: SEG = 8'b00010001;
            4'd11: SEG = 8'b11000001;
            4'd12: SEG = 8'b01100011;
            4'd13: SEG = 8'b10000101;
            4'd14: SEG = 8'b01100001;
            4'd15: SEG = 8'b01110001;
            default: SEG = 8'b11111111;
           endcase
    end
    
endmodule

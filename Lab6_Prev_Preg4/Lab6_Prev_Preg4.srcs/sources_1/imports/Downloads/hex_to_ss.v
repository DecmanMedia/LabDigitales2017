`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2017 02:22:29
// Design Name: 
// Module Name: SW_TO_7SEG
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


module hex_to_ss(input [3:0] hex,
    output reg [6:0] SEG
    );
    always@ (*) begin
        case(hex)      // diccionario de letra o cifra a mostrar
            4'h0: SEG = 7'b100_0000; // 0
            4'h1: SEG = 7'b111_1001; // 1
            4'h2: SEG = 7'b010_0100; // 2
            4'h3: SEG = 7'b011_0000; // 3
            4'h4: SEG = 7'b001_1001; // 4
            4'h5: SEG = 7'b001_0010; // 5
            4'h6: SEG = 7'b000_0010; // 6
            4'h7: SEG = 7'b111_1000; // 7
            4'h8: SEG = 7'b000_0010; // 8
            4'h9: SEG = 7'b001_0000; // 9
            4'h10: SEG = 7'b000_1000; // A
            4'h11: SEG = 7'b000_0011; // b
            4'h12: SEG = 7'b100_0110; // C
            4'h13: SEG = 7'b010_0001; // d
            4'h14: SEG = 7'b000_0110; // E
            6'h15: SEG = 7'b000_1110; // F
            default: SEG = 7'b111_1111; // nada
        endcase
    end
endmodule

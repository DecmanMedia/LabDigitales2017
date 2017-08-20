`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2017 15:53:07
// Design Name: 
// Module Name: Interfaz_Seba
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


 module Interfaz_Seba(
    input CLK82MHZ,
    input PS2_CLK,
    input PS2_DATA,
    input rst,
    output VGA_HS,
    output VGA_VS,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B
    );
    
    localparam NUMERO_DIGITOS = 8;
    
    localparam CUADRILLA_XI =         212;
    localparam CUADRILLA_XF =         812;
    
    localparam CUADRILLA_YI =         200;
    localparam CUADRILLA_YF =         500;
    
    wire [2:0]matrix_x;
    wire [1:0]matrix_y;
    
    wire hs, vs,hc_visible,vc_visible, lines;
    driver_vga_640x480 driver_vga(CLK82MHZ, hs, vs,hc_visible,vc_visible);
    template_6x4_600x400 template_30x20(CLK82MHZ, hc_visible, vc_visible, matrix_x, matrix_y, lines);
    
    
    
    
endmodule

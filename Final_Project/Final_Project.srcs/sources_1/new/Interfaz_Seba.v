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
    wire hs, vs, lines;
    wire [10:0] hc_visible,vc_visible;
    driver_vga_640x480 driver_vga(CLK82MHZ, VGA_HS, VGA_VS,hc_visible,vc_visible);
    template_6x4_600x400 template_30x20(CLK82MHZ, hc_visible, vc_visible, matrix_x, matrix_y, lines);
    
    wire in_sq_gr, in_sq_st, in_sq_sa, in_sq_se, in_sq_re;
    wire dr_gr, dr_st, dr_sa, dr_se, dr_re;
     
    //grid
    hello_world_text_square #(.MENU_X_LOCATION(11'd80), .MENU_Y_LOCATION(11'd80), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d10)) grid(CLK82MHZ, 1'b0,"Grid", hc_visible, vc_visible, in_sq_gr, dr_gr);
    
    //sample time
    hello_world_text_square #(.MENU_X_LOCATION(11'd725), .MENU_Y_LOCATION(11'd80), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d10)) s_time(CLK82MHZ, 1'b0,"Sample Time", hc_visible, vc_visible, in_sq_st, dr_st);
    
    //sample
    hello_world_text_square #(.MENU_X_LOCATION(11'd80), .MENU_Y_LOCATION(11'd580), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d10)) sample(CLK82MHZ, 1'b0,"Sample", hc_visible, vc_visible, in_sq_sa, dr_sa);
    
    //send
    hello_world_text_square #(.MENU_X_LOCATION(11'd400), .MENU_Y_LOCATION(11'd580), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d10)) send(CLK82MHZ, 1'b0,"Send", hc_visible, vc_visible, in_sq_se, dr_se);
    
    //reset
    hello_world_text_square #(.MENU_X_LOCATION(11'd710), .MENU_Y_LOCATION(11'd580), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d10)) reset(CLK82MHZ, 1'b0,"Reset", hc_visible, vc_visible, in_sq_re, dr_re);
    
    reg [11:0]VGA_COLOR;
    
    always@(*)
		if((hc_visible != 0) && (vc_visible != 0))
		begin
		    if(dr_gr == 1'b1 | dr_st == 1'b1 | dr_sa == 1'b1 | dr_se == 1'b1 | dr_re == 1'b1)
				VGA_COLOR = {12'h555};
			else if (in_sq_gr == 1'b1 | in_sq_st == 1'b1 | in_sq_sa == 1'b1 | in_sq_se == 1'b1 | in_sq_re == 1'b1)
				VGA_COLOR = {12'hFFF};
			else if((hc_visible > CUADRILLA_XI) && (hc_visible <= CUADRILLA_XF) && (vc_visible > CUADRILLA_YI) && (vc_visible <= CUADRILLA_YF))
				if(lines)
					VGA_COLOR = {12'h000};
			else
				VGA_COLOR = {12'h0BF};
		end
		else
			VGA_COLOR = {12'd0};

	assign {VGA_R, VGA_G, VGA_B} = VGA_COLOR;

    
endmodule

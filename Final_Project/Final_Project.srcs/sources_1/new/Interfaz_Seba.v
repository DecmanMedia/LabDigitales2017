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
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA,
    input rst,
    inout TMP_SCL, // comunicacion bidireccional clk
    inout TMP_SDA, // comunicacion bidireccional datos
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
    
    wire n_time, init, rdy, grilla, line;
    wire [15:0] temperatura;
    wire [4:0] muestra;
    
    Take_sample take_sample_inst
    (
        .CLK100MHZ(CLK100MHZ),
        .n_time(n_time), //cada cuanto tomar una muestra
        .init(init),
        .TMP_SCL(TMP_SCL), // comunicacion bidireccional clk
        .TMP_SDA(TMP_SDA), // comunicacion bidireccional datos
        .celcius(temperatura), //temperatura
        .n_sample(muestra), // numero de muestra
        .rdy(rdy) // "1" si esta lista la muestra
    );
    
    Grafico_Diego grafico_diego_inst
    (
        .hc_visible(hc_visible),
        .vc_visible(vc_visible),
        .CLK82MHZ(CLK82MHZ),
        .start(rdy),
        .reset(rst),
        .temperatura(temperatura),
        .muestra(muestra),
        .grilla(grilla),
        .line(line)
     );
  
    wire in_sq_gr, in_sq_st, in_sq_sa, in_sq_se, in_sq_re;
    wire dr_gr, dr_st, dr_sa, dr_se, dr_re;
     
    //grid
    hello_world_text_square #(.MENU_X_LOCATION(11'd40), .MENU_Y_LOCATION(11'd40), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d6)) grid(CLK82MHZ, 1'b0,"grid", hc_visible, vc_visible, in_sq_gr, dr_gr);
    
    //sample time
    hello_world_text_square #(.MENU_X_LOCATION(11'd625), .MENU_Y_LOCATION(11'd80), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d11)) s_time(CLK82MHZ, 1'b0,"sample time", hc_visible, vc_visible, in_sq_st, dr_st);
    
    //sample
    hello_world_text_square #(.MENU_X_LOCATION(11'd80), .MENU_Y_LOCATION(11'd580), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d6)) sample(CLK82MHZ, 1'b0,"sample", hc_visible, vc_visible, in_sq_sa, dr_sa);
    
    //send
    hello_world_text_square #(.MENU_X_LOCATION(11'd400), .MENU_Y_LOCATION(11'd580), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d6)) send(CLK82MHZ, 1'b0,"send", hc_visible, vc_visible, in_sq_se, dr_se);
    
    //reset
    hello_world_text_square #(.MENU_X_LOCATION(11'd710), .MENU_Y_LOCATION(11'd580), .MAX_NUMBER_LINES('d1), .MAX_CHARACTER_LINE('d6)) reset(CLK82MHZ, 1'b0,"reset", hc_visible, vc_visible, in_sq_re, dr_re);
    
    reg [11:0]VGA_COLOR;
    
    always@(*)
		if((hc_visible != 0) && (vc_visible != 0))
		begin
		    if(dr_gr == 1'b1 | dr_st == 1'b1 | dr_sa == 1'b1 | dr_se == 1'b1 | dr_re == 1'b1)
				VGA_COLOR = {12'h555};
			else if (in_sq_gr == 1'b1 | in_sq_st == 1'b1 | in_sq_sa == 1'b1 | in_sq_se == 1'b1 | in_sq_re == 1'b1)
				VGA_COLOR = {12'hFFF};
			//else if((hc_visible > CUADRILLA_XI) && (hc_visible <= CUADRILLA_XF) && (vc_visible > CUADRILLA_YI) && (vc_visible <= CUADRILLA_YF))
			else
				VGA_COLOR = {12'h0BF};
		end
		else
			VGA_COLOR = {12'd0};

	assign {VGA_R, VGA_G, VGA_B} = VGA_COLOR;
    
endmodule
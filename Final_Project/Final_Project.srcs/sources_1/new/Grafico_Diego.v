`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2017 15:53:07
// Design Name: 
// Module Name: Grafico_Diego
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


module Grafico_Diego(
    input hc_visible, vc_visible,
    input CLK82MHZ, start, reset,
    input [15:0] temperatura,
    input [4:0] muestra,
    output reg grilla, line);

    localparam CUADRILLA_XI =         212;
    localparam CUADRILLA_XF =         812;
    
    localparam CUADRILLA_YI =         200;
    localparam CUADRILLA_YF =         500;
    
    reg [15:0] storage [0:19];
    reg i, i_next;
    always@(*)
    if(start)
        storage[muestra]= temperatura;
    
    always@(*)
    begin
    if(vc_visible == CUADRILLA_YI + storage[i])
        if((hc_visible > CUADRILLA_XI * i*30) && (hc_visible < CUADRILLA_XI * i*30 + 30))
            line = 1'b1;
        else
            line = 1'b0;
    
    if(i==19)
        i_next = 0;
    else
        i_next = i + 1;
    end
    
    always@(posedge CLK82MHZ)
    if(reset)
    begin
        i <= 0;
        for(integer i; i<20; i=i+1)
            storage[i] <= 16'd0;
    end
    else
        i <= i_next;
        
            
    
endmodule

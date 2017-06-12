`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mauricio Solís
// 
// Create Date:    10:00:00 23/04/2015 
// Design Name: 
// Module Name:    display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: ssdec.v
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// The Cathodes Of FPGA displays may be inverted.
//////////////////////////////////////////////////////////////////////////////////
/*
* clk_display:		display cathodes select.
* num:		num to show in display
* type:		Cathode or Anode
* puntos:		The displays points led
* segmentos:		The segment to turn_on/off, in actual 7segment selected by anodos
* anodos:		Display control or cathodes/anodes select.
*/

`define COMMON_ANODE		0
`define COMMON_CATHODE		1


module display(clk_display,num,type,puntos,segmentos,anodos);
    input clk_display;
    input [31:0] num;
    input type;
    input [7:0]puntos;
    output [7:0]segmentos;
    output [7:0]anodos;

    reg [7:0]anodos_sig;
    reg [7:0]anodos_tmp;
    wire [3:0]val;
    wire pt;

     always@(*)
            case (anodos_tmp)// common_cathode
                8'b11111110:anodos_sig=8'b11111101;
                8'b11111101:anodos_sig=8'b11111011;
                8'b11111011:anodos_sig=8'b11110111;
                8'b11110111:anodos_sig=8'b11101111;
                8'b11101111:anodos_sig=8'b11011111;
                8'b11011111:anodos_sig=8'b10111111;
                8'b10111111:anodos_sig=8'b01111111;
                default:anodos_sig=8'b11111110;
            endcase
            

    always@(posedge clk_display)
        anodos_tmp<=anodos_sig;

    assign anodos=(type==`COMMON_CATHODE)?{~anodos_tmp}:anodos_tmp;//Por alguna extraña razón parece ser que los cátodos están negados.

    assign {val,pt,flag}=(anodos_tmp==8'b11111110)?{num[3:0],puntos[0],1'b0}:
                    (anodos_tmp==8'b11111101)?{num[7:4],puntos[1],1'b0}:
                    (anodos_tmp==8'b11111011)?{num[11:8],puntos[2],1'b0}:
					(anodos_tmp==8'b11110111)?{num[15:12],puntos[3],1'b0}:
					(anodos_tmp==8'b11101111)?{num[19:16],puntos[4],1'b0}:
					(anodos_tmp==8'b11011111)?{num[23:20],puntos[5],1'b0}:
					(anodos_tmp==8'b10111111)?{num[27:24],puntos[6],1'b0}:
					{num[31:28],puntos[7],num[31]};

    ssdec m_ssdec(val, pt, type, segmentos, flag);

endmodule

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
* clk:		display cathodes select.
* num:		num to show in display
* type:		Cathode or Anode
* pts:		The displays points led
* ssg:		The segment to turn_on/off, in actual 7segment selected by dctl
* dctl:		Display control or cathodes/anodes select.
*/

`define COMMON_ANODE		0
`define COMMON_CATHODE		1


module _32bit_7seg(clk,num,type,pts,ssg,dctl);
    input clk;
    input [31:0] num;
    input type;
    input [7:0]pts;
    output [7:0]ssg;
    output [7:0]dctl;

    reg [7:0]dctl_sig;
    reg [7:0]dctl_tmp;
    wire [3:0]val;
    wire pt;

     always@(*)
            case (dctl_tmp)// common_cathode
                8'b11111110:dctl_sig=8'b11111101;
                8'b11111101:dctl_sig=8'b11111011;
                8'b11111011:dctl_sig=8'b11110111;
                8'b11110111:dctl_sig=8'b11101111;
                8'b11101111:dctl_sig=8'b11011111;
                8'b11011111:dctl_sig=8'b10111111;
                8'b10111111:dctl_sig=8'b01111111;
                default:dctl_sig=8'b11111110;
            endcase
            

    always@(posedge clk)
        dctl_tmp<=dctl_sig;

    assign dctl=(type==`COMMON_CATHODE)?{~dctl_tmp}:dctl_tmp;//Por alguna extraña razón parece ser que los cátodos están negados.

    assign {val,pt,flag}=(dctl_tmp==8'b11111110)?{num[3:0],pts[0],1'b0}:
                    (dctl_tmp==8'b11111101)?{num[7:4],pts[1],1'b0}:
                    (dctl_tmp==8'b11111011)?{num[11:8],pts[2],1'b0}:
					(dctl_tmp==8'b11110111)?{num[15:12],pts[3],1'b0}:
					(dctl_tmp==8'b11101111)?{num[19:16],pts[4],1'b0}:
					(dctl_tmp==8'b11011111)?{num[23:20],pts[5],1'b0}:
					(dctl_tmp==8'b10111111)?{num[27:24],pts[6],1'b0}:
					{num[31:28],pts[7],num[31]};

    ssdec m_ssdec(val, pt, type, ssg, flag);

endmodule

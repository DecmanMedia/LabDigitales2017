////////////////////////////////////////////////////////////////////////////////
// ssdec.v -- seven segment decoder
//
// Author:  W. Freund, UTFSM, Valparaiso, Chile
//          03/16/06
////////////////////////////////////////////////////////////////////////////////
module ssdec(val, pt, type, ssg, flag); 
	input [3:0] val; 			// binary value
	input pt, flag , type; 			// point, display type (0: anode, 1: cathode), flag negativo (1: negativo)
	output [7:0] ssg;			// segments

	assign ssg = ((flag==1'b1)? 8'b1_1111_110 : (((type == 1) ? 8'h0 : 8'hff) ^ (
			(val == 0) ? {pt, 7'b1111110} :
			(val == 1) ? {pt, 7'b0110000} :
			(val == 2) ? {pt, 7'b1101101} :
			(val == 3) ? {pt, 7'b1111001} :
			(val == 4) ? {pt, 7'b0110011} :
			(val == 5) ? {pt, 7'b1011011} :
			(val == 6) ? {pt, 7'b1011111} :
			(val == 7) ? {pt, 7'b1110000} :
			(val == 8) ? {pt, 7'b1111111} : 
			(val == 9) ? {pt, 7'b1111011} :
			(val == 10) ? {pt, 7'b1110111} :
			(val == 11) ? {pt, 7'b0011111} :
			(val == 12) ? {pt, 7'b1001110} :
			(val == 13) ? {pt, 7'b0111101} :
			(val == 14) ? {pt, 7'b1001111} : 
			{pt, 7'b1000111})));

endmodule

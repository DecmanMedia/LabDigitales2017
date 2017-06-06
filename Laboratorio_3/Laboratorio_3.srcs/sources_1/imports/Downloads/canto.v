`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:43 05/13/2016 
// Design Name: 
// Module Name:    canto 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module canto(clock,entrada,salida);
	input clock, entrada;
	output salida;
	reg FF1 = 0,FF2 = 0;
	always @(posedge clock) begin
		FF1 <= entrada;
		FF2 <= FF1;
	end
	assign salida = (entrada & ~FF1 & ~FF2);

endmodule

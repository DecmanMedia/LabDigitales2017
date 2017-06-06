`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2017 15:40:03
// Design Name: 
// Module Name: Boton_LED
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


module Boton_LED(
    input BTNC, CLK100MHZ,
    output [2:0] JA
    );
    
    wire clk_nuevo1, clk_nuevo2, clk_nuevo3;
    
    //reg [5:0] count, count_next;
    //always@(*)begin
    //    if(count > (6'b111_111 - 6'd1))  
    //        count_next = 6'd0;
    //    else
    //        count_next = count + 6'd1;   
    //end
    
    //always@(posedge CLK100MHZ or posedge BTNC)
    //begin
    //    if(BTNC)
    //        count <= 6'd0;
    //    else
    //        count <= count_next;
    //end
    
    clk_nuevo inst
      (
      // Clock out ports  
      .clk_out1(clk_out1),
      .clk_out2(clk_out2),
      .clk_out3(clk_out3),
      // Status and control signals               
      .reset(BTNC), 
      .locked(0),
     // Clock in ports
      .clk_in1(CLK100MHZ)
      );
    
    assign JA[0] = clk_out1;
    assign JA[1] = clk_out2;
    assign JA[2] = clk_out3;
       
    
endmodule

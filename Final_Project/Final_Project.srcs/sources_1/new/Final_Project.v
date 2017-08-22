`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2017 15:51:39
// Design Name: 
// Module Name: Final_Project
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


module Final_Project(
    input CLK100MHZ,
    input SW,
    input PS2_CLK,
    input PS2_DATA,
    input rst,
    output VGA_HS,
    output VGA_VS,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B
    );
            
    wire CLK82MHZ;
            
    clk_wiz_0 inst(
    // Clock out ports  
    .clk_out1(CLK82MHZ),
    // Status and control signals               
    .reset(1'b0), 
    //.locked(locked),
    // Clock in ports
    .clk_in1(CLK100MHZ)
    );
    
    Interfaz_Seba interfaz_seba_inst(
    .CLK82MHZ(CLK82MHZ),
    .PS2_CLK(PS2_CLK),
    .PS2_DATA(PS2_DATA),
    .rst(rst),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_R(VGA_R),
    .VGA_G(VGA_G),
    .VGA_B(VGA_B)
    );
             
            
endmodule

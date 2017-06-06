`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2017 16:22:15
// Design Name: 
// Module Name: No_ALU
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


module lab_3_preg_4(
    input [15:0] SW,
    input BTNC, BTNU, BTND, BTNL, BTNR,
    input CLK100MHZ,
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] LED
    );
    wire clk,led_idle;
    wire [7:0] A, B;
    assign A = SW[15:8];
    assign B = SW[7:0];
    clock_divider clockcito(CLK100MHZ,1'b0,clk);
    
    reg [7:0] temp_A, temp_B;
    //reg [7:0] LED_temp;
    reg [31:0] display_temp;
    wire [31:0] result_temp;
    wire [31:0] result_bcd;
    always@(*)
        begin
        
        end
    
    ALU alucito(A, B, BTNC, BTNU, BTND, BTNL, BTNR, result_temp);
    LED ledcito (BTNC, BTNU, BTND, BTNL, BTNR, result_temp[7:0], LED);
    
    reg [31:0] result;
    reg flag_neg;
    
    always@(*)
        begin
            flag_neg = 1'b0;
            if({BTNC, BTNU, BTND, BTNL, BTNR} == 5'b00010 | {BTNC, BTNU, BTND, BTNL, BTNR} == 5'b00001)
                result = 32'h0000_0000;
            else if({BTNC, BTNU, BTND, BTNL, BTNR} == 5'b00100 & B > A)
                begin
                result = ~result_temp + 3'd1;
                flag_neg = 1'b1;
                end
            else
                result = result_temp;
        end
        
    
    double_dabble nose(clk,1'b1,result,led_idle,result_bcd);   
    _32bit_7seg displaycito(clk,{flag_neg,result_bcd[30:0]},1'b0,6'b000000,{CA, CB, CC, CD, CE, CF, CG},AN);
                
endmodule

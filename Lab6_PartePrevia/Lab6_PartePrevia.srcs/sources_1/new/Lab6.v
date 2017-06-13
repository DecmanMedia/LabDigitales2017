`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2017 16:12:50
// Design Name: 
// Module Name: Lab6
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
`define MAKE_CODE		3'b001
`define MAKE_CODE_E0	3'b010
`define BRAKE_CODE		3'b011
`define BRAKE_CODE_E0	3'b100

module Lab6(
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA,
    output kbs_tot,
    output make_code,
    output break_code,
    output is_enter,
    output kc, kd
    );
    assign {kc, kd} = {PS2_CLK,PS2_DATA};
    wire [2:0] data;
    wire [7:0] data_new;
    wire clk;
    
    clock_divider clock_divider_inst(
        .clk_in(CLK100MHZ),
        .rst(),
        .clk_out(clk)
        );
    
    kbd_ms kbd_ms_inst(
        .clk(clk),
        .rst(),
        .kd(PS2_DATA),
        .kc(PS2_CLK),
        .new_data(data_new),
        .data_type(data),
        .kbs_tot(kbs_tot),
        .parity_error()
        );
    
    assign make_code = ((data == `MAKE_CODE) || (data == `MAKE_CODE_E0));
    assign break_code = ((data == `BRAKE_CODE) || (data == `BRAKE_CODE_E0));
    assign is_enter = (data_new == 8'h5A);
        
endmodule

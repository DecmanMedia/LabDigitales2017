`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2017 02:47:40
// Design Name: 
// Module Name: cursor
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


module cursor #(parameter MAX_NUMBER = 4) (
    input CLK,
    input RST,
    input kbs_tot,
    input [7:0] data,
    input [2:0] data_type,
    output reg [2:0] position_x,
    output reg [1:0] position_y,
    output reg [4*MAX_NUMBER - 1:0] hex,
    output reg [2:0] control,
    output exe, ce
    );
    
    wire enter, up, down, right, left;
    assign enter = (kbs_tot & data_type == 3'b001 & data == 8'h5A);
    assign up = (kbs_tot & data_type == 3'b010 & data == 8'h75);
    assign down = (kbs_tot & data_type == 3'b010 & data == 8'h72);
    assign right = (kbs_tot & data_type == 3'b010 & data == 8'h74);
    assign left = (kbs_tot & data_type == 3'b010 & data == 8'h6B);
    
    localparam IDLE = 3'd1;
    localparam RIGHT = 3'd2;
    localparam LEFT = 3'd3;
    localparam DOWN = 3'd4;
    localparam UP = 3'd5;
    localparam ENTER = 3'd6;
    
    reg [2:0] state, state_next;
    always@(*)
    begin
        state_next = state;
        case(state)
            IDLE: state_next =  (up)? UP:
                                (down)? DOWN:
                                (right)? RIGHT:
                                (left)? LEFT: 
                                (enter)? ENTER: state;
            RIGHT: state_next = IDLE;
            LEFT: state_next = IDLE;
            UP: state_next = IDLE;
            DOWN: state_next = IDLE;
            ENTER: state_next = IDLE;
        endcase
    end
    
    wire type;
    wire [3:0] one_hex;
    wire [2:0] control_temp;
    translate translate_inst(position_x, position_y, one_hex, control_temp, type, exe, ce);
    
    reg [2:0] position_x_next;
    reg [1:0] position_y_next;
    reg [8:0] hex_next;
    reg [2:0] control_next;
    reg exe_next;
    
    always@(*)
    begin
        position_x_next = position_x;
        position_y_next = position_y;
        case(state)
            RIGHT: position_x_next = (position_x < 3'd5)? position_x + 3'd1: position_x;
            LEFT: position_x_next = (position_x > 3'd0)? position_x + 3'd1: position_x;
            UP: position_y_next = (position_y > 2'd0)? position_y - 2'd1: position_y;
            DOWN: position_y_next = (position_y < 2'd3)? position_y + 2'd1: position_y;
            ENTER:
            begin
                if(type)
                    control_next = control_temp;
                else
                    hex_next = {hex[3*MAX_NUMBER - 1: 3*MAX_NUMBER - 5],one_hex};   
            end
        endcase
    end
    
    
       
       
    always@(posedge CLK)
        if(RST)
        begin
            position_x <= 3'd0;
            position_y <= 2'd0;
            state <= IDLE;
            hex <= 'd0;
            control <= 3'd0;
        end
        else
        begin
            position_x <= position_x_next;
            position_y <= position_y_next;
            state <= state_next;
            hex <= hex_next;
            control <= control_next;     
        end
        
endmodule

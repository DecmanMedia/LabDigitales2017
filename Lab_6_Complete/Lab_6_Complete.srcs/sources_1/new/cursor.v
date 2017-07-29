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


module cursor #(parameter MAX_NUMBER = 8) (
    input CLK,
    input RST,
    input kbs_tot,
    input [7:0] data,
    input [2:0] data_type,
    output reg [2:0] position_x,
    output reg [1:0] position_y,
    output reg [4*MAX_NUMBER - 1:0] hex,
    output reg [2:0] control,
    output reg exe, ce
    );
    
    
    
    wire enter, up, down, right, left;
  
    assign enter = (kbs_tot && (data_type == 3'b001) && (data == 8'h5A));
    assign up = (kbs_tot && (data_type == 3'b001) && (data == 8'h75));
    assign down = (kbs_tot && (data_type == 3'b001) && (data == 8'h72));
    assign right = (kbs_tot && (data_type == 3'b010) && (data == 8'h74));
    assign left = (kbs_tot && (data_type == 3'b001) && (data == 8'h6B));
    
    localparam IDLE = 3'd1;
    localparam STATE_RIGHT = 3'd2;
    localparam STATE_LEFT = 3'd3;
    localparam STATE_DOWN = 3'd4;
    localparam STATE_UP = 3'd5;
    localparam STATE_ENTER = 3'd6;
    
    reg [2:0] state, state_next;
    always@(*)
    begin
        state_next = state;
        case(state)
            IDLE: state_next =  (up)? STATE_UP:
                                (down)? STATE_DOWN:
                                (right)? STATE_RIGHT:
                                (left)? STATE_LEFT: 
                                (enter)? STATE_ENTER: state;
            STATE_RIGHT: state_next = IDLE;
            STATE_LEFT: state_next = IDLE;
            STATE_UP: state_next = IDLE;
            STATE_DOWN: state_next = IDLE;
            STATE_ENTER: state_next = IDLE;
        endcase
    end
    
    wire type, exe_temp, ce_temp;
    wire [3:0] one_hex;
    wire [2:0] control_temp;
    
    
    translate translate_inst(position_x, position_y, one_hex, control_temp, type, exe_temp, ce_temp);
    
    reg [2:0] position_x_next;
    reg [1:0] position_y_next;
    reg [(4*MAX_NUMBER - 1):0] hex_next;
    reg [2:0] control_next;
    reg exe_next, ce_next;
    
    
    always@(*)
    begin
        position_x_next = position_x;
        position_y_next = position_y;
        hex_next = hex;
        exe_next = 1'b0;
        control_next = control;
        ce_next = 1'b0;
        case(state)
            STATE_DOWN: position_y_next = (position_y < 2'd3)? position_y + 2'd1: position_y;
            STATE_RIGHT: position_x_next = (position_x < 3'd5)? position_x + 3'd1: position_x;
            STATE_LEFT: position_x_next = (position_x > 3'd0)? position_x - 3'd1: position_x;
            STATE_UP: position_y_next = (position_y > 2'd0)? position_y - 2'd1: position_y;
            
            STATE_ENTER:
            begin
                if(position_x == 3'd4 & position_y == 2'd3)
                    exe_next = 1'b1;
                else if(ce_temp)
                    ce_next = 1;
                else if(type)
                    control_next = control_temp;
                else if(~type)
                    hex_next = {hex[4*MAX_NUMBER - 5: 0],one_hex};
            end
        endcase
    end
    
    
       
       
    always@(posedge CLK)
        if(RST)
        begin
            position_x <= 3'd2;
            position_y <= 2'd1;
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
            exe <= exe_next;
            ce <= ce_next;     
        end
        
endmodule

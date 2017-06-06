`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2017 15:47:22
// Design Name: 
// Module Name: UART_RX_CTRL
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


module UART_RX_CTRL(
    input [7:0] rx_data,
    input rx_ready, rst, clk,
    output tx_notice_me,
    output reg [15:0] tx_operador1,
    output reg [15:0] tx_operador2,
    output reg [2:0] tx_ALU_ctrl
    );
    
    localparam WAIT_OP1_LSB         = 4'd1;
    localparam STORE_OP1_LSB        = 4'd2;
    localparam WAIT_OP1_MSB         = 4'd3;
    localparam STORE_OP1_MSB        = 4'd4;
    localparam WAIT_OP2_LSB         = 4'd5;
    localparam STORE_OP2_LSB        = 4'd6;
    localparam WAIT_OP2_MSB         = 4'd7;
    localparam STORE_OP2_MSB        = 4'd8;
    localparam WAIT_CMD             = 4'd9;
    localparam STORE_CMD            = 4'd10;
    localparam DELAY_1_CYCLE        = 4'd11;
    localparam TRIGGER_TX_RESULT    = 4'd12;
    
    reg [2:0] state, next_state;
    reg [15:0] operador1, operador2;
    reg [2:0] operando;
    
    always@(*)
    begin
        next_state = state;
        tx_operador1 = operador1;
        tx_operador2 = operador2;
        tx_ALU_ctrl = operando;
        case(state)
            WAIT_OP1_LSB: if(rx_ready)
                            next_state= STORE_OP1_LSB;
                          else
                            next_state = state;
            
            STORE_OP1_LSB: next_state= WAIT_OP1_MSB;
            
            WAIT_OP1_MSB:   if(rx_ready)
                                next_state = STORE_OP1_MSB;
                            else
                                next_state = state;
            STORE_OP1_MSB: next_state = WAIT_OP2_LSB;
            
            WAIT_OP2_LSB: if(rx_ready)
                                next_state = STORE_OP2_LSB;
                          else
                                next_state = state;
            STORE_OP2_LSB: next_state = WAIT_OP2_MSB;
            
            WAIT_OP2_MSB: if(rx_ready)
                                next_state = STORE_OP2_MSB;
                          else
                                next_state = state;
            STORE_OP2_MSB: next_state = WAIT_CMD;
            
            WAIT_CMD:   if(rx_ready)
                                next_state = STORE_CMD;
                        else
                                next_state = state;
        
            STORE_CMD: next_state = DELAY_1_CYCLE;
            
            DELAY_1_CYCLE: next_state = TRIGGER_TX_RESULT;
            
            TRIGGER_TX_RESULT: next_state = WAIT_OP1_LSB;
        endcase
    end
                                
endmodule

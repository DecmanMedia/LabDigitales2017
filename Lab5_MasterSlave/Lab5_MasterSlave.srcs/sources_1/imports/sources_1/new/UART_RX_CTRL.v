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
    output reg [15:0] tx_operador1,
    output reg [15:0] tx_operador2,
    output reg [2:0] tx_ALU_ctrl,
    output reg state_alu,
    output reg [3:0] state
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
    
    reg [3:0] next_state;
    reg [15:0] tx_operador1_next,tx_operador2_next;
    reg [2:0] tx_ALU_ctrl_next;
    
    reg [7:0] primer, primer_next, segundo_next, segundo;
    
    always@(*)
    begin
        next_state = state;
        tx_operador1_next = tx_operador1;
        tx_operador2_next = tx_operador2;
        tx_ALU_ctrl_next = tx_ALU_ctrl;
        primer_next = primer;
        segundo_next = segundo;
        state_alu = 1'b0;
        case(state)
            WAIT_OP1_LSB: next_state = (rx_ready)? STORE_OP1_LSB: state;
            
            STORE_OP1_LSB:  begin
                            next_state= WAIT_OP1_MSB;
                            primer_next = rx_data;
                            end
            
            WAIT_OP1_MSB:   if(rx_ready)
                                next_state = STORE_OP1_MSB;
                            else
                                next_state = state;
            STORE_OP1_MSB:  begin
                            next_state = WAIT_OP2_LSB;
                            tx_operador1_next = { rx_data,primer};
                            
                            end
            
            WAIT_OP2_LSB: 
            begin
                
                next_state = (rx_ready)? STORE_OP2_LSB: state;
                
            end
            STORE_OP2_LSB:  begin
                            state_alu = 1'b1;
                            next_state = WAIT_OP2_MSB;
                            primer_next = rx_data;
                            end
            
            WAIT_OP2_MSB: if(rx_ready)
                                next_state = STORE_OP2_MSB;
                          else
                                next_state = state;
                                
            STORE_OP2_MSB:  begin
                            next_state = WAIT_CMD;
                            tx_operador2_next = {rx_data, primer};
                            
                            end
                            
            WAIT_CMD:   
            begin
                        
                        if(rx_ready)
                                next_state = STORE_CMD;
                        else
                                next_state = state;
            end
        
            STORE_CMD:  begin
                        next_state = DELAY_1_CYCLE;
                        tx_ALU_ctrl_next = rx_data[2:0];
                        state_alu = 1'b1;
                        end
            
            DELAY_1_CYCLE: 
            begin
                next_state = TRIGGER_TX_RESULT;
                state_alu = 1'b1;
            end
            
            TRIGGER_TX_RESULT:  begin
                                state_alu = 1'b1;
                                next_state = WAIT_OP1_LSB;
                                
                                end
        endcase
    end
    
    always@(posedge clk)
    begin
        if(rst)
            begin
            state <= WAIT_OP1_LSB;
            tx_ALU_ctrl <= 3'd0;
            tx_operador1 <= 16'd0;
            tx_operador2 <= 16'd0;
            primer <= 8'd0;
            segundo <= 8'd0;
            end
        else
            begin
            tx_ALU_ctrl <= tx_ALU_ctrl_next;
            tx_operador1 <= tx_operador1_next;
            tx_operador2 <= tx_operador2_next;
            primer <= primer_next;
            segundo <= segundo_next;
            state <= next_state;
            end
    end
                              
endmodule

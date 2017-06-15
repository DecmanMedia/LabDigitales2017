`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2017 23:02:42
// Design Name: 
// Module Name: module TX_sequence
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


module module_TX_sequence(
	input clock,
	input reset,
	input busy,           // Si esta alto, la UART se encuentra transmitiendo un dato
	output [1:0] stateID  // Indica en que estado de la secuencia esta para mostrarlo en los LEDs
    );
    
    reg[1:0] next_state, state; 

    //state encoding
    localparam IDLE 		 = 2'd0;  // Esperando dato
    localparam TX_OPERAND01  = 2'd1;  // Transmitiendo el primer operando
    localparam TX_OPERAND02  = 2'd2;  // Transmitiendo el segundo operando
    localparam TX_ALU_CTRL 	 = 2'd3;  // Transmitiendo la senal de control para la operacion

    assign stateID = state;
    
    // combo logic of FSM
    always@(*) begin
        //default assignments
        next_state = state;
    	
    	case (state)
    		IDLE: 	begin
						if(~busy) begin
							next_state=TX_OPERAND01;
						end
					end

            TX_OPERAND01: begin
							if(~busy) begin
								next_state=TX_OPERAND02;
							end								
						end
						
            TX_OPERAND02: begin
							if(~busy) begin
								next_state=TX_ALU_CTRL;
							end								
						end

            TX_ALU_CTRL: begin
                            if(~busy) begin
                                next_state=IDLE;
                            end
						end	
    	endcase
    end	

    //when clock ticks, update the state
    always@(posedge clock) begin
    	if(reset)
    		state <= IDLE;
    	else
    		state <= next_state;
	end
	
endmodule


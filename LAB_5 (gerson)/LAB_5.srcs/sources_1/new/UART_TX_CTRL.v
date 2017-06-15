`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2017 01:03:07
// Design Name: 
// Module Name: UART_TX_CTRL
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


module UART_TX_CTRL
#(	parameter INTER_BYTE_DELAY = 1000000,   // ciclos de reloj de espera entre el envio de 2 bytes consecutivos
	parameter WAIT_FOR_REGISTER_DELAY = 100 // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
)(
	input clk,
	input rst,
	input flag,                  // Indica si se recibio el resultado.
	input [15:0] dataIn16,     // Dato que se desea transmitir de 16 bits
	output reg [7:0] tx_data,  // Datos entregados al driver UART para transmision
	output reg tx_start,       // Pulso para iniciar transmision por la UART
	output reg new_tx_busy            // Indica si hay una transmision en proceso
    );
    
 
    reg [2:0]   next_state, state; 
    reg [15:0]  tx_data16;
    reg [31:0]  hold_state_timer;
   assign estado = state;   
    //state encoding
    localparam IDLE 				= 3'd5;  // Modo espera
    localparam REGISTER_DATAIN16 	= 3'd1;  // Cuando se presiona boton, registrar 16 bits a enviar
    localparam SEND_BYTE_0 			= 3'd2;  // Enviar el primer byte
    localparam DELAY_BYTE_0 		= 3'd3;  // Esperar un tiempo suficiente para que la transmision anterior termine
    localparam SEND_BYTE_1 			= 3'd4;  // Si es necesario, enviar el segundo byte
    localparam DELAY_BYTE_1 		= 3'd0;	 // Esperar a que la transmision anterior termine
    
    // combo logic of FSM
    always@(*) begin
        //default assignments
        next_state = state;
		new_tx_busy = 1'b1;
		tx_start = 1'b0;
		tx_data = tx_data16[7:0];
    	
    	case (state)
    		IDLE: 	begin
						new_tx_busy = 1'b0;
						if(flag==1'b1) begin
							next_state=REGISTER_DATAIN16;
						end
					end

			REGISTER_DATAIN16:  begin
			                         if(hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
				                        next_state=SEND_BYTE_0;				
					               end
            SEND_BYTE_0:	begin
								next_state = DELAY_BYTE_0;
								tx_start = 1'b1;
							end
            DELAY_BYTE_0: 	begin
								tx_data = tx_data16[15:8];
								if(hold_state_timer >= INTER_BYTE_DELAY) begin
										next_state = SEND_BYTE_1;								
								end
							end
            SEND_BYTE_1: begin
                        tx_data = tx_data16[15:8];
						next_state = DELAY_BYTE_1;
						tx_start = 1'b1;
					end								
			DELAY_BYTE_1: begin
						if(hold_state_timer >= INTER_BYTE_DELAY)
							next_state = IDLE;
					end	
    	endcase
    end	

    //when clock ticks, update the state
    always@(posedge clk) begin
    	if(rst)
    		state <= IDLE;
    	else
    		state <= next_state;
	end
	
	// registra los datos a enviar
	always@ (posedge clk) begin
		if(state == REGISTER_DATAIN16)
			tx_data16 <= dataIn16;
	end
	
	//activa timer para retener un estado por cierto numero de ciclos de reloj
	always@(posedge clk) begin
    	if(state == DELAY_BYTE_0 || state == DELAY_BYTE_1 || state == REGISTER_DATAIN16) begin
    		hold_state_timer <= hold_state_timer + 1;
    	end else begin
    		hold_state_timer <= 0;
    	end
	end

endmodule
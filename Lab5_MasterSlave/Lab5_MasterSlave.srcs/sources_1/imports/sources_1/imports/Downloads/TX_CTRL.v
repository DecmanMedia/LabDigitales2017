module TX_CTRL
#(	parameter INTER_BYTE_DELAY = 1000000,   // ciclos de reloj de espera entre el envio de 2 bytes consecutivos
	parameter WAIT_FOR_REGISTER_DELAY = 100 // tiempo de espera para iniciar la transmision luego de registrar el dato a enviar
)(
	input [15:0] resultOut16,
	input clk,
	input rst, ready,
	output reg [7:0] tx_data,
	output reg tx_start, tx_busy
);
	reg [2:0] state, state_next;
	reg [15:0] tx_data16;
	reg [31:0]  hold_state_timer;

	
	
	localparam REGISTRAR = 3'd1;
	localparam SEND_BYTE_0 = 3'd2;
	localparam DELAY_0 = 3'd3;
	localparam SEND_BYTE_1 = 3'd4;
	localparam DELAY_1 = 3'd5;
	localparam IDLE = 3'd6;
	
	always@(*)begin
		state_next = state;
		tx_data = tx_data16[7:0];
		tx_start = 1'b0;
		tx_busy = 1'b1;
		case(state)
		    IDLE:
		    begin
		          tx_busy = 1'b0;
		          state_next = (ready)? REGISTRAR: state;
		    end
			REGISTRAR: begin
				if (hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
					state_next = SEND_BYTE_0;
				else
					state_next = state;
			end
			SEND_BYTE_0: begin
				tx_start = 1'b1;
				state_next = DELAY_0;
			end
			DELAY_0: begin
				tx_data = tx_data16[15:8];
				if(hold_state_timer >= INTER_BYTE_DELAY)
					state_next = SEND_BYTE_1;
				else
					state_next = state;

			end
			SEND_BYTE_1: begin
				tx_data = tx_data16[15:8];
				tx_start = 1'b1;
				state_next = DELAY_1;
			end
			DELAY_1:
			begin
			     tx_data = tx_data16[15:8];
		         if (hold_state_timer >= WAIT_FOR_REGISTER_DELAY)
					state_next = IDLE;
				 else
					state_next = state;
			
			end
		endcase
	end
	
	always@(posedge clk)
	   if(state == REGISTRAR)
	       tx_data16 = resultOut16;
	       
	
	always@(posedge clk)
	begin
	   if(rst)
	       state <= IDLE;
	   else
		   state <= state_next;
	
	end
	
	//activa timer para retener un estado por cierto numero de ciclos de reloj
	always@(posedge clk) begin
    	if(state == DELAY_0 || state == DELAY_1 || state == REGISTRAR) begin
    		hold_state_timer <= hold_state_timer + 1;
    	end else begin
    		hold_state_timer <= 0;
    	end
	end
	
endmodule
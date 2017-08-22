//los odio a todos
//Pero no todo el tiempo
//aveces solo los desprecio


module Take_sample
(
	input CLK100MHZ,
	input n_time, //cada cuanto tomar una muestra
	input init,
	inout TMP_SCL, // comunicacion bidireccional clk
	inout TMP_SDA, // comunicacion bidireccional datos
	output [15:0] celcius, //temperatura
	output [4:0] n_sample, // numero de muestra
	output rdy, // "1" si esta lista la muestra
	output [15:0] bcd

);
	wire [12:0] temperatura;
	reg [16:0] n_total; // 
	reg [16:0] cuenta, cuenta_n;
	reg [5:0] reg_n_sample;
	reg [1:0] state, state_next;
	reg take_sample;
	
	localparam S_WAIT = 'b01;
	localparam S_TAKE = 'b10;
	

	TempSensorCtl insttempPort (
		.TMP_SCL(TMP_SCL),// Linea de reloj para el sensor de temperatura
		.TMP_SDA(TMP_SDA),// Linea de datos para el sensor de temperatura		
		.TEMP_O(temperatura),// Temperatura en 13 bits, donde el mas significativo corresponde al signo de la temperatura
		.RDY_O(ready),// '1' cuando hay un valor de temperatura listo para leer
		.ERR_O(error),// '1' si es que hay un error de comunicacion
		
		.CLK_I(CLK100MHZ),// Reloj para el medidor de templeratura
		.SRST_I(1'b0)// //Senial de reset
	);
	
	always@(*)begin
		state_next = state;
		
		case(state)
		S_WAIT: begin
			take_sample = 1'b0;
			cuenta_n = 17'd0;
			reg_n_sample = 5'd0;
			if(init) begin
				state_next = S_TAKE;
			end
		end
		S_TAKE: begin
			cuenta_n = cuenta + 1;
			if(n_sample < 5'd20) begin
				if(n_total == n_time)begin
					take_sample = 1'b1;
					reg_n_sample = n_sample + 1;
				end
				else if(cuenta == 17'd100_000)begin
					n_total = n_total+1;
					cuenta_n = 17'd0;
				end
			end
			else
				state_next = S_WAIT;


	   end
	   endcase
    end

	always@(posedge CLK100MHZ)begin
		
		cuenta <= cuenta_n;		
	
	end
//Transformar la temperatura a BCD para mostrarla en el display
        wire convertir;
        assign  convertir = (idle)?1'd1:1'd0;
        unsigned_to_bcd utb_inst(
            .clk(CLK100MHZ),            // Reloj
            .trigger(convertir),        // Inicio de conversión
            .in({16'd0,tmp_celcius_adaptado_para_pantalla}),          // Número binario de entrada
            .idle(idle),      // Si vale 0, indica una conversión en proceso
            .bcd(bcd) 
        );



	// se asignas las salidas
	assign celcius = (temperatura[11:0]*10)>>4; 
	assign rdy = ((take_sample == 1'b1))?1:0;
	assign n_sample = reg_n_sample;

endmodule


module lab_6(
	input CLK100MHZ,
	input [15:0]SW,
	input PS2_CLK,
	input PS2_DATA,
	input rst,
	output VGA_HS,
	output VGA_VS,
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B
	);
	
	localparam NUMERO_DIGITOS = 4;
	
	localparam CUADRILLA_XI = 		212;
	localparam CUADRILLA_XF = 		812;
	
	localparam CUADRILLA_YI = 		184;
	localparam CUADRILLA_YF = 		584;
	
	wire [10:0]vc_visible,hc_visible;
	wire CLK82MHZ;
	
	clk_wiz_0 inst(
		// Clock out ports  
		.clk_out1(CLK82MHZ),
		// Status and control signals               
		.reset(1'b0), 
		//.locked(locked),
		// Clock in ports
		.clk_in1(CLK100MHZ)
		);
	
	wire kbs_tot;
    wire [7:0] data;
    wire [2:0] data_type;
    wire parity_error;	
    
	driver_vga_640x480 m_driver(CLK82MHZ, VGA_HS, VGA_VS,hc_visible,vc_visible);
	//driver_vga_1024x768 m_driver(CLK82MHZ, VGA_HS, VGA_VS, hc_visible, vc_visible);
	kbd_ms m_kd(CLK82MHZ, 1'b0, PS2_DATA, PS2_CLK, data, data_type, kbs_tot, parity_error);
	
	localparam OPERADOR1 = 3'd1;
	localparam OPERADOR2 = 3'd2;
	localparam CONTROL = 3'd3;
	localparam RESULTADO = 3'd4;
	
	
	reg [2:0] state, next_state;
	wire enter, exe, ce;
    wire [2:0] position_x;
    wire [1:0] position_y;
    wire [4*NUMERO_DIGITOS - 1:0] hex;
    wire [2:0] control;
	
	cursor cursor_inst(CLK82MHZ, rst, kbs_tot, data, data_type, position_x, position_y, hex, control, exe, ce);
	always@(*)
	begin
	   next_state = state;
	   case(state)
	       OPERADOR1: next_state = (exe)? OPERADOR2: state;
	       OPERADOR2: next_state = (exe)? CONTROL: state;
	       CONTROL: next_state = (exe)? RESULTADO: state;
	       RESULTADO: next_state = (exe)? OPERADOR1: state;
	   endcase
    end
	wire [10:0]hc_template, vc_template;
	wire [2:0]matrix_x;
	wire [1:0]matrix_y;
	wire lines;
	wire [23:0] in_square_n,in_character_n;
	
	localparam digito_x = 11'd262;
	localparam digito_y = 11'd210;
	localparam length = 11'd100;
	
	template_6x4_600x400 template_1(CLK82MHZ, hc_visible, vc_visible, matrix_x, matrix_y, lines);
	show_one_char #(.MENU_X_LOCATION(digito_x), .MENU_Y_LOCATION(digito_y)) cero(CLK82MHZ, rst, hc_visible, vc_visible, "0", in_square_n[0], in_character_n[0]);
	show_one_char #(.MENU_X_LOCATION(digito_x + length), .MENU_Y_LOCATION(digito_y)) uno(CLK82MHZ, rst, hc_visible, vc_visible, "1", in_square_n[1], in_character_n[1]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 2*length), .MENU_Y_LOCATION(digito_y)) dos(CLK82MHZ, rst, hc_visible, vc_visible, "2", in_square_n[2], in_character_n[2]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 3*length), .MENU_Y_LOCATION(digito_y)) tres(CLK82MHZ, rst, hc_visible, vc_visible, "3", in_square_n[3], in_character_n[3]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 4*length), .MENU_Y_LOCATION(digito_y)) mas(CLK82MHZ, rst, hc_visible, vc_visible, "+", in_square_n[16], in_character_n[16]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 5*length), .MENU_Y_LOCATION(digito_y)) menos(CLK82MHZ, rst, hc_visible, vc_visible, "-", in_square_n[17], in_character_n[17]);
    show_one_char #(.MENU_X_LOCATION(digito_x), .MENU_Y_LOCATION(digito_y + length)) cuatro(CLK82MHZ, rst, hc_visible, vc_visible, "4", in_square_n[4], in_character_n[4]);
    show_one_char #(.MENU_X_LOCATION(digito_x + length), .MENU_Y_LOCATION(digito_y + length)) cinco(CLK82MHZ, rst, hc_visible, vc_visible, "5", in_square_n[5], in_character_n[5]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 2*length), .MENU_Y_LOCATION(digito_y + length)) seis(CLK82MHZ, rst, hc_visible, vc_visible, "6", in_square_n[6], in_character_n[6]); 
    show_one_char #(.MENU_X_LOCATION(digito_x + 3*length), .MENU_Y_LOCATION(digito_y + length)) siete(CLK82MHZ, rst, hc_visible, vc_visible, "7", in_square_n[7], in_character_n[7]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 4*length), .MENU_Y_LOCATION(digito_y + length)) multp(CLK82MHZ, rst, hc_visible, vc_visible, "*", in_square_n[18], in_character_n[18]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 5*length), .MENU_Y_LOCATION(digito_y + length)) _or(CLK82MHZ, rst, hc_visible, vc_visible, "|", in_square_n[19], in_character_n[19]);
    show_one_char #(.MENU_X_LOCATION(digito_x), .MENU_Y_LOCATION(digito_y + 2*length)) ocho(CLK82MHZ, rst, hc_visible, vc_visible, "8", in_square_n[8], in_character_n[8]); 
    show_one_char #(.MENU_X_LOCATION(digito_x + length), .MENU_Y_LOCATION(digito_y + 2*length)) nueve(CLK82MHZ, rst, hc_visible, vc_visible, "9", in_square_n[9], in_character_n[9]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 2*length), .MENU_Y_LOCATION(digito_y + 2*length)) a(CLK82MHZ, rst, hc_visible, vc_visible, "a", in_square_n[10], in_character_n[10]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 3*length), .MENU_Y_LOCATION(digito_y + 2*length)) b(CLK82MHZ, rst, hc_visible, vc_visible, "b", in_square_n[11], in_character_n[11]);
    show_one_char #(.MENU_X_LOCATION(digito_x + 4*length), .MENU_Y_LOCATION(digito_y + 2*length)) _and(CLK82MHZ, rst, hc_visible, vc_visible, "&", in_square_n[20], in_character_n[20]);
    show_one_line #(.MENU_X_LOCATION(digito_x + 5*length), .MENU_Y_LOCATION(digito_y + 2*length), .MAX_CHARACTER_LINE(2)) _ce(CLK82MHZ, rst, hc_visible, vc_visible, "ce", in_square_n[21], in_character_n[21]);
    show_one_char #(.MENU_X_LOCATION(digito_x), .MENU_Y_LOCATION(digito_y + 3*length)) c(CLK82MHZ, rst, hc_visible, vc_visible, "c", in_square_n[12], in_character_n[12]);
    show_one_char #(.MENU_X_LOCATION(digito_x + length), .MENU_Y_LOCATION(digito_y + 3*length)) d(CLK82MHZ, rst, hc_visible, vc_visible, "d", in_square_n[13], in_character_n[13]); 
    show_one_char #(.MENU_X_LOCATION(digito_x + 2*length), .MENU_Y_LOCATION(digito_y + 3*length)) e(CLK82MHZ, rst, hc_visible, vc_visible, "e", in_square_n[14], in_character_n[14]); 
    show_one_char #(.MENU_X_LOCATION(digito_x + 3*length), .MENU_Y_LOCATION(digito_y + 3*length)) f(CLK82MHZ, rst, hc_visible, vc_visible, "f", in_square_n[15], in_character_n[15]);
    show_one_line #(.MENU_X_LOCATION(digito_x + 4*length - 11'd46), .MENU_Y_LOCATION(digito_y + 3*length), .MAX_CHARACTER_LINE(3)) _exe(CLK82MHZ, rst, hc_visible, vc_visible, "exe", in_square_n[22], in_character_n[22]);
     	
	reg [11:0]VGA_COLOR;
	
	wire in_sq, dr;
	hello_world_text_square #(.MENU_X_LOCATION(11'd384), .MENU_Y_LOCATION(11'd80)) m_hw(CLK82MHZ, 1'b0,"00000", hc_visible, vc_visible, in_sq, dr);
	
	always@(*)
		if((hc_visible != 0) && (vc_visible != 0))
		begin
		    if(|in_character_n)
		        VGA_COLOR = {12'h000};
			else if(dr == 1'b1)
				VGA_COLOR = {12'h555};
			else if (in_sq == 1'b1)
				VGA_COLOR = {12'hFFF};
			else if((hc_visible > CUADRILLA_XI) && (hc_visible <= CUADRILLA_XF) && (vc_visible > CUADRILLA_YI) && (vc_visible <= CUADRILLA_YF))
				if(lines)
					VGA_COLOR = {12'h000};
				else 
					VGA_COLOR = (matrix_x == position_x & matrix_y == position_y)? 12'hE77 : 12'h707; //{3'h7: {2'b0, matrix_x} + {3'b00, matrix_y}, 4'h3};
			else
				VGA_COLOR = {12'h00F};
		end
		else
			VGA_COLOR = {12'd0};

	assign {VGA_R, VGA_G, VGA_B} = VGA_COLOR;
	
endmodule

module lab_6(
	input CLK100MHZ,
	input SW,
	input PS2_CLK,
	input PS2_DATA,
	input rst,
	output VGA_HS,
	output VGA_VS,
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B,
	output [2:0] LED
	);
	
	localparam NUMERO_DIGITOS = 8;
	
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
    
    wire [(NUMERO_DIGITOS*8)-1:0] char, char_resultado;
    reg [(NUMERO_DIGITOS*8)-1:0] char_op1, char_op2,char_op2_next,char_op1_next;
    
    
	driver_vga_640x480 m_driver(CLK82MHZ, VGA_HS, VGA_VS,hc_visible,vc_visible);
	//driver_vga_1024x768 m_driver(CLK82MHZ, VGA_HS, VGA_VS, hc_visible, vc_visible);
	kbd_ms m_kd(CLK82MHZ, 1'b0, PS2_DATA, PS2_CLK, data, data_type, kbs_tot, parity_error);
	
	localparam OPERADOR1_STATE = 3'd1;
	localparam OPERADOR2_STATE = 3'd2;
	localparam CONTROL_STATE = 3'd3;
	localparam RESULTADO_STATE = 3'd4;
	
	reg hexadec = 0;
	
	reg [2:0] state, next_state;
	wire enter, exe, ce;
    wire [2:0] position_x;
    wire [1:0] position_y;
    wire [4*NUMERO_DIGITOS - 1:0] hex;
    wire [2:0] control;
    reg hexdec, next_hexdec; //hex=0, dec = 1;
    
    
    
	//assign exe = kbs_tot && (data == 8'h5A) && (data_type == 3'b001) && ((position_x == 3'd4) && (position_y == 2'd3));
	cursor cursor_inst(CLK82MHZ, rst, kbs_tot, data, data_type, position_x, position_y, hex, control, exe , ce);
	
	
	always@(*)
	begin
	   next_state = state;
	   case(state)
	       OPERADOR1_STATE: next_state = (exe)? OPERADOR2_STATE: state;
	       OPERADOR2_STATE: next_state = (exe)? CONTROL_STATE: state;
	       CONTROL_STATE: next_state = (exe)? RESULTADO_STATE: state;
	       RESULTADO_STATE: next_state = (exe)? OPERADOR1_STATE: state;
	   endcase
    end
    
        reg [31:0] operador1, operador1_next, operador2, operador2_next, resultado, resultado_next;
        reg [2:0] ALU_ctrl, ALU_ctrl_next; 
        
        wire [31:0] result_hex, result_dec;
        wire [3:0] flags;
        ALU inst_ALU(operador1, operador2, ALU_ctrl, result_hex, flags);
        
        double_dabble inst_double_dabble(
            .clk(CLK82MHZ),
            .trigger(),
            .in(result_hex),
            .idle(),
            .bcd(result_dec)
            );
                     
        always@(*)
        begin
           operador1_next = operador1;
           operador2_next = operador2;
           ALU_ctrl_next = ALU_ctrl;
           resultado_next = resultado;
           next_hexdec = hexdec;
           case(state)
               OPERADOR1_STATE: 
               begin
                operador1_next = hex; 
                next_hexdec = SW;
                char_op1_next = char;
               end
               OPERADOR2_STATE: 
               begin
                operador2_next = hex;
                char_op2_next = char;
               end
               CONTROL_STATE: ALU_ctrl_next = control;
               RESULTADO_STATE: resultado_next = (hexdec)? result_dec: result_hex;
           endcase
        end
        
        always@(posedge CLK82MHZ)
            if(rst)
            begin
                operador1 <= 'd0;
                operador2 <= 'd0;
                ALU_ctrl <= 'd0;
                state <= OPERADOR1_STATE;
                hexdec <= 1'b1;
                resultado <= 'd0;
                char_op2 <= "00000000";
                char_op1 <= "00000000";
            end
            else
            begin
                operador1 <= operador1_next;
                operador2 <= operador2_next;
                ALU_ctrl <= ALU_ctrl_next;
                state <= next_state;
                hexdec <= next_hexdec;
                resultado <= resultado_next;
                char_op2 <= char_op2_next;
                char_op1 <= char_op1_next;
            end
    
    numba_to_string char_inst(hex, char);
    numba_to_string result_char_inst(resultado, char_resultado);  
        
	wire [10:0]hc_template, vc_template;
	wire [2:0]matrix_x;
	wire [1:0]matrix_y;
	wire lines;
	wire [23:0] in_square_n,in_character_n;
	wire in_character_hex, in_character_dec;
	
	localparam digito_x = 11'd247;
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
    show_one_line #(.MENU_X_LOCATION(digito_x + 5*length), .MENU_Y_LOCATION(digito_y + 2*length), .MAX_CHARACTER_LINE(2), .ancho_pixel('d5)) _ce(CLK82MHZ, rst, hc_visible, vc_visible, "ce", in_square_n[21], in_character_n[21]);
    show_one_char #(.MENU_X_LOCATION(digito_x), .MENU_Y_LOCATION(digito_y + 3*length)) c(CLK82MHZ, rst, hc_visible, vc_visible, "c", in_square_n[12], in_character_n[12]);
    show_one_char #(.MENU_X_LOCATION(digito_x + length), .MENU_Y_LOCATION(digito_y + 3*length)) d(CLK82MHZ, rst, hc_visible, vc_visible, "d", in_square_n[13], in_character_n[13]); 
    show_one_char #(.MENU_X_LOCATION(digito_x + 2*length), .MENU_Y_LOCATION(digito_y + 3*length)) e(CLK82MHZ, rst, hc_visible, vc_visible, "e", in_square_n[14], in_character_n[14]); 
    show_one_char #(.MENU_X_LOCATION(digito_x + 3*length), .MENU_Y_LOCATION(digito_y + 3*length)) f(CLK82MHZ, rst, hc_visible, vc_visible, "f", in_square_n[15], in_character_n[15]);
    show_one_line #(.MENU_X_LOCATION(digito_x + 4*length - 11'd20), .MENU_Y_LOCATION(digito_y + 3*length), .MAX_CHARACTER_LINE(3), .ancho_pixel('d5)) _exe(CLK82MHZ, rst, hc_visible, vc_visible, "exe", in_square_n[22], in_character_n[22]);
   
    wire in_sq, dr,in_sq_h, dr_h;  
    hello_world_text_square #(.MENU_X_LOCATION(11'd762), .MENU_Y_LOCATION(11'd30), .MAX_CHARACTER_LINE(6)) m_hexdec(CLK82MHZ, 1'b0,{"hex",((hexdec)? " ":"*")},{"dec",((hexdec)? "*":" ")},{(flags[0])?"v":" ",(flags[1])?"c":" ",(flags[2])?"n":" ",(flags[3])?"z":" "}, hc_visible, vc_visible, in_sq_h, dr_h);
    //show_one_line #(.MENU_X_LOCATION(11'd762), .MENU_Y_LOCATION(11'd134), .MAX_CHARACTER_LINE(3), .ancho_pixel('d5)) hex_char(CLK82MHZ, rst, hc_visible, vc_visible, "hex", , in_character_hex);     	
	reg [11:0]VGA_COLOR;
	
	hello_world_text_square #(.MENU_X_LOCATION(11'd364), .MENU_Y_LOCATION(11'd30)) m_hw(CLK82MHZ, 1'b0,{(state==OPERADOR1_STATE)?char:char_op1," op1"},{char_op2," op2"},{char_resultado," res"}, hc_visible, vc_visible, in_sq, dr);
	
	always@(*)
		if((hc_visible != 0) && (vc_visible != 0))
		begin
		    if(|in_character_n)
		        VGA_COLOR = {12'h000};
			else if(dr == 1'b1 | dr_h == 1'b1)
				VGA_COLOR = {12'h555};
			else if (in_sq == 1'b1 | in_sq_h == 1'b1)
				VGA_COLOR = {12'hFFF};
			else if((hc_visible > CUADRILLA_XI) && (hc_visible <= CUADRILLA_XF) && (vc_visible > CUADRILLA_YI) && (vc_visible <= CUADRILLA_YF))
				if(lines)
					VGA_COLOR = {12'h000};
				else 
					VGA_COLOR = (matrix_x == position_x & matrix_y == position_y)? 12'hE77 : {3'h3, {2'b0, matrix_x} + {3'b00, matrix_y}, 4'h1};
			else
				VGA_COLOR = {12'h0BF};
		end
		else
			VGA_COLOR = {12'd0};

	assign {VGA_R, VGA_G, VGA_B} = VGA_COLOR;
	
	assign LED = state;
	
endmodule

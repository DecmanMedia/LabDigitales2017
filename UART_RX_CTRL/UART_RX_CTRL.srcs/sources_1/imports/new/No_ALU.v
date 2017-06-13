`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2017 16:22:15
// Design Name: 
// Module Name: No_ALU
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


module lab_4(
    input [15:0] operando1,
    input [15:0] operando2,
    input [2:0] ALU_ctrl,
    input CLK100MHZ,CPU_RESETN,
    input state,
    output [15:0] result,
    output DP, CA, CB, CC, CD, CE, CF, CG,
    output [7:0] AN
    );
    //Creacion de Reloj 200 Hz
    wire clk;
    clock_divider clockcito(CLK100MHZ,1'b0,clk);

        
    wire [31:0] result_bcd;
    reg [2:0] LED_RGB;
    reg [2:0] estado_actual, estado_sig;
    
        
    
    localparam ESPERANDO_OPERADOR1 = 3'b001;
    localparam ESPERANDO_OPERADOR2 = 3'b011;
    localparam ESPERANDO_OPERACION = 3'b101;
    localparam MOSTRAR_RESULTADO  = 3'b111;
    
    always@(*)
    begin
        //estado_sig = estado_actual;
        case(estado_actual)
            ESPERANDO_OPERADOR1: estado_sig = (state)? ESPERANDO_OPERADOR2:ESPERANDO_OPERADOR1;
            ESPERANDO_OPERADOR2: estado_sig = (state)? ESPERANDO_OPERACION: ESPERANDO_OPERADOR2;
            ESPERANDO_OPERACION: estado_sig = (state)? MOSTRAR_RESULTADO: ESPERANDO_OPERACION;
            MOSTRAR_RESULTADO: estado_sig = (state)? ESPERANDO_OPERADOR1: MOSTRAR_RESULTADO;
            default: estado_sig = ESPERANDO_OPERADOR1;          
        endcase
    end
    //Variables que registran operadores, operador y display
    reg [15:0] A,A_next,B, B_next;
    reg [2:0] operador,operador_next;
    reg [31:0] input_display;
    
    //Acciones segun estado
    always@(*)
    begin
        //Default
        input_display = 32'd0;
        operador_next = operador;
        LED_RGB = 3'd0;
        A_next = A;
        B_next = B;
        case(estado_actual)
            ESPERANDO_OPERADOR1: 
            begin
                B_next = 16'd0;
                A_next = operando1;
                input_display = {16'd0,operando1};
            end
            
            ESPERANDO_OPERADOR2:
            begin
                B_next=operando2;
                input_display = {16'd0,operando2};
            end
            
            ESPERANDO_OPERACION: 
            begin
                operador_next = ALU_ctrl;
                input_display = {16'd0,B};
            end
            
            MOSTRAR_RESULTADO: 
            begin
                input_display = result;
            end
            endcase
    end
    
    
    wire V,C,N,Z;
    wire LED16_R_temp,LED16_B_temp,LED16_G_temp;
    //ALU
    ALU alucito(A, B, operador, result, {V,C,Z,N});
    //Salida LED RGB con pwm  
    pwm red(CLK100MHZ,1,LED16_R_temp);
    pwm green(CLK100MHZ,1,LED16_G_temp);
    pwm blue(CLK100MHZ,1,LED16_B_temp);
    //Asignacion salida LEDs RGB finales segun estado actual
    assign {LED16_R,LED16_B,LED16_G} = (estado_actual == ESPERANDO_OPERACION)? ({LED16_R_temp,LED16_B_temp,LED16_G_temp}&LED_RGB): 3'b000;
    //Tranforma Hex a Dec.
    double_dabble doublecito(clk,1'b1,input_display,led_idle,result_bcd);
    //Dec se muestra en display
    display displaycito(clk,{(estado_actual == MOSTRAR_RESULTADO)? N: result_bcd[31],result_bcd[30:0]},1'b0,7'b000000,{DP, CA, CB, CC, CD, CE, CF, CG},AN);
    
    //Secuencial
    always@(posedge CLK100MHZ or posedge CPU_RESETN)
        if (~CPU_RESETN)
        begin
            estado_actual <= ESPERANDO_OPERADOR1;
        end
        
        else
            estado_actual <= estado_sig;
   
    always@(posedge CLK100MHZ)
    begin      
        A <= A_next;
        B <= B_next;
        operador <= operador_next;      
    end
    
          
endmodule

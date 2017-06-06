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
    input [15:0] SW,
    input BTNC, BTNU, BTND, BTNL, BTNR, CPU_RESETN,
    input CLK100MHZ,
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output reg [15:0] LED,
    output LED16_B,LED16_R,LED16_G
    );
    //Creacion de Reloj 200 Hz
    wire clk;
    clock_divider clockcito(CLK100MHZ,1'b0,clk);
    
    //Creacion señal canto subida boton
    wire pressed, realease, pressing; //Solo se utiliza pressed
    PB_debouncer canto(CLK100MHZ,1'b0,BTNC, pressing, pressed, realease);
    
    wire [31:0] result_bcd;
    wire [15:0] result;
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
            ESPERANDO_OPERADOR1: estado_sig = (pressed == 1'b1)? ESPERANDO_OPERADOR2:ESPERANDO_OPERADOR1;
            ESPERANDO_OPERADOR2: estado_sig = (pressed == 1'b1)? ESPERANDO_OPERACION: ESPERANDO_OPERADOR2;
            ESPERANDO_OPERACION: estado_sig = (pressed == 1'b1)? MOSTRAR_RESULTADO: ESPERANDO_OPERACION;
            MOSTRAR_RESULTADO: estado_sig = (pressed == 1'b1)? ESPERANDO_OPERADOR1: MOSTRAR_RESULTADO;
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
        LED = 16'd0;
        case(estado_actual)
            ESPERANDO_OPERADOR1: 
            begin
                B_next = 16'd0;
                A_next = SW;
                input_display = {16'd0,SW};
                LED = SW;
            end
            
            ESPERANDO_OPERADOR2:
            begin
                B_next=SW;
                input_display = {16'd0,SW};
                LED = SW;
            end
            
            ESPERANDO_OPERACION: 
            begin
                operador_next = ({BTNU, BTND, BTNL, BTNR} == 4'b1000)? 3'd1:
                                ({BTNU, BTND, BTNL, BTNR} == 4'b0100)? 3'd2:
                                ({BTNU, BTND, BTNL, BTNR} == 4'b0010)? 3'd3:
                                ({BTNU, BTND, BTNL, BTNR} == 4'b1001)? 3'd4:
                                ({BTNU, BTND, BTNL, BTNR} == 4'b0101)? 3'd5: 3'd0;
                LED_RGB = ({BTNU, BTND, BTNL, BTNR} == 4'b1000)? 3'b100:
                          ({BTNU, BTND, BTNL, BTNR} == 4'b0100)? 3'b101:
                          ({BTNU, BTND, BTNL, BTNR} == 4'b0010)? 3'b001:
                          ({BTNU, BTND, BTNL, BTNR} == 4'b1001)? 3'b010:
                          ({BTNU, BTND, BTNL, BTNR} == 4'b0101)? 3'b110: 3'b111;
                input_display = {16'd0,B};
                LED = SW;                  
            end
            
            MOSTRAR_RESULTADO: 
            begin
                input_display = result;
                LED = {12'd0,V,C,Z,N};
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

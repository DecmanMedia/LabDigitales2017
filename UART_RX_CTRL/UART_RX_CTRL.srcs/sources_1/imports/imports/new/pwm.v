`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2017 16:46:59
// Design Name: 
// Module Name: pwm
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


module pwm #(parameter CONST_FREC = 100_000, CONST_TRABAJO = 1_000)
(
    input CLK100MHZ,
    input duty,
    output reg signal
);
    wire [17:0] borde;
    assign borde = (duty==0)?17'd5:17'd20;
    reg signal_temp;
    reg [17:0] cnt,cnt_next;
    reg [1:0] estado_actual, estado_siguiente;
    localparam E0 = 2'b00;
    localparam E1 = 2'b01;
    localparam E2 = 2'b10;
    
    always@(*)
    begin
        //cnt = 17'd0;
        //estado_siguiente = E0;
        case(estado_actual)
            E0: estado_siguiente = (cnt == borde*17'd1_000)? E1: E0;
            E1: estado_siguiente = (cnt == 17'd100_000)? E2: E1;
            E2: estado_siguiente = E0;
            default: estado_siguiente = E0;
        endcase
    end
        
    always@(*)
    begin
        signal_temp = 1'b0;
        case(estado_actual)
            E0: begin signal_temp = 1'b1; 
                cnt_next = cnt + 17'd1; 
                end
            E1: begin signal_temp = 1'b0; 
                cnt_next = cnt + 17'd1; 
                end
            E2: cnt_next = 17'd0;
            default: cnt_next=17'd0;
         endcase
    end                
    always@(posedge CLK100MHZ)
        begin
        signal <= signal_temp;
        estado_actual <= estado_siguiente;
        cnt <= cnt_next;
        end
endmodule
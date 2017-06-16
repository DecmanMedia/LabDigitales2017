`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2017 15:38:42
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
    input clk,
    input rst,
    input [7:0] rx,
    input rx_ready,
    output reg [15:0] op1,
    output reg [15:0] op2,
    output reg [2:0] cmd,
    output [3:0] estado,
    output reg tx_result
    );
    localparam E0 = 4'b1111;
    localparam E1 = 4'b0001;
    localparam E2 = 4'b0010;
    localparam E3 = 4'b0011;
    localparam E4 = 4'b0100;
    localparam E5 = 4'b0101;
    localparam E6 = 4'b0110;
    localparam E7 = 4'b0111;
    localparam E8 = 4'b1000;
    localparam E9 = 4'b1001;
    localparam E10 = 4'b1010;
    localparam E11 = 4'b1011;
    
    reg [3:0] estado_actual=E0;
    reg [3:0] estado_siguiente;
    
    reg [7:0] msb;
    reg [7:0] lsb;
    reg [7:0] msb_next;
    reg [7:0] lsb_next;
    
    reg [15:0]op1_next;
    reg [15:0]op2_next;
    reg [2:0] cmd_next;
    reg tx_result_next;
    always@(*)
    begin
        tx_result_next=1'b0;
        case(estado_actual)
        E0:
        begin
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente =(rx_ready==1'b1)?E1:E0;
        end     
        E1:
        begin 
            lsb_next = rx;
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            estado_siguiente=E2; 
        end
        E2:begin
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente =(rx_ready==1'b1)?E3:E2;
            end            
        E3:
        begin
            msb_next=rx;
            op2_next=op2;
            cmd_next=cmd;
            op1_next=op1;
            lsb_next =lsb;
            estado_siguiente = E4;
        end
        E4:begin
            op1_next={msb,lsb};
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente =(rx_ready==1'b1)?E5:E4;
            end
        E5:
        begin
            lsb_next=rx;
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            estado_siguiente=E6;
        end
        E6:begin
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente =(rx_ready==1'b1)?E7:E6;
            end
        E7:
        begin
            op1_next=op1;
            msb_next=rx;
            op2_next =op2 ;
            cmd_next=cmd;
            lsb_next =lsb;
            estado_siguiente=E8;
        end
        E8:begin
            op1_next=op1;
            op2_next={msb,lsb};
            cmd_next=cmd;
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente =(rx_ready==1'b1)?E9:E8;
            end
        E9:
        begin
            cmd_next=rx[2:0];
            op1_next=op1;
            op2_next=op2;
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente=E10;
        end
        E10:
        begin
            op1_next=op1;
            op2_next=op2;
            cmd_next=rx[2:0];
            msb_next = msb;
            lsb_next =lsb;
            estado_siguiente=E11;
        end
        E11:
        begin
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            lsb_next =lsb;
            tx_result_next=1'b1;
            estado_siguiente=(tx_result==1'b1)?E0:E11;
        end
        default:
        begin
            op1_next=op1;
            op2_next=op2;
            cmd_next=cmd;
            msb_next = msb;
            lsb_next = lsb;
            estado_siguiente=E0;
        end
        endcase
    end
    
    always@(posedge clk or posedge rst)
    begin
        op1 <= op1_next;
        op2 <= op2_next;
        cmd <= cmd_next;
        msb <= msb_next;
        lsb <= lsb_next;
        tx_result <=tx_result_next;
        
        if(rst==1'b0)  estado_actual <= E0;
        else estado_actual <= estado_siguiente;        
    end
    assign estado = estado_actual;
    
endmodule

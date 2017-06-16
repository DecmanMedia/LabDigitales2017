`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2017 20:34:51
// Design Name: 
// Module Name: top_modulept2
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


module top_modulept2(
    input CLK100MHZ,
    input CPU_RESETN,
    input JA1,
    output [7:0] AN,
    output CA,CB,CC,CD,CE,CF,CG,DP,
    output JA2
    //output [3:0] LED
    );
    wire [7:0] rxt;
    wire rx_redy;
    wire [15:0] op1;
    wire [15:0] op2;
    wire tx_start;
    wire[7:0] tx_data;
    wire tx_busy;
    uart_basic r1(.clk(CLK100MHZ),
        .reset(~CPU_RESETN),
        .rx(JA1),
        .rx_data(rxt),
        .rx_ready(rx_redy),
        .tx(JA2),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_busy(tx_busy));
    wire [15:0] resulalu;
    wire [3:0] estado;
    wire [2:0] operacion;
    wire trigger_result;
    UART_RX_CTRL rx_sesabe(.clk(CLK100MHZ),
                 .rst(CPU_RESETN), 
                 .rx(rxt),
                 .rx_ready(rx_redy),
                 .op1(op1),
                 .op2(op2),
                 .cmd(operacion),
                 .estado(estado),
                 .tx_result(trigger_result));
    wire tx_result;                 
    UART_TX_CTRL(.clk(CLK100MHZ),
                  .rst(~CPU_RESETN),
                  .flag(trigger_result),
                  .dataIn16(resulalu),
                  .tx_data(tx_data),
                  .tx_start(tx_start),
                  .new_tx_busy());    
    
    ALU r50( .in1(op1),
             .in2(op2),
             .op(operacion),
             .out(resulalu),
             .flags());
   reg [31:0] numerod;
   reg [15:0] numeroh;
   reg [15:0] numeroh_next;
   wire [31:0] convernum;
   driver_display7seg r10(.clk(CLK100MHZ),
                       .rst(1'd0),
                       .AN(AN[7:0]),
                       .SEG({CA,CB,CC,CD,CE,CF,CG,DP}),
                       .datos(numerod));
   unsigned_to_bcd r11(.clk(CLK100MHZ),
                        .trigger(1'd1),
                        .in({16'd0,numeroh}),
                        .idle(),
                        .bcd(convernum));
                
   always@(*)
   begin
        case(estado)
        4'b0100:
        begin
            numeroh_next=op1;
            numerod = convernum;
        end
        4'b1000:
        begin
            numeroh_next=op2;
            numerod = convernum; 
        end
        4'b1111:
        begin
            if(operacion==3'd0) begin
                numerod=31'd0;
                numeroh_next=numeroh;
                end
            else
            begin
            numeroh_next=resulalu;
            numerod=convernum;
            end
        end
        default:begin
        numerod=31'd0;
        numeroh_next=numeroh;
        end
        endcase
   end
always@(posedge CLK100MHZ)
begin
    numeroh <= numeroh_next;
end

    
endmodule

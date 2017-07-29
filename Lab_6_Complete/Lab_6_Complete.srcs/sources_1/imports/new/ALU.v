`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2017 14:37:32
// Design Name: 
// Module Name: ALU
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
/////////////////////////////////////////////////////////////////////////////////


module ALU #(parameter width = 32) (
    input [width-1:0] operador1,
    input [width-1:0] operador2,
    input [2:0] control, //1= suma, 2 = resta, 3 = multiplica, 4 = AND, 5 = OR
    output [width-1:0] result,
    output [3:0] flags
    );
    
    reg [width-1:0] result_temp,add;
    reg V,C,N;
    wire Z;
    
    always@(*)
    begin
        {V,C,N}=3'b000;
        case(control)
            3'd1: 
                begin
                    {add,result_temp} = operador1 + operador2;
                    if (add > 'b0)
                        C= 1'b1;
                    else
                        C= 1'b0;
                end
            3'd2: 
                begin
                if(operador2 > operador1)
                    begin
                    N=1'b1;
                    result_temp = ~(operador1 - operador2)  + 16'd1;
                    end
                else
                    begin
                    N=1'b0;
                    result_temp = operador1 - operador2;
                    end
                end
            3'd3: 
                begin
                    {add,result_temp} = operador1 * operador2;
                    if (add > 'b0)
                        V= 1'b1;
                    else
                        V= 1'b0;
                end
            3'd4: result_temp = operador1 & operador2;
            3'd5: result_temp = operador1 | operador2;
            default: result_temp = 'h0000;
        endcase
    end
    assign Z = (result_temp == 'd0)? 1'b1:1'b0;
    assign result = result_temp;
    assign flags = {V,C,Z,N};
    
    
    
    
endmodule

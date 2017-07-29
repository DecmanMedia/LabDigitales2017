`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2017 16:06:59
// Design Name: 
// Module Name: numba_to_string
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


module numba_to_string #(parameter MAX_CHARACTER_LINE = 8) (
    input [31:0] number,
    output [(MAX_CHARACTER_LINE*8)-1:0] n_string
    );
       
    reg [3:0] i;
    reg [3:0] n_n0,n_n1,n_n2,n_n3,n_n4,n_n5,n_n6,n_n7;
    reg [7:0] n_char0,n_char1,n_char2,n_char3,n_char4,n_char5,n_char6,n_char7;
    always@(*)begin
       n_n0 = number[3:0];
       n_n1 = number[7:4];
       n_n2 = number[11:8];
       n_n3 = number[15:12];
       n_n4 = number[19:16];
       n_n5 = number[23:20];
       n_n6 = number[27:24];
       n_n7 = number[31:28];
       case(n_n0)
               4'd0:n_char0 = "0";
               4'd1:n_char0 = "1";
               4'd2:n_char0 = "2";
               4'd3:n_char0 = "3";
               4'd4:n_char0 = "4";
               4'd5:n_char0 = "5";
               4'd6:n_char0 = "6";
               4'd7:n_char0 = "7";
               4'd8:n_char0 = "8";
               4'd9:n_char0 = "9";
               4'd10:n_char0 = "a";
               4'd11:n_char0 = "b";
               4'd12:n_char0 = "c";
               4'd13:n_char0 = "d";
               4'd14:n_char0 = "e";
               default:n_char0 = "f";
           endcase
           case(n_n1)
               4'd0:n_char1 = "0";
               4'd1:n_char1 = "1";
               4'd2:n_char1 = "2";
               4'd3:n_char1 = "3";
               4'd4:n_char1 = "4";
               4'd5:n_char1 = "5";
               4'd6:n_char1 = "6";
               4'd7:n_char1 = "7";
               4'd8:n_char1 = "8";
               4'd9:n_char1 = "9";
               4'd10:n_char1 = "a";
               4'd11:n_char1 = "b";
               4'd12:n_char1 = "c";
               4'd13:n_char1 = "d";
               4'd14:n_char1 = "e";
               default:n_char1 = "f";
           endcase
           case(n_n2)
               4'd0:n_char2 = "0";
               4'd1:n_char2 = "1";
               4'd2:n_char2 = "2";
               4'd3:n_char2 = "3";
               4'd4:n_char2 = "4";
               4'd5:n_char2 = "5";
               4'd6:n_char2 = "6";
               4'd7:n_char2 = "7";
               4'd8:n_char2 = "8";
               4'd9:n_char2 = "9";
               4'd10:n_char2 = "a";
               4'd11:n_char2 = "b";
               4'd12:n_char2 = "c";
               4'd13:n_char2 = "d";
               4'd14:n_char2 = "e";
               default:n_char2 = "f";
           endcase
           case(n_n3)
               4'd0:n_char3 = "0";
               4'd1:n_char3 = "1";
               4'd2:n_char3 = "2";
               4'd3:n_char3 = "3";
               4'd4:n_char3 = "4";
               4'd5:n_char3 = "5";
               4'd6:n_char3 = "6";
               4'd7:n_char3 = "7";
               4'd8:n_char3 = "8";
               4'd9:n_char3 = "9";
               4'd10:n_char3 = "a";
               4'd11:n_char3 = "b";
               4'd12:n_char3 = "c";
               4'd13:n_char3 = "d";
               4'd14:n_char3 = "e";
               default:n_char3 = "f";
           endcase
           case(n_n4)
               4'd0:n_char4 = "0";
               4'd1:n_char4 = "1";
               4'd2:n_char4 = "2";
               4'd3:n_char4 = "3";
               4'd4:n_char4 = "4";
               4'd5:n_char4 = "5";
               4'd6:n_char4 = "6";
               4'd7:n_char4 = "7";
               4'd8:n_char4 = "8";
               4'd9:n_char4 = "9";
               4'd10:n_char4 = "a";
               4'd11:n_char4 = "b";
               4'd12:n_char4 = "c";
               4'd13:n_char4 = "d";
               4'd14:n_char4 = "e";
               default:n_char4 = "f";
           endcase
           case(n_n5)
               4'd0:n_char5 = "0";
               4'd1:n_char5 = "1";
               4'd2:n_char5 = "2";
               4'd3:n_char5 = "3";
               4'd4:n_char5 = "4";
               4'd5:n_char5 = "5";
               4'd6:n_char5 = "6";
               4'd7:n_char5 = "7";
               4'd8:n_char5 = "8";
               4'd9:n_char5 = "9";
               4'd10:n_char5 = "a";
               4'd11:n_char5 = "b";
               4'd12:n_char5 = "c";
               4'd13:n_char5 = "d";
               4'd14:n_char5 = "e";
               default:n_char5 = "f";
           endcase
           case(n_n6)
               4'd0:n_char6 = "0";
               4'd1:n_char6 = "1";
               4'd2:n_char6 = "2";
               4'd3:n_char6 = "3";
               4'd4:n_char6 = "4";
               4'd5:n_char6 = "5";
               4'd6:n_char6 = "6";
               4'd7:n_char6 = "7";
               4'd8:n_char6 = "8";
               4'd9:n_char6 = "9";
               4'd10:n_char6 = "a";
               4'd11:n_char6 = "b";
               4'd12:n_char6 = "c";
               4'd13:n_char6 = "d";
               4'd14:n_char6 = "e";
               default:n_char6 = "f";
           endcase
           case(n_n7)
               4'd0:n_char7 = "0";
               4'd1:n_char7 = "1";
               4'd2:n_char7 = "2";
               4'd3:n_char7 = "3";
               4'd4:n_char7 = "4";
               4'd5:n_char7 = "5";
               4'd6:n_char7 = "6";
               4'd7:n_char7 = "7";
               4'd8:n_char7 = "8";
               4'd9:n_char7 = "9";
               4'd10:n_char7 = "a";
               4'd11:n_char7 = "b";
               4'd12:n_char7 = "c";
               4'd13:n_char7 = "d";
               4'd14:n_char7 = "e";
               default:n_char7 = "f";
           endcase
    end
    assign n_string = {n_char7,n_char6,n_char5,n_char4,n_char3,n_char2,n_char1,n_char0};
endmodule

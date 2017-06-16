`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2017 17:42:36
// Design Name: 
// Module Name: driver_display7seg
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


module driver_display7seg(
   input clk,
   input rst,
   output [7:0] AN,
   output[7:0] SEG,
   input [31:0] datos
   );
   

localparam N = 18;
reg [N-1:0]count; 
     
always @ (posedge clk or posedge rst)
     begin
      if (rst)
       count <= 0;
      else
       count <= count + 1;
     end
     
    reg [7:0]an_temp; //register for the 4 bit enable 
always @ (*)
    begin
    case(count[N-1:N-3]) //using only the 2 MSB's of the counter 
        
       3'b000 :  //When the 2 MSB's are 00 enable the fourth display
        begin
           an_temp = 8'b11111110;
        end
        3'b001 :  //When the 2 MSB's are 00 enable the fourth display
        begin
           an_temp = 8'b11111101;
        end 
       3'b010:
       begin 

           an_temp = 8'b11111011;
       end
       3'b011:
       begin 

           an_temp = 8'b11110111;
       end
       3'b100:
       begin 

           an_temp = 8'b11101111;
       end
       3'b101:
       begin 

           an_temp = 8'b11011111;
       end
       3'b110:
       begin 
           an_temp = 8'b10111111;
       end
       3'b111:
       begin

           an_temp = 8'b01111111;
       end
       default:
       begin

           an_temp = 8'b11111111;
      end
      endcase
     end
    assign AN = an_temp;

reg [3:0]hex;
wire [7:0]binario;
always @(*) 
begin
 
            case(AN)
                8'b11111110: hex = datos[3:0];               
                8'b11111101: hex = datos[7:4];
                8'b11111011: hex = datos[11:8];
                8'b11110111: hex = datos[15:12];
                8'b11101111: hex = datos[19:16];
                8'b11011111: hex = datos[23:20];
                8'b10111111: hex = datos[27:24];
                8'b01111111: hex = datos[31:28];                                  
                default: hex = 4'd0;
            endcase           
end
decodificador_7s re(.hex(hex),.SEG(binario));
assign SEG = binario;
endmodule

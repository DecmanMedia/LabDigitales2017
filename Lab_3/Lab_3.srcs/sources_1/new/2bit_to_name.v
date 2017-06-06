`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2017 14:09:43
// Design Name: 
// Module Name: 2bit_to_name
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
`define COMMON_ANODE		0
`define COMMON_CATHODE		1

module dosbit_to_name(
    input [1:0] dos_bit,
    input CLK100MHZ,
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] JA,
    output JB
    );
    
    reg [6:0] ssg;
    reg [7:0]dctl_sig;
    reg [7:0]dctl_tmp;
    reg type=`COMMON_ANODE;
    wire clk;
    
    clock_divider clock_f(CLK100MHZ,1'b0,clk);
    
    assign JB=clk;
    
    always@(*)
            case (dctl_tmp)// common_cathode
                8'b11111110:dctl_sig=8'b11111101;
                8'b11111101:dctl_sig=8'b11111011;
                8'b11111011:dctl_sig=8'b11110111;
                8'b11110111:dctl_sig=8'b11101111;
                8'b11101111:dctl_sig=8'b11011111;
                8'b11011111:dctl_sig=8'b10111111;
                8'b10111111:dctl_sig=8'b01111111;
                default:dctl_sig=8'b11111110;
            endcase
            
    always@(posedge clk)
        dctl_tmp<=dctl_sig;
           
    assign AN=(type==`COMMON_CATHODE)?{~dctl_tmp}:dctl_tmp;
    assign JA[7:0]= AN[7:0];
    //assign JA[10:5]=AN[7:4];
               
    always@(*)
        begin
            if(dos_bit == 2'b01)
                case (dctl_tmp)// common_cathode
                    8'b11110111:ssg=7'b0000001;
                    8'b11101111:ssg=7'b0100000;
                    8'b11011111:ssg=7'b0110000;
                    8'b10111111:ssg=7'b1111001;
                    8'b01111111:ssg=7'b1000010;
                    default:ssg=7'b1111111;
                endcase
             else if(dos_bit == 2'b10)
                case (dctl_tmp)// common_cathode
                    8'b11101111:ssg=7'b0001000;
                    8'b11011111:ssg=7'b1100000;
                    8'b10111111:ssg=7'b0110000;
                    8'b01111111:ssg=7'b0100100;
                 default:ssg=7'b1111111;
             endcase
             else if(dos_bit == 2'b11)
                case (dctl_tmp)// common_cathode
                    8'b11110111:ssg=7'b0000001;
                    8'b11101111:ssg=7'b0110001;
                    8'b11011111:ssg=7'b1111010;
                    8'b10111111:ssg=7'b0110000;
                    8'b01111111:ssg=7'b1001100;
                default:ssg=7'b1111111;
             endcase
             
             else
                case (dctl_tmp)// common_cathode
                    8'b11101111:ssg=7'b1100000;
                    8'b11011111:ssg=7'b0000001;
                    8'b10111111:ssg=7'b1001111;
                    8'b01111111:ssg=7'b0100000;
                default:ssg=7'b1111111;
                endcase         
end
     assign {CA,CB,CC,CD,CE,CF,CG} = ssg;
    
        
endmodule

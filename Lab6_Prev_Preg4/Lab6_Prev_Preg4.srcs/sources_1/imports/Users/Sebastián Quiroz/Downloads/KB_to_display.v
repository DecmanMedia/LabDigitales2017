`timescale 1ns / 1ps
module KB_to_display(
	input clk_100MHZ,rst,kd,kc,
	output [7:0] ss_select,
	output [7:0] ss_value
    );

	wire [7:0] new_data;
	wire [2:0] data_type;
	reg [31:0]	data;

	
	wire clk_ss;
	wire clk;
	clk_divider #(.O_CLK_FREQ(480)
	) clk_div_ss_display_480 (
		.clk_in(clk_100M),
		.reset(1'b0),
	.clk_out(clk_ss)
	);
	clk_divider #(.O_CLK_FREQ(1000000)
	) clk_div_ss_display_1k (
		.clk_in(clk_100M),
		.reset(1'b0),
	.clk_out(clk)
	);

	
	

	kbd_ms kbd_ms_inst(.clk(clk), .rst(rst), .kd(kd), .kc(kc), .new_data(new_data), .data_type(data_type), .kbs_tot(), .parity_error());
	
	display_mux display_mux_inst(.clk(clk_ss), .clk_enable(1'd0), .bcd(data), .dots(8'd0), .is_negative(1'd0), .turn_off(1'b0), .ss_value(ss_value), .ss_select(ss_select));

	always@(*) begin

		case(data_type)
			3'b001: data = {24'd0,new_data};
			3'b010: data = {16'd0,8'hE0,new_data};
			3'b011: data = {16'd0,8'hF0,new_data};
			3'b100: data = {8'd0,8'hE0,8'hF0,new_data};
		endcase

	end

endmodule

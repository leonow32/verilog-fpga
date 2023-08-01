`default_nettype none
module UART_TX #(
	parameter CLOCK_HZ = 10_000_000,
	parameter BAUD     = 115200
)(
	input wire Clock,
	input wire Reset,
	input wire Start_i,
	input wire [7:0] Data_i,
	output wire Busy_o,
	output wire Done_o,
	output wire Tx_o
);
	
	reg [7:0] Data;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Data <= 0;
		else begin
			if(Start_i)
				Data <= Data;
		end
	end

endmodule
`default_nettype wire
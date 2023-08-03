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
	
	wire NextBit;
	StrobeGenerator #(
		.CLOCK_HZ(CLOCK_HZ),
		.PERIOD_US(9)
	) StrobeGeneratorMilli(
		.Clock(Clock),
		.Reset(Reset),
		//.Enable_i(Busy_o || Start_i),
		.Enable_i(1'b1),
		.Strobe_o(NextBit)
	);
	
	reg [7:0] ByteCopy;
	reg [3:0] Pointer;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			ByteCopy <= 0;
			Pointer  <= 0;
		end else begin
			if(Start_i)
				ByteCopy <= ByteCopy;
		end
	end
	
	wire [9:0] DataToSend;
	assign DataToSend = {1'b1, DataToSend, 1'b0};
	

endmodule
`default_nettype wire
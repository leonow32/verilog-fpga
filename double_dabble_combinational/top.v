// 231224

`default_nettype none

module top #(
	parameter CLOCK_HZ = 25_000_000
)(
	input wire Clock,					// Pin 20
	input wire Reset,					// Pin 17
	input wire EncoderA_i,				// Pin 
	input wire EncoderB_i,				// Pin
	output wire [7:0] Cathodes_o,
	output wire [7:0] Segments_o
);

	// Encoder instance
	wire Increment;
	wire Decrement;
	
	Encoder Encoder_inst(
		.Clock(Clock),
		.Reset(Reset),
		.AsyncA_i(EncoderA_i),
		.AsyncB_i(EncoderB_i),
		.AsyncS_i(1'b1),
		.Increment_o(Increment),
		.Decrement_o(Decrement),
		.ButtonPress_o(),
		.ButtonRelease_o(),
		.ButtonState_o()		
	);
	
	// Up/down counter, range 0...9999 decimal
	reg [15:0] Counter;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset) begin
			Counter <= 0;
		end else if(Increment) begin
			if(Counter == 16'd9999)
				Counter <= 16'd0;
			else
				Counter <= Counter + 1'b1;
		end else if(Decrement) begin
			if(Counter == 16'd0)
				Counter <= 16'd9999;
			else
				Counter <= Counter - 1'b1;
		end
	end
	
	// Binary to BCD converter
	wire [15:0] Decimal;
	
	DoubleDabble #(
		.INPUT_BITS(16),
		.OUTPUT_DIGITS(4)
	) DoubleDabble_inst(
		.Binary_i(Counter),
		.BCD_o(Decimal)
	);
	
	// Display instance
	DisplayMultiplex #(
		.CLOCK_HZ(CLOCK_HZ),
		.SWITCH_PERIOD_US(1000),
		.DIGITS(8)
	) DisplayMultiplex_inst(
		.Clock(Clock),
		.Reset(Reset),
		.Data_i({Decimal, Counter}),
		.DecimalPoints_i(8'b00010000),
		.Cathodes_o(Cathodes_o),
		.Segments_o(Segments_o),
		.SwitchCathode_o()
	);	
	

endmodule

`default_nettype wire

// 240225

`default_nettype none

module top (
	input wire Clock,				// Pin 20
	input wire Reset,				// Pin 17
	input wire EncoderA_i,			// Pin 68
	input wire EncoderB_i,			// Pin 67
	output wire [7:0] Signal_o,		// Pin 
	output wire [7:0] Cathodes_o,	// Pin 40 41 42 43 45 47 51 52
	output wire [7:0] Segments_o	// Pin 39 38 37 36 35 34 30 29
);
	
	// Rotary encoder
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
	
	// Setting of the tuning word
	reg [7:0] TuningWord;
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			TuningWord <= 0;
		else if(Increment)
			TuningWord <= TuningWord + 1'b1;
		else if(Decrement)
			TuningWord <= TuningWord - 1'b1;
	end
	
	// DDS instance
	DDS DDS_inst(
		.Clock(Clock),
		.Reset(Reset),
		.TuningWord_i(TuningWord),
		.Result_o(Signal_o),
		.Overflow_o()
	);
	
	
	
	
endmodule

`default_nettype wire

// 240225

`default_nettype none

module top #(
	parameter CLOCK_HZ = 25_000_000
)(
	input wire Clock,				// Pin 20
	input wire Reset,				// Pin 17
	input wire EncoderFreqA_i,		// Pin 68
	input wire EncoderFreqB_i,		// Pin 67
	input wire EncoderAmplA_i,		// Pin 71
	input wire EncoderAmplB_i,		// Pin 70
	output wire [7:0] Signal_o,		// Pin 
	output wire [7:0] Cathodes_o,	// Pin 40 41 42 43 45 47 51 52
	output wire [7:0] Segments_o	// Pin 39 38 37 36 35 34 30 29
);
	
	// Encoder to regulate the frequency
	wire IncrementFreq;
	wire DecrementFreq;
	
	Encoder EncoderFreq_inst(
		.Clock(Clock),
		.Reset(Reset),
		.AsyncA_i(EncoderFreqA_i),
		.AsyncB_i(EncoderFreqB_i),
		.AsyncS_i(1'b1),
		.Increment_o(IncrementFreq),
		.Decrement_o(DecrementFreq),
		.ButtonPress_o(),
		.ButtonRelease_o(),
		.ButtonState_o()		
	);
	
	// Encoder to regulate the amplitude
	wire IncrementAmpl;
	wire DecrementAmpl;
	
	Encoder EncoderAmpl_inst(
		.Clock(Clock),
		.Reset(Reset),
		.AsyncA_i(EncoderAmplA_i),
		.AsyncB_i(EncoderAmplB_i),
		.AsyncS_i(1'b1),
		.Increment_o(IncrementAmpl),
		.Decrement_o(DecrementAmpl),
		.ButtonPress_o(),
		.ButtonRelease_o(),
		.ButtonState_o()		
	);
	
	// Setting of the tuning word
	reg [7:0] TuningWord;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			TuningWord <= 0;
		else if(IncrementFreq)
			TuningWord <= TuningWord + 1'b1;
		else if(DecrementFreq)
			TuningWord <= TuningWord - 1'b1;
	end
	
	// Setting of the amplitude multiplier
	reg [7:0] Amplitude;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Amplitude <= 8'hFF;
		else if(IncrementAmpl)
			Amplitude <= Amplitude + 1'b1;
		else if(DecrementAmpl)
			Amplitude <= Amplitude - 1'b1;
	end
	
	// DDS instance
	wire Overflow;
	wire [7:0] SignalTemp;
	
	DDS DDS_inst(
		.Clock(Clock),
		.Reset(Reset),
		.TuningWord_i(TuningWord),
		.Signal_o(SignalTemp),
		.Overflow_o(Overflow)
	);
	
	// Amplitude multiplier
	reg [15:0] Temp;
	
	always @(posedge Clock, negedge Reset) begin
		if(!Reset)
			Temp <= 0;
		else
			Temp <= SignalTemp * Amplitude;
	end
	
	// Amplitude multipler - IP Express
//	wire [15:0] Temp;
//	
//	multiplier multiplier_inst(
//		.Clock(Clock),
//		.ClkEn(1'b1),
//		.Aclr(!Reset),
//		.DataA(SignalTemp),
//		.DataB(Amplitude),
//		.Result(Temp)
//	);
	
	assign Signal_o[7:0] = Temp[15:8];
	
	// Frequency meter instance
	FrequencyMeter #(
		.CLOCK_HZ(CLOCK_HZ)
	) FrequencyMeter_inst(
		.Clock(Clock),
		.Reset(Reset),
		.SignalAsync_i(Overflow),
		.Cathodes_o(Cathodes_o),
		.Segments_o(Segments_o)
	);
	
endmodule

`default_nettype wire

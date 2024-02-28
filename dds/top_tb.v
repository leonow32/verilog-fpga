// 240226

`timescale 1ns/1ns

`default_nettype none
module top_tb();
	
	// Configuration
	parameter CLOCK_HZ = 25_000_000;
	parameter TuningWordRequested = 15;	// 35 is okay
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	reg AsyncFreqA = 1;
	reg AsyncFreqB = 1;
	reg AsyncAmplA = 1;
	reg AsyncAmplB = 1;
	
	// Variable dump
	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, top_tb);
	end
	
	// Instantiate device under test	
	top DUT(
		.Clock(Clock),
		.Reset(Reset),
		.EncoderFreqA_i(AsyncFreqA),
		.EncoderFreqB_i(AsyncFreqB),
		.EncoderAmplA_i(AsyncAmplA),
		.EncoderAmplB_i(AsyncAmplB),
		.Signal_o(),
		.Cathodes_o(),
		.Segments_o()
	);
	
	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset = 1'b1;
		
		repeat(5000)
			@(posedge Clock);
		
		// IncrementFreq the tuning word
		repeat(TuningWordRequested) begin
			#10000 AsyncFreqA = 1'b0;
			#10000 AsyncFreqB = 1'b0;
			#10000 AsyncFreqA = 1'b1;
			#10000 AsyncFreqB = 1'b1;
			#20000;
		end
		
		// DecrementFreq the tuning word
		// repeat(TuningWordRequested) begin
			// #10000 AsyncFreqB = 1'b0;
			// #10000 AsyncFreqA = 1'b0;
			// #10000 AsyncFreqB = 1'b1;
			// #10000 AsyncFreqA = 1'b1;
			// #20000;
		// end
		
		// Decrease amplitude from maximum to zero
		repeat(255) begin
			#2000 AsyncAmplB = 1'b0;
			#2000 AsyncAmplA = 1'b0;
			#2000 AsyncAmplB = 1'b1;
			#2000 AsyncAmplA = 1'b1;
			#5000;
		end
		
		// Increase amplitude from zero to maximum
		repeat(255) begin
			#2000 AsyncAmplA = 1'b0;
			#2000 AsyncAmplB = 1'b0;
			#2000 AsyncAmplA = 1'b1;
			#2000 AsyncAmplB = 1'b1;
			#5000;
		end
		
		/*
		repeat(100)
			@(posedge Clock);
		*/
		
		//@(posedge DUT.FrequencyMeter_inst.DoubleDabble_inst.Done_o);
		
		repeat(5000)
			@(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end

endmodule

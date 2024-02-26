// 240226

`timescale 1ns/1ns

`default_nettype none
module top_tb();
	
	// Configuration
	parameter CLOCK_HZ = 25_000_000;
	parameter TuningWordRequested = 35;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	reg AsyncA = 1;
	reg AsyncB = 1;
	
	// Variable dump
	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, top_tb);
	end
	
	// Instantiate device under test	
	top DUT(
		.Clock(Clock),
		.Reset(Reset),
		.EncoderA_i(AsyncA),
		.EncoderB_i(AsyncB),
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
		
		// Increment the tuning word
		repeat(TuningWordRequested) begin
			#10000 AsyncA = 1'b0;
			#10000 AsyncB = 1'b0;
			#10000 AsyncA = 1'b1;
			#10000 AsyncB = 1'b1;
			#20000;
		end
		
		// Decrement the tuning word
		repeat(TuningWordRequested) begin
			#10000 AsyncB = 1'b0;
			#10000 AsyncA = 1'b0;
			#10000 AsyncB = 1'b1;
			#10000 AsyncA = 1'b1;
			#20000;
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
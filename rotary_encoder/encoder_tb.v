`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module Encoder_tb();

	parameter CLOCK_HZ	= 10_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variables
	reg Reset 	= 1'b1;
	reg AsyncA	= 1'b1;
	reg AsyncB	= 1'b1;
	
	// Variable dump
	initial begin
		$dumpfile("encoder.vcd");
		$dumpvars(0, Encoder_tb);
	end

	// 
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");

		@(posedge Clock);
		Reset = 1'b0;
		#1;
		Reset = 1'b1;
		
		#2025;
		
		// Three turns right (increment)
		repeat(2) begin
			#500 AsyncA = 1'b0;
			#500 AsyncB = 1'b0;
			#500 AsyncA = 1'b1;
			#500 AsyncB = 1'b1;
			#1000;
		end
			
		#2000;
		
		// Three turns left (decrement)
		repeat(2) begin
			#500 AsyncB = 1'b0;
			#500 AsyncA = 1'b0;
			#500 AsyncB = 1'b1;
			#500 AsyncA = 1'b1;
			#1000;
		end
		
		#2000;
		
		// Improper operation - A low/high
		repeat(2) begin
			#500 AsyncA = 1'b0;
			#500 AsyncA = 1'b1;
			#1000;
		end
		
		// Improper operation - B low/high
		repeat(2) begin
			#500 AsyncB = 1'b0;
			#500 AsyncB = 1'b1;
			#1000;
		end
		
		// Improper operation - both A & B low
		repeat(2) begin
			#500 AsyncA = 1'b0; AsyncB = 1'b0;
			#500 AsyncA = 1'b1; AsyncB = 1'b1;
			#1000;
		end
		
		#1 $display("===== END =====");
		#1 $finish;
	end

	// Instantiate device under test
	Encoder DUT(
		.Clock(Clock),
		.Reset(Reset),
		.AsyncA_i(AsyncA),
		.AsyncB_i(AsyncB),
		.Increment_o(),
		.Decrement_o()
	);

endmodule
`default_nettype wire

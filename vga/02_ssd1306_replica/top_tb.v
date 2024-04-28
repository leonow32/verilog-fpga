`timescale 1ns/1ps  // time-unit, precision

`default_nettype none
module top_tb();

	parameter CLOCK_HZ	= 25_175_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2.0 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	
	// Instantiate device under test
	top DUT(
		.Clock(Clock),
		.Reset(Reset),
		
		.CS_i(),
		.SCK_i(),
		.MOSI_i(),
		.DC_i(),
		
		.HSync_o(),
		.VSync_o(),
		.Red_o(),
		.Green_o(),
		.Blue_o()
	);

	// Variable dump
	initial begin
		$dumpfile("too.vcd");
		$dumpvars(0, top_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");

		@(posedge Clock);
		Reset <= 1;
		
		repeat(100) @(posedge Clock);
		
		$display("===== END =====");
		$finish;
	end
	
endmodule
`default_nettype wire

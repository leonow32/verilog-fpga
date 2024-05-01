`timescale 1ns/1ps  // time-unit, precision

`default_nettype none
module VGA_tb();

	parameter CLOCK_HZ	= 25_175_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2.0 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 1'b0;
	
	// Instantiate device under test
	VGA DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Red_o(),
		.Green_o(),
		.Blue_o(),
		.HSync_o(),
		.VSync_o()
	);

	// Variable dump
	initial begin
		$dumpfile("vga.vcd");
		$dumpvars(0, VGA_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");

		@(posedge Clock);
		Reset <= 1'b1;
		
		wait(DUT.VCounter == 524 && DUT.HCounter == 799);
		wait(DUT.VCounter == 10);
		
		$display("===== END =====");
		$finish;
	end
	
endmodule
`default_nettype wire

`timescale 1 ns/1 ns  // time-unit, precision

`default_nettype none
module Debouncer_tb();

	parameter CLOCK_HZ	= 10_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variable dump
	initial begin
		$dumpfile("debouncer.vcd");
		$dumpvars(0, Debouncer_tb);
	end
	
	// Variables
	reg Reset  = 1'b0;
	reg Button = 1'b0;
	wire Out;
	
	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("CLOCK_HZ  = %9d", DUT.CLOCK_HZ);
		$display("PERIOD_US = %9d", DUT.PERIOD_US);
		$display("DELAY     = %9d", DUT.DELAY);
		$display("WIDTH     = %9d", DUT.WIDTH);

		#1 Reset = 1'b1; #9;

		Button   = 1'b1; #100    Button   = 1'b0; #100 
		Button   = 1'b1; #200    Button   = 1'b0; #200 
		Button   = 1'b1; #500    Button   = 1'b0; #500 
		Button   = 1'b1; #1000   Button   = 1'b0; #1000
		Button   = 1'b1; #2000   Button   = 1'b0; #2000
		Button   = 1'b1; #5000   Button   = 1'b0; #5000
		Button   = 1'b1; #10000  Button   = 1'b0; #10000
		Button   = 1'b1; #20000  Button   = 1'b0; #20000
		Button   = 1'b1; #50000  Button   = 1'b0; #10000
		$display("===== END =====");
		#20 $finish;
	end

	// Instantiate device under test
	Debouncer #(
		.CLOCK_HZ(CLOCK_HZ),
		.PERIOD_US(5)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.NoisySignal_i(Button),
		.FilteredSignal_o(Out)
	);

endmodule
`default_nettype wire

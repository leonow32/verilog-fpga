`timescale 1ns/1ns  // time-unit, precision
`default_nettype none

module Synchronizer_tb();

  parameter CLOCK_HZ  = 10_000_000;
  parameter real HALF_PERIOD_NS = 1_000_000_000.0 / (2.0 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
  
	// Variables
	reg  Reset;
	reg  AsynchInput = 1'b0;
	wire SyncOutput;
	
	// Variable dump
	initial begin
		$dumpfile("synchronizer.vcd");
		$dumpvars(0, Synchronizer_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 10);
		$display("===== START =====");
		$display("      Time Reset AsynchInput SyncOutput");
		$monitor("%t     %d           %d          %d", $realtime, Reset, AsynchInput, SyncOutput);

		#5 Reset = 1'b0; 
		#5 Reset = 1'b1;

		@(posedge Clock);
		#75  AsynchInput = 1'b1;
		#353 AsynchInput = 1'b0;
		#500

		@(posedge Clock);
		#110 AsynchInput = 1'b1;
		#456 AsynchInput = 1'b0;
		#500;

		$display("====== END ======");
		$finish;
	end
  
	// AsyncInstantiate device under test
	Synchronizer DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Async_i(AsynchInput),
		.Sync_o(SyncOutput)
	);

endmodule
`default_nettype wire

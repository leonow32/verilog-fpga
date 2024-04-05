// 240405

`timescale 1ns/1ns

`default_nettype none
module SlaveSPI_tb();
	
	// Configuration
	parameter CLOCK_HZ   = 25_000_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	
	// Variable dump
	initial begin
		$dumpfile("slave_spi.vcd");
		$dumpvars(0, SlaveSPI_tb);
	end
	
	// Instantiate device under test
	SlaveSPI DUT(
		.Clock(Clock),
		.Reset(Reset),
	);
	
	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset <= 1'b1;
				
		$display("====== END ======");
		$finish;
	end

endmodule

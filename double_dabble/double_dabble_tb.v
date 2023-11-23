// 231117

`timescale 1ns/1ns

`default_nettype none
module DoubleDabble_tb();
	
	// Configuration
	parameter BITS   = 16;
	parameter DIGITS = 5;
	
	parameter CLOCK_HZ            = 1_000_000;
	parameter real HALF_PERIOD_NS = 1_000_000_000.0 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variables
	reg Reset  = 0;
	reg [BITS-1:0] Binary = 0;
	integer MaxInput = 2**BITS - 1;
	integer i;
	
	// Variable dump
	initial begin
		$dumpfile("double_dabble.vcd");
		$dumpvars(0, DoubleDabble_tb);
	end
	
	// Instantiate device under test
	DoubleDabble #(
		.INPUT_BITS(16),
		.OUTPUT_DIGITS(5)
	) DUT(
		.Binary_i(Binary),
		.BCD_o()
	);
	
	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		$display("INPUT_BITS:  %3d", BITS);
		$display("OUTPUT_BITS: %3d", DUT.OUTPUT_BITS);
		$display("DIGITS:      %3d", DIGITS);
		$display("MaxInput:    %d", MaxInput);
		
		@(posedge Clock);
		Reset = 1'b1;
		
		for(i=0; i<=65535; i++) begin
			@(posedge Clock);
			Binary <= i;
		end
		
		for(i=0; i<=255; i++) begin
			@(posedge Clock);
			Binary <= i;
		end
		
		@(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end

endmodule

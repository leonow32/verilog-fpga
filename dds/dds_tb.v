// 240218

`timescale 1ns/1ns

`default_nettype none
module DDS_tb();
	
	// Configuration
	parameter OUTPUT_BITS   = OUTPUT_DIGITS * 4;
	
	parameter CLOCK_HZ            = 1_000_000;
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#(HALF_PERIOD_NS = 1_000_000_000.0 / (2 * CLOCK_HZ));
		Clock = !Clock;
	end
	
	// Variables
	reg Reset = 0;
	reg Start = 0;
	wire Done;
	reg  [ INPUT_BITS-1:0] Binary = {INPUT_BITS{1'bX}};
	wire [OUTPUT_BITS-1:0] BCD;
	
	integer MaxInput = 2**INPUT_BITS - 1;
	
	integer i;
	
	// Variable dump
	initial begin
		$dumpfile("double_dabble.vcd");
		$dumpvars(0, DoubleDabble_tb);
	end
	
	// Instantiate device under test
	DDS #(
		.INPUT_BITS(INPUT_BITS),
		.OUTPUT_DIGITS(OUTPUT_DIGITS),
		.OUTPUT_BITS(OUTPUT_BITS)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Start_i(Start),
		.Busy_o(),
		.Done_o(Done),
		.Binary_i(Binary),
		.BCD_o(BCD)
	);

	// Test sequence
	initial begin
		$timeformat(-9, 3, "ns", 10);
		$display("===== START =====");
		
		@(posedge Clock);
		Reset = 1'b1;
		
		
		
		@(posedge Clock);
		
		$display("====== END ======");
		$finish;
	end

endmodule

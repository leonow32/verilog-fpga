`timescale 1ns/1ns  // time-unit, precision

`default_nettype none
module Player_tb();

	parameter CLOCK_HZ	= 10_000_000;
	parameter HALF_PERIOD_NS = 1_000_000_000 / (2 * CLOCK_HZ);
	
	// Clock generator
	reg Clock = 1'b1;
	always begin
		#HALF_PERIOD_NS;
		Clock = !Clock;
	end
	
	// Variables
	reg Reset   = 1'b0;
	reg Play    = 1'b0;
	reg Stop    = 1'b0;
	
	// Instantiate device under test
	Player #(
		.CLOCK_HZ(CLOCK_HZ)
	) DUT(
		.Clock(Clock),
		.Reset(Reset),
		.Play_i(Play),
		.Stop_i(Stop),
		.SoundWave_o()
	);
	
	// Variable dump
	initial begin
		$dumpfile("player.vcd");
		$dumpvars(0, Player_tb);
	end

	// Test sequence
	initial begin
		$timeformat(-6, 3, "us", 12);
		$display("===== START =====");
		$display("        Time Durat HaPer        Freq");

		#1 Reset <= 1'b1; 
		
		repeat(10) @(posedge Clock);
		
		
		#1 $display("===== END =====");
		#1 $finish;
	end

endmodule
`default_nettype wire
